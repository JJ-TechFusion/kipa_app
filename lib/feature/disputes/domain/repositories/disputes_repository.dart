import '../../../../core/services/network/network_response.dart';

abstract class DisputesRepository {
  Future<NetworkResponse> getDisputes();
  Future<NetworkResponse> getDisputeById(String id);
}
