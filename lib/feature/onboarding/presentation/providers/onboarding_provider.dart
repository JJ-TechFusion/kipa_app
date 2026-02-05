import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../../core/services/storage/secure_storage.dart';
import '../../domain/entities/entities.dart';
import '../../domain/usecases/usecases.dart';
import '../../data/datasources/datasources.dart';
import '../../data/repositories/repositories.dart';
import '../../../../utils/no_params.dart';

final onboardingLocalDataSourceProvider = Provider<OnboardingLocalDataSource>((
  ref,
) {
  return OnboardingLocalDataSourceImpl(
    SecureStorageService(const FlutterSecureStorage()),
  );
});

final onboardingRepositoryProvider = Provider((ref) {
  final localDataSource = ref.watch(onboardingLocalDataSourceProvider);
  return OnboardingRepositoryImpl(localDataSource);
});

final getOnboardingPagesUseCaseProvider = Provider((ref) {
  final repository = ref.watch(onboardingRepositoryProvider);
  return GetOnboardingPagesUseCase(repository);
});

final completeOnboardingUseCaseProvider = Provider((ref) {
  final repository = ref.watch(onboardingRepositoryProvider);
  return CompleteOnboardingUseCase(repository);
});

final checkOnboardingStatusUseCaseProvider = Provider((ref) {
  final repository = ref.watch(onboardingRepositoryProvider);
  return CheckOnboardingStatusUseCase(repository);
});

final onboardingPagesProvider = FutureProvider<List<OnboardingPageEntity>>((
  ref,
) async {
  final getOnboardingPagesUseCase = ref.watch(
    getOnboardingPagesUseCaseProvider,
  );
  return await getOnboardingPagesUseCase(NoParams());
});

class CurrentPageIndexNotifier extends Notifier<int> {
  @override
  int build() => 0;

  void setIndex(int index) {
    state = index;
  }

  void increment() {
    state++;
  }

  void reset() {
    state = 0;
  }
}

final currentPageIndexProvider =
    NotifierProvider<CurrentPageIndexNotifier, int>(
      CurrentPageIndexNotifier.new,
    );

final completeOnboardingProvider = FutureProvider.autoDispose
    .family<void, void>((ref, _) async {
      final completeOnboardingUseCase = ref.watch(
        completeOnboardingUseCaseProvider,
      );
      await completeOnboardingUseCase(NoParams());
    });
