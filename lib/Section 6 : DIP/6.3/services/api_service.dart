import 'package:solid_examples/Section%206%20:%20DIP/6.3/services/auth_service.dart';

abstract class ApiService {
  Future<List<String>> fetchUserPosts(String userId);
}

class RestApiService implements ApiService {
  final AuthService _authService;

  RestApiService(this._authService);

  @override
  Future<List<String>> fetchUserPosts(String userId) async {
    if (!_authService.isLoggedIn()) {
      throw Exception('User not logged in');
    }
    await Future.delayed(Duration(milliseconds: 500));
    return ['Post 1', 'Post 2', 'Post 3'];
  }
}
