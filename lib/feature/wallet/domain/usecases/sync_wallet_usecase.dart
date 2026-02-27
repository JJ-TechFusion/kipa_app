import '../../../../core/services/network/network_response.dart';
import '../repositories/wallet_repository.dart';

class SyncWalletUseCase {
  final WalletRepository repository;

  SyncWalletUseCase(this.repository);

  Future<NetworkResponse> call() async {
    return await repository.syncWallet();
  }
}
