import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'permission_service.dart';

class LocationService {
  static final LocationService _instance = LocationService._internal();
  factory LocationService() => _instance;
  LocationService._internal();

  final PermissionService _permissionService = PermissionService();

  Future<Position?> getCurrentLocation() async {
    try {
      final hasPermission = await _permissionService.requestLocationPermission();
      if (!hasPermission) {
        throw Exception('Location permission denied');
      }

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      
      return position;
    } catch (e) {
      debugPrint('Error getting current location: $e');
      return null;
    }
  }

  Future<LocationPermission> checkLocationPermission() async {
    return await Geolocator.checkPermission();
  }

  Future<LocationPermission> requestLocationPermission() async {
    return await Geolocator.requestPermission();
  }

  Future<bool> isLocationServiceEnabled() async {
    return await Geolocator.isLocationServiceEnabled();
  }

  Future<void> openLocationSettings() async {
    await Geolocator.openLocationSettings();
  }

  Future<void> openAppSettings() async {
    await Geolocator.openAppSettings();
  }

  Stream<Position> getPositionStream({
    LocationSettings? locationSettings,
  }) {
    return Geolocator.getPositionStream(
      locationSettings: locationSettings ?? 
        const LocationSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 100,
        ),
    );
  }

  double calculateDistance(
    double startLatitude,
    double startLongitude,
    double endLatitude,
    double endLongitude,
  ) {
    return Geolocator.distanceBetween(
      startLatitude,
      startLongitude,
      endLatitude,
      endLongitude,
    );
  }

  Future<String> getAddressFromCoordinates(double latitude, double longitude) async {
    // This is a placeholder implementation
    // In a real app, you would use a geocoding service like geocoding package
    return '$latitude, $longitude';
  }

  Future<Map<String, double>?> getCoordinatesFromAddress(String address) async {
    // This is a placeholder implementation
    // In a real app, you would use a geocoding service like geocoding package
    return null;
  }
}
