import '../../../../core/services/network/network_response.dart';
import '../repositories/purchases_repository.dart';

class RebookDeliveryUseCase {
  final PurchasesRepository repository;

  RebookDeliveryUseCase(this.repository);

  Future<NetworkResponse> call(String purchaseId) async {
    return await repository.rebookDelivery(purchaseId);
  }
}
