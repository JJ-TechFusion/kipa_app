import '../../../../core/services/network/network_response.dart';
import '../repositories/wallet_repository.dart';

class RequestPinResetUseCase {
  final WalletRepository repository;

  RequestPinResetUseCase(this.repository);

  Future<NetworkResponse> call() async {
    return await repository.requestPinReset();
  }
}
