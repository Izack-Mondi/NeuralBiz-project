# Nexify

Nexify is a Flutter mobile app for connecting people, trading products and services, and finding opportunities. It comes with a small Node.js GraphQL backend.

## Features

- Home feed with posts and videos
- Marketplace: list products, offer services, and make requests
- Network: connect with other users
- Opportunities board
- Sign in and local storage for listings and connection requests

## Project Structure

```
Nexify-project/
├── flutter_project/   # Flutter app (screens, widgets, data, theme)
├── server.js          # Express + Apollo GraphQL backend
└── package.json
```

## Getting Started

### Backend

```bash
npm install
npm start
```

The server runs at `http://localhost:3000`:

- GraphQL: `/graphql`
- Health check: `/health`
- Status: `/api/status`

### Flutter App

```bash
cd flutter_project
flutter pub get
flutter run
```

The app currently uses mock data for the feed, so it runs without the backend.

## Tech Stack

- Flutter and Dart (Provider, Hive)
- Node.js, Express, Apollo Server, GraphQL
