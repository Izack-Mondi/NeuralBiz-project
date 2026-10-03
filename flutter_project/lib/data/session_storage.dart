import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SessionStorage {
  const SessionStorage({this._storage = const FlutterSecureStorage()});

  static const _userIdKey = 'session_user_id';
  static const _userNameKey = 'session_user_name';
  static const _userEmailKey = 'session_user_email';
  static const _accessTokenKey = 'session_access_token';
  static const _refreshTokenKey = 'session_refresh_token';

  final FlutterSecureStorage _storage;

  Future<void> saveSession({
    required String userId,
    required String userName,
    required String userEmail,
    required String accessToken,
    required String refreshToken,
  }) async {
    await _storage.write(key: _userIdKey, value: userId);
    await _storage.write(key: _userNameKey, value: userName);
    await _storage.write(key: _userEmailKey, value: userEmail);
    await _storage.write(key: _accessTokenKey, value: accessToken);
    await _storage.write(key: _refreshTokenKey, value: refreshToken);
  }

  Future<Map<String, String>?> readSession() async {
    final values = await Future.wait([
      _storage.read(key: _userIdKey),
      _storage.read(key: _userNameKey),
      _storage.read(key: _userEmailKey),
      _storage.read(key: _accessTokenKey),
      _storage.read(key: _refreshTokenKey),
    ]);
    final userId = values[0];
    final userName = values[1];
    final userEmail = values[2];
    final accessToken = values[3];
    final refreshToken = values[4];

    if (userId == null ||
        userName == null ||
        userEmail == null ||
        accessToken == null ||
        refreshToken == null) {
      return null;
    }

    return {
      'userId': userId,
      'userName': userName,
      'userEmail': userEmail,
      'accessToken': accessToken,
      'refreshToken': refreshToken,
    };
  }

  Future<void> clearSession() async {
    await Future.wait([
      _storage.delete(key: _userIdKey),
      _storage.delete(key: _userNameKey),
      _storage.delete(key: _userEmailKey),
      _storage.delete(key: _accessTokenKey),
      _storage.delete(key: _refreshTokenKey),
    ]);
  }
}
