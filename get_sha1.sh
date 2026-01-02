#!/bin/bash

echo "=== Getting SHA-1 Fingerprint for Google Sign-In ==="
echo ""
echo "This script will help you get the SHA-1 fingerprint needed for Google Sign-In configuration."
echo ""

cd android

echo "Running signing report..."
./gradlew signingReport

echo ""
echo "=== Instructions ==="
echo "1. Look for 'SHA-1' in the output above"
echo "2. Copy the SHA-1 fingerprint (it looks like: XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX)"
echo "3. Go to Google Cloud Console: https://console.cloud.google.com/"
echo "4. Select your project or create a new one"
echo "5. Enable 'Google Sign-In API'"
echo "6. Go to 'Credentials' → 'Create Credentials' → 'OAuth 2.0 Client IDs'"
echo "7. Select 'Android'"
echo "8. Enter your package name: com.ronak.gear_ghar"
echo "9. Paste the SHA-1 fingerprint"
echo "10. Download the google-services.json file"
echo "11. Place it in android/app/google-services.json"
echo ""
echo "After setup, run: flutter clean && flutter pub get && flutter run"
echo ""
