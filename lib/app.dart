import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'shared/providers/auth_provider.dart';
import 'shared/providers/admin_provider.dart';
import 'shared/widgets/route_guard.dart';
import 'providers/product_provider.dart';
import 'presentation/screens/main_screen.dart';
import 'presentation/screens/splash_screen.dart';
import 'features/auth/presentation/screens/login_screen.dart';
import 'features/auth/presentation/screens/forgot_password_screen.dart';
import 'features/admin/presentation/screens/admin_users_screen.dart';
import 'features/admin/presentation/screens/admin_user_detail_screen.dart';
import 'features/admin/presentation/screens/admin_create_user_screen.dart';
import 'features/admin/presentation/screens/admin_edit_user_screen.dart';
import 'features/user/presentation/screens/user_profile_screen.dart';
import 'core/models/api_user_model.dart';

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
    // Initialize auth in background without blocking UI
    Future.microtask(() => _authProvider.initializeAuth());
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: _authProvider),
        ChangeNotifierProvider(create: (context) => ProductProvider()),
        ChangeNotifierProvider(create: (context) => AdminProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: const SplashScreen(),
        routes: {
          '/main': (context) => const MainScreen(),
          '/login': (context) => const LoginScreen(),
          '/forgot-password': (context) => const ForgotPasswordScreen(),
          '/user/profile': (context) => const UserProfileScreen().protectRoute(requireAuth: true),
          '/admin/users': (context) => const AdminUsersScreen().protectRoute(requiredRole: 'admin'),
          '/admin/users/create': (context) => const AdminCreateUserScreen().protectRoute(requiredRole: 'admin'),
        },
        onGenerateRoute: (settings) {
          // Handle dynamic routes like /admin/users/[id] and /admin/users/[id]/edit
          if (settings.name?.startsWith('/admin/users/') == true) {
            final uri = Uri.parse(settings.name!);
            final pathSegments = uri.pathSegments;
            
            if (pathSegments.length == 3) {
              // /admin/users/[id]
              final userId = pathSegments[2];
              return MaterialPageRoute(
                builder: (context) => AdminUserDetailScreen(userId: userId).protectRoute(requiredRole: 'admin'),
                settings: settings,
              );
            } else if (pathSegments.length == 4 && pathSegments[3] == 'edit') {
              // /admin/users/[id]/edit
              final userId = pathSegments[2];
              return MaterialPageRoute(
                builder: (context) => AdminEditUserScreen(
                  user: ApiUser(
                    id: userId,
                    firstName: '',
                    lastName: '',
                    email: '',
                    role: 'user',
                    status: 'active',
                    createdAt: DateTime.now(),
                    updatedAt: DateTime.now(),
                  ),
                ).protectRoute(requiredRole: 'admin'),
                settings: settings,
              );
            }
          }
          return null;
        },
      ),
    );
  }
}
