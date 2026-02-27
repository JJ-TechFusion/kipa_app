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
  Future<NetworkResponse> requestPinReset();
  Future<NetworkResponse> confirmPinReset(String otpCode, String newPin);

  // Subaccount operations
  Future<NetworkResponse> getSubaccount();
  Future<NetworkResponse> createSubaccount(String email);
  Future<NetworkResponse> syncWallet();

  // Bank account operations
  Future<NetworkResponse> getBanks();
  Future<NetworkResponse> getBankAccounts();
  Future<NetworkResponse> resolveAccount(String accountNumber, String bankCode);
  Future<NetworkResponse> addBankAccount(String bankCode, String accountNumber);
  Future<NetworkResponse> setDefaultBankAccount(String id);
  Future<NetworkResponse> deleteBankAccount(String id);

  // Withdrawal operations
  Future<NetworkResponse> withdraw(String bankAccountId, double amount);
}
