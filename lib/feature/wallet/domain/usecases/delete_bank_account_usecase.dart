import '../../../../core/services/network/network_response.dart';
import '../repositories/wallet_repository.dart';

class DeleteBankAccountUseCase {
  final WalletRepository repository;

  DeleteBankAccountUseCase(this.repository);

  Future<NetworkResponse> call(String id) async {
    return await repository.deleteBankAccount(id);
  }
}
