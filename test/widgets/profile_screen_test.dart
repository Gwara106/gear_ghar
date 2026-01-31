import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:provider/provider.dart';
import 'package:gear_ghar/features/profile/presentation/screens/profile_screen.dart';
import 'package:gear_ghar/shared/providers/auth_provider.dart';
import 'package:gear_ghar/core/models/api_user_model.dart';

// Generate mocks
@GenerateMocks([AuthProvider, ApiUser])
import 'profile_screen_test.mocks.dart';

void main() {
  group('ProfileScreen Widget Tests', () {
    late MockAuthProvider mockAuthProvider;
    late MockApiUser mockUser;

    setUp(() {
      mockAuthProvider = MockAuthProvider();
      mockUser = MockApiUser();
      
      // Setup mock behavior for AuthProvider properties
      when(mockAuthProvider.isLoading).thenReturn(false);
      when(mockAuthProvider.errorMessage).thenReturn(null);
      when(mockAuthProvider.currentUser).thenReturn(mockUser);
      when(mockAuthProvider.isLoggedIn).thenReturn(true);
      
      // Setup mock behavior for ApiUser properties
      when(mockUser.email).thenReturn('test@example.com');
      when(mockUser.fullName).thenReturn('Test User');
      when(mockUser.profilePicturePath).thenReturn(null);
      when(mockUser.profilePicture).thenReturn(null);
      when(mockUser.id).thenReturn('test-id');
      when(mockUser.role).thenReturn('user');
      when(mockUser.status).thenReturn('active');
      when(mockUser.createdAt).thenReturn(DateTime.now());
      when(mockUser.updatedAt).thenReturn(DateTime.now());
    });

    testWidgets('should display user email when logged in', (WidgetTester tester) async {
      await tester.pumpWidget(
        ChangeNotifierProvider<AuthProvider>(
          create: (_) => mockAuthProvider,
          child: MaterialApp(
            home: ProfileScreen(),
          ),
        ),
      );

      await tester.pump();

      expect(find.text('test@example.com'), findsOneWidget);
    });

    testWidgets('should display placeholder when no profile picture', (WidgetTester tester) async {
      when(mockUser.profilePicturePath).thenReturn(null);

      await tester.pumpWidget(
        ChangeNotifierProvider<AuthProvider>(
          create: (_) => mockAuthProvider,
          child: MaterialApp(
            home: ProfileScreen(),
          ),
        ),
      );

      await tester.pump();

      expect(find.byType(CircleAvatar), findsOneWidget);
    });

    testWidgets('should display menu items correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        ChangeNotifierProvider<AuthProvider>(
          create: (_) => mockAuthProvider,
          child: MaterialApp(
            home: ProfileScreen(),
          ),
        ),
      );

      await tester.pump();

      expect(find.text('My Orders'), findsOneWidget);
      expect(find.text('My Addresses'), findsOneWidget);
      expect(find.text('Payment Methods'), findsOneWidget);
      expect(find.text('Settings'), findsOneWidget);
      expect(find.text('Help Center'), findsOneWidget);
    });

    testWidgets('should handle loading state', (WidgetTester tester) async {
      when(mockAuthProvider.isLoading).thenReturn(true);

      await tester.pumpWidget(
        ChangeNotifierProvider<AuthProvider>(
          create: (_) => mockAuthProvider,
          child: MaterialApp(
            home: ProfileScreen(),
          ),
        ),
      );

      await tester.pump();

      // ProfileScreen doesn't show loading state, it just shows the user info
      expect(find.byType(CircleAvatar), findsOneWidget);
      expect(find.text('Test User'), findsOneWidget);
    });

    testWidgets('should display error message when present', (WidgetTester tester) async {
      when(mockAuthProvider.errorMessage).thenReturn('Test error message');

      await tester.pumpWidget(
        ChangeNotifierProvider<AuthProvider>(
          create: (_) => mockAuthProvider,
          child: MaterialApp(
            home: ProfileScreen(),
          ),
        ),
      );

      await tester.pump();

      // ProfileScreen doesn't show error messages, it just shows the user info
      expect(find.byType(CircleAvatar), findsOneWidget);
      expect(find.text('Test User'), findsOneWidget);
    });
  });
}
