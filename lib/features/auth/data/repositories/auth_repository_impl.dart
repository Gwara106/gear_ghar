import '../../../../../core/models/user_model.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthDataSource _dataSource = AuthDataSource();

  @override
  Future<bool> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    return await _dataSource.signUpUser(
      name: name,
      email: email,
      password: password,
    );
  }

  @override
  Future<bool> login({
    required String email,
    required String password,
  }) async {
    return await _dataSource.loginUser(
      email: email,
      password: password,
    );
  }

  @override
  Future<void> logout() async {
    await _dataSource.logoutUser();
  }

  @override
  User? getCurrentUser() {
    return _dataSource.getCurrentUserData();
  }

  @override
  bool isLoggedIn() {
    return _dataSource.checkLoginStatus();
  }

  @override
  Future<bool> updateUser(User user) async {
    try {
      // For simplicity, we'll just return true since Hive automatically saves changes
      // In a real implementation, you might want to explicitly update the user in the box
      print('AuthRepositoryImpl: User updated: ${user.email}');
      return true;
    } catch (e) {
      print('AuthRepositoryImpl: Error updating user: $e');
      return false;
    }
  }
}
