import '../../../../utils/no_params.dart';
import '../repositories/repositories.dart';

class CheckOnboardingStatusUseCase {
  final OnboardingRepository repository;

  CheckOnboardingStatusUseCase(this.repository);

  Future<bool> call(NoParams params) async {
    return await repository.hasCompletedOnboarding();
  }
}
