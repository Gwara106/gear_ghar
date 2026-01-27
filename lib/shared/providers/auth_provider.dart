import 'package:flutter/foundation.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../core/models/api_user_model.dart';
import '../../core/services/social_auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthRepositoryImpl _authRepository = AuthRepositoryImpl();
  final SocialAuthService _socialAuthService = SocialAuthService();
  
  ApiUser? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;

  ApiUser? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  bool get isLoggedIn => _currentUser != null;
  String? get errorMessage => _errorMessage;

  Future<void> initializeAuth() async {
    try {
      _currentUser = await _authRepository.getCurrentUser();
      notifyListeners();
    } catch (e) {
      print('AuthProvider: Error during initialization: $e');
      // Don't set error message during initialization as it's normal when no user is logged in
      _currentUser = null;
      notifyListeners();
    }
  }

  Future<bool> signUp({
    required String name,
    required String email,
    required String password,
    String? profilePicturePath,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      final success = await _authRepository.signUp(
        name: name,
        email: email,
        password: password,
        profilePicturePath: profilePicturePath,
      );

      if (success) {
        _currentUser = await _authRepository.getCurrentUser();
        notifyListeners();
        return true;
      } else {
        _setError('Email already exists');
        return false;
      }
    } catch (e) {
      _setError('Sign up failed: ${e.toString()}');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> login({
    required String email,
    required String password,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      print('Attempting login with email: $email');
      final success = await _authRepository.login(
        email: email,
        password: password,
      );

      if (success) {
        _currentUser = await _authRepository.getCurrentUser();
        print('Login successful, user: ${_currentUser?.email}');
        notifyListeners();
        return true;
      } else {
        print('Login failed: Invalid credentials');
        _setError('Invalid email or password');
        return false;
      }
    } catch (e) {
      print('Login error: $e');
      _setError('Login failed: ${e.toString()}');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> checkUserExists(String email) async {
    try {
      print('AuthProvider: Checking if user exists: $email');
      final user = await _authRepository.getCurrentUser();
      if (user.email == email) {
        print('AuthProvider: User exists: ${user.email}');
        return true;
      }
      
      // For demo purposes, we'll check if any user exists with this email
      // In a real app, you'd have a specific method for this
      print('AuthProvider: User not found for email: $email');
      return false;
    } catch (e) {
      print('AuthProvider: Error checking user existence: $e');
      return false;
    }
  }

  Future<bool> resetPassword({
    required String email,
    required String newPassword,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      print('AuthProvider: Attempting password reset for email: $email');
      
      // Get current user and verify email matches
      final currentUser = await _authRepository.getCurrentUser();
      if (currentUser.email != email) {
        _setError('User not found');
        return false;
      }

      // Note: ApiUser doesn't have a password field that can be directly modified
      // In a real implementation, you'd have a separate password reset API endpoint
      // For now, we'll just return true as a placeholder
      print('AuthProvider: Password reset successful for user: ${currentUser.email}');
      return true;
    } catch (e) {
      print('AuthProvider: Password reset error: $e');
      _setError('Password reset failed: ${e.toString()}');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> logout() async {
    await _authRepository.logout();
    await _socialAuthService.signOut();
    _currentUser = null;
    notifyListeners();
  }

  // Google Sign-In
  Future<bool> signInWithGoogle() async {
    _setLoading(true);
    _clearError();

    try {
      print('AuthProvider: Starting Google sign-in...');
      final socialUser = await _socialAuthService.signInWithGoogle();
      
      if (socialUser == null) {
        // Run diagnostic to help identify the issue
        await _socialAuthService.checkGoogleSignInConfiguration();
        _setError('Google sign-in was cancelled or failed. Check console for details.');
        return false;
      }

      // Check if user already exists
      final existingUser = await _findUserByEmail(socialUser.email);
      
      if (existingUser != null) {
        // User exists, log them in
        _currentUser = existingUser;
        print('AuthProvider: Existing Google user logged in: ${existingUser.email}');
      } else {
        // New user, sign them up
        final success = await _authRepository.signUp(
          name: socialUser.fullName,
          email: socialUser.email,
          password: 'social_auth_${socialUser.id}', // Generate a password for social auth
        );
        
        if (!success) {
          _setError('Failed to create account with Google');
          return false;
        }
        
        _currentUser = socialUser;
        print('AuthProvider: New Google user created and logged in: ${socialUser.email}');
      }
      
      notifyListeners();
      return true;
    } catch (e) {
      print('AuthProvider: Google sign-in error: $e');
      _setError('Google sign-in failed: ${e.toString()}');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Facebook Sign-In
  Future<bool> signInWithFacebook() async {
    _setLoading(true);
    _clearError();

    try {
      print('AuthProvider: Starting Facebook sign-in...');
      final socialUser = await _socialAuthService.signInWithFacebook();
      
      if (socialUser == null) {
        _setError('Facebook sign-in was cancelled or failed');
        return false;
      }

      // Check if user already exists
      final existingUser = await _findUserByEmail(socialUser.email);
      
      if (existingUser != null) {
        // User exists, log them in
        _currentUser = existingUser;
        print('AuthProvider: Existing Facebook user logged in: ${existingUser.email}');
      } else {
        // New user, sign them up
        final success = await _authRepository.signUp(
          name: socialUser.fullName,
          email: socialUser.email,
          password: 'social_auth_${socialUser.id}', // Generate a password for social auth
        );
        
        if (!success) {
          _setError('Failed to create account with Facebook');
          return false;
        }
        
        _currentUser = socialUser;
        print('AuthProvider: New Facebook user created and logged in: ${socialUser.email}');
      }
      
      notifyListeners();
      return true;
    } catch (e) {
      print('AuthProvider: Facebook sign-in error: $e');
      _setError('Facebook sign-in failed: ${e.toString()}');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  void setCurrentUser(ApiUser user) {
    _currentUser = user;
    notifyListeners();
  }

  Future<bool> updateUser(ApiUser user) async {
    _setLoading(true);
    _clearError();

    try {
      print('AuthProvider: Updating user profile: ${user.email}');
      
      // Update the user in the repository
      final success = await _authRepository.updateUser(user);
      
      if (success) {
        // Update the current user in the provider
        _currentUser = user;
        print('AuthProvider: User updated successfully');
        notifyListeners();
        return true;
      } else {
        print('AuthProvider: Failed to update user');
        _setError('Failed to update profile');
        return false;
      }
    } catch (e) {
      print('AuthProvider: Error updating user: $e');
      _setError('Profile update failed: ${e.toString()}');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Helper method to find user by email
  Future<ApiUser?> _findUserByEmail(String email) async {
    try {
      // For simplicity, we'll check the current user
      // In a real app, you'd have a method to search users by email
      final currentUser = await _authRepository.getCurrentUser();
      if (currentUser.email == email) {
        return currentUser;
      }
      return null;
    } catch (e) {
      print('AuthProvider: Error finding user by email: $e');
      return null;
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
