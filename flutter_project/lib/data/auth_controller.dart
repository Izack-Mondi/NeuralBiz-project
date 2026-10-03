import 'package:flutter/foundation.dart';

import 'api_client.dart';
import 'auth_session.dart';
import 'session_storage.dart';

class PendingSignup {
  const PendingSignup({required this.userId, required this.email});

  final String userId;
  final String email;
}

class AuthController extends ChangeNotifier {
  AuthController({SessionStorage? sessionStorage, ApiClient? apiClient})
    : _sessionStorage = sessionStorage ?? const SessionStorage(),
      _apiClient = apiClient ?? ApiClient();

  final SessionStorage _sessionStorage;
  final ApiClient _apiClient;
  AuthSession _session = const AuthSession.loggedOut();
  PendingSignup? _pendingSignup;
  String? _accessToken;
  String? _refreshToken;

  AuthSession get session => _session;
  PendingSignup? get pendingSignup => _pendingSignup;
  String? get currentUserId => _session.user?.id;

  Future<bool> register({
    required String name,
    required String email,
    required String phone,
    String? verificationMethod,
  }) async {
    _setSession(const AuthSession.loggingIn());
    try {
      final payload = await _apiClient.register(
        fullName: name,
        email: email,
        phoneNumber: phone,
        verificationMethod: verificationMethod,
      );
      _pendingSignup = PendingSignup(userId: payload.user.id, email: email);
      _setSession(const AuthSession.loggedOut());
      return payload.verificationRequired ?? true;
    } catch (_) {
      _setSession(const AuthSession.loggedOut());
      rethrow;
    }
  }

  Future<void> verifyRegistration(String userId, String code) async {
    await _apiClient.verifyRegistration(userId: userId, code: code);
  }

  Future<void> resendVerificationCode(String userId, String email, String verificationMethod) async {
    await _apiClient.resendVerificationCode(
      userId: userId,
      email: email,
      verificationMethod: verificationMethod,
    );
  }

  Future<void> completePasswordSetup(String userId, String password) async {
    await _apiClient.completePasswordSetup(
      userId: userId,
      password: password,
    );
  }

  Future<void> completeProfileAndLogin({
    required String userId,
    required String email,
    required String fullName,
    required String country,
    required String location,
    required List<String> interests,
    required String password,
  }) async {
    await _apiClient.completeProfile(
      userId: userId,
      fullName: fullName,
      country: country,
      location: location,
      interests: interests,
    );
    await login(email, password);
    _pendingSignup = null;
  }

  Future<void> updateProfile({
    required String fullName,
    required String country,
    required String location,
    required List<String> interests,
  }) async {
    final userId = currentUserId;
    if (userId == null) {
      throw const ApiException('You must be logged in to update your profile.');
    }
    final payload = await _apiClient.completeProfile(
      userId: userId,
      fullName: fullName,
      country: country,
      location: location,
      interests: interests,
    );
    _setSession(AuthSession.loggedIn(_toAppUser(payload.user)));
    final accessToken = _accessToken;
    final refreshToken = _refreshToken;
    if (accessToken == null || refreshToken == null) {
      throw const ApiException('Your session has expired.');
    }
    await _saveSession(payload.user, accessToken, refreshToken);
  }

  Future<void> login(String identifier, String password) async {
    _setSession(const AuthSession.loggingIn());
    try {
      final payload = await _apiClient.login(
        identifier: identifier,
        password: password,
      );
      await _applyAuthPayload(payload);
    } catch (_) {
      _setSession(const AuthSession.loggedOut());
      rethrow;
    }
  }

  Future<void> tryRestoreSession() async {
    final stored = await _sessionStorage.readSession();
    if (stored == null) {
      return;
    }
    final accessToken = stored['accessToken']!;
    final refreshToken = stored['refreshToken']!;
    _refreshToken = refreshToken;
    _accessToken = accessToken;
    _apiClient.accessToken = accessToken;
    try {
      final user = await _apiClient.me();
      _setSession(AuthSession.loggedIn(_toAppUser(user)));
      await _saveSession(user, accessToken, refreshToken);
      return;
    } catch (_) {
      try {
        final payload = await _apiClient.refreshSession(
          refreshToken: refreshToken,
        );
        await _applyAuthPayload(payload);
        return;
      } catch (_) {
        await _clearSession();
      }
    }
  }

  Future<void> logout() async {
    final refreshToken = _refreshToken;
    try {
      if (refreshToken != null) {
        await _apiClient.logout(refreshToken: refreshToken);
      }
    } finally {
      await _clearSession();
    }
  }

  PendingSignup _requirePendingSignup() {
    final pending = _pendingSignup;
    if (pending == null) {
      throw const ApiException('No pending registration was found.');
    }
    return pending;
  }

  Future<void> _applyAuthPayload(AuthPayload payload) async {
    final accessToken = payload.accessToken;
    final refreshToken = payload.refreshToken;
    if (accessToken == null || refreshToken == null) {
      throw const ApiException('The server did not return a complete session.');
    }
    _apiClient.accessToken = accessToken;
    _accessToken = accessToken;
    _refreshToken = refreshToken;
    _setSession(AuthSession.loggedIn(_toAppUser(payload.user)));
    await _saveSession(payload.user, accessToken, refreshToken);
  }

  Future<void> _saveSession(
    ApiUser user,
    String accessToken,
    String refreshToken,
  ) {
    return _sessionStorage.saveSession(
      userId: user.id,
      userName: user.fullName,
      userEmail: user.email,
      accessToken: accessToken,
      refreshToken: refreshToken,
    );
  }

  Future<void> _clearSession() async {
    _apiClient.accessToken = null;
    _accessToken = null;
    _refreshToken = null;
    _pendingSignup = null;
    _setSession(const AuthSession.loggedOut());
    await _sessionStorage.clearSession();
  }

  AppUser _toAppUser(ApiUser user) => AppUser(
    id: user.id,
    name: user.fullName,
    email: user.email,
    phoneNumber: user.phoneNumber,
    country: user.country,
    location: user.location,
    interests: user.interests,
  );

  void _setSession(AuthSession session) {
    _session = session;
    notifyListeners();
  }
}
