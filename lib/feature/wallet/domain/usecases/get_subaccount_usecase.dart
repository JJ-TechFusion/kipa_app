import '../../../../core/services/network/network_response.dart';
import '../repositories/wallet_repository.dart';

class GetSubaccountUseCase {
  final WalletRepository repository;

  GetSubaccountUseCase(this.repository);

  Future<NetworkResponse> call() async {
    return await repository.getSubaccount();
  }
}
