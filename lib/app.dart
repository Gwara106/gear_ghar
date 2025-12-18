import 'package:flutter/material.dart';
import 'package:gear_ghar/providers/product_provider.dart';
import 'package:gear_ghar/screens/main_screen.dart';
import 'package:gear_ghar/screens/splash_screen.dart';
import 'package:provider/provider.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ProductProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: const SplashScreen(),
        routes: {
          '/main': (context) => const MainScreen(),
        },
      ),
    );
  }
}
