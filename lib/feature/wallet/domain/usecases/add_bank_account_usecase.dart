import '../../../../core/services/network/network_response.dart';
import '../repositories/wallet_repository.dart';

class AddBankAccountUseCase {
  final WalletRepository repository;

  AddBankAccountUseCase(this.repository);

  Future<NetworkResponse> call(String bankCode, String accountNumber) async {
    return await repository.addBankAccount(bankCode, accountNumber);
  }
}
