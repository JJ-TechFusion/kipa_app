import '../../../../core/constants/api_constants.dart';
import '../../../../core/services/network/api_services.dart';
import '../../../../core/services/network/network_response.dart';
import '../models/sale_model.dart';

class SalesRemoteDataSource {
  final ApiService apiService;

  SalesRemoteDataSource(this.apiService);

  Future<NetworkResponse> getSales() async {
    final response = await apiService.getRequest(
      endpoint: ApiEndpoints.sellerSalesUrl,
    );

    if (response.success && response.data != null) {
      final dataMap = response.data as Map<String, dynamic>;
      return NetworkResponse(
        success: true,
        data: SaleListModel.fromJson(dataMap).toEntity(),
        message: response.message,
      );
    }
    return response;
  }

  Future<NetworkResponse> getSaleById(String orderId) async {
    final response = await apiService.getRequest(
      endpoint: ApiEndpoints.sellerSaleByIdUrl(orderId),
    );

    if (response.success && response.data != null) {
      final dataMap = response.data as Map<String, dynamic>;
      return NetworkResponse(
        success: true,
        data: SaleDetailModel.fromJson(dataMap).toEntity(),
        message: response.message,
      );
    }
    return response;
  }
}
