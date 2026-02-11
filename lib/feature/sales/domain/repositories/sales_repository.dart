import '../../../../core/services/network/network_response.dart';

abstract class SalesRepository {
  Future<NetworkResponse> getSales();
  Future<NetworkResponse> getSaleById(String orderId);
  Future<NetworkResponse> confirmReturn({
    required String orderId,
    required String condition,
    String? notes,
    String? damageReason,
    List<String> damageEvidenceUrls = const [],
  });
  Future<NetworkResponse> uploadDamageEvidence({
    required String fileName,
    required List<int> fileBytes,
  });
}
