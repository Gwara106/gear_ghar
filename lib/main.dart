import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:gear_ghar/app.dart';
import 'providers/address_provider.dart';

void main() async {
  // Optimize performance
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Hive
  await Hive.initFlutter();
  
  // Register adapters
  Hive.registerAdapter(AddressAdapter());
  
  // Set preferred orientations
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  
  // Enable performance overlays for debugging (remove in production)
  // WidgetsApp.debugAllowBannerOverride = false;
  
  runApp(App());
}
