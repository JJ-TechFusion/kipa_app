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

  Future<NetworkResponse> getTransactions() async {
    final response = await apiService.getRequest(
      endpoint: ApiEndpoints.walletTransactionsUrl,
    );

    if (response.success && response.data != null) {
      final dataMap = response.data as Map<String, dynamic>;
      return NetworkResponse(
        success: true,
        data: WalletTransactionListModel.fromJson(dataMap),
        message: response.message,
      );
    }
    return response;
  }

  Future<NetworkResponse> getPendingFunds() async {
    final response = await apiService.getRequest(
      endpoint: ApiEndpoints.walletPendingUrl,
    );

    if (response.success && response.data != null) {
      final dataMap = response.data as Map<String, dynamic>;
      return NetworkResponse(
        success: true,
        data: PendingFundListModel.fromJson(dataMap),
        message: response.message,
      );
    }
    return response;
  }

  Future<NetworkResponse> getPinStatus() async {
    final response = await apiService.getRequest(
      endpoint: ApiEndpoints.walletPinStatusUrl,
    );

    if (response.success && response.data != null) {
      final dataMap = response.data as Map<String, dynamic>;
      return NetworkResponse(
        success: true,
        data: PinStatusModel.fromJson(dataMap),
        message: response.message,
      );
    }
    return response;
  }

  Future<NetworkResponse> createPin(String pin) async {
    final response = await apiService.postRequest(
      endpoint: ApiEndpoints.walletPinUrl,
      requestBody: CreatePinRequestModel(pin: pin).toJson(),
    );

    if (response.success && response.data != null) {
      final dataMap = response.data as Map<String, dynamic>;
      return NetworkResponse(
        success: true,
        data: PinResponseModel.fromJson(dataMap),
        message: response.message,
      );
    }
    return response;
  }

  Future<NetworkResponse> verifyPin(String pin) async {
    final response = await apiService.postRequest(
      endpoint: ApiEndpoints.walletPinVerifyUrl,
      requestBody: VerifyPinRequestModel(pin: pin).toJson(),
    );

    if (response.success && response.data != null) {
      final dataMap = response.data as Map<String, dynamic>;
      return NetworkResponse(
        success: true,
        data: PinResponseModel.fromJson(dataMap),
        message: response.message,
      );
    }
    return response;
  }

  Future<NetworkResponse> changePin(String oldPin, String newPin) async {
    final response = await apiService.putRequest(
      endpoint: ApiEndpoints.walletPinUrl,
      requestBody: ChangePinRequestModel(
        oldPin: oldPin,
        newPin: newPin,
      ).toJson(),
    );

    if (response.success && response.data != null) {
      final dataMap = response.data as Map<String, dynamic>;
      return NetworkResponse(
        success: true,
        data: PinResponseModel.fromJson(dataMap),
        message: response.message,
      );
    }
    return response;
  }

  Future<NetworkResponse> requestPinReset() async {
    final response = await apiService.postRequest(
      endpoint: ApiEndpoints.walletPinResetRequestUrl,
      requestBody: {},
    );

    if (response.success && response.data != null) {
      final dataMap = response.data as Map<String, dynamic>;
      return NetworkResponse(
        success: true,
        data: PinResetRequestResponseModel.fromJson(dataMap),
        message: response.message,
      );
    }
    return response;
  }

  Future<NetworkResponse> confirmPinReset(String otpCode, String newPin) async {
    final response = await apiService.postRequest(
      endpoint: ApiEndpoints.walletPinResetConfirmUrl,
      requestBody: PinResetConfirmRequestModel(
        otpCode: otpCode,
        newPin: newPin,
      ).toJson(),
    );

    if (response.success && response.data != null) {
      final dataMap = response.data as Map<String, dynamic>;
      return NetworkResponse(
        success: true,
        data: PinResponseModel.fromJson(dataMap),
        message: response.message,
      );
    }
    return response;
  }

  Future<NetworkResponse> getSubaccount() async {
    final response = await apiService.getRequest(
      endpoint: ApiEndpoints.walletSubaccountUrl,
    );

    if (response.success && response.data != null) {
      final dataMap = response.data as Map<String, dynamic>;
      final subaccountData = dataMap['subaccount'] as Map<String, dynamic>?;
      if (subaccountData != null) {
        return NetworkResponse(
          success: true,
          data: SubaccountModel.fromJson(subaccountData),
          message: response.message,
        );
      }
    }
    return response;
  }

  Future<NetworkResponse> createSubaccount(String email) async {
    final response = await apiService.postRequest(
      endpoint: ApiEndpoints.walletSubaccountUrl,
      requestBody: CreateSubaccountRequestModel(email: email).toJson(),
    );

    if (response.success && response.data != null) {
      final dataMap = response.data as Map<String, dynamic>;
      final subaccountData = dataMap['subaccount'] as Map<String, dynamic>?;
      if (subaccountData != null) {
        return NetworkResponse(
          success: true,
          data: SubaccountModel.fromJson(subaccountData),
          message: response.message,
        );
      }
    }
    return response;
  }
}
