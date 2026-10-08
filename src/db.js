const fs = require('fs');
const path = require('path');
const { DatabaseSync } = require('node:sqlite');

// Each entry runs once, in order. Never edit an old entry: add a new one.
const MIGRATIONS = [
  // 1: users + auth
  `
  CREATE TABLE users (
    id             TEXT PRIMARY KEY,
    full_name      TEXT NOT NULL,
    email          TEXT NOT NULL UNIQUE COLLATE NOCASE,
    phone_number   TEXT UNIQUE,
    password_hash  TEXT,
    country        TEXT,
    location       TEXT,
    interests      TEXT NOT NULL DEFAULT '[]',
    status         TEXT NOT NULL DEFAULT 'PENDING_VERIFICATION',
    email_verified INTEGER NOT NULL DEFAULT 0,
    phone_verified INTEGER NOT NULL DEFAULT 0,
    created_at     INTEGER NOT NULL,
    updated_at     INTEGER NOT NULL
  );

  CREATE TABLE verification_codes (
    id           INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id      TEXT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    method       TEXT NOT NULL,
    code_hash    TEXT NOT NULL,
    expires_at   INTEGER NOT NULL,
    attempts     INTEGER NOT NULL DEFAULT 0,
    consumed_at  INTEGER,
    created_at   INTEGER NOT NULL
  );
  CREATE INDEX idx_codes_user ON verification_codes(user_id, created_at);

  CREATE TABLE refresh_tokens (
    id           TEXT PRIMARY KEY,
    user_id      TEXT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    token_hash   TEXT NOT NULL UNIQUE,
    expires_at   INTEGER NOT NULL,
    revoked_at   INTEGER,
    replaced_by  TEXT,
    created_at   INTEGER NOT NULL
  );
  CREATE INDEX idx_refresh_user ON refresh_tokens(user_id);
  `,

  // 2: marketplace + feed content (used from step 3 onward)
  `
  CREATE TABLE products (
    id            TEXT PRIMARY KEY,
    seller_id     TEXT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    name          TEXT NOT NULL,
    description   TEXT,
    price         REAL NOT NULL,
    unit          TEXT NOT NULL,
    category      TEXT NOT NULL,
    location      TEXT,
    media_url     TEXT,
    thumbnail_url TEXT,
    media_type    TEXT NOT NULL DEFAULT 'IMAGE',
    created_at    INTEGER NOT NULL
  );
  CREATE INDEX idx_products_seller ON products(seller_id);
  CREATE INDEX idx_products_category ON products(category);

  CREATE TABLE services (
    id            TEXT PRIMARY KEY,
    provider_id   TEXT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    name          TEXT NOT NULL,
    description   TEXT,
    category      TEXT NOT NULL,
    location      TEXT,
    price         TEXT,
    availability  TEXT,
    experience    TEXT,
    media_url     TEXT,
    thumbnail_url TEXT,
    media_type    TEXT NOT NULL DEFAULT 'IMAGE',
    rating        REAL NOT NULL DEFAULT 0,
    reviews       INTEGER NOT NULL DEFAULT 0,
    created_at    INTEGER NOT NULL
  );
  CREATE INDEX idx_services_provider ON services(provider_id);

  CREATE TABLE posts (
    id             TEXT PRIMARY KEY,
    author_id      TEXT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    type           TEXT NOT NULL DEFAULT 'GENERAL',
    caption        TEXT,
    media_url      TEXT,
    thumbnail_url  TEXT,
    media_type     TEXT NOT NULL DEFAULT 'IMAGE',
    product_id     TEXT REFERENCES products(id) ON DELETE SET NULL,
    service_id     TEXT REFERENCES services(id) ON DELETE SET NULL,
    likes_count    INTEGER NOT NULL DEFAULT 0,
    comments_count INTEGER NOT NULL DEFAULT 0,
    views_count    INTEGER NOT NULL DEFAULT 0,
    created_at     INTEGER NOT NULL,
    updated_at     INTEGER NOT NULL
  );
  CREATE INDEX idx_posts_feed ON posts(created_at DESC, id DESC);
  CREATE INDEX idx_posts_type ON posts(type, created_at DESC);
  `,
];

function openDatabase(dbPath) {
  if (dbPath !== ':memory:') {
    fs.mkdirSync(path.dirname(path.resolve(dbPath)), { recursive: true });
  }
  const db = new DatabaseSync(dbPath);
  db.exec('PRAGMA journal_mode = WAL;');
  db.exec('PRAGMA foreign_keys = ON;');
  migrate(db);
  return db;
}

function migrate(db) {
  const current = db.prepare('PRAGMA user_version').get().user_version;
  for (let v = current; v < MIGRATIONS.length; v++) {
    db.exec('BEGIN');
    try {
      db.exec(MIGRATIONS[v]);
      db.exec(`PRAGMA user_version = ${v + 1}`);
      db.exec('COMMIT');
    } catch (err) {
      db.exec('ROLLBACK');
      throw err;
    }
  }
}

// node:sqlite is synchronous, so run multi-statement work inside one
// transaction (no `await` inside fn).
function transaction(db, fn) {
  db.exec('BEGIN IMMEDIATE');
  try {
    const result = fn();
    db.exec('COMMIT');
    return result;
  } catch (err) {
    db.exec('ROLLBACK');
    throw err;
  }
}

module.exports = { openDatabase, transaction };
