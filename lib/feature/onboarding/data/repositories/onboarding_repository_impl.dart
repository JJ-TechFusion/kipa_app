import '../../domain/entities/entities.dart';
import '../../domain/repositories/repositories.dart';
import '../datasources/datasources.dart';

class OnboardingRepositoryImpl implements OnboardingRepository {
  final OnboardingLocalDataSource localDataSource;

  OnboardingRepositoryImpl(this.localDataSource);

  @override
  Future<List<OnboardingPageEntity>> getOnboardingPages() async {
    final pages = await localDataSource.getOnboardingPages();
    return pages.map((model) => model.toEntity()).toList();
  }

  @override
  Future<void> completeOnboarding() async {
    await localDataSource.completeOnboarding();
  }

  @override
  Future<bool> hasCompletedOnboarding() async {
    return await localDataSource.hasCompletedOnboarding();
  }
}
