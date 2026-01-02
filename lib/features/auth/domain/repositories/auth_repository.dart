import '../../../../core/models/user_model.dart';

abstract class AuthRepository {
  Future<bool> signUp({
    required String name,
    required String email,
    required String password,
  });

  Future<bool> login({
    required String email,
    required String password,
  });

  Future<void> logout();

  User? getCurrentUser();

  bool isLoggedIn();

  Future<bool> updateUser(User user);
}
