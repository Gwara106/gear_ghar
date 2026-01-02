import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'shared/providers/auth_provider.dart';
import 'providers/product_provider.dart';
import 'presentation/screens/main_screen.dart';
import 'presentation/screens/splash_screen.dart';
import 'features/auth/presentation/screens/login_screen.dart';
import 'features/auth/presentation/screens/forgot_password_screen.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  final AuthProvider _authProvider = AuthProvider();

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    // Hive is initialized by AuthRepositoryImpl
    await _authProvider.initializeAuth();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: _authProvider),
        ChangeNotifierProvider(create: (context) => ProductProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: const SplashScreen(),
        routes: {
          '/main': (context) => const MainScreen(),
          '/login': (context) => const LoginScreen(),
          '/forgot-password': (context) => const ForgotPasswordScreen(),
        },
      ),
    );
  }
}
