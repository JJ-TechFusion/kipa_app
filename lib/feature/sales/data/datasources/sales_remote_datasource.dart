import 'package:dio/dio.dart';

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

  Future<NetworkResponse> confirmReturn({
    required String orderId,
    required String condition,
    String? notes,
    String? damageReason,
    List<String> damageEvidenceUrls = const [],
  }) async {
    final response = await apiService.postRequest(
      endpoint: ApiEndpoints.confirmReturnUrl(orderId),
      requestBody: {
        'condition': condition,
        'notes': notes,
        'damage_reason': damageReason,
        'damage_evidence_urls': damageEvidenceUrls,
      },
    );

    return response;
  }

  Future<NetworkResponse> uploadDamageEvidence({
    required String fileName,
    required List<int> fileBytes,
  }) async {
    final mimeType = DioMediaType('image', fileName.split('.').last);
    final response = await apiService.requestWithFile(
      endpoint: ApiEndpoints.uploadDisputeEvidenceUrl,
      fileName: 'file',
      fileBytes: fileBytes,
      mimeType: mimeType,
      otherFieldsInRequest: {
        'file': MultipartFile.fromBytes(
          fileBytes,
          filename: fileName,
          contentType: mimeType,
        ),
      },
    );

    if (response.success && response.data != null) {
      final dataMap = response.data as Map<String, dynamic>;
      return NetworkResponse(
        success: true,
        data: dataMap['url']?.toString() ?? '',
        message: response.message,
      );
    }
    return response;
  }
}
