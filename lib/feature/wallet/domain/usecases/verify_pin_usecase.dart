import '../../../../core/services/network/network_response.dart';
import '../repositories/wallet_repository.dart';

class VerifyPinUseCase {
  final WalletRepository repository;

  VerifyPinUseCase(this.repository);

  Future<NetworkResponse> call(String pin) async {
    return await repository.verifyPin(pin);
  }
}
