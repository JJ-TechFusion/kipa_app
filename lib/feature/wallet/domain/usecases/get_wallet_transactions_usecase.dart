import '../../../../core/services/network/network_response.dart';
import '../repositories/wallet_repository.dart';

class GetWalletTransactionsUseCase {
  final WalletRepository repository;

  GetWalletTransactionsUseCase(this.repository);

  Future<NetworkResponse> call() async {
    return await repository.getTransactions();
  }
}
