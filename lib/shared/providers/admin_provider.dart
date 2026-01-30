import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../core/models/api_user_model.dart';
import '../../core/constants/api_constants.dart';

class AdminProvider extends ChangeNotifier {
  List<ApiUser> _users = [];
  bool _isLoading = false;
  String? _errorMessage;
  int _currentPage = 1;
  int _totalPages = 1;
  int _totalUsers = 0;

  List<ApiUser> get users => _users;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  int get currentPage => _currentPage;
  int get totalPages => _totalPages;
  int get totalUsers => _totalUsers;

  // Get all users with pagination and filtering
  Future<bool> getAllUsers({
    int page = 1,
    int limit = 10,
    String? role,
    String? status,
    String? search,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      // Build query parameters
      final queryParams = <String, String>{
        'page': page.toString(),
        'limit': limit.toString(),
      };
      
      if (role != null) queryParams['role'] = role;
      if (status != null) queryParams['status'] = status;
      if (search != null && search.isNotEmpty) queryParams['search'] = search;

      final uri = Uri.parse('${ApiConstants.baseUrl}/api/admin/users')
          .replace(queryParameters: queryParams);

      debugPrint('AdminProvider: Fetching users from: $uri');

      final response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          // Add auth token header here if needed
        },
      ).timeout(const Duration(seconds: 10));

      debugPrint('AdminProvider: Response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        
        if (responseData['success'] == true) {
          final List<dynamic> usersData = responseData['data'];
          _users = usersData.map((json) => ApiUser.fromJson(json)).toList();
          _currentPage = responseData['page'] ?? page;
          _totalPages = responseData['pages'] ?? 1;
          _totalUsers = responseData['total'] ?? _users.length;
          
          debugPrint('AdminProvider: Loaded ${_users.length} users');
          notifyListeners();
          return true;
        } else {
          _setError(responseData['message'] ?? 'Failed to load users');
          return false;
        }
      } else {
        _setError('Failed to load users: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      debugPrint('AdminProvider: Error fetching users: $e');
      _setError('Failed to load users: ${e.toString()}');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Get user by ID
  Future<ApiUser?> getUserById(String userId) async {
    _setLoading(true);
    _clearError();

    try {
      final response = await http.get(
        Uri.parse('${ApiConstants.baseUrl}/api/admin/users/$userId'),
        headers: {
          'Content-Type': 'application/json',
          // Add auth token header here if needed
        },
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        
        if (responseData['success'] == true) {
          return ApiUser.fromJson(responseData['data']);
        } else {
          _setError(responseData['message'] ?? 'User not found');
          return null;
        }
      } else {
        _setError('Failed to load user: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      debugPrint('AdminProvider: Error fetching user: $e');
      _setError('Failed to load user: ${e.toString()}');
      return null;
    } finally {
      _setLoading(false);
    }
  }

  // Create new user
  Future<bool> createUser({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    String? username,
    String? phoneNumber,
    String? profilePicture,
    String role = 'user',
    String status = 'active',
  }) async {
    _setLoading(true);
    _clearError();

    try {
      final userData = {
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'password': password,
        'role': role,
        'status': status,
      };

      // Add optional fields
      if (username != null) userData['username'] = username;
      if (phoneNumber != null) userData['phoneNumber'] = phoneNumber;
      if (profilePicture != null) userData['profilePicture'] = profilePicture;

      final response = await http.post(
        Uri.parse('${ApiConstants.baseUrl}/api/admin/users'),
        headers: {
          'Content-Type': 'application/json',
          // Add auth token header here if needed
        },
        body: json.encode(userData),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 201) {
        final responseData = json.decode(response.body);
        
        if (responseData['success'] == true) {
          // Refresh the users list
          await getAllUsers(page: _currentPage);
          return true;
        } else {
          _setError(responseData['message'] ?? 'Failed to create user');
          return false;
        }
      } else {
        final errorData = json.decode(response.body);
        _setError(errorData['message'] ?? 'Failed to create user');
        return false;
      }
    } catch (e) {
      debugPrint('AdminProvider: Error creating user: $e');
      _setError('Failed to create user: ${e.toString()}');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Update user
  Future<bool> updateUser({
    required String userId,
    String? firstName,
    String? lastName,
    String? email,
    String? username,
    String? password,
    String? phoneNumber,
    String? profilePicture,
    String? role,
    String? status,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      final userData = <String, dynamic>{};
      
      // Add only provided fields
      if (firstName != null) userData['firstName'] = firstName;
      if (lastName != null) userData['lastName'] = lastName;
      if (email != null) userData['email'] = email;
      if (username != null) userData['username'] = username;
      if (password != null) userData['password'] = password;
      if (phoneNumber != null) userData['phoneNumber'] = phoneNumber;
      if (profilePicture != null) userData['profilePicture'] = profilePicture;
      if (role != null) userData['role'] = role;
      if (status != null) userData['status'] = status;

      final response = await http.put(
        Uri.parse('${ApiConstants.baseUrl}/api/admin/users/$userId'),
        headers: {
          'Content-Type': 'application/json',
          // Add auth token header here if needed
        },
        body: json.encode(userData),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        
        if (responseData['success'] == true) {
          // Refresh the users list
          await getAllUsers(page: _currentPage);
          return true;
        } else {
          _setError(responseData['message'] ?? 'Failed to update user');
          return false;
        }
      } else {
        final errorData = json.decode(response.body);
        _setError(errorData['message'] ?? 'Failed to update user');
        return false;
      }
    } catch (e) {
      debugPrint('AdminProvider: Error updating user: $e');
      _setError('Failed to update user: ${e.toString()}');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Delete user
  Future<bool> deleteUser(String userId) async {
    _setLoading(true);
    _clearError();

    try {
      final response = await http.delete(
        Uri.parse('${ApiConstants.baseUrl}/api/admin/users/$userId'),
        headers: {
          'Content-Type': 'application/json',
          // Add auth token header here if needed
        },
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        
        if (responseData['success'] == true) {
          // Refresh the users list
          await getAllUsers(page: _currentPage);
          return true;
        } else {
          _setError(responseData['message'] ?? 'Failed to delete user');
          return false;
        }
      } else {
        final errorData = json.decode(response.body);
        _setError(errorData['message'] ?? 'Failed to delete user');
        return false;
      }
    } catch (e) {
      debugPrint('AdminProvider: Error deleting user: $e');
      _setError('Failed to delete user: ${e.toString()}');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Refresh users list
  Future<void> refreshUsers() async {
    await getAllUsers(page: _currentPage);
  }

  // Load next page
  Future<void> loadNextPage() async {
    if (_currentPage < _totalPages) {
      await getAllUsers(page: _currentPage + 1);
    }
  }

  // Load previous page
  Future<void> loadPreviousPage() async {
    if (_currentPage > 1) {
      await getAllUsers(page: _currentPage - 1);
    }
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _errorMessage = error;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
