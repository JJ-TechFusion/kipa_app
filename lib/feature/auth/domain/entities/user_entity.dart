class UserEntity {
  const UserEntity({
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

  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final bool active;
  final String phoneNumber;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String profile;

  String get fullName => '$firstName $lastName';
  bool get isProfileComplete =>
      firstName.isNotEmpty && lastName.isNotEmpty && phoneNumber.isNotEmpty;
}
