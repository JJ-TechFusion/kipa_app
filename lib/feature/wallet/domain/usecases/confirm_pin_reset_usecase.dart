import '../../../../core/services/network/network_response.dart';
import '../repositories/wallet_repository.dart';

class ConfirmPinResetUseCase {
  final WalletRepository repository;

  ConfirmPinResetUseCase(this.repository);

  Future<NetworkResponse> call(String otpCode, String newPin) async {
    return await repository.confirmPinReset(otpCode, newPin);
  }
}
