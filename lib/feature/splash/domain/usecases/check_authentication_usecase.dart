import '../../../../utils/no_params.dart';
import '../repositories/repositories.dart';

class CheckAuthenticationUseCase {
  final SplashRepository repository;

  CheckAuthenticationUseCase(this.repository);

  Future<bool> call(NoParams params) async {
    return await repository.isAuthenticated();
  }
}
