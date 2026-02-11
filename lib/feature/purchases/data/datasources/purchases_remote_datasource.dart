import 'package:dio/dio.dart';

import '../../../../core/constants/api_constants.dart';
import '../../../../core/services/network/api_services.dart';
import '../../../../core/services/network/network_response.dart';
import '../models/purchase_model.dart';
import '../models/ready_for_return_response_model.dart';
import '../models/dispute_response_model.dart';

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

  Future<NetworkResponse> readyForReturn(String purchaseId) async {
    final response = await apiService.postRequest(
      endpoint: ApiEndpoints.readyForReturnUrl(purchaseId),
      requestBody: {},
    );

    if (response.success && response.data != null) {
      final dataMap = response.data as Map<String, dynamic>;
      return NetworkResponse(
        success: true,
        data: ReadyForReturnResponseModel.fromJson(dataMap).toEntity(),
        message: response.message,
      );
    }
    return response;
  }

  Future<NetworkResponse> uploadDisputeEvidence({
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
        data: EvidenceUploadResponseModel.fromJson(dataMap).toEntity(),
        message: response.message,
      );
    }
    return response;
  }

  Future<NetworkResponse> openDispute({
    required String purchaseId,
    required String reason,
    required List<String> evidence,
  }) async {
    final response = await apiService.postRequest(
      endpoint: ApiEndpoints.openDisputeUrl(purchaseId),
      requestBody: {'reason': reason, 'evidence': evidence},
    );

    if (response.success && response.data != null) {
      final dataMap = response.data as Map<String, dynamic>;
      return NetworkResponse(
        success: true,
        data: DisputeResponseModel.fromJson(dataMap).toEntity(),
        message: response.message,
      );
    }
    return response;
  }

  Future<NetworkResponse> rebookDelivery(String purchaseId) async {
    final response = await apiService.postRequest(
      endpoint: ApiEndpoints.rebookDeliveryUrl(purchaseId),
      requestBody: {},
    );

    return response;
  }
}
