import '../../../../core/services/network/network_response.dart';

abstract class WalletRepository {
  Future<NetworkResponse> getWallet();
  Future<NetworkResponse> topUpWallet(double amount);
  Future<NetworkResponse> verifyTopUp(String reference);
  Future<NetworkResponse> getTransactions();
  Future<NetworkResponse> getPendingFunds();

  // PIN operations
  Future<NetworkResponse> getPinStatus();
  Future<NetworkResponse> createPin(String pin);
  Future<NetworkResponse> verifyPin(String pin);
  Future<NetworkResponse> changePin(String oldPin, String newPin);
}
