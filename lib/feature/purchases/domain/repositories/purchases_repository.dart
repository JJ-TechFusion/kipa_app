import '../../../../core/services/network/network_response.dart';

abstract class PurchasesRepository {
  Future<NetworkResponse> getPurchases();
  Future<NetworkResponse> getPurchaseById(String purchaseId);
  Future<NetworkResponse> confirmDelivery(String purchaseId);
  Future<NetworkResponse> readyForReturn(String purchaseId);
  Future<NetworkResponse> rebookDelivery(String purchaseId);
  Future<NetworkResponse> uploadDisputeEvidence({
    required String fileName,
    required List<int> fileBytes,
  });
  Future<NetworkResponse> openDispute({
    required String purchaseId,
    required String reason,
    required List<String> evidence,
  });
}
