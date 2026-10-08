const crypto = require('crypto');
const jwt = require('jsonwebtoken');

const sha256 = (value) => crypto.createHash('sha256').update(value).digest('hex');

function createTokenService(db, config) {
  const insertRefresh = db.prepare(
    `INSERT INTO refresh_tokens (id, user_id, token_hash, expires_at, created_at)
     VALUES (?, ?, ?, ?, ?)`,
  );
  const findRefresh = db.prepare('SELECT * FROM refresh_tokens WHERE token_hash = ?');
  const revokeOne = db.prepare(
    'UPDATE refresh_tokens SET revoked_at = ?, replaced_by = ? WHERE id = ? AND revoked_at IS NULL',
  );
  const revokeAll = db.prepare(
    'UPDATE refresh_tokens SET revoked_at = ? WHERE user_id = ? AND revoked_at IS NULL',
  );

  return {
    signAccessToken(userId) {
      return jwt.sign({}, config.jwtSecret, {
        algorithm: 'HS256',
        subject: userId,
        issuer: config.jwtIssuer,
        expiresIn: config.accessTokenTtl,
      });
    },

    // Returns the user id, or null for any invalid/expired token.
    verifyAccessToken(token) {
      try {
        const payload = jwt.verify(token, config.jwtSecret, {
          algorithms: ['HS256'],
          issuer: config.jwtIssuer,
        });
        return payload.sub ?? null;
      } catch {
        return null;
      }
    },

    // Refresh tokens are random opaque strings; only their hash is stored.
    issueRefreshToken(userId) {
      const raw = crypto.randomBytes(48).toString('base64url');
      const id = crypto.randomUUID();
      const now = Date.now();
      const expiresAt = now + config.refreshTokenTtlDays * 24 * 60 * 60 * 1000;
      insertRefresh.run(id, userId, sha256(raw), expiresAt, now);
      return { raw, id };
    },

    findRefreshToken(raw) {
      return findRefresh.get(sha256(String(raw))) ?? null;
    },

    revokeRefreshToken(id, replacedBy = null) {
      revokeOne.run(Date.now(), replacedBy, id);
    },

    revokeAllForUser(userId) {
      revokeAll.run(Date.now(), userId);
    },
  };
}

module.exports = { createTokenService };
