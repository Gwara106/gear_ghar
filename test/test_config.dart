/// Test configuration and utilities

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

/// Test utilities for the project
class TestHelpers {
  /// Creates a material app wrapper for testing
  static Widget createMaterialApp(Widget child) {
    return MaterialApp(
      home: Scaffold(
        body: child,
      ),
    );
  }

  /// Creates a material app with provider for testing
  static Widget createMaterialAppWithProvider<T extends ChangeNotifier>(
    Widget child, {
    required T Function() create,
  }) {
    return ChangeNotifierProvider<T>(
      create: create,
      child: MaterialApp(
        home: Scaffold(
          body: child,
        ),
      ),
    );
  }

  /// Waits for all animations and async operations to complete
  static Future<void> pumpAndSettleWithTimeout(
    WidgetTester tester, {
    Duration timeout = const Duration(seconds: 10),
  }) async {
    await tester.pumpAndSettle(timeout);
  }

  /// Finds a widget by type and key
  static Finder findByTypeAndKey<T extends Widget>(Key key) {
    return find.byType(T).first;
  }

  /// Enters text into a text field and waits
  static Future<void> enterTextAndWait(
    WidgetTester tester,
    Finder finder,
    String text, {
    Duration waitDuration = const Duration(milliseconds: 100),
  }) async {
    await tester.enterText(finder, text);
    await tester.pump(waitDuration);
  }

  /// Taps a widget and waits
  static Future<void> tapAndWait(
    WidgetTester tester,
    Finder finder, {
    Duration waitDuration = const Duration(milliseconds: 100),
  }) async {
    await tester.tap(finder);
    await tester.pump(waitDuration);
  }
}

/// Common test data
class TestData {
  static const String validImageUrl = 'http://example.com/test.jpg';
  static const String validAssetPath = 'assets/images/profile_placeholder.png';
  static const String invalidUrl = '';
  static const String testEmail = 'test@example.com';
  static const String testPassword = 'password123';
  static const String testFirstName = 'John';
  static const String testLastName = 'Doe';
}

/// Common test keys
class TestKeys {
  static const Key emailField = Key('email_field');
  static const Key passwordField = Key('password_field');
  static const Key firstNameField = Key('first_name_field');
  static const Key lastNameField = Key('last_name_field');
  static const Key loginButton = Key('login_button');
  static const Key saveButton = Key('save_button');
  static const Key profileImage = Key('profile_image');
}
