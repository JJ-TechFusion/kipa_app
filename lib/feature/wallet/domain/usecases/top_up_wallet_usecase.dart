import '../../../../core/services/network/network_response.dart';
import '../repositories/wallet_repository.dart';

class TopUpWalletUseCase {
  final WalletRepository repository;

  TopUpWalletUseCase(this.repository);

  Future<NetworkResponse> call(double amount) async {
    return await repository.topUpWallet(amount);
  }
}
