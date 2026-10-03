enum AuthStatus { loggedOut, loggingIn, loggedIn }

class AppUser {
  const AppUser({
    required this.id,
    required this.name,
    required this.email,
    this.phoneNumber,
    this.country,
    this.location,
    this.interests = const <String>[],
  });

  final String id;
  final String name;
  final String email;
  final String? phoneNumber;
  final String? country;
  final String? location;
  final List<String> interests;
}

class AuthSession {
  const AuthSession.loggedOut() : status = AuthStatus.loggedOut, user = null;

  const AuthSession.loggingIn() : status = AuthStatus.loggingIn, user = null;

  const AuthSession.loggedIn(AppUser this.user) : status = AuthStatus.loggedIn;

  final AuthStatus status;
  final AppUser? user;

  bool get isLoggedIn => status == AuthStatus.loggedIn && user != null;
}
