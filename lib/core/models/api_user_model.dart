import 'package:json_annotation/json_annotation.dart';

part 'api_user_model.g.dart';

@JsonSerializable()
class ApiUser {
  @JsonKey(name: '_id')
  final String id;
  
  @JsonKey(name: 'firstName')
  final String firstName;
  
  @JsonKey(name: 'lastName')
  final String lastName;
  
  @JsonKey(name: 'name')
  final String? name; // For backward compatibility with mobile backend
  
  final String email;
  
  @JsonKey(name: 'username')
  final String? username; // Mobile backend field
  
  @JsonKey(name: 'phoneNumber')
  final String? phoneNumber; // Mobile backend field
  
  @JsonKey(name: 'profilePicture')
  final String? profilePicture; // Mobile backend field
  
  @JsonKey(name: 'role')
  final String role;
  
  @JsonKey(name: 'status')
  final String status;
  
  @JsonKey(name: 'lastLogin')
  final DateTime? lastLogin;
  
  @JsonKey(name: 'createdAt')
  final DateTime createdAt;
  
  @JsonKey(name: 'updatedAt')
  final DateTime updatedAt;

  ApiUser({
    required this.id,
    required this.firstName,
    required this.lastName,
    this.name,
    required this.email,
    this.username,
    this.phoneNumber,
    this.profilePicture,
    required this.role,
    required this.status,
    this.lastLogin,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ApiUser.fromJson(Map<String, dynamic> json) => _$ApiUserFromJson(json);
  Map<String, dynamic> toJson() => _$ApiUserToJson(this);
  
  // Get full name
  String get fullName => name ?? '$firstName $lastName';
  
  // Get profile picture path
  String? get profilePicturePath => profilePicture;
}
