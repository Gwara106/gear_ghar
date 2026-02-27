import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'notifications_settings_screen.dart';
import 'change_password_screen.dart';
import 'terms_of_service_screen.dart';
import 'privacy_policy_screen.dart';
import '../../../../shared/providers/auth_provider.dart';
import '../../../../shared/providers/theme_provider.dart';
import '../../../../shared/providers/notification_provider.dart';
import '../../../../features/auth/presentation/screens/login_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final notificationProvider = Provider.of<NotificationProvider>(context);
    
    // Only build if theme provider is initialized
    if (!themeProvider.isInitialized) {
      return Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          title: const Text('Settings'),
          backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
          foregroundColor: Theme.of(context).appBarTheme.foregroundColor,
          elevation: 0,
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        foregroundColor: Theme.of(context).appBarTheme.foregroundColor,
        elevation: 0,
      ),
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          _buildSectionHeader('Account Settings'),
          _buildListTile(
            context,
            title: 'Edit Profile',
            icon: Icons.person_outline,
            onTap: () {
              Navigator.pushNamed(context, '/edit-profile');
            },
          ),
          _buildListTile(
            context,
            title: 'Change Password',
            icon: Icons.lock_outline,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ChangePasswordScreen(),
                ),
              );
            },
          ),
          _buildSectionHeader('Preferences'),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            decoration: BoxDecoration(
              color: Theme.of(context).cardTheme.color,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Theme.of(context).brightness == Brightness.dark 
                    ? Colors.grey.shade800 
                    : Colors.grey.shade200,
              ),
            ),
            child: SwitchListTile(
              title: Text(
                'Dark Mode',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                ),
              ),
              subtitle: Text(
                'Reduce eye strain in low light',
                style: TextStyle(
                  fontSize: 12,
                  color: Theme.of(context).textTheme.bodySmall?.color,
                ),
              ),
              secondary: Icon(
                Icons.dark_mode_outlined,
                color: themeProvider.isDarkMode 
                    ? const Color(0xFF4CAF50)
                    : Theme.of(context).iconTheme.color,
              ),
              value: themeProvider.isDarkMode,
              onChanged: (bool value) {
                // Add haptic feedback
                HapticFeedback.lightImpact();
                themeProvider.toggleTheme();
              },
              activeThumbColor: const Color(0xFF4CAF50),
              inactiveThumbColor: Colors.grey.shade400,
              inactiveTrackColor: Colors.grey.shade300,
            ),
          ),
          _buildListTile(
            context,
            title: 'Notifications',
            icon: Icons.notifications_outlined,
            trailing: notificationProvider.notificationsEnabled 
                ? const Icon(Icons.check_circle, color: Colors.green)
                : const Icon(Icons.circle_outlined, color: Colors.grey),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const NotificationsSettingsScreen(),
                ),
              );
            },
          ),
          _buildSectionHeader('Support'),
          _buildListTile(
            context,
            title: 'Help Center',
            icon: Icons.help_outline,
            onTap: () {
              Navigator.pushNamed(context, '/help-center');
            },
          ),
          _buildListTile(
            context,
            title: 'Contact Support',
            icon: Icons.email_outlined,
            onTap: () {
              _showContactSupportBottomSheet(context);
            },
          ),
          _buildListTile(
            context,
            title: 'About',
            icon: Icons.info_outline,
            onTap: () {
              _showAboutDialog(context);
            },
          ),
          _buildSectionHeader('Legal'),
          _buildListTile(
            context,
            title: 'Terms of Service',
            icon: Icons.description_outlined,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const TermsOfServiceScreen(),
                ),
              );
            },
          ),
          _buildListTile(
            context,
            title: 'Privacy Policy',
            icon: Icons.privacy_tip_outlined,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PrivacyPolicyScreen(),
                ),
              );
            },
          ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: OutlinedButton(
              onPressed: () {
                _handleLogout(context);
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.red,
                side: const BorderSide(color: Colors.red),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Logout'),
            ),
          ),
          const SizedBox(height: 24),
          Center(
            child: Text(
              'Version 1.0.0',
              style: TextStyle(
                color: Theme.of(context).brightness == Brightness.dark 
                    ? Colors.grey.shade400 
                    : Colors.grey.shade600, 
                fontSize: 12,
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Theme.of(context).brightness == Brightness.dark 
              ? Colors.grey.shade400 
              : Colors.grey.shade600,
        ),
      ),
    );
  }

  Widget _buildListTile(BuildContext context, {
    required String title,
    required IconData icon,
    Widget? trailing,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).brightness == Brightness.dark 
              ? Colors.grey.shade800 
              : Colors.grey.shade200,
        ),
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: Theme.of(context).iconTheme.color,
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: Theme.of(context).textTheme.bodyLarge?.color,
          ),
        ),
        trailing: trailing ?? Icon(
          Icons.chevron_right,
          color: Theme.of(context).brightness == Brightness.dark 
              ? Colors.grey.shade400 
              : Colors.grey.shade600,
        ),
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      ),
    );
  }

  void _showContactSupportBottomSheet(BuildContext context) {
    final subjectController = TextEditingController();
    final messageController = TextEditingController();
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).dialogTheme.backgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 16,
          right: 16,
          top: 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Contact Support',
              style: TextStyle(
                fontSize: 20, 
                fontWeight: FontWeight.bold,
                color: Theme.of(context).dialogTheme.titleTextStyle?.color,
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: subjectController,
              style: TextStyle(
                color: Theme.of(context).dialogTheme.contentTextStyle?.color,
              ),
              decoration: InputDecoration(
                labelText: 'Subject',
                labelStyle: TextStyle(
                  color: Theme.of(context).inputDecorationTheme.labelStyle?.color,
                ),
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Theme.of(context).brightness == Brightness.dark 
                        ? Colors.grey.shade700 
                        : Colors.grey.shade300,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Theme.of(context).brightness == Brightness.dark 
                        ? Colors.grey.shade700 
                        : Colors.grey.shade300,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Theme.of(context).brightness == Brightness.dark 
                        ? Colors.white 
                        : Colors.black,
                    width: 2,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: messageController,
              style: TextStyle(
                color: Theme.of(context).dialogTheme.contentTextStyle?.color,
              ),
              decoration: InputDecoration(
                labelText: 'Message',
                labelStyle: TextStyle(
                  color: Theme.of(context).inputDecorationTheme.labelStyle?.color,
                ),
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Theme.of(context).brightness == Brightness.dark 
                        ? Colors.grey.shade700 
                        : Colors.grey.shade300,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Theme.of(context).brightness == Brightness.dark 
                        ? Colors.grey.shade700 
                        : Colors.grey.shade300,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Theme.of(context).brightness == Brightness.dark 
                        ? Colors.white 
                        : Colors.black,
                    width: 2,
                  ),
                ),
                alignLabelWithHint: true,
              ),
              maxLines: 5,
              textAlignVertical: TextAlignVertical.top,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                IconButton(
                  icon: Icon(
                    Icons.attach_file,
                    color: Theme.of(context).iconTheme.color,
                  ),
                  onPressed: () {
                    _attachFile();
                  },
                ),
                Text(
                  'Attach File',
                  style: TextStyle(
                    color: Theme.of(context).dialogTheme.contentTextStyle?.color,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  if (subjectController.text.trim().isNotEmpty && 
                      messageController.text.trim().isNotEmpty) {
                    _sendMessage(context, subjectController.text, messageController.text);
                    Navigator.pop(context);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('Please fill in all fields'),
                        backgroundColor: Colors.orange,
                      ),
                    );
                  }
                },
                child: const Text('Send Message'),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }


  void _handleLogout(BuildContext context) {
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

  void _attachFile() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('File attachment coming soon!'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _sendMessage(BuildContext context, String subject, String message) async {
    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final userEmail = authProvider.currentUser?.email ?? 'anonymous@gearghar.com';
      
      final Uri emailUri = Uri(
        scheme: 'mailto',
        path: 'support@gearghar.com',
        query: 'subject=${Uri.encodeComponent(subject)}&body=${Uri.encodeComponent('From: $userEmail\n\n$message')}',
      );
      
      if (await canLaunchUrl(emailUri)) {
        await launchUrl(emailUri);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Opening email client...'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Could not open email client'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showAboutDialog(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationName: 'Gear Ghar',
      applicationVersion: '1.0.0',
      applicationIcon: const Icon(Icons.shopping_bag_outlined, size: 50),
      applicationLegalese: '© 2023 Gear Ghar. All rights reserved.',
      children: const [
        SizedBox(height: 16),
        Text(
          'Gear Ghar is your one-stop shop for all your gear needs. '
          'We provide high-quality products with fast delivery and excellent customer service.',
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
