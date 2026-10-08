const { test, before, after } = require('node:test');
const assert = require('node:assert/strict');

const { createApp } = require('../src/app');
const { setSender } = require('../src/delivery');

let nexify;
let url;
const sentCodes = [];

before(async () => {
  setSender(async (msg) => sentCodes.push(msg));
  nexify = await createApp({
    dbPath: ':memory:',
    jwtSecret: 'test-secret',
    bcryptRounds: 4,
    loginMaxFailures: 4,
  });
  const port = await nexify.listen(0);
  url = `http://127.0.0.1:${port}/graphql`;
});

after(async () => {
  await nexify.close();
});

// The same request shape the Flutter ApiClient sends.
async function gql(query, variables = {}, token) {
  const res = await fetch(url, {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
      ...(token ? { Authorization: `Bearer ${token}` } : {}),
    },
    body: JSON.stringify({ query, variables }),
  });
  return res.json();
}

const USER_FIELDS = `id fullName email phoneNumber country location interests status emailVerified phoneVerified`;
const PAYLOAD = `accessToken refreshToken verificationRequired message user { ${USER_FIELDS} }`;

const mutation = (name, type) =>
  `mutation($input: ${type}!) { ${name}(input: $input) { ${PAYLOAD} } }`;

const register = (input) => gql(mutation('register', 'RegisterInput'), { input });
const verify = (input) => gql(mutation('verifyRegistration', 'VerifyRegistrationInput'), { input });
const resend = (input) => gql(mutation('resendVerificationCode', 'ResendVerificationCodeInput'), { input });
const setPassword = (input) => gql(mutation('completePasswordSetup', 'CompletePasswordSetupInput'), { input });
const setProfile = (input, token) => gql(mutation('completeProfile', 'CompleteProfileInput'), { input }, token);
const login = (input) => gql(mutation('login', 'LoginInput'), { input });
const refresh = (input) => gql(mutation('refreshSession', 'RefreshSessionInput'), { input });
const logout = (input) => gql(`mutation($input: LogoutInput!) { logout(input: $input) }`, { input });
const me = (token) => gql(`query { me { ${USER_FIELDS} } }`, {}, token);

const PASSWORD = 'Sup3r$ecret';

test('full signup flow, matching the Flutter screens', async () => {
  // 1. register (the app sends E.164 phone and EMAIL by default)
  let r = await register({
    fullName: 'Henry Nyoike',
    email: 'Henry@Example.com',
    phoneNumber: '+254712345678',
    verificationMethod: 'EMAIL',
  });
  assert.equal(r.errors, undefined);
  const { user } = r.data.register;
  assert.equal(r.data.register.verificationRequired, true);
  assert.equal(r.data.register.accessToken, null);
  assert.equal(user.email, 'henry@example.com');
  assert.equal(user.status, 'PENDING_VERIFICATION');
  assert.equal(sentCodes.at(-1).destination, 'henry@example.com');
  const code = sentCodes.at(-1).code;
  assert.match(code, /^\d{6}$/);

  // resend straight away is rate limited
  r = await resend({ userId: user.id, email: user.email, verificationMethod: 'EMAIL' });
  assert.match(r.errors[0].message, /wait/i);

  // 2. wrong code, then right code
  const wrong = code === '000000' ? '111111' : '000000';
  r = await verify({ userId: user.id, code: wrong });
  assert.match(r.errors[0].message, /Incorrect code/);
  r = await verify({ userId: user.id, code });
  assert.equal(r.errors, undefined);
  assert.equal(r.data.verifyRegistration.user.status, 'PENDING_PASSWORD');
  assert.equal(r.data.verifyRegistration.user.emailVerified, true);

  // 3. password: weak rejected, strong accepted
  r = await setPassword({ userId: user.id, password: 'weakpass' });
  assert.match(r.errors[0].message, /uppercase/);
  r = await setPassword({ userId: user.id, password: PASSWORD });
  assert.equal(r.data.completePasswordSetup.user.status, 'PENDING_PROFILE');
  r = await setPassword({ userId: user.id, password: PASSWORD });
  assert.ok(r.errors, 'password cannot be set twice');

  // 4. profile (no token yet, mid-signup), then login by email
  r = await setProfile({
    userId: user.id,
    fullName: 'Henry Ndirangu Nyoike',
    country: 'Kenya',
    location: 'Machakos',
    interests: ['Farming', 'Tech', 'farming'],
  });
  assert.equal(r.errors, undefined);
  assert.equal(r.data.completeProfile.user.status, 'ACTIVE');
  assert.deepEqual(r.data.completeProfile.user.interests, ['Farming', 'Tech']);

  r = await login({ identifier: 'henry@example.com', password: PASSWORD });
  assert.equal(r.errors, undefined);
  const session = r.data.login;
  assert.ok(session.accessToken && session.refreshToken);

  // login by local phone format works too
  r = await login({ identifier: '0712 345 678', password: PASSWORD });
  assert.equal(r.errors, undefined);

  // 5. me
  r = await me(session.accessToken);
  assert.equal(r.data.me.fullName, 'Henry Ndirangu Nyoike');
  r = await me();
  assert.equal(r.errors[0].extensions.code, 'UNAUTHENTICATED');
  r = await me('not-a-token');
  assert.equal(r.errors[0].extensions.code, 'UNAUTHENTICATED');

  // 6. profile edit needs your own token once ACTIVE
  const edit = { userId: user.id, fullName: 'Henry N', country: 'Kenya', location: 'Nairobi', interests: [] };
  r = await setProfile(edit);
  assert.equal(r.errors[0].extensions.code, 'UNAUTHENTICATED');
  r = await setProfile(edit, session.accessToken);
  assert.equal(r.data.completeProfile.user.location, 'Nairobi');

  // 7. refresh rotates; old token is dead and reuse kills the family
  r = await refresh({ refreshToken: session.refreshToken });
  assert.equal(r.errors, undefined);
  const rotated = r.data.refreshSession;
  assert.notEqual(rotated.refreshToken, session.refreshToken);
  r = await me(rotated.accessToken);
  assert.equal(r.errors, undefined);

  r = await refresh({ refreshToken: session.refreshToken }); // reuse of old token
  assert.ok(r.errors);
  r = await refresh({ refreshToken: rotated.refreshToken }); // family revoked
  assert.ok(r.errors);

  // 8. logout revokes
  r = await login({ identifier: 'henry@example.com', password: PASSWORD });
  const s2 = r.data.login;
  r = await logout({ refreshToken: s2.refreshToken });
  assert.equal(r.data.logout, 'Logged out.');
  r = await refresh({ refreshToken: s2.refreshToken });
  assert.ok(r.errors);
});

