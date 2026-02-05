// import 'dart:convert';

// abstract class AuthLocalDataSource {
//   Future<UserModel?> getCachedUser();
//   Future<void> cacheUser(UserModel user);
//   Future<void> clearCache();
//   Future<void> saveToken(String token);
//   Future<String?> getToken();
//   Future<void> clearToken();
// }

// class AuthLocalDataSourceImpl implements AuthLocalDataSource {
//   final SecureStorageService secureStorage;

//   AuthLocalDataSourceImpl({required this.secureStorage});

//   @override
//   Future<UserModel?> getCachedUser() async {
//     try {
//       final user = await secureStorage.readData('cached_user');
//       if (user != null) {
//         return UserModel.fromJson(jsonDecode(user));
//       }
//       return null;
//     } catch (e) {
//       rethrow;
//     }
//   }

//   @override
//   Future<void> cacheUser(UserModel user) async {
//     try {
//       await secureStorage.writeData('cached_user', jsonEncode(user.toJson()));
//     } catch (e) {
//       rethrow;
//     }
//   }

//   @override
//   Future<void> saveToken(String token) async {
//     if (token.isEmpty) {
//       return;
//     }

//     try {
//       await secureStorage.writeData(AppStrings.token, token);

//       final savedToken = await secureStorage.readData(AppStrings.token);
//       if (savedToken != token) {
//         throw Exception('Token verification failed');
//       }
//     } catch (e) {
//       rethrow;
//     }
//   }

//   @override
//   Future<String?> getToken() async {
//     try {
//       final token = await secureStorage.readData(AppStrings.token);
//       return token;
//     } catch (e) {
//       return null;
//     }
//   }

//   @override
//   Future<void> clearToken() async {
//     await secureStorage.deleteData(AppStrings.token);
//   }

//   @override
//   Future<void> clearCache() async {
//     await secureStorage.deleteData('cached_user');
//   }
// }
