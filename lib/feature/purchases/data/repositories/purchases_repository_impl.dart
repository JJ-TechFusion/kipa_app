import '../../../../core/services/network/network_response.dart';
import '../../domain/repositories/purchases_repository.dart';
import '../datasources/purchases_remote_datasource.dart';

class PurchasesRepositoryImpl implements PurchasesRepository {
  final PurchasesRemoteDataSource remoteDataSource;

  PurchasesRepositoryImpl(this.remoteDataSource);

  @override
  Future<NetworkResponse> getPurchases() async {
    return await remoteDataSource.getPurchases();
  }

  @override
  Future<NetworkResponse> getPurchaseById(String purchaseId) async {
    return await remoteDataSource.getPurchaseById(purchaseId);
  }

  @override
  Future<NetworkResponse> confirmDelivery(String purchaseId) async {
    return await remoteDataSource.confirmDelivery(purchaseId);
  }
}
