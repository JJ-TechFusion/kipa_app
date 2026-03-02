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

  @override
  Future<NetworkResponse> requestPinReset() async {
    return await remoteDataSource.requestPinReset();
  }

  @override
  Future<NetworkResponse> confirmPinReset(String otpCode, String newPin) async {
    return await remoteDataSource.confirmPinReset(otpCode, newPin);
  }

  @override
  Future<NetworkResponse> getBanks() async {
    return await remoteDataSource.getBanks();
  }

  @override
  Future<NetworkResponse> getBankAccounts() async {
    return await remoteDataSource.getBankAccounts();
  }

  @override
  Future<NetworkResponse> resolveAccount(
    String accountNumber,
    String bankCode,
  ) async {
    return await remoteDataSource.resolveAccount(accountNumber, bankCode);
  }

  @override
  Future<NetworkResponse> addBankAccount(
    String bankCode,
    String accountNumber,
  ) async {
    return await remoteDataSource.addBankAccount(bankCode, accountNumber);
  }

  @override
  Future<NetworkResponse> setDefaultBankAccount(String id) async {
    return await remoteDataSource.setDefaultBankAccount(id);
  }

  @override
  Future<NetworkResponse> deleteBankAccount(String id) async {
    return await remoteDataSource.deleteBankAccount(id);
  }

  @override
  Future<NetworkResponse> withdraw(String bankAccountId, double amount) async {
    return await remoteDataSource.withdraw(bankAccountId, amount);
  }

  @override
  Future<NetworkResponse> syncWallet() async {
    return await remoteDataSource.syncWallet();
  }

  @override
  Future<NetworkResponse> getVirtualAccountStatus() async {
    return await remoteDataSource.getVirtualAccountStatus();
  }

  @override
  Future<NetworkResponse> createVirtualAccount(String bvn) async {
    return await remoteDataSource.createVirtualAccount(bvn);
  }

  @override
  Future<NetworkResponse> getVirtualAccount() async {
    return await remoteDataSource.getVirtualAccount();
  }

  @override
  Future<NetworkResponse> declineVirtualAccount() async {
    return await remoteDataSource.declineVirtualAccount();
  }
}
