import 'package:kipa/core/routes/route_names.dart';
import 'package:kipa/core/services/storage/secure_storage.dart';
import 'package:kipa/main.dart';
import 'package:kipa/utils/constant.dart';

class AuthTokenService {
  final SecureStorageService _storageService;

  AuthTokenService({SecureStorageService? secureStorage})
    : _storageService = secureStorage ?? getIt<SecureStorageService>();

  Future<void> handleTokenExpiration() async {
    try {
      await _storageService.deleteData('access_token');
      await _storageService.deleteData('refresh_token');
      await _storageService.deleteData('profile_completed');
      await _storageService.deleteData('userId');
      await _storageService.deleteData('cached_user');

      await _storageService.writeData('tokenExpired', 'true');

      _navigateToLogin();
    } catch (e) {
      try {
        await _storageService.writeData('tokenExpired', 'true');
        await _storageService.deleteData('access_token');
        _navigateToLogin();
      } catch (flagError) {
        // Critical failure in token expiration handling
      }
    }
  }

  void _navigateToLogin() {
    navigatorKey.currentState?.pushNamedAndRemoveUntil(
      RouteNames.loginRoute,
      (route) => false,
    );
  }

  Future<String?> getToken() async {
    return await _storageService.readData('access_token');
  }

  Future<bool> hasValidToken() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }
}
