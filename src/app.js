const http = require('http');
const express = require('express');
const cors = require('cors');
const { ApolloServer } = require('@apollo/server');
const { expressMiddleware } = require('@apollo/server/express4');
const { ApolloServerPluginDrainHttpServer } = require('@apollo/server/plugin/drainHttpServer');

const { loadConfig } = require('./config');
const { openDatabase } = require('./db');
const { typeDefs } = require('./schema');
const { resolvers } = require('./resolvers');
const { createAuthService } = require('./auth/service');

async function createApp(overrides = {}) {
  const config = loadConfig(overrides);
  const db = openDatabase(config.dbPath);
  const auth = createAuthService(db, config);

  const app = express();
  const httpServer = http.createServer(app);

  const server = new ApolloServer({
    typeDefs,
    resolvers,
    introspection: !config.isProduction,
    plugins: [ApolloServerPluginDrainHttpServer({ httpServer })],
    formatError: (formatted, error) => {
      if (formatted.extensions?.code === 'INTERNAL_SERVER_ERROR') {
        console.error('Unhandled GraphQL error:', error);
        if (config.isProduction) {
          return {
            message: 'Something went wrong. Please try again.',
            extensions: { code: 'INTERNAL_SERVER_ERROR' },
          };
        }
      }
      return formatted;
    },
  });
  await server.start();

  app.use(cors());
  app.use(express.json({ limit: '1mb' }));

  app.use(
    '/graphql',
    expressMiddleware(server, {
      context: async ({ req }) => {
        const match = /^Bearer (.+)$/i.exec(req.headers.authorization || '');
        const user = match ? auth.getUserFromAccessToken(match[1]) : null;
        return { auth, user };
      },
    }),
  );

  app.get('/health', (req, res) => {
    res.json({ status: 'ok', message: 'Nexify Backend is running' });
  });

  app.get('/api/status', (req, res) => {
    res.json({
      status: 'running',
      version: '1.1.0',
      timestamp: new Date().toISOString(),
    });
  });

  return {
    config,
    db,
    async listen(port = config.port) {
      await new Promise((resolve) => httpServer.listen({ port }, resolve));
      return httpServer.address().port;
    },
    async close() {
      await server.stop();
      if (httpServer.listening) {
        await new Promise((resolve) => httpServer.close(resolve));
      }
      db.close();
    },
  };
}

module.exports = { createApp };
