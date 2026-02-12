import '../../domain/entities/user_entity.dart';

class UserModel {
  final String id;
  final String phoneNumber;
  final bool phoneVerified;
  final String email;
  final String firstName;
  final String lastName;
  final bool isSeller;
  final bool isBuyer;
  final bool isRider;
  final bool sellerVerified;
  final DateTime createdAt;
  final String? profileImageUrl;

  const UserModel({
    required this.id,
    required this.phoneNumber,
    required this.phoneVerified,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.isSeller,
    required this.isBuyer,
    required this.isRider,
    required this.sellerVerified,
    required this.createdAt,
    this.profileImageUrl,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      phoneNumber: json['phone_number'] ?? '',
      phoneVerified: json['phone_verified'] ?? false,
      email: json['email'] ?? '',
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      isSeller: json['is_seller'] ?? false,
      isBuyer: json['is_buyer'] ?? false,
      isRider: json['is_rider'] ?? false,
      sellerVerified: json['seller_verified'] ?? false,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
      profileImageUrl: json['profile_photo_url'],
    );
  }

  // Convert from Entity to Model
  factory UserModel.fromEntity(UserEntity entity) {
    return UserModel(
      id: entity.id,
      phoneNumber: entity.phoneNumber,
      phoneVerified: entity.phoneVerified,
      email: entity.email,
      firstName: entity.firstName,
      lastName: entity.lastName,
      isSeller: entity.isSeller,
      isBuyer: entity.isBuyer,
      isRider: entity.isRider,
      sellerVerified: entity.sellerVerified,
      createdAt: entity.createdAt,
      profileImageUrl: entity.profileImageUrl,
    );
  }

  // Convert from Model to Entity
  UserEntity toEntity() {
    return UserEntity(
      id: id,
      phoneNumber: phoneNumber,
      phoneVerified: phoneVerified,
      email: email,
      firstName: firstName,
      lastName: lastName,
      isSeller: isSeller,
      isBuyer: isBuyer,
      isRider: isRider,
      sellerVerified: sellerVerified,
      createdAt: createdAt,
      profileImageUrl: profileImageUrl,
    );
  }

  // Convert from Model to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'phone_number': phoneNumber,
      'phone_verified': phoneVerified,
      'email': email,
      'first_name': firstName,
      'last_name': lastName,
      'is_seller': isSeller,
      'is_buyer': isBuyer,
      'is_rider': isRider,
      'seller_verified': sellerVerified,
      'created_at': createdAt.toIso8601String(),
      if (profileImageUrl != null) 'profile_photo_url': profileImageUrl,
    };
  }
}
