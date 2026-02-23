import '../../../../core/services/auth_api_service.dart';
import '../../../../core/models/api_user_model.dart';

class AuthApiDataSource {
  final AuthApiService _authApiService = AuthApiService();

  Future<Map<String, dynamic>> signUpUser({
    required String name,
    required String email,
    required String password,
    String? profilePicturePath,
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
      profilePicturePath: profilePicturePath,
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
    String? profilePicturePath,
  }) async {
    // Split name into first and last name for the API
    final nameParts = name.split(' ');
    final firstName = nameParts[0];
    final lastName = nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '';
    
    return await _authApiService.updateProfile(
      firstName: firstName,
      lastName: lastName,
      profilePicturePath: profilePicturePath,
    );
  }

  bool checkLoginStatus() {
    // Check if there's a stored token
    final token = _authApiService.getToken();
    return token != null && token.isNotEmpty;
  }
}
