import '../../../../core/services/network/network_response.dart';
import '../repositories/purchases_repository.dart';

class OpenDisputeUseCase {
  final PurchasesRepository repository;

  OpenDisputeUseCase(this.repository);

  Future<NetworkResponse> call({
    required String purchaseId,
    required String reason,
    required List<String> evidence,
  }) async {
    return await repository.openDispute(
      purchaseId: purchaseId,
      reason: reason,
      evidence: evidence,
    );
  }
}
