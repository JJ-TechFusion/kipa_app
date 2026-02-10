import '../../../../core/services/network/network_response.dart';
import '../repositories/purchases_repository.dart';

class ConfirmDeliveryUseCase {
  final PurchasesRepository repository;

  ConfirmDeliveryUseCase(this.repository);

  Future<NetworkResponse> call(String purchaseId) async {
    return await repository.confirmDelivery(purchaseId);
  }
}
