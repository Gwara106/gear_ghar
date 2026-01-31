import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../constants/api_constants.dart';

class UploadService {
  static final Dio _dio = Dio(BaseOptions(
    baseUrl: ApiConstants.baseUrl,
    connectTimeout: const Duration(seconds: 30),
    receiveTimeout: const Duration(seconds: 30),
  ));

  static Future<String?> uploadProfilePicture(File imageFile) async {
    try {
      debugPrint('UploadService: Starting profile picture upload...');
      
      final formData = FormData.fromMap({
        'profilePicture': await MultipartFile.fromFile(
          imageFile.path,
          filename: imageFile.path.split('/').last,
        ),
      });

      final response = await _dio.post(
        '/api/v1/users/upload',
        data: formData,
        options: Options(
          headers: {
            'Content-Type': 'multipart/form-data',
          },
        ),
      );

      if (response.statusCode == 200) {
        final fileName = response.data['fileName'];
        final serverUrl = 'http://10.0.2.2:5000/profile_pictures/$fileName';
        debugPrint('UploadService: Upload successful: $serverUrl');
        return serverUrl;
      } else {
        debugPrint('UploadService: Upload failed with status: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      debugPrint('UploadService: Upload error: $e');
      return null;
    }
  }

  static Future<String?> uploadProductImage(File imageFile) async {
    try {
      debugPrint('UploadService: Starting product image upload...');
      
      final formData = FormData.fromMap({
        'itemPhoto': await MultipartFile.fromFile(
          imageFile.path,
          filename: imageFile.path.split('/').last,
        ),
      });

      final response = await _dio.post(
        '/api/v1/items/upload',
        data: formData,
        options: Options(
          headers: {
            'Content-Type': 'multipart/form-data',
          },
        ),
      );

      if (response.statusCode == 200) {
        final fileName = response.data['fileName'];
        final serverUrl = 'http://10.0.2.2:5000/item_photos/$fileName';
        debugPrint('UploadService: Upload successful: $serverUrl');
        return serverUrl;
      } else {
        debugPrint('UploadService: Upload failed with status: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      debugPrint('UploadService: Upload error: $e');
      return null;
    }
  }

  static Future<bool> deleteImageFromServer(String imageUrl) async {
    try {
      debugPrint('UploadService: Deleting image from server: $imageUrl');
      
      // Extract filename from URL
      final uri = Uri.parse(imageUrl);
      final pathSegments = uri.pathSegments;
      final fileName = pathSegments.last;
      
      final response = await _dio.delete(
        '/api/v1/upload/$fileName',
      );

      if (response.statusCode == 200) {
        debugPrint('UploadService: Image deleted successfully');
        return true;
      } else {
        debugPrint('UploadService: Delete failed with status: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      debugPrint('UploadService: Delete error: $e');
      return false;
    }
  }

  static Future<bool> isImageFileValid(File imageFile) async {
    try {
      if (!await imageFile.exists()) {
        debugPrint('UploadService: File does not exist');
        return false;
      }

      final fileSize = await imageFile.length();
      const maxSize = 5 * 1024 * 1024; // 5MB
      
      if (fileSize > maxSize) {
        debugPrint('UploadService: File too large: $fileSize bytes');
        return false;
      }

      final fileName = imageFile.path.toLowerCase();
      final validExtensions = ['.jpg', '.jpeg', '.png', '.gif', '.bmp'];
      final hasValidExtension = validExtensions.any((ext) => fileName.endsWith(ext));
      
      if (!hasValidExtension) {
        debugPrint('UploadService: Invalid file extension');
        return false;
      }

      debugPrint('UploadService: File validation passed');
      return true;
    } catch (e) {
      debugPrint('UploadService: Validation error: $e');
      return false;
    }
  }
}
