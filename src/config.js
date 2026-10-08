require('dotenv').config();

function loadConfig(overrides = {}) {
  const env = process.env;
  const isProduction = env.NODE_ENV === 'production';

  let jwtSecret = overrides.jwtSecret ?? env.JWT_SECRET;
  if (!jwtSecret) {
    if (isProduction) {
      throw new Error('JWT_SECRET must be set when NODE_ENV=production');
    }
    jwtSecret = 'dev-only-insecure-secret-change-me';
    console.warn('⚠️  JWT_SECRET is not set. Using an insecure dev secret.');
  }

  return {
    isProduction,
    port: Number(env.PORT) || 3000,
    dbPath: env.DATABASE_PATH || './data/nexify.db',
    jwtSecret,
    jwtIssuer: 'nexify',
    accessTokenTtl: '15m',
    refreshTokenTtlDays: 30,
    bcryptRounds: 10,
    codeTtlMinutes: 10,
    codeMaxAttempts: 5,
    resendCooldownSeconds: 60,
    loginMaxFailures: 8,
    loginWindowMinutes: 15,
    ...overrides,
  };
}

module.exports = { loadConfig };
