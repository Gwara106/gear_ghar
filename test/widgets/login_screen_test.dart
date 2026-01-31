import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:gear_ghar/features/auth/presentation/screens/login_screen.dart';
import 'package:gear_ghar/shared/providers/auth_provider.dart';

// Generate mocks
@GenerateMocks([AuthProvider])
import 'login_screen_test.mocks.dart';

void main() {
  group('LoginScreen Widget Tests', () {
    late MockAuthProvider mockAuthProvider;

    setUp(() {
      mockAuthProvider = MockAuthProvider();
      
      // Setup mock behavior for AuthProvider properties
      when(mockAuthProvider.isLoading).thenReturn(false);
      when(mockAuthProvider.errorMessage).thenReturn(null);
      when(mockAuthProvider.currentUser).thenReturn(null);
      when(mockAuthProvider.isLoggedIn).thenReturn(false);
    });

    testWidgets('should display email and password fields', (WidgetTester tester) async {
      await tester.pumpWidget(
        ChangeNotifierProvider<AuthProvider>(
          create: (_) => mockAuthProvider,
          child: MaterialApp(
            home: LoginScreen(),
          ),
        ),
      );

      await tester.pump();

      expect(find.byType(TextField), findsNWidgets(2));
      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);
    });

    testWidgets('should display login button', (WidgetTester tester) async {
      await tester.pumpWidget(
        ChangeNotifierProvider<AuthProvider>(
          create: (_) => mockAuthProvider,
          child: MaterialApp(
            home: LoginScreen(),
          ),
        ),
      );

      await tester.pump();

      expect(find.text('Login'), findsOneWidget);
      expect(find.byType(ElevatedButton), findsNWidgets(3));
    });

    testWidgets('should display social login buttons', (WidgetTester tester) async {
      await tester.pumpWidget(
        ChangeNotifierProvider<AuthProvider>(
          create: (_) => mockAuthProvider,
          child: MaterialApp(
            home: LoginScreen(),
          ),
        ),
      );

      await tester.pump();

      expect(find.text('Login with Google'), findsOneWidget);
      expect(find.text('Login with Facebook'), findsOneWidget);
    });

    testWidgets('should validate empty email field', (WidgetTester tester) async {
      await tester.pumpWidget(
        ChangeNotifierProvider<AuthProvider>(
          create: (_) => mockAuthProvider,
          child: MaterialApp(
            home: LoginScreen(),
          ),
        ),
      );

      await tester.pump();

      // Tap login button without entering email
      await tester.tap(find.byType(ElevatedButton).first);
      await tester.pump();

      expect(find.text('Please enter your email'), findsOneWidget);
    });

    testWidgets('should navigate to forgot password screen', (WidgetTester tester) async {
      await tester.pumpWidget(
        ChangeNotifierProvider<AuthProvider>(
          create: (_) => mockAuthProvider,
          child: MaterialApp(
            home: LoginScreen(),
            routes: {
              '/forgot-password': (context) => const Scaffold(body: Text('Forgot Password')),
            },
          ),
        ),
      );

      await tester.pump();

      await tester.tap(find.text('Forgot Password?'));
      await tester.pump();

      expect(find.text('Forgot Password?'), findsOneWidget);
    });
  });
}
