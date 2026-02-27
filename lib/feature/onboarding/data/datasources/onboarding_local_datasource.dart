import '../../../../core/services/storage/secure_storage.dart';
import '../../../../theme/app_colors.dart';
import '../models/models.dart';

abstract class OnboardingLocalDataSource {
  Future<List<OnboardingPageModel>> getOnboardingPages();
  Future<void> completeOnboarding();
  Future<bool> hasCompletedOnboarding();
}

class OnboardingLocalDataSourceImpl implements OnboardingLocalDataSource {
  final SecureStorageService secureStorage;

  OnboardingLocalDataSourceImpl(this.secureStorage);

  @override
  Future<List<OnboardingPageModel>> getOnboardingPages() async {
    return [
      const OnboardingPageModel(
        title: 'Run all your errands',
        description:
            'Book rides for deliveries or everyday tasks. Fast, reliable, and fully in your control.',
        imageAsset: 'assets/images/splash1.png',
        backgroundColor: AppColor.onboardingBackground1,
      ),
      const OnboardingPageModel(
        title: 'Buy and Sell without fear',
        description:
            'Send or receive payments with confidence. Funds are only released after delivery is confirmed.',
        imageAsset: 'assets/images/splash2.png',
        backgroundColor: AppColor.onboardingBackground2,
      ),
      const OnboardingPageModel(
        title: 'Your money stays protected',
        description:
            'Buyer payments are secured with Kipa Protect. Sellers get paid only when delivery is verified.',
        imageAsset: 'assets/images/splash3.png',
        backgroundColor: AppColor.onboardingBackground3,
      ),
      const OnboardingPageModel(
        title: 'Verified delivery every time',
        description:
            'Every delivery is tracked and confirmed in real-time. Pick-up and drop-off verified every handover.',
        imageAsset: 'assets/images/splash4.png',
        backgroundColor: AppColor.onboardingBackground4,
      ),
    ];
  }

  @override
  Future<void> completeOnboarding() async {
    await secureStorage.writeData('has_seen_onboarding', 'true');
  }

  @override
  Future<bool> hasCompletedOnboarding() async {
    final hasSeenOnboarding = await secureStorage.readData(
      'has_seen_onboarding',
    );
    return hasSeenOnboarding == 'true';
  }
}
