import '../../../../core/services/network/network_response.dart';

abstract class WalletRepository {
  Future<NetworkResponse> getWallet();
  Future<NetworkResponse> topUpWallet(double amount);
  Future<NetworkResponse> verifyTopUp(String reference);
  Future<NetworkResponse> getTransactions();
  Future<NetworkResponse> getPendingFunds();
  Future<NetworkResponse> getPinStatus();
  Future<NetworkResponse> createPin(String pin);
  Future<NetworkResponse> verifyPin(String pin);
  Future<NetworkResponse> changePin(String oldPin, String newPin);
  Future<NetworkResponse> requestPinReset();
  Future<NetworkResponse> confirmPinReset(String otpCode, String newPin);

  Future<NetworkResponse> syncWallet();
  Future<NetworkResponse> getBanks();
  Future<NetworkResponse> getBankAccounts();
  Future<NetworkResponse> resolveAccount(String accountNumber, String bankCode);
  Future<NetworkResponse> addBankAccount(String bankCode, String accountNumber);
  Future<NetworkResponse> setDefaultBankAccount(String id);
  Future<NetworkResponse> deleteBankAccount(String id);
  Future<NetworkResponse> withdraw(String bankAccountId, double amount);
  Future<NetworkResponse> getVirtualAccountStatus();
  Future<NetworkResponse> createVirtualAccount(String bvn);
  Future<NetworkResponse> getVirtualAccount();
  Future<NetworkResponse> declineVirtualAccount();
}
