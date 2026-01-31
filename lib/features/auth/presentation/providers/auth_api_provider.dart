import 'package:flutter/foundation.dart';
import '../../../../core/models/api_user_model.dart';
import '../../domain/repositories/auth_api_repository.dart';

class AuthProvider extends ChangeNotifier {
  final AuthRepository _authRepository = AuthRepository();
  
  ApiUser? _user;
  bool _isLoading = false;
  bool _isAuthenticated = false;
  String? _errorMessage;

  // Getters
  ApiUser? get user => _user;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _isAuthenticated;
  String? get errorMessage => _errorMessage;

  // Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  // Set loading state
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  // Set error
  void _setError(String error) {
    _errorMessage = error;
    notifyListeners();
  }

  // Sign up
  Future<bool> signUp({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
  }) async {
    _setLoading(true);
    _setError('');

    try {
      final result = await _authRepository.signUp(
        firstName: firstName,
        lastName: lastName,
        email: email,
        password: password,
      );

      if (result['user'] != null) {
        _user = ApiUser.fromJson(result['user']);
        _isAuthenticated = true;
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Sign in
  Future<bool> signIn({
    required String email,
    required String password,
  }) async {
    _setLoading(true);
    _setError('');

    try {
      final result = await _authRepository.signIn(
        email: email,
        password: password,
      );

      if (result['user'] != null) {
        _user = ApiUser.fromJson(result['user']);
        _isAuthenticated = true;
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Sign out
  Future<void> signOut() async {
    _setLoading(true);
    
    try {
      await _authRepository.signOut();
    } catch (e) {
      debugPrint('Error during sign out: $e');
    } finally {
      _user = null;
      _isAuthenticated = false;
      _setLoading(false);
    }
  }

  // Social sign-in methods (placeholder implementations)
  Future<bool> signInWithGoogle() async {
    _setError('Google sign-in not implemented yet');
    return false;
  }

  Future<bool> signInWithFacebook() async {
    _setError('Facebook sign-in not implemented yet');
    return false;
  }

  // Check authentication status
  Future<void> checkAuthStatus() async {
    _setLoading(true);

    try {
      final user = await _authRepository.getCurrentUser();
      _user = user;
      _isAuthenticated = true;
    } catch (e) {
      // User is not authenticated
      _user = null;
      _isAuthenticated = false;
    } finally {
      _setLoading(false);
    }
  }

  // Update profile
  Future<bool> updateProfile({
    required String firstName,
    required String lastName,
  }) async {
    _setLoading(true);
    _setError('');

    try {
      final updatedUser = await _authRepository.updateProfile(
        firstName: firstName,
        lastName: lastName,
      );

      _user = updatedUser;
      notifyListeners();
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }
}
