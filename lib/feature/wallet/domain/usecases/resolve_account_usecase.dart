import '../../../../core/services/network/network_response.dart';
import '../repositories/wallet_repository.dart';

class ResolveAccountUseCase {
  final WalletRepository repository;

  ResolveAccountUseCase(this.repository);

  Future<NetworkResponse> call(String accountNumber, String bankCode) async {
    return await repository.resolveAccount(accountNumber, bankCode);
  }
}
