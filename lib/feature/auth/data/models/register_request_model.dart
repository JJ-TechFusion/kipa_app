class AssessmentEntryModel {
  final String category;
  final List<String> primaryApps;
  final String timeSpent;
  final String dependencyLevel;

  AssessmentEntryModel({
    required this.category,
    required this.primaryApps,
    required this.timeSpent,
    required this.dependencyLevel,
  });

  Map<String, dynamic> toJson() {
    return {
      'category': category,
      'primaryApps': primaryApps,
      'timeSpent': timeSpent,
      'dependencyLevel': dependencyLevel,
    };
  }
}

class ProfileModel {
  final List<String> selectedHabits;
  final List<AssessmentEntryModel> assessmentEntries;

  ProfileModel({required this.selectedHabits, required this.assessmentEntries});

  Map<String, dynamic> toJson() {
    return {
      'selectedHabits': selectedHabits,
      'assessmentEntries':
          assessmentEntries.map((entry) => entry.toJson()).toList(),
    };
  }
}

class RegisterRequestModel {
  final String firstName;
  final String lastName;
  final String email;
  final String password;
  final String passwordConfirm;
  final String? phoneNumber;
  final ProfileModel profile;

  RegisterRequestModel({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
    required this.passwordConfirm,
    this.phoneNumber,
    required this.profile,
  });

  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'password': password,
      'passwordConfirm': passwordConfirm,
      if (phoneNumber != null) 'phoneNumber': phoneNumber,
      'profile': profile.toJson(),
    };
  }
}
