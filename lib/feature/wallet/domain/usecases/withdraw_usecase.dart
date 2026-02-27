import '../../../../core/services/network/network_response.dart';
import '../repositories/wallet_repository.dart';

class WithdrawUseCase {
  final WalletRepository repository;

  WithdrawUseCase(this.repository);

  Future<NetworkResponse> call(String bankAccountId, double amount) async {
    return await repository.withdraw(bankAccountId, amount);
  }
}
