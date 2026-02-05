import '../entities/entities.dart';

abstract class SplashRepository {
  Future<AppStateEntity> checkAppState();
  Future<bool> isFirstTime();
  Future<bool> isAuthenticated();
}
