import '../../../../core/services/network/network_response.dart';
import '../repositories/wallet_repository.dart';

class VerifyTopUpUseCase {
  final WalletRepository repository;

  VerifyTopUpUseCase(this.repository);

  Future<NetworkResponse> call(String reference) async {
    return await repository.verifyTopUp(reference);
  }
}
