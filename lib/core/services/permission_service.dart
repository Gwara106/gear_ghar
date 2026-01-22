import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  static final PermissionService _instance = PermissionService._internal();
  factory PermissionService() => _instance;
  PermissionService._internal();

  Future<bool> requestCameraPermission() async {
    final status = await Permission.camera.request();
    return status.isGranted;
  }

  Future<bool> requestStoragePermission() async {
    if (defaultTargetPlatform == TargetPlatform.android) {
      final androidVersion = await _getAndroidVersion();
      debugPrint('PermissionService: Android version: $androidVersion');
      
      if (androidVersion >= 33) {
        // For Android 13+, use media permissions
        debugPrint('PermissionService: Requesting media permissions for Android 13+');
        final photosStatus = await Permission.photos.request();
        final videosStatus = await Permission.videos.request();
        final storageStatus = await Permission.storage.request();
        
        debugPrint('PermissionService: Photos: ${photosStatus.isGranted}, Videos: ${videosStatus.isGranted}, Storage: ${storageStatus.isGranted}');
        return photosStatus.isGranted || videosStatus.isGranted || storageStatus.isGranted;
      } else {
        debugPrint('PermissionService: Requesting storage permission for Android < 13');
        final storageStatus = await Permission.storage.request();
        debugPrint('PermissionService: Storage: ${storageStatus.isGranted}');
        return storageStatus.isGranted;
      }
    } else {
      debugPrint('PermissionService: Requesting photos permission for non-Android');
      final photosStatus = await Permission.photos.request();
      debugPrint('PermissionService: Photos: ${photosStatus.isGranted}');
      return photosStatus.isGranted;
    }
  }

  Future<bool> requestLocationPermission() async {
    final locationStatus = await Permission.location.request();
    if (locationStatus.isGranted) {
      return true;
    } else if (locationStatus.isDenied) {
      return await Permission.location.request().isGranted;
    }
    return false;
  }

  Future<bool> checkCameraPermission() async {
    return await Permission.camera.isGranted;
  }

  Future<bool> checkStoragePermission() async {
    if (defaultTargetPlatform == TargetPlatform.android) {
      final androidVersion = await _getAndroidVersion();
      if (androidVersion >= 33) {
        return await Permission.photos.isGranted ||
            await Permission.videos.isGranted ||
            await Permission.storage.isGranted;
      } else {
        return await Permission.storage.isGranted;
      }
    } else {
      return await Permission.photos.isGranted;
    }
  }

  Future<bool> checkLocationPermission() async {
    return await Permission.location.isGranted;
  }

  Future<void> openAppSettings() async {
    await openAppSettings();
  }

  Future<int> _getAndroidVersion() async {
    try {
      // This is a simplified version - in production you might want to use device_info_plus
      return 33; // Assuming Android 13+ for API 33+
    } catch (e) {
      return 33;
    }
  }

  Future<bool> hasAllPermissions() async {
    final camera = await checkCameraPermission();
    final storage = await checkStoragePermission();
    final location = await checkLocationPermission();
    return camera && storage && location;
  }

  Future<Map<Permission, bool>> requestAllPermissions() async {
    final results = <Permission, bool>{};

    results[Permission.camera] = await requestCameraPermission();
    results[Permission.photos] = await requestStoragePermission();
    results[Permission.location] = await requestLocationPermission();

    return results;
  }
}
