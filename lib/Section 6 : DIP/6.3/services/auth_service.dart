abstract class AuthService {
  Future<bool> login(String email, String password);

  bool isLoggedIn();

  String? getCurrentUserId();
}

class AuthServiceImpl implements AuthService {
  @override
  Future<bool> login(String email, String password) async {
    print('Logging in...');
    await Future.delayed(Duration(seconds: 1));
    return true;
  }

  @override
  bool isLoggedIn() => true;

  @override
  String? getCurrentUserId() => 'user123';
}
