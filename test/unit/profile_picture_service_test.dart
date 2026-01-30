import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:gear_ghar/core/services/profile_picture_service.dart';
import 'package:gear_ghar/core/services/upload_service.dart';

// Generate mocks
@GenerateMocks([UploadService])
import 'profile_picture_service_test.mocks.dart';

void main() {
  group('ProfilePictureService Tests', () {
    late MockUploadService mockUploadService;
    late ProfilePictureService service;
    late File testImageFile;

    setUp(() {
      mockUploadService = MockUploadService();
      service = ProfilePictureService();
      testImageFile = File('test_assets/test_image.jpg');
    });

    test('should return singleton instance', () {
      final instance1 = ProfilePictureService();
      final instance2 = ProfilePictureService();
      
      expect(identical(instance1, instance2), isTrue);
    });

    test('should handle image file validation', () {
      expect(service.isValidImageFile('test.jpg'), isTrue);
      expect(service.isValidImageFile('test.jpeg'), isTrue);
      expect(service.isValidImageFile('test.png'), isTrue);
      expect(service.isValidImageFile('test.gif'), isTrue);
      expect(service.isValidImageFile('test.bmp'), isTrue);
      expect(service.isValidImageFile('test.txt'), isFalse);
      expect(service.isValidImageFile('test.pdf'), isFalse);
    });

    test('should handle file size calculation correctly', () async {
      final tempDir = Directory.systemTemp;
      final testFile = File('${tempDir.path}/size_test.jpg');
      await testFile.writeAsBytes([1, 2, 3, 4, 5]); // 5 bytes

      final fileSize = await service.getFileSize(testFile.path);
      expect(fileSize, equals(5));

      await testFile.delete();
    });

    test('should handle non-existent file size', () async {
      final fileSize = await service.getFileSize('non_existent.jpg');
      expect(fileSize, equals(0));
    });

    test('should handle profile picture file existence check', () async {
      final tempDir = Directory.systemTemp;
      final testFile = File('${tempDir.path}/existence_test.jpg');
      await testFile.writeAsBytes([1, 2, 3, 4, 5]);

      final existingFile = await service.getProfilePictureFile(testFile.path);
      expect(existingFile, isNotNull);
      expect(existingFile!.path, equals(testFile.path));

      await testFile.delete();

      final nonExistingFile = await service.getProfilePictureFile(testFile.path);
      expect(nonExistingFile, isNull);
    });
  });
}
