const { createApp } = require('./src/app');

async function main() {
  const nexify = await createApp();
  const port = await nexify.listen();

  console.log(`🚀 Server ready at http://localhost:${port}`);
  console.log(`📊 GraphQL endpoint: http://localhost:${port}/graphql`);
  console.log(`❤️  Health check: http://localhost:${port}/health`);
  console.log(`🗄️  Database: ${nexify.config.dbPath}`);

  const shutdown = async () => {
    await nexify.close();
    process.exit(0);
  };
  process.on('SIGINT', shutdown);
  process.on('SIGTERM', shutdown);
}

main().catch((err) => {
  console.error('Error starting server:', err);
  process.exit(1);
});
