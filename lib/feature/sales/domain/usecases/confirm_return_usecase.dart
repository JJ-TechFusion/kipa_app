import '../../../../core/services/network/network_response.dart';
import '../repositories/sales_repository.dart';

class ConfirmReturnUseCase {
  final SalesRepository repository;

  ConfirmReturnUseCase(this.repository);

  Future<NetworkResponse> call({
    required String orderId,
    required String condition,
    String? notes,
    String? damageReason,
    List<String> damageEvidenceUrls = const [],
  }) async {
    return await repository.confirmReturn(
      orderId: orderId,
      condition: condition,
      notes: notes,
      damageReason: damageReason,
      damageEvidenceUrls: damageEvidenceUrls,
    );
  }
}
