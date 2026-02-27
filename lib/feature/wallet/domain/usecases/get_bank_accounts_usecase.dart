import '../../../../core/services/network/network_response.dart';
import '../repositories/wallet_repository.dart';

class GetBankAccountsUseCase {
  final WalletRepository repository;

  GetBankAccountsUseCase(this.repository);

  Future<NetworkResponse> call() async {
    return await repository.getBankAccounts();
  }
}
