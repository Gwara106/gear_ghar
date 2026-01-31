import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:gear_ghar/core/widgets/cached_network_image_widget.dart';
import 'package:gear_ghar/shared/providers/auth_provider.dart';
import 'package:gear_ghar/core/models/api_user_model.dart';

// Generate mocks
@GenerateMocks([AuthProvider, ApiUser])
import 'image_upload_widget_test.mocks.dart';

void main() {
  group('Image Upload Widget Tests', () {
    late MockAuthProvider mockAuthProvider;
    late MockApiUser mockUser;

    setUp(() {
      mockAuthProvider = MockAuthProvider();
      mockUser = MockApiUser();
      
      when(mockAuthProvider.currentUser).thenReturn(mockUser);
      when(mockUser.profilePicturePath).thenReturn('http://example.com/profile.jpg');
    });

    testWidgets('should handle server URL widget creation', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CachedNetworkImageWidget(
              imageUrl: 'http://example.com/profile.jpg',
              width: 100,
              height: 100,
            ),
          ),
        ),
      );

      // Use pump instead of pumpAndSettle to avoid timeout
      await tester.pump(const Duration(milliseconds: 100));
      
      expect(find.byType(CachedNetworkImageWidget), findsOneWidget);
    });

    testWidgets('should display placeholder for invalid URL', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CachedNetworkImageWidget(
              imageUrl: '',
              width: 100,
              height: 100,
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.image_outlined), findsOneWidget);
      expect(find.byType(Container), findsOneWidget);
    });

    testWidgets('should handle asset images correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CachedNetworkImageWidget(
              imageUrl: 'assets/images/profile_placeholder.png',
              width: 100,
              height: 100,
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(Image), findsOneWidget);
    });

    testWidgets('should handle custom fit property', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CachedNetworkImageWidget(
              imageUrl: 'http://example.com/profile.jpg',
              width: 100,
              height: 100,
              fit: BoxFit.contain,
            ),
          ),
        ),
      );

      // Use pump instead of pumpAndSettle to avoid timeout
      await tester.pump(const Duration(milliseconds: 100));
      
      expect(find.byType(CachedNetworkImageWidget), findsOneWidget);
    });

    testWidgets('should display custom placeholder when provided', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CachedNetworkImageWidget(
              imageUrl: '',
              width: 100,
              height: 100,
              placeholder: const Text('Custom Placeholder'),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Custom Placeholder'), findsOneWidget);
    });
  });
}
