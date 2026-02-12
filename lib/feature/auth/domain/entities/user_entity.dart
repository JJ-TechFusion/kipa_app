class UserEntity {
  const UserEntity({
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

  String get fullName => '$firstName $lastName';
  bool get isProfileComplete =>
      firstName.isNotEmpty && lastName.isNotEmpty && phoneNumber.isNotEmpty;
}
