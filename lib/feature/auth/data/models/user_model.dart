import 'dart:convert';
import '../../domain/entities/user_entity.dart';

class UserModel {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final bool active;
  final String phoneNumber;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String profile;

  const UserModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.active,
    required this.phoneNumber,
    required this.createdAt,
    required this.updatedAt,
    required this.profile,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      email: json['email'] ?? '',
      active: json['active'] ?? false,
      phoneNumber: json['phoneNumber'] ?? '',
      createdAt:
          json['createdAt'] != null
              ? DateTime.parse(json['createdAt'])
              : DateTime.now(),
      updatedAt:
          json['updatedAt'] != null
              ? DateTime.parse(json['updatedAt'])
              : DateTime.now(),
      profile: json['profile'] != null ? jsonEncode(json['profile']) : '',
    );
  }

  // Convert from Entity to Model
  factory UserModel.fromEntity(UserEntity entity) {
    return UserModel(
      id: entity.id,
      firstName: entity.firstName,
      lastName: entity.lastName,
      email: entity.email,
      active: entity.active,
      phoneNumber: entity.phoneNumber,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      profile: entity.profile,
    );
  }

  // Convert from Model to Entity
  UserEntity toEntity() {
    return UserEntity(
      id: id,
      firstName: firstName,
      lastName: lastName,
      email: email,
      active: active,
      phoneNumber: phoneNumber,
      createdAt: createdAt,
      updatedAt: updatedAt,
      profile: profile,
    );
  }

  // Convert from Model to JSON
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'active': active,
      'phoneNumber': phoneNumber,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'profile': profile,
    };
  }
}
