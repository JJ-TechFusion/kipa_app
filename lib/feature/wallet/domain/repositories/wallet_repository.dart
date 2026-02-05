import '../../../../core/services/network/network_response.dart';

abstract class WalletRepository {
  Future<NetworkResponse> getWallet();
  Future<NetworkResponse> topUpWallet(double amount);
  Future<NetworkResponse> verifyTopUp(String reference);
}
