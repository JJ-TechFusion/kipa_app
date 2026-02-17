import '../../../../core/constants/api_constants.dart';
import '../../../../core/services/network/api_services.dart';
import '../../../../core/services/network/network_response.dart';
import '../models/dispute_model.dart';

class DisputesRemoteDataSource {
  final ApiService apiService;

  DisputesRemoteDataSource(this.apiService);

  Future<NetworkResponse> getDisputes() async {
    final response = await apiService.getRequest(
      endpoint: ApiEndpoints.disputesUrl,
    );

    if (response.success && response.data != null) {
      final dataMap = response.data as Map<String, dynamic>;
      return NetworkResponse(
        success: true,
        data: DisputeListModel.fromJson(dataMap).toEntity(),
        message: response.message,
      );
    }
    return response;
  }

  Future<NetworkResponse> getDisputeById(String id) async {
    final response = await apiService.getRequest(
      endpoint: ApiEndpoints.disputeByIdUrl(id),
    );

    if (response.success && response.data != null) {
      final dataMap = response.data as Map<String, dynamic>;
      return NetworkResponse(
        success: true,
        data: DisputeModel.fromJson(dataMap).toEntity(),
        message: response.message,
      );
    }
    return response;
  }
}
