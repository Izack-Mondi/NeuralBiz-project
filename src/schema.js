const typeDefs = `#graphql
  enum VerificationMethod {
    EMAIL
    PHONE
  }

  enum UserStatus {
    PENDING_VERIFICATION
    PENDING_PASSWORD
    PENDING_PROFILE
    ACTIVE
  }

  type User {
    id: ID!
    fullName: String!
    email: String!
    phoneNumber: String
    country: String
    location: String
    interests: [String!]!
    status: UserStatus!
    emailVerified: Boolean!
    phoneVerified: Boolean!
  }

  type AuthPayload {
    accessToken: String
    refreshToken: String
    verificationRequired: Boolean
    message: String
    user: User!
  }

  input RegisterInput {
    fullName: String!
    email: String!
    phoneNumber: String
    verificationMethod: VerificationMethod
  }

  input VerifyRegistrationInput {
    userId: ID!
    code: String!
  }

  input ResendVerificationCodeInput {
    userId: ID
    email: String
    verificationMethod: VerificationMethod
  }

  input CompletePasswordSetupInput {
    userId: ID!
    password: String!
  }

  input CompleteProfileInput {
    userId: ID!
    fullName: String!
    country: String
    location: String
    interests: [String!]
  }

  input LoginInput {
    identifier: String!
    password: String!
  }

  input RefreshSessionInput {
    refreshToken: String!
  }

  input LogoutInput {
    refreshToken: String!
  }

  type Query {
    hello: String
    version: String
    me: User!
  }

  type Mutation {
    register(input: RegisterInput!): AuthPayload!
    verifyRegistration(input: VerifyRegistrationInput!): AuthPayload!
    resendVerificationCode(input: ResendVerificationCodeInput!): AuthPayload!
    completePasswordSetup(input: CompletePasswordSetupInput!): AuthPayload!
    completeProfile(input: CompleteProfileInput!): AuthPayload!
    login(input: LoginInput!): AuthPayload!
    refreshSession(input: RefreshSessionInput!): AuthPayload!
    logout(input: LogoutInput!): String!
  }
`;

module.exports = { typeDefs };
