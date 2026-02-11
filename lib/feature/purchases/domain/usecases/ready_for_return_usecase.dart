import '../../../../core/services/network/network_response.dart';
import '../repositories/purchases_repository.dart';

class ReadyForReturnUseCase {
  final PurchasesRepository repository;

  ReadyForReturnUseCase(this.repository);

  Future<NetworkResponse> call(String purchaseId) async {
    return await repository.readyForReturn(purchaseId);
  }
}
