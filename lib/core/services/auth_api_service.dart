import '../services/api_service.dart';
import '../models/api_user_model.dart';
import '../constants/api_constants.dart';

class AuthApiService {
  final ApiService _apiService = ApiService();
  
  // Get current token
  String? getToken() => _apiService.getToken();
  
  // Register new user
  Future<Map<String, dynamic>> register({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    String? profilePicturePath,
  }) async {
    try {
      final requestData = {
        'firstName': firstName,
        'lastName': lastName,
        'name': '$firstName $lastName', // For backward compatibility
        'email': email,
        'password': password,
      };
      
      // Add profile picture if provided
      if (profilePicturePath != null && profilePicturePath.isNotEmpty) {
        requestData['profilePicture'] = profilePicturePath;
      }
      
      // Send to mobile backend with unified schema
      final response = await _apiService.post(ApiConstants.register, requestData);
      
      // If registration returns a token, set it
      if (response['token'] != null) {
        await _apiService.setToken(response['token']);
      }
      
      return response;
    } catch (e) {
      throw Exception('Registration failed: $e');
    }
  }
  
  // Login user
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _apiService.post(ApiConstants.login, {
        'email': email,
        'password': password,
      });
      
      // Set token if login successful
      if (response['token'] != null) {
        await _apiService.setToken(response['token']);
      }
      
      return response;
    } catch (e) {
      throw Exception('Login failed: $e');
    }
  }
  
  // Get user profile
  Future<ApiUser> getProfile() async {
    try {
      final response = await _apiService.get(ApiConstants.profile);
      return ApiUser.fromJson(response['data']);
    } catch (e) {
      // If we get a 401 or similar error, it means no user is logged in
      if (e.toString().contains('401') || e.toString().contains('Unauthorized')) {
        throw Exception('No user is currently logged in');
      }
      throw Exception('Failed to get profile: $e');
    }
  }
  
  // Logout user
  Future<void> logout() async {
    try {
      await _apiService.post(ApiConstants.logout, {});
      await _apiService.setToken('');
    } catch (e) {
      // Even if API call fails, clear local token
      await _apiService.setToken('');
    }
  }
  
  // Update profile
  Future<ApiUser> updateProfile({
    required String firstName,
    required String lastName,
    String? profilePicturePath,
  }) async {
    try {
      final requestData = {
        'firstName': firstName,
        'lastName': lastName,
        'name': '$firstName $lastName', // For backward compatibility
      };
      
      // Add profile picture if provided
      if (profilePicturePath != null && profilePicturePath.isNotEmpty) {
        requestData['profilePicture'] = profilePicturePath;
      }
      
      final response = await _apiService.put(ApiConstants.profile, requestData);
      
      return ApiUser.fromJson(response['data']);
    } catch (e) {
      throw Exception('Failed to update profile: $e');
    }
  }
}
