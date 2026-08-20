import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenStorageService {
  TokenStorageService(this._storage);

  final FlutterSecureStorage _storage;

  static const _tokenKey = 'jwt_token';

  Future<void> saveToken(String token) {
    return _storage.write(key: _tokenKey, value: token);
  }

  Future<String?> readToken() {
    return _storage.read(key: _tokenKey);
  }

  Future<void> clearToken() {
    return _storage.delete(key: _tokenKey);
  }
}
