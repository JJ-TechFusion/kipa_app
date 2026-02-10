import '../../../../core/constants/api_constants.dart';
import '../../../../core/services/network/api_services.dart';
import '../../../../core/services/network/network_response.dart';
import '../models/active_delivery_model.dart';

class DashboardRemoteDataSource {
  final ApiService apiService;

  DashboardRemoteDataSource(this.apiService);

  Future<NetworkResponse> getActiveDeliveries() async {
    final response = await apiService.getRequest(
      endpoint: ApiEndpoints.activeDeliveriesUrl,
    );

    if (response.success && response.data != null) {
      try {
        final dataMap = response.data as Map<String, dynamic>;
        return NetworkResponse(
          success: true,
          data: ActiveDeliveriesResponseModel.fromJson(dataMap).toEntity(),
          message: response.message,
        );
      } catch (e) {
        return NetworkResponse(
          success: false,
          data: null,
          message: 'Failed to parse active deliveries: ${e.toString()}',
        );
      }
    }
    return response;
  }
}
