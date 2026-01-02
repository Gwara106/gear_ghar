# Google Sign-In Configuration Fix

The error `ApiException: 10` means Google Sign-In is not properly configured. Follow these steps:

## Step 1: Get Google Configuration Files

1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Select your project or create a new one
3. Enable "Google Sign-In API"
4. Go to "Credentials" → "Create Credentials" → "OAuth 2.0 Client IDs"
5. Create credentials for:
   - **Android**: Use your app's package name and SHA-1 fingerprint
   - **Web** (optional): For web testing

## Step 2: Get Your App's SHA-1 Fingerprint

Run this command in your project directory:

```bash
cd android
./gradlew signingReport
```

Look for the SHA-1 fingerprint in the output and copy it.

## Step 3: Configure Android

1. Download the `google-services.json` file from Google Cloud Console
2. Place it in `android/app/google-services.json`
3. Update `android/build.gradle`:

```gradle
dependencies {
    classpath 'com.google.gms:google-services:4.3.15'
}
```

4. Update `android/app/build.gradle`:

```gradle
apply plugin: 'com.google.gms.google-services'

dependencies {
    implementation 'com.google.android.gms:play-services-auth:20.7.0'
}
```

## Step 4: Update AndroidManifest.xml

Add this to `android/app/src/main/AndroidManifest.xml` inside `<application>`:

```xml
<meta-data android:name="com.google.android.gms.version" android:value="@integer/google_play_services_version" />
```

## Step 5: Test Configuration

After setting up, clean and rebuild:

```bash
flutter clean
flutter pub get
flutter run
```

## Step 6: Alternative - Use Web Client ID (Quick Fix)

If you want a quick test without full Android setup, you can use a web client ID:

1. In Google Cloud Console, create a Web OAuth 2.0 Client ID
2. Update the SocialAuthService:

```dart
final GoogleSignIn _googleSignIn = GoogleSignIn(
  clientId: 'YOUR_WEB_CLIENT_ID.apps.googleusercontent.com',
  serverClientId: 'YOUR_WEB_CLIENT_ID.apps.googleusercontent.com',
);
```

## Current Status

Your Google Sign-In worked once because it was using cached credentials. The second time failed because the configuration is incomplete.

## Debug Steps

1. Check if `google-services.json` exists in `android/app/`
2. Verify the package name matches your Google Console project
3. Ensure SHA-1 fingerprint is correctly added
4. Check if Google Play Services is installed on the test device

## Quick Test

You can test the configuration by running:

```bash
flutter doctor
```

Make sure "Android toolchain" and "Connected device" show no errors.
