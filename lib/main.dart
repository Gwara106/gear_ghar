import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gear_ghar/app.dart';

void main() {
  // Optimize performance
  WidgetsFlutterBinding.ensureInitialized();
  
  // Set preferred orientations
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  
  // Enable performance overlays for debugging (remove in production)
  // WidgetsApp.debugAllowBannerOverride = false;
  
  runApp(App());
}
