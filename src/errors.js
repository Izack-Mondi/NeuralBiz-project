const { GraphQLError } = require('graphql');

const make = (code) => (message) =>
  new GraphQLError(message, { extensions: { code } });

module.exports = {
  badInput: make('BAD_USER_INPUT'),
  unauthenticated: make('UNAUTHENTICATED'),
  forbidden: make('FORBIDDEN'),
  conflict: make('CONFLICT'),
  tooManyRequests: make('TOO_MANY_REQUESTS'),
  accountIncomplete: make('ACCOUNT_INCOMPLETE'),
};
