import '../../../../utils/no_params.dart';
import '../entities/entities.dart';
import '../repositories/repositories.dart';

class CheckAppStateUseCase {
  final SplashRepository repository;

  CheckAppStateUseCase(this.repository);

  Future<AppStateEntity> call(NoParams params) async {
    return await repository.checkAppState();
  }
}
