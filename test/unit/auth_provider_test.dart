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
    });

    test('should handle loading state correctly', () {
      authProvider.setLoading(true);
      expect(authProvider.isLoading, isTrue);
      
      authProvider.setLoading(false);
      expect(authProvider.isLoading, isFalse);
    });

    test('should handle error messages correctly', () {
      const errorMessage = 'Test error message';
      authProvider.setError(errorMessage);
      
      expect(authProvider.errorMessage, equals(errorMessage));
      
      authProvider.clearError();
      expect(authProvider.errorMessage, isNull);
    });

    test('should update current user correctly', () {
      authProvider.setCurrentUser(mockUser);
      
      expect(authProvider.currentUser, equals(mockUser));
      expect(authProvider.isAuthenticated, isTrue);
    });

    test('should handle logout correctly', () {
      authProvider.setCurrentUser(mockUser);
      expect(authProvider.isAuthenticated, isTrue);
      
      authProvider.logout();
      expect(authProvider.currentUser, isNull);
      expect(authProvider.isAuthenticated, isFalse);
    });
  });
}
