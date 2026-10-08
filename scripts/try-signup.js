// Walks through the full Nexify signup + login flow in the terminal,
// so you can test the backend without the Flutter app.
//
//   1. Start the server:   npm start
//   2. In another session: node scripts/try-signup.js
//
// Use a throwaway password for testing.

const readline = require('node:readline');

const URL = process.env.NEXIFY_API_URL || 'http://127.0.0.1:3000/graphql';
const rl = readline.createInterface({ input: process.stdin });
const lines = rl[Symbol.asyncIterator]();

async function ask(question) {
  process.stdout.write(question);
  const { value } = await lines.next();
  return (value ?? '').trim();
}

async function gql(query, variables = {}, token) {
  let res;
  try {
    res = await fetch(URL, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        ...(token ? { Authorization: `Bearer ${token}` } : {}),
      },
      body: JSON.stringify({ query, variables }),
    });
  } catch {
    console.error(`\n❌ Cannot reach ${URL}. Is the server running (npm start)?`);
    process.exit(1);
  }
  return res.json();
}

const USER = 'id fullName email phoneNumber country location interests status emailVerified phoneVerified';
const PAYLOAD = `accessToken refreshToken verificationRequired message user { ${USER} }`;

async function step(title, name, type, input, token) {
  const r = await gql(
    `mutation($input: ${type}!) { ${name}(input: $input) { ${PAYLOAD} } }`,
    { input },
    token,
  );
  if (r.errors) {
    console.error(`\n❌ ${title} failed: ${r.errors[0].message}`);
    process.exit(1);
  }
  const p = r.data[name];
  console.log(`✅ ${title}: ${p.message ?? 'ok'}  (status: ${p.user.status})`);
  return p;
}

async function main() {
  console.log(`Testing against ${URL}\n`);
  const fullName = await ask('Full name: ');
  const email = await ask('Email: ');
  const phoneNumber = await ask('Phone (e.g. 0712345678): ');

  const reg = await step('Register', 'register', 'RegisterInput', {
    fullName,
    email,
    phoneNumber,
    verificationMethod: 'EMAIL',
  });
  const userId = reg.user.id;

  console.log('\nThe 6-digit code was emailed (or printed in the server console).');
  const code = await ask('Enter the code: ');
  await step('Verify', 'verifyRegistration', 'VerifyRegistrationInput', { userId, code });

  const password = await ask('\nChoose a password (8+ chars, uppercase, number, symbol): ');
  await step('Password', 'completePasswordSetup', 'CompletePasswordSetupInput', { userId, password });

  const country = await ask('\nCountry: ');
  const location = await ask('Town/location: ');
  await step('Profile', 'completeProfile', 'CompleteProfileInput', {
    userId,
    fullName,
    country,
    location,
    interests: ['Testing'],
  });

  const session = await step('Login', 'login', 'LoginInput', { identifier: email, password });

  const me = await gql(`query { me { ${USER} } }`, {}, session.accessToken);
  if (me.errors) {
    console.error(`❌ me failed: ${me.errors[0].message}`);
    process.exit(1);
  }
  console.log(`✅ me: ${me.data.me.fullName} <${me.data.me.email}>, ${me.data.me.location}`);

  const refreshed = await step('Refresh session', 'refreshSession', 'RefreshSessionInput', {
    refreshToken: session.refreshToken,
  });

  const out = await gql(`mutation($input: LogoutInput!) { logout(input: $input) }`, {
    input: { refreshToken: refreshed.refreshToken },
  });
  console.log(`✅ Logout: ${out.data.logout}`);

  console.log('\n🎉 The whole flow works.');
  rl.close();
}

main();