test('duplicate email is rejected once verified', async () => {
  const r = await register({
    fullName: 'Someone Else',
    email: 'henry@example.com',
    phoneNumber: '+254799999999',
  });
  assert.match(r.errors[0].message, /already exists/);
  assert.equal(r.errors[0].extensions.code, 'CONFLICT');
});

test('verification code locks after too many wrong attempts', async () => {
  let r = await register({ fullName: 'Lock Test', email: 'lock@example.com', phoneNumber: '0711000111' });
  const { user } = r.data.register;
  const code = sentCodes.at(-1).code;
  const wrong = code === '123456' ? '654321' : '123456';
  for (let i = 0; i < 5; i++) await verify({ userId: user.id, code: wrong });
  r = await verify({ userId: user.id, code }); // even the right code is refused now
  assert.match(r.errors[0].message, /Too many/);
});

test('login: wrong password, unknown user, and throttling', async () => {
  let r = await login({ identifier: 'henry@example.com', password: 'Wrong$pass1' });
  assert.equal(r.errors[0].message, 'Incorrect email/phone or password.');
  r = await login({ identifier: 'nobody@example.com', password: 'Wrong$pass1' });
  assert.equal(r.errors[0].message, 'Incorrect email/phone or password.'); // same message

  for (let i = 0; i < 4; i++) await login({ identifier: 'throttle@example.com', password: 'x' });
  r = await login({ identifier: 'throttle@example.com', password: 'x' });
  assert.equal(r.errors[0].extensions.code, 'TOO_MANY_REQUESTS');
});

test('login is refused until signup is complete', async () => {
  await register({ fullName: 'Half Way', email: 'half@example.com', phoneNumber: '0722000222' });
  const r = await login({ identifier: 'half@example.com', password: PASSWORD });
  assert.ok(r.errors); // no password yet
});

test('PHONE verification needs a phone number and sends to it', async () => {
  let r = await register({ fullName: 'No Phone', email: 'nophone@example.com', verificationMethod: 'PHONE' });
  assert.match(r.errors[0].message, /phone number/i);

  r = await register({
    fullName: 'Phone User',
    email: 'phoneuser@example.com',
    phoneNumber: '0733000333',
    verificationMethod: 'PHONE',
  });
  assert.equal(r.errors, undefined);
  assert.equal(sentCodes.at(-1).method, 'PHONE');
  assert.equal(sentCodes.at(-1).destination, '+254733000333');
});

test('passwords are stored hashed and tokens are not stored in clear', async () => {
  const user = nexify.db.prepare('SELECT password_hash FROM users WHERE email = ?').get('henry@example.com');
  assert.match(user.password_hash, /^\$2[aby]\$/);
  const rows = nexify.db.prepare('SELECT token_hash FROM refresh_tokens').all();
  assert.ok(rows.length > 0);
  assert.ok(rows.every((t) => /^[0-9a-f]{64}$/.test(t.token_hash)));
});
