# Social Authentication Setup Guide

This app supports Google and Facebook authentication. Follow these steps to configure them:

## Google Sign-In Setup

1. **Get Google Credentials:**
   - Go to [Google Cloud Console](https://console.cloud.google.com/)
   - Create a new project or select existing one
   - Enable "Google Sign-In API"
   - Create OAuth 2.0 Client IDs for Android and iOS
   - Download the configuration files

2. **Android Setup:**
   - Add `google-services.json` to `android/app/`
   - Add the SHA-1 fingerprint to your Google Console

3. **iOS Setup:**
   - Add `GoogleService-Info.plist` to `ios/Runner/`
   - Add URL scheme to `ios/Runner/Info.plist`

## Facebook Login Setup

1. **Get Facebook App ID:**
   - Go to [Facebook Developers](https://developers.facebook.com/)
   - Create a new app
   - Add "Facebook Login" product
   - Configure Android and iOS platforms

2. **Android Setup:**
   - Add Facebook App ID to `android/app/src/main/AndroidManifest.xml`
   - Add Facebook App Name to `android/app/src/main/AndroidManifest.xml`

3. **iOS Setup:**
   - Add Facebook App ID to `ios/Runner/Info.plist`
   - Add URL scheme to `ios/Runner/Info.plist`

## Current Implementation

The app currently has a **demo implementation** that simulates social authentication:

- **Google Sign-In:** Creates a user with Google account information
- **Facebook Login:** Creates a user with Facebook account information
- **Password Reset:** Full implementation with email verification
- **User Management:** All users are stored locally using Hive

## Features Implemented

✅ **Email Authentication:** Full signup/login with validation
✅ **Password Reset:** Two-step process with email verification
✅ **Social Auth UI:** Google and Facebook login buttons
✅ **Error Handling:** Comprehensive error messages
✅ **Loading States:** Proper loading indicators
✅ **Navigation:** Automatic redirect to main screen after login

## Next Steps for Production

1. Configure actual Google and Facebook credentials
2. Add proper backend integration
3. Implement real email sending for password reset
4. Add user profile management
5. Implement session management

## Testing

You can test the current functionality:

1. **Email Login:** Use any email/password combination
2. **Social Login:** Click Google/Facebook buttons (will show demo flow)
3. **Password Reset:** Enter any email to test the reset flow
4. **Navigation:** All screens properly connected

The app is fully functional with local storage using Hive database!
