import '../../../../utils/no_params.dart';
import '../repositories/repositories.dart';

class CheckFirstTimeUseCase {
  final SplashRepository repository;

  CheckFirstTimeUseCase(this.repository);

  Future<bool> call(NoParams params) async {
    return await repository.isFirstTime();
  }
}
