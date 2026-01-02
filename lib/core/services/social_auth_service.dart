import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import '../models/user_model.dart';

class SocialAuthService {
  static final SocialAuthService _instance = SocialAuthService._internal();
  factory SocialAuthService() => _instance;
  SocialAuthService._internal();

  final GoogleSignIn _googleSignIn = GoogleSignIn(
  clientId: '295843782166-3d1a8j.apps.googleusercontent.com',
  serverClientId: '295843782166-3d1a8j.apps.googleusercontent.com',
);

  // Google Sign-In
  Future<User?> signInWithGoogle() async {
    try {
      print('SocialAuthService: Starting Google sign-in...');

      // Check if Google Play Services is available
      if (!await _googleSignIn.isSignedIn()) {
        print('SocialAuthService: User not currently signed in, attempting sign-in...');
      }

      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        print('SocialAuthService: Google sign-in cancelled by user');
        return null;
      }

      print('SocialAuthService: Google sign-in successful for: ${googleUser.email}');

      // Create a User object from Google account info
      final user = User.create(
        name: googleUser.displayName ?? 'Google User',
        email: googleUser.email,
        password: 'google_auth_${googleUser.id}', // Generate a unique password
      );

      return user;
    } catch (e) {
      print('SocialAuthService: Google sign-in error: $e');

      // Provide specific error messages
      if (e.toString().contains('ApiException: 10')) {
        print('SocialAuthService: ERROR - Google Sign-In not configured properly');
        print('SocialAuthService: Please check GOOGLE_SIGNIN_FIX.md for setup instructions');
      } else if (e.toString().contains('ApiException: 12500')) {
        print('SocialAuthService: ERROR - Google Play Services not available');
        print('SocialAuthService: Please install Google Play Services on the device');
      } else if (e.toString().contains('network')) {
        print('SocialAuthService: ERROR - Network connection issue');
      }

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

  // Diagnostic method to check configuration
  Future<void> checkGoogleSignInConfiguration() async {
    try {
      print('=== Google Sign-In Configuration Check ===');
      
      // Check if GoogleSignIn is initialized
      print('GoogleSignIn initialized: ${_googleSignIn != null}');
      
      // Check current sign-in status
      final isSignedIn = await _googleSignIn.isSignedIn();
      print('Currently signed in: $isSignedIn');
      
      // Get current user
      final currentUser = _googleSignIn.currentUser;
      print('Current user: ${currentUser?.email ?? "None"}');
      
      // Check if google-services.json is likely configured
      print('Note: If ApiException: 10 occurs, google-services.json may be missing or incorrect');
      print('Package name should be: com.ronak.gear_ghar');
      print('SHA-1 should be: BD:C6:8A:3C:1C:11:E1:D6:A0:78:A7:8C:47:B7:22:82:42:7D:27:90');
      
      print('=== End Configuration Check ===');
    } catch (e) {
      print('Configuration check error: $e');
    }
  }
}
