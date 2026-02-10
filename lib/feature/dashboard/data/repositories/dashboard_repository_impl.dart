import '../../../../core/services/network/network_response.dart';
import '../../domain/repositories/dashboard_repository.dart';
import '../datasources/dashboard_remote_datasource.dart';

class DashboardRepositoryImpl implements DashboardRepository {
  final DashboardRemoteDataSource remoteDataSource;

  DashboardRepositoryImpl(this.remoteDataSource);

  @override
  Future<NetworkResponse> getActiveDeliveries() async {
    return await remoteDataSource.getActiveDeliveries();
  }
}
