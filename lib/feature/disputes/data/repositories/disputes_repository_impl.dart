import '../../../../core/services/network/network_response.dart';
import '../../domain/repositories/disputes_repository.dart';
import '../datasources/disputes_remote_datasource.dart';

class DisputesRepositoryImpl implements DisputesRepository {
  final DisputesRemoteDataSource remoteDataSource;

  DisputesRepositoryImpl(this.remoteDataSource);

  @override
  Future<NetworkResponse> getDisputes() async {
    return await remoteDataSource.getDisputes();
  }

  @override
  Future<NetworkResponse> getDisputeById(String id) async {
    return await remoteDataSource.getDisputeById(id);
  }
}
