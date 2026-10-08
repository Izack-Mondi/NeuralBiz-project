# Nexify

Nexify is a Flutter mobile app for connecting people, trading products and services, and finding opportunities. It comes with a Node.js GraphQL backend.

## Features

- Home feed with posts and videos
- Marketplace: list products, offer services, and make requests
- Network: connect with other users
- Opportunities board
- Sign up with email or phone verification, password login, and persistent sessions

## Project Structure

```
Nexify-project/
├── flutter_project/        # Flutter app (screens, widgets, data, theme)
├── server.js               # Starts the backend
├── src/
│   ├── app.js              # Express + Apollo setup
│   ├── config.js           # Environment settings
│   ├── db.js               # SQLite connection + migrations
│   ├── schema.js           # GraphQL schema
│   ├── resolvers.js        # GraphQL resolvers
│   ├── delivery.js         # Sends verification codes (SMTP email)
│   └── auth/               # Auth logic (service, tokens, validation)
├── scripts/test-email.js   # Checks your SMTP settings
├── test/                   # Auth and delivery tests
└── package.json
```

## Getting Started

### Backend

Requires Node.js 22.5 or newer (it uses the built-in `node:sqlite`, so there is nothing native to compile).

```bash
npm install
cp .env.example .env     # then set JWT_SECRET
npm start
```

The server runs at `http://localhost:3000`:

- GraphQL: `/graphql`
- Health check: `/health`
- Status: `/api/status`

The SQLite database is created automatically at `DATABASE_PATH` (default `./data/nexify.db`) and migrated on startup.

**Verification codes:** email codes are sent over SMTP when `SMTP_HOST`, `SMTP_USER` and `SMTP_PASS` are set in `.env`. Check your settings with `node scripts/test-email.js you@example.com`. If SMTP isn't set (development only), codes are printed in the server console. There is no SMS provider yet, so phone codes also print in the console; plug one in with `setSender()` in `src/delivery.js`.

Run the tests with `npm test`.

### Flutter App

```bash
cd flutter_project
flutter pub get
flutter run --dart-define=NEXIFY_API_URL=http://<backend-address>:3000/graphql
```

Use `http://10.0.2.2:3000/graphql` for the Android emulator, or your computer's local network IP for a physical phone.

The feed still uses mock data until the content API is connected.

## Auth Flow

`register` → `verifyRegistration` → `completePasswordSetup` → `completeProfile` → `login`

Access tokens last 15 minutes. Refresh tokens last 30 days, are rotated on every use, and reusing an old one signs out all sessions for that user.

## Tech Stack

- Flutter and Dart (Provider, Hive)
- Node.js, Express, Apollo Server, GraphQL
- SQLite (`node:sqlite`), bcryptjs, JSON Web Tokens
