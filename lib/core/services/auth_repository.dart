import '../../shared/models/user_session.dart';
import 'api_client.dart';
import 'token_storage_service.dart';

class AuthRepository {
  AuthRepository(
    this._apiClient,
    this._tokenStorageService,
  );

  final ApiClient _apiClient;
  final TokenStorageService _tokenStorageService;

  Future<UserSession> login({
    required String email,
    required String password,
  }) async {
    final response = await _apiClient.post(
      '/auth/login',
      body: {
        'email': email,
        'password': password,
      },
    );

    final token = response['token'] as String;
    await _tokenStorageService.saveToken(token);

    return UserSession(
      token: token,
      user: AppUser.fromJson(response['user'] as Map<String, dynamic>),
    );
  }

  Future<void> register({
    required String name,
    required String email,
    required String password,
  }) async {
    await _apiClient.post(
      '/auth/register',
      body: {
        'name': name,
        'email': email,
        'password': password,
      },
    );
  }

  Future<AppUser?> currentUser() async {
    final token = await _tokenStorageService.readToken();

    if (token == null) {
      return null;
    }

    final response = await _apiClient.get('/auth/me');
    return AppUser.fromJson(response['user'] as Map<String, dynamic>);
  }

  Future<void> logout() {
    return _tokenStorageService.clearToken();
  }
}
