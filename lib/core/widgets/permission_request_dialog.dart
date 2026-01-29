import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import '../services/permission_service.dart';

class PermissionRequestDialog extends StatelessWidget {
  final String title;
  final String description;
  final String permissionType;
  final VoidCallback? onGranted;
  final VoidCallback? onDenied;

  const PermissionRequestDialog({
    super.key,
    required this.title,
    required this.description,
    required this.permissionType,
    this.onGranted,
    this.onDenied,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(description),
          const SizedBox(height: 16),
          Text(
            'This permission is required for the app to function properly.',
            style: TextStyle(color: Colors.grey[600], fontSize: 14),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            onDenied?.call();
          },
          child: const Text('Deny'),
        ),
        ElevatedButton(
          onPressed: () async {
            Navigator.of(context).pop();
            await _requestPermission(context);
          },
          child: const Text('Allow'),
        ),
      ],
    );
  }

  Future<void> _requestPermission(BuildContext context) async {
    final permissionService = PermissionService();
    bool granted = false;

    switch (permissionType.toLowerCase()) {
      case 'camera':
        granted = await permissionService.requestCameraPermission();
        break;
      case 'storage':
        granted = await permissionService.requestStoragePermission();
        break;
      case 'location':
        granted = await permissionService.requestLocationPermission();
        break;
      default:
        granted = false;
    }

    if (granted) {
      onGranted?.call();
    } else {
      if (context.mounted) {
        _showPermissionDeniedDialog(context);
      }
    }
  }

  void _showPermissionDeniedDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Permission Denied'),
        content: const Text(
          'You have denied the permission. You can enable it later in the app settings.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              openAppSettings();
            },
            child: const Text('Open Settings'),
          ),
        ],
      ),
    );
  }
}

class PermissionChecker {
  static Future<bool> checkAndRequestPermissions(
    BuildContext context, {
    bool requestCamera = false,
    bool requestStorage = false,
    bool requestLocation = false,
  }) async {
    final permissionService = PermissionService();
    bool allGranted = true;

    if (requestCamera) {
      final hasPermission = await permissionService.checkCameraPermission();
      if (!hasPermission) {
        if (context.mounted) {
          final granted = await _showPermissionDialog(
            context,
            'Camera Permission',
            'The app needs access to your camera to take photos for your profile picture.',
            'camera',
          );
          allGranted = allGranted && granted;
        }
      }
    }

    if (requestStorage) {
      final hasPermission = await permissionService.checkStoragePermission();
      if (!hasPermission) {
        if (context.mounted) {
          final granted = await _showPermissionDialog(
            context,
            'Storage Permission',
            'The app needs access to your storage to select and save photos.',
            'storage',
          );
          allGranted = allGranted && granted;
        }
      }
    }

    if (requestLocation) {
      final hasPermission = await permissionService.checkLocationPermission();
      if (!hasPermission) {
        if (context.mounted) {
          final granted = await _showPermissionDialog(
            context,
            'Location Permission',
            'The app needs access to your location to provide location-based features.',
            'location',
          );
          allGranted = allGranted && granted;
        }
      }
    }

    return allGranted;
  }

  static Future<bool> _showPermissionDialog(
    BuildContext context,
    String title,
    String description,
    String permissionType,
  ) async {
    bool granted = false;

    await showDialog(
      context: context,
      builder: (context) => PermissionRequestDialog(
        title: title,
        description: description,
        permissionType: permissionType,
        onGranted: () => granted = true,
        onDenied: () => granted = false,
      ),
    );

    return granted;
  }
}
