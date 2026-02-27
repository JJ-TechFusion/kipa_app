import '../../../../core/services/network/network_response.dart';
import '../repositories/wallet_repository.dart';

class SetDefaultBankAccountUseCase {
  final WalletRepository repository;

  SetDefaultBankAccountUseCase(this.repository);

  Future<NetworkResponse> call(String id) async {
    return await repository.setDefaultBankAccount(id);
  }
}
