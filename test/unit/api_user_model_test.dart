import 'package:flutter_test/flutter_test.dart';
import 'package:gear_ghar/core/models/api_user_model.dart';

void main() {
  group('ApiUser Model Tests', () {
    late DateTime testDate;
    late ApiUser testUser;

    setUp(() {
      testDate = DateTime.now();
      testUser = ApiUser(
        id: 'test_id',
        firstName: 'John',
        lastName: 'Doe',
        email: 'john.doe@example.com',
        role: 'user',
        status: 'active',
        createdAt: testDate,
        updatedAt: testDate,
        profilePicture: 'http://example.com/profile.jpg',
      );
    });

    test('should create ApiUser with required fields', () {
      expect(testUser.id, equals('test_id'));
      expect(testUser.firstName, equals('John'));
      expect(testUser.lastName, equals('Doe'));
      expect(testUser.email, equals('john.doe@example.com'));
      expect(testUser.role, equals('user'));
      expect(testUser.status, equals('active'));
      expect(testUser.createdAt, equals(testDate));
      expect(testUser.updatedAt, equals(testDate));
    });

    test('should handle fullName getter correctly', () {
      expect(testUser.fullName, equals('John Doe'));
    });

    test('should handle fullName getter with name field', () {
      final userWithName = ApiUser(
        id: 'test_id',
        firstName: 'John',
        lastName: 'Doe',
        email: 'john.doe@example.com',
        role: 'user',
        status: 'active',
        createdAt: testDate,
        updatedAt: testDate,
        name: 'Jane Smith',
      );
      
      expect(userWithName.fullName, equals('Jane Smith'));
    });

    test('should handle profilePicturePath getter', () {
      expect(testUser.profilePicturePath, equals('http://example.com/profile.jpg'));
    });

    test('should handle null profile picture', () {
      final userWithoutPic = ApiUser(
        id: 'test_id',
        firstName: 'John',
        lastName: 'Doe',
        email: 'john.doe@example.com',
        role: 'user',
        status: 'active',
        createdAt: testDate,
        updatedAt: testDate,
      );
      
      expect(userWithoutPic.profilePicturePath, isNull);
    });

    test('should handle JSON serialization', () {
      final json = testUser.toJson();
      expect(json['id'], equals('test_id'));
      expect(json['firstName'], equals('John'));
      expect(json['lastName'], equals('Doe'));
      expect(json['email'], equals('john.doe@example.com'));
    });

    test('should handle JSON deserialization', () {
      final json = {
        '_id': 'test_id',
        'firstName': 'John',
        'lastName': 'Doe',
        'email': 'john.doe@example.com',
        'role': 'user',
        'status': 'active',
        'createdAt': testDate.toIso8601String(),
        'updatedAt': testDate.toIso8601String(),
        'profilePicture': 'http://example.com/profile.jpg',
      };
      
      final user = ApiUser.fromJson(json);
      expect(user.id, equals('test_id'));
      expect(user.firstName, equals('John'));
      expect(user.lastName, equals('Doe'));
      expect(user.email, equals('john.doe@example.com'));
    });
  });
}
