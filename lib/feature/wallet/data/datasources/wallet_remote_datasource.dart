import '../../../../core/constants/api_constants.dart';
import '../../../../core/services/network/api_services.dart';
import '../../../../core/services/network/network_response.dart';
import '../models/wallet_models.dart';

class WalletRemoteDataSource {
  final ApiService apiService;

  WalletRemoteDataSource(this.apiService);

  Future<NetworkResponse> getWallet() async {
    final response = await apiService.getRequest(
      endpoint: ApiEndpoints.walletUrl,
    );

    if (response.success && response.data != null) {
      final dataMap = response.data as Map<String, dynamic>;
      return NetworkResponse(
        success: true,
        data: WalletModel.fromJson(dataMap),
        message: response.message,
      );
    }
    return response;
  }

  Future<NetworkResponse> topUpWallet(double amount) async {
    final response = await apiService.postRequest(
      endpoint: ApiEndpoints.walletTopUpUrl,
      requestBody: TopUpRequestModel(amount: amount).toJson(),
    );

    if (response.success && response.data != null) {
      final dataMap = response.data as Map<String, dynamic>;
      return NetworkResponse(
        success: true,
        data: TopUpResponseModel.fromJson(dataMap),
        message: response.message,
      );
    }
    return response;
  }

  Future<NetworkResponse> verifyTopUp(String reference) async {
    final response = await apiService.postRequest(
      endpoint: ApiEndpoints.walletTopUpVerifyUrl,
      requestBody: VerifyTopUpRequestModel(reference: reference).toJson(),
    );

    if (response.success && response.data != null) {
      final dataMap = response.data as Map<String, dynamic>;
      return NetworkResponse(
        success: true,
        data: VerifyTopUpResponseModel.fromJson(dataMap),
        message: response.message,
      );
    }
    return response;
  }
}
