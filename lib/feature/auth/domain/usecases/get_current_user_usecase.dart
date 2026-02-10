import '../../../../core/services/network/network_response.dart';
import '../repositories/auth_repository.dart';

class GetCurrentUserUseCase {
  final AuthRepository repository;

  GetCurrentUserUseCase(this.repository);

  Future<NetworkResponse> call() async {
    return await repository.getCurrentUser();
  }
}
