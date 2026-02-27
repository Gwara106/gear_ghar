import 'package:flutter/material.dart';
import 'dart:io';
import '../../../auth/presentation/screens/login_screen.dart';
import '../../../shop/presentation/screens/orders_screen.dart';
import 'addresses_screen_simple.dart';
import 'payment_methods_screen.dart';
import 'settings_screen.dart';
import 'help_center_screen.dart';
import 'edit_profile_screen.dart';
import '../../../../shared/providers/auth_provider.dart';
import '../../../../providers/address_provider.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    // Set current user in address provider when profile screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final addressProvider = Provider.of<AddressProvider>(context, listen: false);
      
      if (authProvider.currentUser != null) {
        addressProvider.setCurrentUser(authProvider.currentUser!.email);
        debugPrint('ProfileScreen: Set address provider user to: ${authProvider.currentUser!.email}');
      }
    });
  }

  ImageProvider _buildProfileImage(String? profilePicture) {
    if (profilePicture != null && profilePicture.isNotEmpty) {
      debugPrint('ProfileScreen: User profile picture: $profilePicture');
      
      // Check if it's a server URL
      if (profilePicture.startsWith('http')) {
        debugPrint('ProfileScreen: Using NetworkImage for server URL');
        return NetworkImage(profilePicture);
      } else {
        // Handle local file
        final file = File(profilePicture);
        debugPrint('ProfileScreen: Checking if file exists: ${file.path}');
        
        if (file.existsSync()) {
          debugPrint('ProfileScreen: File exists, using FileImage');
          return FileImage(file);
        } else {
          debugPrint('ProfileScreen: File does not exist, using placeholder');
        }
      }
    }
    
    debugPrint('ProfileScreen: Using placeholder image');
    return const AssetImage('assets/images/profile_placeholder.png');
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    
    // Debug logging
    debugPrint('ProfileScreen: User profile picture: ${authProvider.currentUser?.profilePicture}');
    
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('My Profile'),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        foregroundColor: Theme.of(context).appBarTheme.foregroundColor,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Profile Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              color: Theme.of(context).cardTheme.color,
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: _buildProfileImage(authProvider.currentUser?.profilePicture),
                    backgroundColor: Theme.of(context).brightness == Brightness.dark 
                        ? Colors.grey.shade700 
                        : Colors.grey.shade200,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    authProvider.currentUser?.fullName ?? 'Guest User',
                    style: TextStyle(
                      fontSize: 22, 
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).textTheme.bodyLarge?.color,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    authProvider.currentUser?.email ?? 'No email',
                    style: TextStyle(
                      color: Theme.of(context).brightness == Brightness.dark 
                          ? Colors.grey.shade400 
                          : Colors.grey.shade600, 
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const EditProfileScreen(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).brightness == Brightness.dark 
                          ? const Color(0xFF2A2A2A)
                          : Colors.black,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 10,
                      ),
                    ),
                    child: const Text('Edit Profile'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),

            // Menu Items
            _buildMenuCard(
              context,
              title: 'My Orders',
              icon: Icons.shopping_bag_outlined,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => OrdersScreen()),
                );
              },
            ),
            _buildMenuCard(
              context,
              title: 'My Addresses',
              icon: Icons.location_on_outlined,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AddressesScreenSimple(),
                  ),
                );
              },
            ),
            _buildMenuCard(
              context,
              title: 'Payment Methods',
              icon: Icons.payment_outlined,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PaymentMethodsScreen(),
                  ),
                );
              },
            ),
            _buildMenuCard(
              context,
              title: 'Settings',
              icon: Icons.settings_outlined,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SettingsScreen(),
                  ),
                );
              },
            ),
            _buildMenuCard(
              context,
              title: 'Help Center',
              icon: Icons.help_outline,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const HelpCenterScreen(),
                  ),
                );
              },
            ),
            const SizedBox(height: 10),
            _buildMenuCard(
              context,
              title: 'Logout',
              icon: Icons.logout,
              isLogout: true,
              onTap: () {
                _showLogoutConfirmation(context);
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required VoidCallback onTap,
    bool isLogout = false,
  }) {
    return Card(
      color: Theme.of(context).cardTheme.color,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(
          color: Theme.of(context).brightness == Brightness.dark 
              ? Colors.grey.shade800 
              : Colors.grey.shade200,
        ),
      ),
      child: ListTile(
        leading: Icon(
          icon, 
          color: isLogout 
              ? Colors.red 
              : Theme.of(context).brightness == Brightness.dark 
                  ? Colors.white 
                  : Colors.black,
        ),
        title: Text(
          title,
          style: TextStyle(
            color: isLogout 
                ? Colors.red 
                : Theme.of(context).brightness == Brightness.dark 
                    ? Colors.white 
                    : Colors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: isLogout
            ? null
            : Icon(
                Icons.arrow_forward_ios, 
                size: 16, 
                color: Theme.of(context).brightness == Brightness.dark 
                    ? Colors.grey.shade400 
                    : Colors.grey,
              ),
        onTap: onTap,
      ),
    );
  }

  void _showLogoutConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).dialogTheme.backgroundColor,
          title: Text(
            'Logout',
            style: TextStyle(
              color: Theme.of(context).dialogTheme.titleTextStyle?.color,
            ),
          ),
          content: Text(
            'Are you sure you want to logout?',
            style: TextStyle(
              color: Theme.of(context).dialogTheme.contentTextStyle?.color,
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: Theme.of(context).brightness == Brightness.dark 
                      ? Colors.white 
                      : Colors.black,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                final authProvider = Provider.of<AuthProvider>(context, listen: false);
                authProvider.logout();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                  (Route<dynamic> route) => false,
                );
              },
              child: const Text('Logout', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
}
