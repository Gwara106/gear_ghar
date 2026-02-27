import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationProvider extends ChangeNotifier {
  static const String _notificationsEnabledKey = 'notifications_enabled';
  static const String _orderUpdatesKey = 'order_updates';
  static const String _promotionsKey = 'promotions';
  static const String _priceAlertsKey = 'price_alerts';
  static const String _stockNotificationsKey = 'stock_notifications';
  static const String _emailNotificationsKey = 'email_notifications';
  static const String _pushNotificationsKey = 'push_notifications';
  static const String _smsNotificationsKey = 'sms_notifications';

  bool _notificationsEnabled = true;
  bool _orderUpdates = true;
  bool _promotions = true;
  bool _priceAlerts = false;
  bool _stockNotifications = true;
  bool _emailNotifications = true;
  bool _pushNotifications = true;
  bool _smsNotifications = false;

  // Getters
  bool get notificationsEnabled => _notificationsEnabled;
  bool get orderUpdates => _orderUpdates;
  bool get promotions => _promotions;
  bool get priceAlerts => _priceAlerts;
  bool get stockNotifications => _stockNotifications;
  bool get emailNotifications => _emailNotifications;
  bool get pushNotifications => _pushNotifications;
  bool get smsNotifications => _smsNotifications;

  NotificationProvider() {
    _loadNotificationSettings();
  }

  Future<void> _loadNotificationSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      _notificationsEnabled = prefs.getBool(_notificationsEnabledKey) ?? true;
      _orderUpdates = prefs.getBool(_orderUpdatesKey) ?? true;
      _promotions = prefs.getBool(_promotionsKey) ?? true;
      _priceAlerts = prefs.getBool(_priceAlertsKey) ?? false;
      _stockNotifications = prefs.getBool(_stockNotificationsKey) ?? true;
      _emailNotifications = prefs.getBool(_emailNotificationsKey) ?? true;
      _pushNotifications = prefs.getBool(_pushNotificationsKey) ?? true;
      _smsNotifications = prefs.getBool(_smsNotificationsKey) ?? false;
      
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading notification settings: $e');
    }
  }

  Future<void> setNotificationsEnabled(bool value) async {
    try {
      _notificationsEnabled = value;
      
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_notificationsEnabledKey, value);
      
      // If notifications are disabled, disable all notification types
      if (!value) {
        await setOrderUpdates(false);
        await setPromotions(false);
        await setPriceAlerts(false);
        await setStockNotifications(false);
        await setEmailNotifications(false);
        await setPushNotifications(false);
        await setSmsNotifications(false);
      } else {
        // Enable default notification types when notifications are enabled
        await setOrderUpdates(true);
        await setPromotions(true);
        await setStockNotifications(true);
        await setEmailNotifications(true);
        await setPushNotifications(true);
      }
      
      notifyListeners();
    } catch (e) {
      debugPrint('Error setting notifications enabled: $e');
    }
  }

  Future<void> setOrderUpdates(bool value) async {
    try {
      _orderUpdates = _notificationsEnabled ? value : false;
      
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_orderUpdatesKey, _orderUpdates);
      
      notifyListeners();
    } catch (e) {
      debugPrint('Error setting order updates: $e');
    }
  }

  Future<void> setPromotions(bool value) async {
    try {
      _promotions = _notificationsEnabled ? value : false;
      
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_promotionsKey, _promotions);
      
      notifyListeners();
    } catch (e) {
      debugPrint('Error setting promotions: $e');
    }
  }

  Future<void> setPriceAlerts(bool value) async {
    try {
      _priceAlerts = _notificationsEnabled ? value : false;
      
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_priceAlertsKey, _priceAlerts);
      
      notifyListeners();
    } catch (e) {
      debugPrint('Error setting price alerts: $e');
    }
  }

  Future<void> setStockNotifications(bool value) async {
    try {
      _stockNotifications = _notificationsEnabled ? value : false;
      
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_stockNotificationsKey, _stockNotifications);
      
      notifyListeners();
    } catch (e) {
      debugPrint('Error setting stock notifications: $e');
    }
  }

  Future<void> setEmailNotifications(bool value) async {
    try {
      _emailNotifications = _notificationsEnabled ? value : false;
      
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_emailNotificationsKey, _emailNotifications);
      
      notifyListeners();
    } catch (e) {
      debugPrint('Error setting email notifications: $e');
    }
  }

  Future<void> setPushNotifications(bool value) async {
    try {
      _pushNotifications = _notificationsEnabled ? value : false;
      
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_pushNotificationsKey, _pushNotifications);
      
      notifyListeners();
    } catch (e) {
      debugPrint('Error setting push notifications: $e');
    }
  }

  Future<void> setSmsNotifications(bool value) async {
    try {
      _smsNotifications = _notificationsEnabled ? value : false;
      
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_smsNotificationsKey, _smsNotifications);
      
      notifyListeners();
    } catch (e) {
      debugPrint('Error setting SMS notifications: $e');
    }
  }

  Future<void> resetToDefaults() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      await prefs.setBool(_notificationsEnabledKey, true);
      await prefs.setBool(_orderUpdatesKey, true);
      await prefs.setBool(_promotionsKey, true);
      await prefs.setBool(_priceAlertsKey, false);
      await prefs.setBool(_stockNotificationsKey, true);
      await prefs.setBool(_emailNotificationsKey, true);
      await prefs.setBool(_pushNotificationsKey, true);
      await prefs.setBool(_smsNotificationsKey, false);
      
      await _loadNotificationSettings();
    } catch (e) {
      debugPrint('Error resetting notification settings: $e');
    }
  }

  Map<String, bool> getAllSettings() {
    return {
      'notificationsEnabled': _notificationsEnabled,
      'orderUpdates': _orderUpdates,
      'promotions': _promotions,
      'priceAlerts': _priceAlerts,
      'stockNotifications': _stockNotifications,
      'emailNotifications': _emailNotifications,
      'pushNotifications': _pushNotifications,
      'smsNotifications': _smsNotifications,
    };
  }
}
