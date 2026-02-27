import '../../../../core/services/network/network_response.dart';
import '../repositories/wallet_repository.dart';

class CreateSubaccountUseCase {
  final WalletRepository repository;

  CreateSubaccountUseCase(this.repository);

  Future<NetworkResponse> call(String email) async {
    return await repository.createSubaccount(email);
  }
}
