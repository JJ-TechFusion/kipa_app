import '../../../../core/services/network/network_response.dart';
import '../repositories/purchases_repository.dart';

class GetPurchaseByIdUseCase {
  final PurchasesRepository repository;

  GetPurchaseByIdUseCase(this.repository);

  Future<NetworkResponse> call(String purchaseId) async {
    return await repository.getPurchaseById(purchaseId);
  }
}
