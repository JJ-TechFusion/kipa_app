import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../../core/services/storage/secure_storage.dart';
import '../../domain/entities/entities.dart';
import '../../domain/usecases/usecases.dart';
import '../../data/datasources/datasources.dart';
import '../../data/repositories/repositories.dart';
import '../../../../utils/no_params.dart';

final splashLocalDataSourceProvider = Provider<SplashLocalDataSource>((ref) {
  return SplashLocalDataSourceImpl(
    SecureStorageService(const FlutterSecureStorage()),
  );
});

final splashRepositoryProvider = Provider((ref) {
  final localDataSource = ref.watch(splashLocalDataSourceProvider);
  return SplashRepositoryImpl(localDataSource);
});

final checkAppStateUseCaseProvider = Provider((ref) {
  final repository = ref.watch(splashRepositoryProvider);
  return CheckAppStateUseCase(repository);
});

final checkFirstTimeUseCaseProvider = Provider((ref) {
  final repository = ref.watch(splashRepositoryProvider);
  return CheckFirstTimeUseCase(repository);
});

final checkAuthenticationUseCaseProvider = Provider((ref) {
  final repository = ref.watch(splashRepositoryProvider);
  return CheckAuthenticationUseCase(repository);
});

final appStateProvider = FutureProvider<AppStateEntity>((ref) async {
  final checkAppStateUseCase = ref.watch(checkAppStateUseCaseProvider);
  return await checkAppStateUseCase(NoParams());
});
