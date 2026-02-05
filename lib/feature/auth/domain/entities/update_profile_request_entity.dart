class UpdateProfileRequest {
  final String firstName;
  final String lastName;
  final String email;
  final String? profilePhotoUrl;

  UpdateProfileRequest({
    required this.firstName,
    required this.lastName,
    required this.email,
    this.profilePhotoUrl,
  });

  Map<String, dynamic> toJson() => {
    'first_name': firstName,
    'last_name': lastName,
    'email': email,
    if (profilePhotoUrl != null) 'profile_photo_url': profilePhotoUrl,
  };
}
