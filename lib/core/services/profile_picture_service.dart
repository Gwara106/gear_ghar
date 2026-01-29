import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'permission_service.dart';
import 'upload_service.dart';

class ProfilePictureService {
  static final ProfilePictureService _instance =
      ProfilePictureService._internal();
  factory ProfilePictureService() => _instance;
  ProfilePictureService._internal();

  final ImagePicker _imagePicker = ImagePicker();
  final PermissionService _permissionService = PermissionService();

  Future<File?> pickImageFromCamera() async {
    try {
      final hasPermission = await _permissionService.requestCameraPermission();
      if (!hasPermission) {
        throw Exception('Camera permission denied');
      }

      final XFile? pickedFile = await _imagePicker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
        maxWidth: 800,
        maxHeight: 800,
      );

      if (pickedFile != null) {
        return await _cropImage(File(pickedFile.path));
      }
      return null;
    } catch (e) {
      debugPrint('Error picking image from camera: $e');
      return null;
    }
  }

  Future<File?> pickImageFromGallery() async {
    try {
      debugPrint('ProfilePictureService: Requesting storage permission...');
      final hasPermission = await _permissionService.requestStoragePermission();
      debugPrint('ProfilePictureService: Storage permission granted: $hasPermission');
      
      if (!hasPermission) {
        throw Exception('Storage permission denied');
      }

      debugPrint('ProfilePictureService: Picking image from gallery...');
      final XFile? pickedFile = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
        maxWidth: 800,
        maxHeight: 800,
      );

      debugPrint('ProfilePictureService: Picked file: ${pickedFile?.path}');
      if (pickedFile != null) {
        return await _cropImage(File(pickedFile.path));
      }
      return null;
    } catch (e) {
      debugPrint('Error picking image from gallery: $e');
      return null;
    }
  }

  Future<File?> _cropImage(File imageFile) async {
    try {
      // For now, just return the original file without cropping
      // In a production app, you might want to implement custom cropping
      // or use a different cropping library that's compatible with your Flutter version
      return imageFile;
    } catch (e) {
      debugPrint('Error cropping image: $e');
      return imageFile;
    }
  }

  Future<String> saveProfilePicture(File imageFile, String userId) async {
    try {
      debugPrint('ProfilePictureService: Uploading to server...');
      
      // Upload to server
      final serverUrl = await UploadService.uploadProfilePicture(imageFile);
      
      if (serverUrl != null) {
        debugPrint('ProfilePictureService: Upload successful: $serverUrl');
        return serverUrl;
      } else {
        // Fallback to local storage if server upload fails
        debugPrint('ProfilePictureService: Server upload failed, using local storage');
        return await _saveLocally(imageFile, userId);
      }
    } catch (e) {
      debugPrint('Error saving profile picture: $e');
      // Fallback to local storage
      return await _saveLocally(imageFile, userId);
    }
  }

  Future<String> _saveLocally(File imageFile, String userId) async {
    try {
      final appDir = await getApplicationDocumentsDirectory();
      final profileDir = Directory(path.join(appDir.path, 'profile_pictures'));

      if (!await profileDir.exists()) {
        await profileDir.create(recursive: true);
      }

      final fileName = '${userId}_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final savedImage = await imageFile.copy(
        path.join(profileDir.path, fileName),
      );

      return savedImage.path;
    } catch (e) {
      debugPrint('Error saving profile picture locally: $e');
      rethrow;
    }
  }

  Future<bool> deleteProfilePicture(String imagePath) async {
    try {
      final file = File(imagePath);
      if (await file.exists()) {
        await file.delete();
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('Error deleting profile picture: $e');
      return false;
    }
  }

  Future<void> deleteAllUserProfilePictures(String userId) async {
    try {
      final appDir = await getApplicationDocumentsDirectory();
      final profileDir = Directory(path.join(appDir.path, 'profile_pictures'));

      if (await profileDir.exists()) {
        final files = await profileDir.list().toList();
        for (final file in files) {
          if (file is File && path.basename(file.path).startsWith(userId)) {
            await file.delete();
          }
        }
      }
    } catch (e) {
      debugPrint('Error deleting user profile pictures: $e');
    }
  }

  Future<List<String>> getUserProfilePictures(String userId) async {
    try {
      final appDir = await getApplicationDocumentsDirectory();
      final profileDir = Directory(path.join(appDir.path, 'profile_pictures'));

      if (!await profileDir.exists()) {
        return [];
      }

      final files = await profileDir.list().toList();
      final userFiles = <String>[];

      for (final file in files) {
        if (file is File && path.basename(file.path).startsWith(userId)) {
          userFiles.add(file.path);
        }
      }

      return userFiles;
    } catch (e) {
      debugPrint('Error getting user profile pictures: $e');
      return [];
    }
  }

  Future<File?> getProfilePictureFile(String? imagePath) async {
    if (imagePath == null || imagePath.isEmpty) {
      return null;
    }

    // Check if it's a server URL
    if (imagePath.startsWith('http')) {
      // For server URLs, we'll handle them differently in the UI
      // The image will be loaded directly from the URL
      return null;
    }

    final file = File(imagePath);
    return await file.exists() ? file : null;
  }

  Future<Uint8List?> getProfilePictureBytes(String? imagePath) async {
    if (imagePath == null || imagePath.isEmpty) {
      return null;
    }

    try {
      final file = File(imagePath);
      if (await file.exists()) {
        return await file.readAsBytes();
      }
      return null;
    } catch (e) {
      debugPrint('Error reading profile picture bytes: $e');
      return null;
    }
  }

  bool isValidImageFile(String filePath) {
    final extension = path.extension(filePath).toLowerCase();
    return ['.jpg', '.jpeg', '.png', '.gif', '.bmp'].contains(extension);
  }

  Future<int> getFileSize(String filePath) async {
    try {
      final file = File(filePath);
      if (await file.exists()) {
        return await file.length();
      }
      return 0;
    } catch (e) {
      debugPrint('Error getting file size: $e');
      return 0;
    }
  }
}
