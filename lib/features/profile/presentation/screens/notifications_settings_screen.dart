import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../shared/providers/notification_provider.dart';

class NotificationsSettingsScreen extends StatefulWidget {
  const NotificationsSettingsScreen({super.key});

  @override
  State<NotificationsSettingsScreen> createState() =>
      _NotificationsSettingsScreenState();
}

class _NotificationsSettingsScreenState
    extends State<NotificationsSettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final notificationProvider = Provider.of<NotificationProvider>(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notification Settings'),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text(
              'Enable Notifications',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            value: notificationProvider.notificationsEnabled,
            onChanged: (bool value) {
              notificationProvider.setNotificationsEnabled(value);
            },
          ),
          const Divider(),
          if (notificationProvider.notificationsEnabled) ..._buildNotificationSettings(notificationProvider),
        ],
      ),
    );
  }

  List<Widget> _buildNotificationSettings(NotificationProvider notificationProvider) {
    return [
      const Padding(
        padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
        child: Text(
          'Notification Types',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
      ),
      SwitchListTile(
        title: const Text('Order Updates'),
        subtitle: const Text('Order confirmations, shipping updates, etc.'),
        value: notificationProvider.orderUpdates,
        onChanged: notificationProvider.notificationsEnabled
            ? (bool value) {
                notificationProvider.setOrderUpdates(value);
              }
            : null,
      ),
      SwitchListTile(
        title: const Text('Promotions & Offers'),
        subtitle: const Text('Special offers and discounts'),
        value: notificationProvider.promotions,
        onChanged: notificationProvider.notificationsEnabled
            ? (bool value) {
                notificationProvider.setPromotions(value);
              }
            : null,
      ),
      SwitchListTile(
        title: const Text('Price Alerts'),
        subtitle: const Text('Get notified when prices drop on saved items'),
        value: notificationProvider.priceAlerts,
        onChanged: notificationProvider.notificationsEnabled
            ? (bool value) {
                notificationProvider.setPriceAlerts(value);
              }
            : null,
      ),
      SwitchListTile(
        title: const Text('Back in Stock'),
        subtitle: const Text('Get notified when out-of-stock items are back'),
        value: notificationProvider.stockNotifications,
        onChanged: notificationProvider.notificationsEnabled
            ? (bool value) {
                notificationProvider.setStockNotifications(value);
              }
            : null,
      ),
      const Divider(),
      const Padding(
        padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
        child: Text(
          'Notification Methods',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
      ),
      SwitchListTile(
        title: const Text('Email Notifications'),
        value: notificationProvider.emailNotifications,
        onChanged: notificationProvider.notificationsEnabled
            ? (bool value) {
                notificationProvider.setEmailNotifications(value);
              }
            : null,
      ),
      SwitchListTile(
        title: const Text('Push Notifications'),
        value: notificationProvider.pushNotifications,
        onChanged: notificationProvider.notificationsEnabled
            ? (bool value) {
                notificationProvider.setPushNotifications(value);
              }
            : null,
      ),
      SwitchListTile(
        title: const Text('SMS Notifications'),
        subtitle: const Text('Standard message rates may apply'),
        value: notificationProvider.smsNotifications,
        onChanged: notificationProvider.notificationsEnabled
            ? (bool value) {
                if (value) {
                  _showSmsConsentDialog();
                }
                notificationProvider.setSmsNotifications(value);
              }
            : null,
      ),
      const Divider(),
      ListTile(
        title: const Text('Notification Sound'),
        subtitle: const Text('Default (Chime)'),
        trailing: const Icon(Icons.chevron_right, color: Colors.grey),
        onTap: notificationProvider.notificationsEnabled
            ? () {
                _showSoundSelectionDialog();
              }
            : null,
      ),
      ListTile(
        title: const Text('Do Not Disturb'),
        subtitle: const Text('Off'),
        trailing: const Icon(Icons.chevron_right, color: Colors.grey),
        onTap: notificationProvider.notificationsEnabled
            ? () {
                _showDNDSettings();
              }
            : null,
      ),
      const SizedBox(height: 24),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Notification settings saved'),
                duration: Duration(seconds: 2),
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Text('Save Changes'),
        ),
      ),
      const SizedBox(height: 16),
    ];
  }

  void _showSmsConsentDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('SMS Notifications'),
          content: const Text(
            'By enabling SMS notifications, you agree to receive text messages from Gear Ghar. '
            'Standard message and data rates may apply. Reply STOP to opt-out at any time.',
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('CANCEL'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // SMS subscription is handled by the provider
              },
              child: const Text('AGREE'),
            ),
          ],
        );
      },
    );
  }

  void _showSoundSelectionDialog() {
    // Placeholder implementation for sound selection dialog
    debugPrint('Show sound selection dialog');
  }

  void _showDNDSettings() {
    // Placeholder implementation for DND settings
    debugPrint('Show DND settings');
  }

}
