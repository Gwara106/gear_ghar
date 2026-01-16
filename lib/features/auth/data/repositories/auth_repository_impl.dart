import '../../../../../core/models/api_user_model.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_api_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthApiDataSource _dataSource = AuthApiDataSource();

  @override
  Future<bool> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final result = await _dataSource.signUpUser(
        name: name,
        email: email,
        password: password,
      );
      return result['success'] ?? false;
    } catch (e) {
      print('AuthRepositoryImpl: Error during sign up: $e');
      return false;
    }
  }

  @override
  Future<bool> login({
    required String email,
    required String password,
  }) async {
    try {
      final result = await _dataSource.loginUser(
        email: email,
        password: password,
      );
      return result['success'] ?? false;
    } catch (e) {
      print('AuthRepositoryImpl: Error during login: $e');
      return false;
    }
  }

  @override
  Future<void> logout() async {
    await _dataSource.logoutUser();
  }

  @override
  Future<ApiUser> getCurrentUser() async {
    return await _dataSource.getCurrentUserData();
  }

  @override
  bool isLoggedIn() {
    return _dataSource.checkLoginStatus();
  }

  @override
  Future<bool> updateUser(ApiUser user) async {
    try {
      await _dataSource.updateUserData(
        name: user.fullName,
      );
      print('AuthRepositoryImpl: User updated: ${user.email}');
      return true;
    } catch (e) {
      print('AuthRepositoryImpl: Error updating user: $e');
      return false;
    }
  }
}
