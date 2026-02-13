import '../../../../core/services/network/network_response.dart';
import '../repositories/wallet_repository.dart';

class CreatePinUseCase {
  final WalletRepository repository;

  CreatePinUseCase(this.repository);

  Future<NetworkResponse> call(String pin) async {
    return await repository.createPin(pin);
  }
}
