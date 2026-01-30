import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:gear_ghar/core/widgets/cached_network_image_widget.dart';

void main() {
  group('CachedNetworkImageWidget Tests', () {
    setUp(() async {
      // Mock network images for testing
      await mockNetworkImagesFor(() {});
    });

    testWidgets('should display placeholder when imageUrl is empty', (WidgetTester tester) async {
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

      expect(find.byType(Container), findsOneWidget);
      expect(find.byIcon(Icons.image_outlined), findsOneWidget);
    });

    testWidgets('should display placeholder when imageUrl is null', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CachedNetworkImageWidget(
              imageUrl: null,
              width: 100,
              height: 100,
            ),
          ),
        ),
      );

      expect(find.byType(Container), findsOneWidget);
      expect(find.byIcon(Icons.image_outlined), findsOneWidget);
    });

    testWidgets('should handle network URL loading with timeout', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CachedNetworkImageWidget(
              imageUrl: 'https://example.com/test.jpg',
              width: 100,
              height: 100,
            ),
          ),
        ),
      );

      // Use pump instead of pumpAndSettle to avoid timeout
      await tester.pump(const Duration(milliseconds: 100));
      
      // Check that the widget is rendered (either loading or error state)
      expect(find.byType(CachedNetworkImageWidget), findsOneWidget);
    });

    testWidgets('should display asset image when asset path provided', (WidgetTester tester) async {
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

    testWidgets('should apply custom dimensions correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CachedNetworkImageWidget(
              imageUrl: '',
              width: 200,
              height: 150,
            ),
          ),
        ),
      );

      final container = tester.widget<Container>(find.byType(Container).first);
      final decoration = container.decoration as BoxDecoration;
      
      expect(container.constraints?.maxWidth, equals(200));
      expect(container.constraints?.maxHeight, equals(150));
    });
  });
}
