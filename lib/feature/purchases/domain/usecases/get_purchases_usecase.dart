import '../../../../core/services/network/network_response.dart';
import '../repositories/purchases_repository.dart';

class GetPurchasesUseCase {
  final PurchasesRepository repository;

  GetPurchasesUseCase(this.repository);

  Future<NetworkResponse> call() async {
    return await repository.getPurchases();
  }
}
