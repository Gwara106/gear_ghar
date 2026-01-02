import '../../../../../core/services/hive_auth_service.dart';

class AuthDataSource {
  final HiveAuthService _hiveService = HiveAuthService.instance;

  Future<bool> signUpUser({
    required String name,
    required String email,
    required String password,
  }) async {
    return await _hiveService.signUp(
      name: name,
      email: email,
      password: password,
    );
  }

  Future<bool> loginUser({
    required String email,
    required String password,
  }) async {
    return await _hiveService.login(email: email, password: password);
  }

  Future<void> logoutUser() async {
    await _hiveService.logout();
  }

  dynamic getCurrentUserData() {
    return _hiveService.getCurrentUser();
  }

  bool checkLoginStatus() {
    return _hiveService.isLoggedIn();
  }
}
