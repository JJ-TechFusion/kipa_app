import '../../../../core/services/network/network_response.dart';
import '../repositories/wallet_repository.dart';

class CreateVirtualAccountUseCase {
  final WalletRepository repository;

  CreateVirtualAccountUseCase(this.repository);

  Future<NetworkResponse> call(String bvn) async {
    return await repository.createVirtualAccount(bvn);
  }
}
