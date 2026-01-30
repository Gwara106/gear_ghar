import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:provider/provider.dart';
import '../../lib/features/profile/presentation/screens/edit_profile_screen.dart';
import '../../lib/shared/providers/auth_provider.dart';
import '../../lib/core/models/api_user_model.dart';

// Generate mocks
@GenerateMocks([AuthProvider, ApiUser])
import 'edit_profile_screen_test.mocks.dart';

void main() {
  group('EditProfileScreen Widget Tests', () {
    late MockAuthProvider mockAuthProvider;
    late MockApiUser mockUser;

    setUp(() {
      mockAuthProvider = MockAuthProvider();
      mockUser = MockApiUser();
      
      when(mockAuthProvider.currentUser).thenReturn(mockUser);
      when(mockUser.firstName).thenReturn('John');
      when(mockUser.lastName).thenReturn('Doe');
      when(mockUser.email).thenReturn('john.doe@example.com');
      when(mockUser.phoneNumber).thenReturn('1234567890');
    });

    testWidgets('should display current user information', (WidgetTester tester) async {
      await tester.pumpWidget(
        ChangeNotifierProvider<AuthProvider>(
          create: (_) => mockAuthProvider,
          child: MaterialApp(
            home: EditProfileScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('John'), findsOneWidget);
      expect(find.text('Doe'), findsOneWidget);
      expect(find.text('john.doe@example.com'), findsOneWidget);
      expect(find.text('1234567890'), findsOneWidget);
    });

    testWidgets('should display editable fields', (WidgetTester tester) async {
      await tester.pumpWidget(
        ChangeNotifierProvider<AuthProvider>(
          create: (_) => mockAuthProvider,
          child: MaterialApp(
            home: EditProfileScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(TextField), findsNWidgets(4));
      expect(find.text('First Name'), findsOneWidget);
      expect(find.text('Last Name'), findsOneWidget);
      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Phone Number'), findsOneWidget);
    });

    testWidgets('should display save button', (WidgetTester tester) async {
      await tester.pumpWidget(
        ChangeNotifierProvider<AuthProvider>(
          create: (_) => mockAuthProvider,
          child: MaterialApp(
            home: EditProfileScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Save Changes'), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);
    });

    testWidgets('should allow editing first name field', (WidgetTester tester) async {
      await tester.pumpWidget(
        ChangeNotifierProvider<AuthProvider>(
          create: (_) => mockAuthProvider,
          child: MaterialApp(
            home: EditProfileScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Find first name field and enter new text
      final firstNameField = find.byKey(const Key('first_name_field'));
      await tester.enterText(firstNameField, 'Jane');
      await tester.pump();

      expect(find.text('Jane'), findsOneWidget);
    });

    testWidgets('should display profile picture section', (WidgetTester tester) async {
      await tester.pumpWidget(
        ChangeNotifierProvider<AuthProvider>(
          create: (_) => mockAuthProvider,
          child: MaterialApp(
            home: EditProfileScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(CircleAvatar), findsOneWidget);
      expect(find.text('Change Photo'), findsOneWidget);
    });
  });
}
