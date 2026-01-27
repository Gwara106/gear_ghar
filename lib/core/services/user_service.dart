import 'dart:io';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import '../models/user_model.dart';
import 'profile_picture_service.dart';

class UserService {
  static final UserService _instance = UserService._internal();
  factory UserService() => _instance;
  UserService._internal();

  final ProfilePictureService _profilePictureService = ProfilePictureService();

  Future<void> updateUserProfilePicture(String userId, String? profilePicturePath) async {
    try {
      final box = await Hive.openBox<User>('users');
      final user = box.values.firstWhere(
        (u) => u.id == userId,
        orElse: () => throw Exception('User not found'),
      );

      // Clean up old profile picture if it exists
      if (user.profilePicturePath != null && user.profilePicturePath != profilePicturePath) {
        await _profilePictureService.deleteProfilePicture(user.profilePicturePath!);
      }

      // Update user with new profile picture
      final updatedUser = User(
        id: user.id,
        name: user.name,
        email: user.email,
        password: user.password,
        createdAt: user.createdAt,
        profilePicturePath: profilePicturePath,
        additionalProfilePictures: user.additionalProfilePictures,
      );

      await box.put(user.key!, updatedUser);
    } catch (e) {
      throw Exception('Failed to update profile picture: $e');
    }
  }

  Future<void> addAdditionalProfilePicture(String userId, String imagePath) async {
    try {
      final box = await Hive.openBox<User>('users');
      final user = box.values.firstWhere(
        (u) => u.id == userId,
        orElse: () => throw Exception('User not found'),
      );

      final updatedPictures = List<String>.from(user.additionalProfilePictures);
      if (!updatedPictures.contains(imagePath)) {
        updatedPictures.add(imagePath);
      }

      final updatedUser = User(
        id: user.id,
        name: user.name,
        email: user.email,
        password: user.password,
        createdAt: user.createdAt,
        profilePicturePath: user.profilePicturePath,
        additionalProfilePictures: updatedPictures,
      );

      await box.put(user.key!, updatedUser);
    } catch (e) {
      throw Exception('Failed to add additional profile picture: $e');
    }
  }

  Future<void> removeAdditionalProfilePicture(String userId, String imagePath) async {
    try {
      final box = await Hive.openBox<User>('users');
      final user = box.values.firstWhere(
        (u) => u.id == userId,
        orElse: () => throw Exception('User not found'),
      );

      final updatedPictures = List<String>.from(user.additionalProfilePictures);
      updatedPictures.remove(imagePath);

      // Delete the actual file
      await _profilePictureService.deleteProfilePicture(imagePath);

      final updatedUser = User(
        id: user.id,
        name: user.name,
        email: user.email,
        password: user.password,
        createdAt: user.createdAt,
        profilePicturePath: user.profilePicturePath,
        additionalProfilePictures: updatedPictures,
      );

      await box.put(user.key!, updatedUser);
    } catch (e) {
      throw Exception('Failed to remove additional profile picture: $e');
    }
  }

  Future<void> deleteUserProfilePictures(String userId) async {
    try {
      final box = await Hive.openBox<User>('users');
      final user = box.values.firstWhere(
        (u) => u.id == userId,
        orElse: () => throw Exception('User not found'),
      );

      // Delete main profile picture
      if (user.profilePicturePath != null) {
        await _profilePictureService.deleteProfilePicture(user.profilePicturePath!);
      }

      // Delete additional profile pictures
      for (final imagePath in user.additionalProfilePictures) {
        await _profilePictureService.deleteProfilePicture(imagePath);
      }

      // Update user with cleared profile pictures
      final updatedUser = User(
        id: user.id,
        name: user.name,
        email: user.email,
        password: user.password,
        createdAt: user.createdAt,
        profilePicturePath: null,
        additionalProfilePictures: [],
      );

      await box.put(user.key!, updatedUser);
    } catch (e) {
      throw Exception('Failed to delete user profile pictures: $e');
    }
  }

  Future<List<String>> getUserProfilePictures(String userId) async {
    try {
      final box = await Hive.openBox<User>('users');
      final user = box.values.firstWhere(
        (u) => u.id == userId,
        orElse: () => throw Exception('User not found'),
      );

      final allPictures = <String>[];
      if (user.profilePicturePath != null) {
        allPictures.add(user.profilePicturePath!);
      }
      allPictures.addAll(user.additionalProfilePictures);

      return allPictures;
    } catch (e) {
      throw Exception('Failed to get user profile pictures: $e');
    }
  }

  Future<String?> getMainProfilePicture(String userId) async {
    try {
      final box = await Hive.openBox<User>('users');
      final user = box.values.firstWhere(
        (u) => u.id == userId,
        orElse: () => throw Exception('User not found'),
      );

      return user.profilePicturePath;
    } catch (e) {
      throw Exception('Failed to get main profile picture: $e');
    }
  }

  Future<List<String>> getAdditionalProfilePictures(String userId) async {
    try {
      final box = await Hive.openBox<User>('users');
      final user = box.values.firstWhere(
        (u) => u.id == userId,
        orElse: () => throw Exception('User not found'),
      );

      return List<String>.from(user.additionalProfilePictures);
    } catch (e) {
      throw Exception('Failed to get additional profile pictures: $e');
    }
  }

  Future<void> cleanupOrphanedProfilePictures() async {
    try {
      final box = await Hive.openBox<User>('users');
      final allValidPaths = <String>{};

      // Collect all valid paths from users
      for (final user in box.values) {
        if (user.profilePicturePath != null) {
          allValidPaths.add(user.profilePicturePath!);
        }
        allValidPaths.addAll(user.additionalProfilePictures);
      }

      // Get all profile pictures from storage
      final appDir = await getApplicationDocumentsDirectory();
      final profileDir = Directory('${appDir.path}/profile_pictures');
      
      if (await profileDir.exists()) {
        final files = await profileDir.list().toList();
        
        for (final file in files) {
          if (file is File) {
            final filePath = file.path;
            if (!allValidPaths.contains(filePath)) {
              // This file is orphaned, delete it
              await file.delete();
              print('Deleted orphaned profile picture: $filePath');
            }
          }
        }
      }
    } catch (e) {
      print('Error cleaning up orphaned profile pictures: $e');
    }
  }

  Future<int> getProfilePicturesStorageSize(String userId) async {
    try {
      final pictures = await getUserProfilePictures(userId);
      int totalSize = 0;

      for (final picturePath in pictures) {
        final fileSize = await _profilePictureService.getFileSize(picturePath);
        totalSize += fileSize;
      }

      return totalSize;
    } catch (e) {
      throw Exception('Failed to get profile pictures storage size: $e');
    }
  }
}
