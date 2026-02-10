import '../../../../core/services/network/network_response.dart';

abstract class SalesRepository {
  Future<NetworkResponse> getSales();
  Future<NetworkResponse> getSaleById(String orderId);
}
