import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenService {

  final _secureStorage = const FlutterSecureStorage();

  Future<bool> addToken(String token) async {
    await _secureStorage.write(key: "token", value: token);
    return true;
  }

  Future<String?> getToken() async {
    final token = await _secureStorage.read(key: "token");
    return token;
  }

  Future<bool> deleteToken() async {
    _secureStorage.delete(key: "token");
    return true;
  }
}
