import '../../../../core/services/network/network_response.dart';
import '../repositories/auth_repository.dart';

class LogoutUseCase {
  final AuthRepository repository;

  LogoutUseCase(this.repository);

  Future<NetworkResponse> call() async {
    return await repository.logout();
  }
}
