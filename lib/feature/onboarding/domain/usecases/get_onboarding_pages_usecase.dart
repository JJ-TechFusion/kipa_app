import '../../../../utils/no_params.dart';
import '../entities/entities.dart';
import '../repositories/repositories.dart';

class GetOnboardingPagesUseCase {
  final OnboardingRepository repository;

  GetOnboardingPagesUseCase(this.repository);

  Future<List<OnboardingPageEntity>> call(NoParams params) async {
    return await repository.getOnboardingPages();
  }
}
