import '../../../../core/services/network/network_response.dart';
import '../repositories/dashboard_repository.dart';

class GetActiveDeliveriesUseCase {
  final DashboardRepository repository;

  GetActiveDeliveriesUseCase(this.repository);

  Future<NetworkResponse> call() async {
    return await repository.getActiveDeliveries();
  }
}
