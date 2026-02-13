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

  @override
  Future<NetworkResponse> getTransactions() async {
    return await remoteDataSource.getTransactions();
  }

  @override
  Future<NetworkResponse> getPendingFunds() async {
    return await remoteDataSource.getPendingFunds();
  }

  @override
  Future<NetworkResponse> getPinStatus() async {
    return await remoteDataSource.getPinStatus();
  }

  @override
  Future<NetworkResponse> createPin(String pin) async {
    return await remoteDataSource.createPin(pin);
  }

  @override
  Future<NetworkResponse> verifyPin(String pin) async {
    return await remoteDataSource.verifyPin(pin);
  }

  @override
  Future<NetworkResponse> changePin(String oldPin, String newPin) async {
    return await remoteDataSource.changePin(oldPin, newPin);
  }
}
