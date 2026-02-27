import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'shared/providers/auth_provider.dart';
import 'shared/providers/admin_provider.dart';
import 'shared/providers/theme_provider.dart';
import 'shared/providers/notification_provider.dart';
import 'shared/widgets/route_guard.dart';
import 'providers/product_provider.dart';
import 'providers/cart_provider.dart';
import 'providers/address_provider.dart';
import 'presentation/screens/main_screen.dart';
import 'presentation/screens/splash_screen.dart';
import 'features/auth/presentation/screens/login_screen.dart';
import 'features/auth/presentation/screens/forgot_password_screen.dart';
import 'features/admin/presentation/screens/admin_users_screen.dart';
import 'features/admin/presentation/screens/admin_user_detail_screen.dart';
import 'features/admin/presentation/screens/admin_create_user_screen.dart';
import 'features/admin/presentation/screens/admin_edit_user_screen.dart';
import 'features/user/presentation/screens/user_profile_screen.dart';
import 'features/shop/presentation/screens/cart_screen.dart';
import 'features/checkout/presentation/screens/simple_checkout_screen.dart';
import 'features/shop/presentation/screens/order_tracking_screen_simple.dart';
import 'features/shop/presentation/screens/orders_screen.dart';
import 'features/profile/presentation/screens/edit_profile_screen.dart';
import 'features/profile/presentation/screens/help_center_screen.dart';
import 'core/services/api_service.dart';
import 'core/models/api_user_model.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  void initState() {
    super.initState();
    // Don't initialize here - wait for didChangeDependencies
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    debugPrint('App: didChangeDependencies called');
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    debugPrint('App: _initializeApp called');
    
    // Initialize ApiService first to load token from storage
    await ApiService().init();
    
    // Get auth provider and initialize in background without blocking UI
    // if (mounted) {
    //   final authProvider = Provider.of<AuthProvider>(context, listen: false);
    //   Future.microtask(() => authProvider.initializeAuth());
    // }
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
        ChangeNotifierProvider(create: (context) => NotificationProvider()),
        ChangeNotifierProvider(create: (context) => AuthProvider()),
        ChangeNotifierProvider(create: (context) => ProductProvider()),
        ChangeNotifierProvider(create: (context) => CartProvider()),
        ChangeNotifierProvider(create: (context) => AddressProvider()),
        ChangeNotifierProvider(create: (context) => AdminProvider()),
      ],
      child: Consumer2<ThemeProvider, NotificationProvider>(
        builder: (context, themeProvider, notificationProvider, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: themeProvider.lightTheme,
            darkTheme: themeProvider.darkTheme,
            themeMode: themeProvider.themeMode,
            home: const SplashScreen(),
            routes: {
              '/main': (context) => const MainScreen(),
              '/login': (context) => const LoginScreen(),
              '/forgot-password': (context) => const ForgotPasswordScreen(),
              '/user/profile': (context) => const UserProfileScreen().protectRoute(requireAuth: true),
              '/admin/users': (context) => const AdminUsersScreen().protectRoute(requiredRole: 'admin'),
              '/admin/users/create': (context) => const AdminCreateUserScreen().protectRoute(requiredRole: 'admin'),
              '/cart': (context) => const CartScreen(),
              '/checkout': (context) => SimpleCheckoutScreen(),
              '/order-tracking': (context, {arguments}) {
                final orderId = arguments as String?;
                return OrderTrackingScreenSimple(orderId: orderId ?? '');
              },
              '/orders': (context) => const OrdersScreen(),
              '/edit-profile': (context) => const EditProfileScreen(),
              '/help-center': (context) => const HelpCenterScreen(),
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
          );
        },
      ),
    );
  }
}
