import '../../domain/entities/entities.dart';
import '../../domain/repositories/repositories.dart';
import '../datasources/datasources.dart';

class SplashRepositoryImpl implements SplashRepository {
  final SplashLocalDataSource localDataSource;

  SplashRepositoryImpl(this.localDataSource);

  @override
  Future<AppStateEntity> checkAppState() async {
    final isFirstTime = await localDataSource.isFirstTime();
    final isAuthenticated = await localDataSource.isAuthenticated();
    final isProfileCompleted = await localDataSource.isProfileCompleted();

    return AppStateEntity(
      isFirstTime: isFirstTime,
      isAuthenticated: isAuthenticated,
      needsProfileCompletion: isAuthenticated && !isProfileCompleted,
    );
  }

  @override
  Future<bool> isFirstTime() async {
    return await localDataSource.isFirstTime();
  }

  @override
  Future<bool> isAuthenticated() async {
    return await localDataSource.isAuthenticated();
  }
}
