import 'package:front_end_frotas/core/api_client.dart';
import 'package:front_end_frotas/core/token_storage.dart';
import 'package:front_end_frotas/task/models/user.dart';

class AuthService {
  final ApiClient api;
  final TokenStorage storage;

  AuthService(this.api, this.storage);

  Future<void> register({
    required String username,
    required String password,
    required String role,
  }) async {
    await api.post('/auth/register', {
      'username': username,
      'password': password,
      'role': role,
    });
  }

  Future<User> login({
    required String username,
    required String password,
  }) async {
    final res = await api.post('/auth/login', {
      'username': username,
      'password': password,
    });
    final token = res['access_token'] as String?;
    if (token == null) throw Exception('Token ausente no login');
    await storage.save(token);

    final userMap = res['userIn'] as Map<String, dynamic>;
    return User.fromJson(userMap);
  }

  Future<void> logout() => storage.clear();
}
