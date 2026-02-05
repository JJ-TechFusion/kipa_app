import '../../../../utils/no_params.dart';
import '../repositories/repositories.dart';

class CompleteOnboardingUseCase {
  final OnboardingRepository repository;

  CompleteOnboardingUseCase(this.repository);

  Future<void> call(NoParams params) async {
    return await repository.completeOnboarding();
  }
}
