import '../../../../core/constants/api_constants.dart';
import '../../../../core/services/network/api_services.dart';
import '../../../../core/services/network/network_response.dart';
import '../models/wallet_models.dart';
import '../models/bank_model.dart';

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

  Future<NetworkResponse> syncWallet() async {
    final response = await apiService.postRequest(
      endpoint: ApiEndpoints.walletSyncUrl,
      requestBody: {},
    );

    if (response.success && response.data != null) {
      final dataMap = response.data as Map<String, dynamic>;
      return NetworkResponse(
        success: true,
        data: WalletSyncResponseModel.fromJson(dataMap),
        message: response.message,
      );
    }
    return response;
  }

  Future<NetworkResponse> getBanks() async {
    final response = await apiService.getRequest(
      endpoint: ApiEndpoints.flutterwaveBanksUrl,
    );

    if (response.success && response.data != null) {
      final dataMap = response.data as Map<String, dynamic>;
      final banksList =
          (dataMap['banks'] as List<dynamic>?)
              ?.map((e) => BankModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [];
      return NetworkResponse(
        success: true,
        data: banksList,
        message: response.message,
      );
    }
    return response;
  }

  Future<NetworkResponse> getBankAccounts() async {
    final response = await apiService.getRequest(
      endpoint: ApiEndpoints.bankAccountsUrl,
    );

    if (response.success && response.data != null) {
      final dataMap = response.data as Map<String, dynamic>;
      final accountsList =
          (dataMap['bank_accounts'] as List<dynamic>?)
              ?.map((e) => BankAccountModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [];
      return NetworkResponse(
        success: true,
        data: accountsList,
        message: response.message,
      );
    }
    return response;
  }

  Future<NetworkResponse> resolveAccount(
    String accountNumber,
    String bankCode,
  ) async {
    final response = await apiService.postRequest(
      endpoint: ApiEndpoints.resolveAccountUrl,
      requestBody: ResolveAccountRequestModel(
        accountNumber: accountNumber,
        bankCode: bankCode,
      ).toJson(),
    );

    if (response.success && response.data != null) {
      final dataMap = response.data as Map<String, dynamic>;
      return NetworkResponse(
        success: true,
        data: ResolveAccountResponseModel.fromJson(dataMap),
        message: response.message,
      );
    }
    return response;
  }

  Future<NetworkResponse> addBankAccount(
    String bankCode,
    String accountNumber,
  ) async {
    final response = await apiService.postRequest(
      endpoint: ApiEndpoints.bankAccountsUrl,
      requestBody: AddBankAccountRequestModel(
        bankCode: bankCode,
        accountNumber: accountNumber,
      ).toJson(),
    );

    if (response.success && response.data != null) {
      final dataMap = response.data as Map<String, dynamic>;
      final accountData = dataMap['bank_account'] as Map<String, dynamic>?;
      if (accountData != null) {
        return NetworkResponse(
          success: true,
          data: BankAccountModel.fromJson(accountData),
          message: response.message,
        );
      }
    }
    return response;
  }

  Future<NetworkResponse> setDefaultBankAccount(String id) async {
    final response = await apiService.putRequest(
      endpoint: ApiEndpoints.setBankAccountDefaultUrl(id),
      requestBody: {},
    );

    return response;
  }

  Future<NetworkResponse> deleteBankAccount(String id) async {
    final response = await apiService.deleteRequest(
      endpoint: ApiEndpoints.deleteBankAccountUrl(id),
    );

    return response;
  }

  Future<NetworkResponse> withdraw(String bankAccountId, double amount) async {
    final response = await apiService.postRequest(
      endpoint: ApiEndpoints.withdrawUrl,
      requestBody: WithdrawRequestModel(
        bankAccountId: bankAccountId,
        amount: amount,
      ).toJson(),
    );

    if (response.success && response.data != null) {
      final dataMap = response.data as Map<String, dynamic>;
      final withdrawalData = dataMap['withdrawal'] as Map<String, dynamic>?;
      if (withdrawalData != null) {
        return NetworkResponse(
          success: true,
          data: WithdrawalModel.fromJson(withdrawalData),
          message: response.message,
        );
      }
    }
    return response;
  }

  Future<NetworkResponse> getVirtualAccountStatus() async {
    final response = await apiService.getRequest(
      endpoint: ApiEndpoints.virtualAccountStatusUrl,
    );

    if (response.success && response.data != null) {
      final dataMap = response.data as Map<String, dynamic>;
      return NetworkResponse(
        success: true,
        data: VirtualAccountStatusModel.fromJson(dataMap),
        message: response.message,
      );
    }
    return response;
  }

  Future<NetworkResponse> createVirtualAccount(String bvn) async {
    final response = await apiService.postRequest(
      endpoint: ApiEndpoints.virtualAccountUrl,
      requestBody: CreateVirtualAccountRequestModel(bvn: bvn).toJson(),
    );

    if (response.success && response.data != null) {
      final dataMap = response.data as Map<String, dynamic>;
      final virtualAccountData =
          dataMap['virtual_account'] as Map<String, dynamic>?;
      if (virtualAccountData != null) {
        return NetworkResponse(
          success: true,
          data: VirtualAccountModel.fromJson(virtualAccountData),
          message: dataMap['message'] ?? response.message,
        );
      }
    }
    return response;
  }

  Future<NetworkResponse> getVirtualAccount() async {
    final response = await apiService.getRequest(
      endpoint: ApiEndpoints.virtualAccountUrl,
    );

    if (response.success && response.data != null) {
      final dataMap = response.data as Map<String, dynamic>;
      final virtualAccountData =
          dataMap['virtual_account'] as Map<String, dynamic>?;
      if (virtualAccountData != null) {
        return NetworkResponse(
          success: true,
          data: VirtualAccountModel.fromJson(virtualAccountData),
          message: dataMap['message'] ?? response.message,
        );
      }
    }
    return response;
  }

  Future<NetworkResponse> declineVirtualAccount() async {
    final response = await apiService.getRequest(
      endpoint: ApiEndpoints.virtualAccountDeclineUrl,
    );

    return response;
  }
}
