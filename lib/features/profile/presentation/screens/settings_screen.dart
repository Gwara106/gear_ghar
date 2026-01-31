import 'package:flutter/material.dart';
import 'notifications_settings_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _darkMode = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView(
        children: [
          _buildSectionHeader('Account Settings'),
          _buildListTile(
            context,
            title: 'Edit Profile',
            icon: Icons.person_outline,
            onTap: () {
              // Navigate to edit profile screen
              Navigator.pushNamed(context, '/edit-profile');
            },
          ),
          _buildListTile(
            context,
            title: 'Change Password',
            icon: Icons.lock_outline,
            onTap: () {
              // Navigate to change password screen
              Navigator.pushNamed(context, '/change-password');
            },
          ),
          _buildSectionHeader('Preferences'),
          SwitchListTile(
            title: const Text('Dark Mode'),
            secondary: const Icon(Icons.dark_mode_outlined),
            value: _darkMode,
            onChanged: (bool value) {
              setState(() {
                _darkMode = value;
                // Theme change would be implemented here
              });
            },
          ),
          _buildListTile(
            context,
            title: 'Notifications',
            icon: Icons.notifications_outlined,
            trailing: const Icon(Icons.chevron_right, color: Colors.grey),
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
              // Navigate to help center
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
              // Show terms of service
              _showTermsOfService();
            },
          ),
          _buildListTile(
            context,
            title: 'Privacy Policy',
            icon: Icons.privacy_tip_outlined,
            onTap: () {
              // Show privacy policy
              _showPrivacyPolicy();
            },
          ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: OutlinedButton(
              onPressed: () {
                // Implement logout
                _handleLogout();
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
              style: TextStyle(color: Colors.grey[600], fontSize: 12),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Text(
        title,
        style: TextStyle(
          color: Colors.grey[600],
          fontSize: 14,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildListTile(
    BuildContext context, {
    required String title,
    required IconData icon,
    Widget? trailing,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: Colors.grey[200]!),
      ),
      child: ListTile(
        leading: Icon(icon, color: Theme.of(context).primaryColor),
        title: Text(title),
        trailing:
            trailing ?? const Icon(Icons.chevron_right, color: Colors.grey),
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      ),
    );
  }

  void _showContactSupportBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
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
            const Text(
              'Contact Support',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Subject',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Message',
                border: OutlineInputBorder(),
                alignLabelWithHint: true,
              ),
              maxLines: 5,
              textAlignVertical: TextAlignVertical.top,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.attach_file),
                  onPressed: () {
                    // Implement file attachment
                    _attachFile();
                  },
                ),
                const Text('Attach File'),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  // Implement send message
                  _sendMessage();
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Your message has been sent to support'),
                      duration: Duration(seconds: 2),
                    ),
                  );
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

  void _showTermsOfService() {
    // Placeholder implementation for showing terms of service
    debugPrint('Show terms of service');
  }

  void _showPrivacyPolicy() {
    // Placeholder implementation for showing privacy policy
    debugPrint('Show privacy policy');
  }

  void _handleLogout() {
    // Placeholder implementation for logout
    debugPrint('Handle logout');
  }

  void _attachFile() {
    // Placeholder implementation for file attachment
    debugPrint('Attach file');
  }

  void _sendMessage() {
    // Placeholder implementation for sending message
    debugPrint('Send message');
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
