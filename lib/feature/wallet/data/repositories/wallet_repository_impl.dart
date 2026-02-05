import '../../../../core/services/network/network_response.dart';
import '../../domain/repositories/wallet_repository.dart';
import '../datasources/wallet_remote_datasource.dart';

class WalletRepositoryImpl implements WalletRepository {
  final WalletRemoteDataSource remoteDataSource;

  WalletRepositoryImpl(this.remoteDataSource);

  @override
  Future<NetworkResponse> getWallet() async {
    return await remoteDataSource.getWallet();
  }

  @override
  Future<NetworkResponse> topUpWallet(double amount) async {
    return await remoteDataSource.topUpWallet(amount);
  }

  @override
  Future<NetworkResponse> verifyTopUp(String reference) async {
    return await remoteDataSource.verifyTopUp(reference);
  }
}
