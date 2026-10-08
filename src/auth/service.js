const crypto = require('crypto');
const bcrypt = require('bcryptjs');

const { transaction } = require('../db');
const { sendVerificationCode } = require('../delivery');
const {
  badInput,
  unauthenticated,
  forbidden,
  conflict,
  tooManyRequests,
  accountIncomplete,
} = require('../errors');
const {
  normalizeName,
  normalizeEmail,
  normalizePhone,
  validatePassword,
  cleanOptionalText,
  cleanInterests,
} = require('./validation');
const { createTokenService } = require('./tokens');

const SESSION_EXPIRED = 'Your session has expired. Please log in again.';

function toApiUser(row) {
  return {
    id: row.id,
    fullName: row.full_name,
    email: row.email,
    phoneNumber: row.phone_number,
    country: row.country,
    location: row.location,
    interests: JSON.parse(row.interests),
    status: row.status,
    emailVerified: Boolean(row.email_verified),
    phoneVerified: Boolean(row.phone_verified),
  };
}

function createAuthService(db, config) {
  const tokens = createTokenService(db, config);
  const dummyHash = bcrypt.hashSync('nexify-dummy-password', config.bcryptRounds);

  const q = {
    userById: db.prepare('SELECT * FROM users WHERE id = ?'),
    userByEmail: db.prepare('SELECT * FROM users WHERE email = ?'),
    userByPhone: db.prepare('SELECT * FROM users WHERE phone_number = ?'),
    insertUser: db.prepare(
      `INSERT INTO users (id, full_name, email, phone_number, created_at, updated_at)
       VALUES (?, ?, ?, ?, ?, ?)`,
    ),
    updatePending: db.prepare(
      'UPDATE users SET full_name = ?, phone_number = ?, updated_at = ? WHERE id = ?',
    ),
    deleteUser: db.prepare('DELETE FROM users WHERE id = ?'),
    lastCode: db.prepare(
      'SELECT * FROM verification_codes WHERE user_id = ? ORDER BY id DESC LIMIT 1',
    ),
    activeCode: db.prepare(
      `SELECT * FROM verification_codes
       WHERE user_id = ? AND consumed_at IS NULL ORDER BY id DESC LIMIT 1`,
    ),
    retireCodes: db.prepare(
      'UPDATE verification_codes SET consumed_at = ? WHERE user_id = ? AND consumed_at IS NULL',
    ),
    insertCode: db.prepare(
      `INSERT INTO verification_codes (user_id, method, code_hash, expires_at, created_at)
       VALUES (?, ?, ?, ?, ?)`,
    ),
    bumpAttempts: db.prepare(
      'UPDATE verification_codes SET attempts = attempts + 1 WHERE id = ?',
    ),
    consumeCode: db.prepare('UPDATE verification_codes SET consumed_at = ? WHERE id = ?'),
    markVerified: db.prepare(
      `UPDATE users SET email_verified = ?, phone_verified = ?, status = 'PENDING_PASSWORD',
       updated_at = ? WHERE id = ?`,
    ),
    setPassword: db.prepare(
      `UPDATE users SET password_hash = ?, status = 'PENDING_PROFILE', updated_at = ?
       WHERE id = ?`,
    ),
    setProfile: db.prepare(
      `UPDATE users SET full_name = ?, country = ?, location = ?, interests = ?,
       status = 'ACTIVE', updated_at = ? WHERE id = ?`,
    ),
  };

  // ---- helpers ---------------------------------------------------------

  const hashCode = (userId, code) =>
    crypto.createHmac('sha256', config.jwtSecret).update(`${userId}:${code}`).digest('hex');

  const safeEqual = (a, b) => {
    const x = Buffer.from(a);
    const y = Buffer.from(b);
    return x.length === y.length && crypto.timingSafeEqual(x, y);
  };

  const requireUser = (userId) => {
    const user = userId ? q.userById.get(String(userId)) : null;
    if (!user) throw badInput('No pending registration was found.');
    return user;
  };

  const payload = (user, extra = {}) => ({
    accessToken: null,
    refreshToken: null,
    verificationRequired: false,
    message: null,
    ...extra,
    user: toApiUser(user),
  });

  const startSession = (user, message) =>
    payload(user, {
      accessToken: tokens.signAccessToken(user.id),
      refreshToken: tokens.issueRefreshToken(user.id).raw,
      message,
    });

  const secondsSince = (ms) => (Date.now() - ms) / 1000;

  // Creates and sends a fresh code, retiring any earlier ones.
  async function issueCode(user, method) {
    const destination = method === 'PHONE' ? user.phone_number : user.email;
    const code = String(crypto.randomInt(0, 1_000_000)).padStart(6, '0');
    const now = Date.now();

    transaction(db, () => {
      q.retireCodes.run(now, user.id);
      q.insertCode.run(
        user.id,
        method,
        hashCode(user.id, code),
        now + config.codeTtlMinutes * 60 * 1000,
        now,
      );
    });

    try {
      await sendVerificationCode({
        method,
        destination,
        code,
        expiresInMinutes: config.codeTtlMinutes,
      });
    } catch (err) {
      console.error('Failed to send verification code:', err.message);
      throw badInput('We could not send your verification code. Please try again.');
    }
    return destination;
  }

  // Login throttling (per identifier, in memory).
  const failures = new Map();
  const throttleKey = (identifier) => identifier.trim().toLowerCase();

  function checkThrottle(key) {
    const entry = failures.get(key);
    if (!entry) return;
    if (entry.resetAt < Date.now()) {
      failures.delete(key);
      return;
    }
    if (entry.count >= config.loginMaxFailures) {
      throw tooManyRequests('Too many failed attempts. Please try again later.');
    }
  }

  function recordFailure(key) {
    if (failures.size > 5000) {
      const now = Date.now();
      for (const [k, v] of failures) if (v.resetAt < now) failures.delete(k);
    }
    const entry = failures.get(key);
    if (entry && entry.resetAt >= Date.now()) {
      entry.count += 1;
    } else {
      failures.set(key, {
        count: 1,
        resetAt: Date.now() + config.loginWindowMinutes * 60 * 1000,
      });
    }
  }

  // ---- public API ------------------------------------------------------

  return {
    toApiUser,

    getUserFromAccessToken(token) {
      const userId = tokens.verifyAccessToken(token);
      return userId ? (q.userById.get(userId) ?? null) : null;
    },

    async register({ fullName, email, phoneNumber, verificationMethod }) {
      const name = normalizeName(fullName);
      const mail = normalizeEmail(email);
      const phone = normalizePhone(phoneNumber);
      const method = verificationMethod || 'EMAIL';
      if (method === 'PHONE' && !phone) {
        throw badInput('Add a phone number to verify by phone.');
      }

      let user = q.userByEmail.get(mail);
      if (user && user.status !== 'PENDING_VERIFICATION') {
        throw conflict('An account with this email already exists. Try logging in.');
      }

      if (phone) {
        const other = q.userByPhone.get(phone);
        if (other && (!user || other.id !== user.id)) {
          if (other.status !== 'PENDING_VERIFICATION') {
            throw conflict('An account with this phone number already exists.');
          }
          q.deleteUser.run(other.id); // stale, never-verified signup
        }
      }

      const now = Date.now();
      if (user) {
        q.updatePending.run(name, phone, now, user.id);
      } else {
        q.insertUser.run(crypto.randomUUID(), name, mail, phone, now, now);
      }
      user = q.userByEmail.get(mail);

      // A double-tap shouldn't send two emails.
      const last = q.lastCode.get(user.id);
      let destination = method === 'PHONE' ? user.phone_number : user.email;
      if (!last || secondsSince(last.created_at) >= config.resendCooldownSeconds) {
        destination = await issueCode(user, method);
      }

      return payload(user, {
        verificationRequired: true,
        message: `We sent a verification code to ${destination}.`,
      });
    },

    async verifyRegistration({ userId, code }) {
      const user = requireUser(userId);
      if (user.status !== 'PENDING_VERIFICATION') {
        return payload(user, { message: 'Already verified.' });
      }

      const entered = String(code ?? '').trim();
      if (!/^\d{6}$/.test(entered)) {
        throw badInput('Please enter the 6-digit verification code.');
      }

      const row = q.activeCode.get(user.id);
      if (!row) throw badInput('There is no active code. Please request a new one.');
      if (row.expires_at < Date.now()) {
        throw badInput('This code has expired. Please request a new one.');
      }
      if (row.attempts >= config.codeMaxAttempts) {
        throw tooManyRequests('Too many incorrect attempts. Please request a new code.');
      }

      q.bumpAttempts.run(row.id);
      if (!safeEqual(hashCode(user.id, entered), row.code_hash)) {
        const left = config.codeMaxAttempts - (row.attempts + 1);
        throw badInput(
          left > 0
            ? `Incorrect code. ${left} attempt${left === 1 ? '' : 's'} left.`
            : 'Too many incorrect attempts. Please request a new code.',
        );
      }

      transaction(db, () => {
        const now = Date.now();
        q.consumeCode.run(now, row.id);
        q.markVerified.run(
          row.method === 'EMAIL' ? 1 : user.email_verified,
          row.method === 'PHONE' ? 1 : user.phone_verified,
          now,
          user.id,
        );
      });

      return payload(q.userById.get(user.id), { message: 'Verification successful.' });
    },

    async resendVerificationCode({ userId, email, verificationMethod }) {
      let user = userId ? q.userById.get(String(userId)) : null;
      if (!user && email) {
        user = q.userByEmail.get(normalizeEmail(email));
      }
      if (!user) throw badInput('No pending registration was found.');
      if (user.status !== 'PENDING_VERIFICATION') {
        throw badInput('This account is already verified.');
      }

      const last = q.lastCode.get(user.id);
      const method = verificationMethod || last?.method || 'EMAIL';
      if (method === 'PHONE' && !user.phone_number) {
        throw badInput('Add a phone number to verify by phone.');
      }
      if (last && secondsSince(last.created_at) < config.resendCooldownSeconds) {
        const wait = Math.ceil(config.resendCooldownSeconds - secondsSince(last.created_at));
        throw tooManyRequests(`Please wait ${wait}s before requesting another code.`);
      }

      const destination = await issueCode(user, method);
      return payload(user, {
        verificationRequired: true,
        message: `A new code was sent to ${destination}.`,
      });
    },

    async completePasswordSetup({ userId, password }) {
      const user = requireUser(userId);
      if (user.status === 'PENDING_VERIFICATION') {
        throw forbidden('Please verify your account first.');
      }
      if (user.status !== 'PENDING_PASSWORD') {
        throw forbidden('A password has already been set. Please log in.');
      }
      const valid = validatePassword(password);
      const hash = await bcrypt.hash(valid, config.bcryptRounds);
      q.setPassword.run(hash, Date.now(), user.id);
      return payload(q.userById.get(user.id), { message: 'Password saved.' });
    },

    // Used during signup (no session yet) and later to edit the profile.
    async completeProfile({ userId, fullName, country, location, interests }, currentUser) {
      const user = requireUser(userId);
      const signingUp = user.status === 'PENDING_PROFILE';
      const isSelf = currentUser && currentUser.id === user.id;
      if (!signingUp && !isSelf) {
        throw currentUser
          ? forbidden('You can only edit your own profile.')
          : unauthenticated('Please log in to update your profile.');
      }

      q.setProfile.run(
        normalizeName(fullName),
        cleanOptionalText(country),
        cleanOptionalText(location),
        JSON.stringify(cleanInterests(interests)),
        Date.now(),
        user.id,
      );
      return payload(q.userById.get(user.id), { message: 'Profile saved.' });
    },

    async login({ identifier, password }) {
      const id = String(identifier ?? '').trim();
      const key = throttleKey(id);
      checkThrottle(key);

      let user = null;
      try {
        user = id.includes('@')
          ? q.userByEmail.get(normalizeEmail(id))
          : q.userByPhone.get(normalizePhone(id));
      } catch {
        user = null;
      }

      // Always run bcrypt so response time doesn't reveal whether the account exists.
      const matches = await bcrypt.compare(
        String(password ?? ''),
        user?.password_hash ?? dummyHash,
      );
      if (!user || !user.password_hash || !matches) {
        recordFailure(key);
        throw unauthenticated('Incorrect email/phone or password.');
      }
      failures.delete(key);

      if (user.status !== 'ACTIVE' && user.status !== 'PENDING_PROFILE') {
        throw accountIncomplete('Please finish setting up your account first.');
      }
      return startSession(user, 'Welcome back.');
    },

    // Rotates the refresh token: the old one stops working immediately.
    // Presenting an already-used token revokes every session for that user.
    async refreshSession({ refreshToken }) {
      const row = tokens.findRefreshToken(refreshToken ?? '');
      if (!row) throw unauthenticated(SESSION_EXPIRED);

      if (row.revoked_at) {
        tokens.revokeAllForUser(row.user_id);
        throw unauthenticated(SESSION_EXPIRED);
      }
      if (row.expires_at < Date.now()) throw unauthenticated(SESSION_EXPIRED);

      const user = q.userById.get(row.user_id);
      if (!user) throw unauthenticated(SESSION_EXPIRED);

      const next = transaction(db, () => {
        const issued = tokens.issueRefreshToken(user.id);
        tokens.revokeRefreshToken(row.id, issued.id);
        return issued;
      });

      return payload(user, {
        accessToken: tokens.signAccessToken(user.id),
        refreshToken: next.raw,
        message: 'Session refreshed.',
      });
    },

    async logout({ refreshToken }) {
      const row = tokens.findRefreshToken(refreshToken ?? '');
      if (row && !row.revoked_at) tokens.revokeRefreshToken(row.id);
      return 'Logged out.';
    },
  };
}

module.exports = { createAuthService };
