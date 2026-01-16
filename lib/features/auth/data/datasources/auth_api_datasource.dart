import '../../../../core/services/auth_api_service.dart';
import '../../../../core/models/api_user_model.dart';

class AuthApiDataSource {
  final AuthApiService _authApiService = AuthApiService();

  Future<Map<String, dynamic>> signUpUser({
    required String name,
    required String email,
    required String password,
  }) async {
    // Split name into first and last name for the API
    final nameParts = name.split(' ');
    final firstName = nameParts[0];
    final lastName = nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '';
    
    return await _authApiService.register(
      firstName: firstName,
      lastName: lastName,
      email: email,
      password: password,
    );
  }

  Future<Map<String, dynamic>> loginUser({
    required String email,
    required String password,
  }) async {
    return await _authApiService.login(
      email: email,
      password: password,
    );
  }

  Future<void> logoutUser() async {
    await _authApiService.logout();
  }

  Future<ApiUser> getCurrentUserData() async {
    return await _authApiService.getProfile();
  }

  Future<ApiUser> updateUserData({
    required String name,
  }) async {
    // Split name into first and last name for the API
    final nameParts = name.split(' ');
    final firstName = nameParts[0];
    final lastName = nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '';
    
    return await _authApiService.updateProfile(
      firstName: firstName,
      lastName: lastName,
    );
  }

  bool checkLoginStatus() {
    // For now, return false since we don't have persistent login state
    // In a real implementation, you would check token storage or local storage
    return false;
  }
}
