import '../../../../core/services/storage/secure_storage.dart';

abstract class SplashLocalDataSource {
  Future<bool> isFirstTime();
  Future<bool> isAuthenticated();
  Future<bool> isProfileCompleted();
}

class SplashLocalDataSourceImpl implements SplashLocalDataSource {
  final SecureStorageService secureStorage;

  SplashLocalDataSourceImpl(this.secureStorage);

  @override
  Future<bool> isFirstTime() async {
    final hasSeenOnboarding = await secureStorage.readData(
      'has_seen_onboarding',
    );
    return hasSeenOnboarding == null || hasSeenOnboarding.isEmpty;
  }

  @override
  Future<bool> isAuthenticated() async {
    final token = await secureStorage.readData('access_token');
    return token != null && token.isNotEmpty;
  }

  @override
  Future<bool> isProfileCompleted() async {
    final completed = await secureStorage.readData('profile_completed');
    return completed == 'true';
  }
}
