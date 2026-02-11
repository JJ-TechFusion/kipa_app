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

  @override
  Future<NetworkResponse> confirmReturn({
    required String orderId,
    required String condition,
    String? notes,
    String? damageReason,
    List<String> damageEvidenceUrls = const [],
  }) async {
    return await remoteDataSource.confirmReturn(
      orderId: orderId,
      condition: condition,
      notes: notes,
      damageReason: damageReason,
      damageEvidenceUrls: damageEvidenceUrls,
    );
  }

  @override
  Future<NetworkResponse> uploadDamageEvidence({
    required String fileName,
    required List<int> fileBytes,
  }) async {
    return await remoteDataSource.uploadDamageEvidence(
      fileName: fileName,
      fileBytes: fileBytes,
    );
  }
}
