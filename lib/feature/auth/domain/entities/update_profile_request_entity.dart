class UpdateProfileRequest {
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? profilePhotoUrl;

  UpdateProfileRequest({
    this.firstName,
    this.lastName,
    this.email,
    this.profilePhotoUrl,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {};
    if (firstName != null) json['first_name'] = firstName;
    if (lastName != null) json['last_name'] = lastName;
    if (email != null) json['email'] = email;
    if (profilePhotoUrl != null) json['profile_photo_url'] = profilePhotoUrl;
    return json;
  }
}
