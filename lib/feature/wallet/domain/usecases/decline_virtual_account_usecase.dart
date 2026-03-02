import '../../../../core/services/network/network_response.dart';
import '../repositories/wallet_repository.dart';

class DeclineVirtualAccountUseCase {
  final WalletRepository repository;

  DeclineVirtualAccountUseCase(this.repository);

  Future<NetworkResponse> call() async {
    return await repository.declineVirtualAccount();
  }
}
