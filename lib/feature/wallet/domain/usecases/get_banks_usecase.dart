import '../../../../core/services/network/network_response.dart';
import '../repositories/wallet_repository.dart';

class GetBanksUseCase {
  final WalletRepository repository;

  GetBanksUseCase(this.repository);

  Future<NetworkResponse> call() async {
    return await repository.getBanks();
  }
}
