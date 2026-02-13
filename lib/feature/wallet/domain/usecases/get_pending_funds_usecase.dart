import '../../../../core/services/network/network_response.dart';
import '../repositories/wallet_repository.dart';

class GetPendingFundsUseCase {
  final WalletRepository repository;

  GetPendingFundsUseCase(this.repository);

  Future<NetworkResponse> call() async {
    return await repository.getPendingFunds();
  }
}
