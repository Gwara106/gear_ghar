import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import '../models/user_model.dart';

class SocialAuthService {
  static final SocialAuthService _instance = SocialAuthService._internal();
  factory SocialAuthService() => _instance;
  SocialAuthService._internal();

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    clientId: kIsWeb
        ? 'your-web-client-id.apps.googleusercontent.com'
        : null, // For mobile, client ID is configured in google-services.json
  );

  // Google Sign-In
  Future<User?> signInWithGoogle() async {
    try {
      print('SocialAuthService: Starting Google sign-in...');

      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        print('SocialAuthService: Google sign-in cancelled by user');
        return null;
      }

      print(
        'SocialAuthService: Google sign-in successful for: ${googleUser.email}',
      );

      // Create a User object from Google account info
      final user = User.create(
        name: googleUser.displayName ?? 'Google User',
        email: googleUser.email,
        password: 'google_auth_${googleUser.id}', // Generate a unique password
      );

      return user;
    } catch (e) {
      print('SocialAuthService: Google sign-in error: $e');
      return null;
    }
  }

  // Facebook Sign-In
  Future<User?> signInWithFacebook() async {
    try {
      print('SocialAuthService: Starting Facebook sign-in...');

      final LoginResult result = await FacebookAuth.instance.login(
        permissions: ['email', 'public_profile'],
      );

      if (result.status == LoginStatus.success) {
        final userData = await FacebookAuth.instance.getUserData();

        print(
          'SocialAuthService: Facebook sign-in successful for: ${userData['email']}',
        );

        // Create a User object from Facebook account info
        final user = User.create(
          name: userData['name'] ?? 'Facebook User',
          email: userData['email'] ?? '',
          password:
              'facebook_auth_${userData['id']}', // Generate a unique password
        );

        return user;
      } else {
        print(
          'SocialAuthService: Facebook sign-in failed with status: ${result.status}',
        );
        print('SocialAuthService: Facebook error message: ${result.message}');
        return null;
      }
    } catch (e) {
      print('SocialAuthService: Facebook sign-in error: $e');
      return null;
    }
  }

  // Sign out from all social providers
  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
      await FacebookAuth.instance.logOut();
      print('SocialAuthService: Signed out from all social providers');
    } catch (e) {
      print('SocialAuthService: Error signing out from social providers: $e');
    }
  }

  // Check if user is signed in with Google
  Future<bool> isSignedInWithGoogle() async {
    return await _googleSignIn.isSignedIn();
  }

  // Get current Google user
  Future<GoogleSignInAccount?> getCurrentGoogleUser() async {
    return _googleSignIn.currentUser;
  }
}
