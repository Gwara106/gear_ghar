import '../../../../core/services/auth_api_service.dart';
import '../../../../core/models/api_user_model.dart';

class AuthRepository {
  final AuthApiService _authApiService = AuthApiService();

  Future<Map<String, dynamic>> signUp({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
  }) async {
    try {
      final result = await _authApiService.register(
        firstName: firstName,
        lastName: lastName,
        email: email,
        password: password,
      );
      return result;
    } catch (e) {
      throw Exception('Failed to sign up: $e');
    }
  }

  Future<Map<String, dynamic>> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final result = await _authApiService.login(
        email: email,
        password: password,
      );
      return result;
    } catch (e) {
      throw Exception('Failed to sign in: $e');
    }
  }

  Future<void> signOut() async {
    try {
      await _authApiService.logout();
    } catch (e) {
      // Even if logout fails on server, continue with local cleanup
      print('Logout API call failed: $e');
    }
  }

  Future<ApiUser> getCurrentUser() async {
    try {
      return await _authApiService.getProfile();
    } catch (e) {
      throw Exception('Failed to get current user: $e');
    }
  }

  Future<ApiUser> updateProfile({
    required String firstName,
    required String lastName,
  }) async {
    try {
      return await _authApiService.updateProfile(
        firstName: firstName,
        lastName: lastName,
      );
    } catch (e) {
      throw Exception('Failed to update profile: $e');
    }
  }
}
