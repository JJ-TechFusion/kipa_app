import '../../../../core/constants/api_constants.dart';
import '../../../../core/services/network/api_services.dart';
import '../../../../core/services/network/network_response.dart';
import '../models/purchase_model.dart';

class PurchasesRemoteDataSource {
  final ApiService apiService;

  PurchasesRemoteDataSource(this.apiService);

  Future<NetworkResponse> getPurchases() async {
    final response = await apiService.getRequest(
      endpoint: ApiEndpoints.buyerPurchasesUrl,
    );

    if (response.success && response.data != null) {
      final dataMap = response.data as Map<String, dynamic>;
      return NetworkResponse(
        success: true,
        data: PurchaseListModel.fromJson(dataMap).toEntity(),
        message: response.message,
      );
    }
    return response;
  }

  Future<NetworkResponse> getPurchaseById(String purchaseId) async {
    final response = await apiService.getRequest(
      endpoint: ApiEndpoints.buyerPurchaseByIdUrl(purchaseId),
    );

    if (response.success && response.data != null) {
      final dataMap = response.data as Map<String, dynamic>;
      return NetworkResponse(
        success: true,
        data: PurchaseDetailModel.fromJson(dataMap).toEntity(),
        message: response.message,
      );
    }
    return response;
  }

  Future<NetworkResponse> confirmDelivery(String purchaseId) async {
    final response = await apiService.postRequest(
      endpoint: ApiEndpoints.confirmDeliveryUrl(purchaseId),
      requestBody: {},
    );

    return response;
  }
}
