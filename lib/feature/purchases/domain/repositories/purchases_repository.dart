import '../../../../core/services/network/network_response.dart';

abstract class PurchasesRepository {
  Future<NetworkResponse> getPurchases();
  Future<NetworkResponse> getPurchaseById(String purchaseId);
  Future<NetworkResponse> confirmDelivery(String purchaseId);
}
