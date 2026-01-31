import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Image Display Utility Tests', () {
    test('should identify network URLs correctly', () {
      expect(_isNetworkUrl('http://example.com/image.jpg'), isTrue);
      expect(_isNetworkUrl('https://example.com/image.jpg'), isTrue);
      expect(_isNetworkUrl('ftp://example.com/image.jpg'), isFalse);
      expect(_isNetworkUrl('/local/path/image.jpg'), isFalse);
      expect(_isNetworkUrl('assets/images/profile.png'), isFalse);
    });

    test('should identify asset URLs correctly', () {
      expect(_isAssetUrl('assets/images/profile.png'), isTrue);
      expect(_isAssetUrl('assets/icons/app_icon.png'), isTrue);
      expect(_isAssetUrl('http://example.com/image.jpg'), isFalse);
      expect(_isAssetUrl('/local/path/image.jpg'), isFalse);
      expect(_isAssetUrl('profile.png'), isFalse);
    });

    test('should extract filename from URL correctly', () {
      expect(_extractFilename('http://example.com/profile_pictures/user123.jpg'), equals('user123.jpg'));
      expect(_extractFilename('https://cdn.example.com/images/photo.png'), equals('photo.png'));
      expect(_extractFilename('/local/path/image.gif'), equals('image.gif'));
      expect(_extractFilename('image.jpg'), equals('image.jpg'));
      expect(_extractFilename(''), isEmpty);
    });

    test('should validate image extensions correctly', () {
      expect(_hasValidImageExtension('image.jpg'), isTrue);
      expect(_hasValidImageExtension('image.jpeg'), isTrue);
      expect(_hasValidImageExtension('image.png'), isTrue);
      expect(_hasValidImageExtension('image.gif'), isTrue);
      expect(_hasValidImageExtension('image.bmp'), isTrue);
      expect(_hasValidImageExtension('image.txt'), isFalse);
      expect(_hasValidImageExtension('image.pdf'), isFalse);
      expect(_hasValidImageExtension('IMAGE.JPG'), isTrue); // Case insensitive
    });

    test('should handle empty and null inputs gracefully', () {
      expect(_isNetworkUrl(''), isFalse);
      expect(_isNetworkUrl(null), isFalse);
      expect(_isAssetUrl(''), isFalse);
      expect(_isAssetUrl(null), isFalse);
      expect(_extractFilename(''), isEmpty);
      expect(_extractFilename(null), isEmpty);
      expect(_hasValidImageExtension(''), isFalse);
      expect(_hasValidImageExtension(null), isFalse);
    });
  });
}

// Helper functions for testing (these would normally be in a utility class)
bool _isNetworkUrl(String? url) {
  if (url == null || url.isEmpty) return false;
  return url.startsWith('http://') || url.startsWith('https://');
}

bool _isAssetUrl(String? url) {
  if (url == null || url.isEmpty) return false;
  return url.startsWith('assets/');
}

String _extractFilename(String? url) {
  if (url == null || url.isEmpty) return '';
  return url.split('/').last;
}

bool _hasValidImageExtension(String? filename) {
  if (filename == null || filename.isEmpty) return false;
  final validExtensions = ['.jpg', '.jpeg', '.png', '.gif', '.bmp'];
  final lowerFilename = filename.toLowerCase();
  return validExtensions.any((ext) => lowerFilename.endsWith(ext));
}
