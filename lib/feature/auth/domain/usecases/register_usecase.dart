// import '../entities/entities.dart';

// import '../repositories/auth_repository.dart';

// class RegisterUsecase {
//   RegisterUsecase(this._repository);

//   final AuthRepository _repository;

//   Future<UserEntity> call(RegisterParams params) async {
//     if (params.password != params.passwordConfirm) {
//       throw Exception('Passwords do not match');
//     }

//     if (params.password.length < 8) {
//       throw Exception('Password must be at least 8 characters long');
//     }

//     if (params.email.isEmpty ||
//         params.password.isEmpty ||
//         params.passwordConfirm.isEmpty) {
//       throw Exception('Email, password and password confirm are required');
//     }

//     if (params.firstName.isEmpty || params.lastName.isEmpty) {
//       throw Exception('First name and last name are required');
//     }

//     if (params.profile.selectedHabits.isEmpty) {
//       throw Exception('Please select at least one habit to track');
//     }

//     final selectedHabits = params.profile.selectedHabits;
//     final assessmentEntries = params.profile.assessmentEntries;

//     for (final habit in selectedHabits) {
//       final hasAssessment = assessmentEntries.any(
//         (entry) => entry.category == habit,
//       );
//       if (!hasAssessment) {
//         throw Exception('Please complete the assessment for $habit');
//       }
//     }

//     for (final entry in assessmentEntries) {
//       if (entry.primaryApps.isEmpty) {
//         throw Exception(
//           'Please select at least one app/website for ${entry.category}',
//         );
//       }

//       if (entry.timeSpent.isEmpty) {
//         throw Exception('Please specify time spent for ${entry.category}');
//       }
//     }

//     return await _repository.register(params);
//   }
// }

// class RegisterParams {
//   RegisterParams({
//     required this.email,
//     required this.password,
//     required this.passwordConfirm,
//     required this.firstName,
//     required this.lastName,
//     this.phoneNumber,
//     required this.profile,
//   });

//   final String email;
//   final String password;
//   final String passwordConfirm;
//   final String firstName;
//   final String lastName;
//   final String? phoneNumber;
//   final ProfileModel profile;
// }
