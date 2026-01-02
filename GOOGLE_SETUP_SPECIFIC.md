# Google Sign-In Setup - SPECIFIC FOR YOUR APP

## Your App Information
- **Package Name**: `com.ronak.gear_ghar`
- **SHA-1 Fingerprint**: `BD:C6:8A:3C:1C:11:E1:D6:A0:78:A7:8C:47:B7:22:82:42:7D:27:90`

## Step-by-Step Setup

### 1. Go to Google Cloud Console
- Visit: https://console.cloud.google.com/
- Select your project or create a new one
- Enable "Google Sign-In API"

### 2. Create OAuth 2.0 Client ID
- Go to "Credentials" → "Create Credentials" → "OAuth 2.0 Client IDs"
- Select "Android"
- Enter package name: `com.ronak.gear_ghar`
- Paste SHA-1 fingerprint: `BD:C6:8A:3C:1C:11:E1:D6:A0:78:A7:8C:47:B7:22:82:42:7D:27:90`
- Click "Create"

### 3. Download Configuration File
- Download the `google-services.json` file
- Place it in: `android/app/google-services.json`

### 4. Update Android Configuration

#### Update `android/build.gradle`:
```gradle
buildscript {
    dependencies {
        classpath 'com.google.gms:google-services:4.3.15'
    }
}
```

#### Update `android/app/build.gradle`:
```gradle
apply plugin: 'com.google.gms.google-services'

dependencies {
    implementation 'com.google.android.gms:play-services-auth:20.7.0'
}
```

### 5. Clean and Rebuild
```bash
flutter clean
flutter pub get
flutter run
```

## Why It Failed Before

The error `ApiException: 10` means:
- Google Sign-In API is not enabled
- OR OAuth 2.0 Client ID is not configured
- OR SHA-1 fingerprint doesn't match
- OR google-services.json is missing

## Quick Test

After setup, test with this command:
```bash
flutter run --debug
```

The app should now show:
```
SocialAuthService: Starting Google sign-in...
SocialAuthService: Google sign-in successful for: your-email@gmail.com
```

## If It Still Fails

1. Check if `google-services.json` exists in `android/app/`
2. Verify the package name matches exactly
3. Ensure Google Play Services is installed on test device
4. Try clearing app data and testing again

## Current Status

✅ SHA-1 fingerprint obtained: `BD:C6:8A:3C:1C:11:E1:D6:A0:78:A7:8C:47:B7:22:82:42:7D:27:90`
✅ Package name identified: `com.ronak.gear_ghar`
✅ Enhanced error handling added
✅ Diagnostic tools implemented

🔲 Google Cloud Console configuration needed
🔲 google-services.json file needed
🔲 Android build.gradle updates needed

## Alternative: Web Client ID

For quick testing without full Android setup:
1. Create a Web OAuth 2.0 Client ID
2. Update SocialAuthService with the client ID
3. This works for development but not production

The enhanced error handling will now show detailed diagnostic information when Google Sign-In fails!
