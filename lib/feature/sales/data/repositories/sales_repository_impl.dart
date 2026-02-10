import '../../../../core/services/network/network_response.dart';
import '../../domain/repositories/sales_repository.dart';
import '../datasources/sales_remote_datasource.dart';

class SalesRepositoryImpl implements SalesRepository {
  final SalesRemoteDataSource remoteDataSource;

  SalesRepositoryImpl(this.remoteDataSource);

  @override
  Future<NetworkResponse> getSales() async {
    return await remoteDataSource.getSales();
  }

  @override
  Future<NetworkResponse> getSaleById(String orderId) async {
    return await remoteDataSource.getSaleById(orderId);
  }
}
