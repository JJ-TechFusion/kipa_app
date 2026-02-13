import '../../../../core/services/network/network_response.dart';
import '../repositories/wallet_repository.dart';

class ChangePinUseCase {
  final WalletRepository repository;

  ChangePinUseCase(this.repository);

  Future<NetworkResponse> call(String oldPin, String newPin) async {
    return await repository.changePin(oldPin, newPin);
  }
}
