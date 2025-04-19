import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/*
  This stores API tokens (e.g. Supabase JWT) securely.
 */

class SecureStorage {
  final _storage = const FlutterSecureStorage();
  Future<String?> readToken() =>
      _storage.read(key: 'auth_token');
  Future<void> writeToken(String token) =>
      _storage.write(key: 'auth_token', value: token);
}