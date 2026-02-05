import '../entities/entities.dart';

abstract class OnboardingRepository {
  Future<List<OnboardingPageEntity>> getOnboardingPages();
  Future<void> completeOnboarding();
  Future<bool> hasCompletedOnboarding();
}
