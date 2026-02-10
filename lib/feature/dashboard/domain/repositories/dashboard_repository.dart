import '../../../../core/services/network/network_response.dart';

abstract class DashboardRepository {
  Future<NetworkResponse> getActiveDeliveries();
}
