const { unauthenticated } = require('./errors');

const resolvers = {
  Query: {
    hello: () => 'Hello from Nexify Backend!',
    version: () => '1.1.0',
    me: (_, __, { auth, user }) => {
      if (!user) throw unauthenticated('Please log in to continue.');
      return auth.toApiUser(user);
    },
  },

  Mutation: {
    register: (_, { input }, { auth }) => auth.register(input),
    verifyRegistration: (_, { input }, { auth }) => auth.verifyRegistration(input),
    resendVerificationCode: (_, { input }, { auth }) => auth.resendVerificationCode(input),
    completePasswordSetup: (_, { input }, { auth }) => auth.completePasswordSetup(input),
    completeProfile: (_, { input }, { auth, user }) => auth.completeProfile(input, user),
    login: (_, { input }, { auth }) => auth.login(input),
    refreshSession: (_, { input }, { auth }) => auth.refreshSession(input),
    logout: (_, { input }, { auth }) => auth.logout(input),
  },
};

module.exports = { resolvers };
