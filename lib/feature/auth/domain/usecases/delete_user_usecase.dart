import '../../../../core/services/network/network_response.dart';
import '../repositories/auth_repository.dart';

class DeleteUserUseCase {
  final AuthRepository repository;

  DeleteUserUseCase(this.repository);

  Future<NetworkResponse> call() async {
    return await repository.deleteUser();
  }
}
