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

  @override
  Future<NetworkResponse> readyForReturn(String purchaseId) async {
    return await remoteDataSource.readyForReturn(purchaseId);
  }

  @override
  Future<NetworkResponse> rebookDelivery(String purchaseId) async {
    return await remoteDataSource.rebookDelivery(purchaseId);
  }

  @override
  Future<NetworkResponse> uploadDisputeEvidence({
    required String fileName,
    required List<int> fileBytes,
  }) async {
    return await remoteDataSource.uploadDisputeEvidence(
      fileName: fileName,
      fileBytes: fileBytes,
    );
  }

  @override
  Future<NetworkResponse> openDispute({
    required String purchaseId,
    required String reason,
    required List<String> evidence,
  }) async {
    return await remoteDataSource.openDispute(
      purchaseId: purchaseId,
      reason: reason,
      evidence: evidence,
    );
  }
}
