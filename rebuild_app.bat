@echo off
echo Cleaning Flutter project...
flutter clean

echo Getting Flutter dependencies...
flutter pub get

echo Rebuilding Android app...
flutter run --debug

echo Done!
