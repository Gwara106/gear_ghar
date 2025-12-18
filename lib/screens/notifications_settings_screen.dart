import 'package:flutter/material.dart';

class NotificationsSettingsScreen extends StatefulWidget {
  const NotificationsSettingsScreen({super.key});

  @override
  State<NotificationsSettingsScreen> createState() =>
      _NotificationsSettingsScreenState();
}

class _NotificationsSettingsScreenState
    extends State<NotificationsSettingsScreen> {
  bool _notificationsEnabled = true;
  bool _orderUpdates = true;
  bool _promotions = true;
  bool _priceAlerts = false;
  bool _stockNotifications = true;
  bool _emailNotifications = true;
  bool _pushNotifications = true;
  bool _smsNotifications = false;

  @override
  Widget build(BuildContext context) {
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
            value: _notificationsEnabled,
            onChanged: (bool value) {
              setState(() {
                _notificationsEnabled = value;
                if (!_notificationsEnabled) {
                  _orderUpdates = false;
                  _promotions = false;
                  _priceAlerts = false;
                  _stockNotifications = false;
                  _emailNotifications = false;
                  _pushNotifications = false;
                  _smsNotifications = false;
                } else {
                  _orderUpdates = true;
                  _promotions = true;
                  _stockNotifications = true;
                  _emailNotifications = true;
                  _pushNotifications = true;
                }
              });
            },
          ),
          const Divider(),
          if (_notificationsEnabled) ..._buildNotificationSettings(),
        ],
      ),
    );
  }

  List<Widget> _buildNotificationSettings() {
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
        value: _orderUpdates,
        onChanged: _notificationsEnabled
            ? (bool value) {
                setState(() {
                  _orderUpdates = value;
                });
              }
            : null,
      ),
      SwitchListTile(
        title: const Text('Promotions & Offers'),
        subtitle: const Text('Special offers and discounts'),
        value: _promotions,
        onChanged: _notificationsEnabled
            ? (bool value) {
                setState(() {
                  _promotions = value;
                });
              }
            : null,
      ),
      SwitchListTile(
        title: const Text('Price Alerts'),
        subtitle: const Text('Get notified when prices drop on saved items'),
        value: _priceAlerts,
        onChanged: _notificationsEnabled
            ? (bool value) {
                setState(() {
                  _priceAlerts = value;
                });
              }
            : null,
      ),
      SwitchListTile(
        title: const Text('Back in Stock'),
        subtitle: const Text('Get notified when out-of-stock items are back'),
        value: _stockNotifications,
        onChanged: _notificationsEnabled
            ? (bool value) {
                setState(() {
                  _stockNotifications = value;
                });
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
        value: _emailNotifications,
        onChanged: _notificationsEnabled
            ? (bool value) {
                setState(() {
                  _emailNotifications = value;
                });
              }
            : null,
      ),
      SwitchListTile(
        title: const Text('Push Notifications'),
        value: _pushNotifications,
        onChanged: _notificationsEnabled
            ? (bool value) {
                setState(() {
                  _pushNotifications = value;
                });
              }
            : null,
      ),
      SwitchListTile(
        title: const Text('SMS Notifications'),
        subtitle: const Text('Standard message rates may apply'),
        value: _smsNotifications,
        onChanged: _notificationsEnabled
            ? (bool value) {
                setState(() {
                  _smsNotifications = value;
                  if (_smsNotifications) {
                    _showSmsConsentDialog();
                  }
                });
              }
            : null,
      ),
      const Divider(),
      ListTile(
        title: const Text('Notification Sound'),
        subtitle: const Text('Default (Chime)'),
        trailing: const Icon(Icons.chevron_right, color: Colors.grey),
        onTap: _notificationsEnabled
            ? () {
                // TODO: Show sound selection dialog
              }
            : null,
      ),
      ListTile(
        title: const Text('Do Not Disturb'),
        subtitle: const Text('Off'),
        trailing: const Icon(Icons.chevron_right, color: Colors.grey),
        onTap: _notificationsEnabled
            ? () {
                // TODO: Show DND settings
              }
            : null,
      ),
      const SizedBox(height: 24),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: ElevatedButton(
          onPressed: () {
            // TODO: Save notification settings
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
                setState(() {
                  _smsNotifications = false;
                });
              },
              child: const Text('CANCEL'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // TODO: Implement SMS subscription logic
              },
              child: const Text('AGREE'),
            ),
          ],
        );
      },
    );
  }
}
