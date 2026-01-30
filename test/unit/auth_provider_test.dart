import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:gear_ghar/shared/providers/auth_provider.dart';
import 'package:gear_ghar/core/models/api_user_model.dart';

// Generate mocks
@GenerateMocks([ApiUser])
import 'auth_provider_test.mocks.dart';

void main() {
  group('AuthProvider Tests', () {
    late AuthProvider authProvider;
    late MockApiUser mockUser;

    setUp(() {
      authProvider = AuthProvider();
      mockUser = MockApiUser();
      
      // Setup mock user behavior
      when(mockUser.email).thenReturn('test@example.com');
      when(mockUser.fullName).thenReturn('Test User');
      when(mockUser.profilePicturePath).thenReturn('http://example.com/pic.jpg');
    });

    tearDown(() {
      authProvider.dispose();
    });

    test('should initialize with null current user', () {
      expect(authProvider.currentUser, isNull);
      expect(authProvider.isLoading, isFalse);
      expect(authProvider.errorMessage, isNull);
      expect(authProvider.isLoggedIn, isFalse);
    });

    test('should handle login state correctly', () {
      // Initially not logged in
      expect(authProvider.isLoggedIn, isFalse);
      expect(authProvider.currentUser, isNull);
    });

    test('should handle error state correctly', () {
      // Initially no error
      expect(authProvider.errorMessage, isNull);
    });

    test('should handle loading state correctly', () {
      // Initially not loading
      expect(authProvider.isLoading, isFalse);
    });

    test('should handle logout correctly', () {
      // Logout should work even when not logged in
      authProvider.logout();
      expect(authProvider.currentUser, isNull);
      expect(authProvider.isLoggedIn, isFalse);
    });
  });
}
