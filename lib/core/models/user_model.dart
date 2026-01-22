import 'package:hive/hive.dart';

part 'user_model.g.dart';

@HiveType(typeId: 0)
class User extends HiveObject {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  String name;
  
  @HiveField(2)
  final String email;
  
  @HiveField(3)
  String password;
  
  @HiveField(4)
  final DateTime createdAt;
  
  @HiveField(5)
  String? profilePicturePath;
  
  @HiveField(6)
  List<String> additionalProfilePictures = [];

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.createdAt,
    this.profilePicturePath,
    this.additionalProfilePictures = const [],
  });

  factory User.create({
    required String name,
    required String email,
    required String password,
  }) {
    return User(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      email: email,
      password: password,
      createdAt: DateTime.now(),
    );
  }
}
