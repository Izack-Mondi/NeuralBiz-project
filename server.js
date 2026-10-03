const express = require('express');
const { ApolloServer } = require('@apollo/server');
const { expressMiddleware } = require('@apollo/server/express4');
const { ApolloServerPluginDrainHttpServer } = require('@apollo/server/plugin/drainHttpServer');
const http = require('http');
const cors = require('cors');

const app = express();
const PORT = 3000;

// Basic GraphQL schema
const typeDefs = `#graphql
  type Query {
    hello: String
    version: String
  }
  
  type Mutation {
    sendMessage(message: String!): String
  }
`;

const resolvers = {
  Query: {
    hello: () => 'Hello from Nexify Backend!',
    version: () => '1.0.0'
  },
  Mutation: {
    sendMessage: (_, { message }) => {
      console.log('Received message:', message);
      return `Message received: ${message}`;
    }
  }
};

async function startServer() {
  const httpServer = http.createServer(app);

  const server = new ApolloServer({
    typeDefs,
    resolvers,
    plugins: [ApolloServerPluginDrainHttpServer({ httpServer })],
  });

  await server.start();

  app.use(cors());
  app.use(express.json());

  app.use('/graphql', expressMiddleware(server));

  // Health check endpoint
  app.get('/health', (req, res) => {
    res.json({ status: 'ok', message: 'Nexify Backend is running' });
  });

  // Basic API endpoint
  app.get('/api/status', (req, res) => {
    res.json({ 
      status: 'running', 
      version: '1.0.0',
      timestamp: new Date().toISOString()
    });
  });

  await new Promise(resolve => httpServer.listen({ port: PORT }, resolve));
  console.log(`🚀 Server ready at http://localhost:${PORT}`);
  console.log(`📊 GraphQL endpoint: http://localhost:${PORT}/graphql`);
  console.log(`❤️  Health check: http://localhost:${PORT}/health`);
}

startServer().catch(err => {
  console.error('Error starting server:', err);
  process.exit(1);
});