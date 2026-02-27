import 'package:dio/dio.dart';

import '../../../../core/constants/api_constants.dart';
import '../../../../core/services/network/api_services.dart';
import '../../../../core/services/network/network_response.dart';
import '../../../location/domain/entities/fulfillment_entity.dart';
import '../../domain/entities/payment_request_entity.dart';
import '../../domain/entities/payment_buyer_entities.dart';
import '../models/payment_request_model.dart';
import '../models/fulfillment_model.dart';
import '../models/payment_buyer_models.dart';
import '../models/transaction_status_models.dart';
import '../models/transaction_list_models.dart';
import '../models/ship_logistics_model.dart';
import '../../domain/entities/ship_logistics_entity.dart';

class PaymentRemoteDataSource {
  final ApiService apiService;

  PaymentRemoteDataSource(this.apiService);

  Future<NetworkResponse> createPaymentRequest(
    CreatePaymentRequestEntity request,
  ) async {
    final response = await apiService.postRequest(
      endpoint: ApiEndpoints.createPaymentRequestUrl,
      requestBody: CreatePaymentRequestModel.toEntity(request).toJson(),
    );

    if (response.success && response.data != null) {
      final dataMap = response.data as Map<String, dynamic>;
      return NetworkResponse(
        success: true,
        data: PaymentRequestResponseModel.fromJson(dataMap).toEntity(),
        message: response.message,
      );
    }
    return response;
  }

  Future<NetworkResponse> updatePaymentRequest(
    String id,
    Map<String, dynamic> data,
  ) async {
    final response = await apiService.patchRequest(
      endpoint: '${ApiEndpoints.createPaymentRequestUrl}/$id',
      requestBody: data,
    );

    if (response.success && response.data != null) {
      final dataMap = response.data as Map<String, dynamic>;
      return NetworkResponse(
        success: true,
        data: PaymentRequestResponseModel.fromJson(dataMap).toEntity(),
        message: response.message,
      );
    }
    return response;
  }

  Future<NetworkResponse> deletePaymentRequest(String id) async {
    final response = await apiService.deleteRequest(
      endpoint: '${ApiEndpoints.createPaymentRequestUrl}/$id',
    );
    return response;
  }

  Future<NetworkResponse> getPaymentRequests() async {
    final response = await apiService.getRequest(
      endpoint: ApiEndpoints.createPaymentRequestUrl,
    );

    if (response.success && response.data != null) {
      final dataMap = response.data as Map<String, dynamic>;
      return NetworkResponse(
        success: true,
        data: PaymentRequestListModel.fromJson(dataMap).toEntity(),
        message: response.message,
      );
    }
    return response;
  }

  Future<NetworkResponse> getPaymentRequestById(String paymentRequestId) async {
    final response = await apiService.getRequest(
      endpoint: '${ApiEndpoints.createPaymentRequestUrl}/$paymentRequestId',
    );

    if (response.success && response.data != null) {
      final dataMap = response.data as Map<String, dynamic>;
      return NetworkResponse(
        success: true,
        data: PaymentRequestResponseModel.fromJson(dataMap).toEntity(),
        message: response.message,
      );
    }
    return response;
  }

  Future<NetworkResponse> getPaymentRequestHistory() async {
    final response = await apiService.getRequest(
      endpoint: ApiEndpoints.paymentRequestHistoryUrl,
    );

    if (response.success && response.data != null) {
      // response.data is already the inner data object {count, payment_requests}
      final dataMap = response.data as Map<String, dynamic>;
      return NetworkResponse(
        success: true,
        data: PaymentRequestListModel.fromJson(dataMap).toEntity(),
        message: response.message,
      );
    }
    return response;
  }

  Future<NetworkResponse> createFulfillment(
    String paymentRequestId,
    CreateFulfillmentEntity request,
  ) async {
    final response = await apiService.patchRequest(
      endpoint: ApiEndpoints.fulfillmentUrl(paymentRequestId),
      requestBody: CreateFulfillmentModel.fromEntity(request).toJson(),
    );

    if (response.success && response.data != null) {
      final dataMap = response.data as Map<String, dynamic>;
      return NetworkResponse(
        success: true,
        data: FulfillmentResponseModel.fromJson(dataMap).toEntity(),
        message: response.message,
      );
    }
    return response;
  }

  Future<NetworkResponse> initializePayment(
    String paymentCode,
    InitializePaymentEntity request,
  ) async {
    final response = await apiService.postRequest(
      endpoint: ApiEndpoints.initializePaymentUrl(paymentCode),
      requestBody: request is InitializePaymentModel
          ? request.toJson()
          : InitializePaymentModel(
              paymentMethod: request.paymentMethod,
            ).toJson(),
    );

    if (response.success && response.data != null) {
      final dataMap = response.data as Map<String, dynamic>;
      return NetworkResponse(
        success: true,
        data: InitializePaymentResponseModel.fromJson(dataMap),
        message: response.message,
      );
    }
    return response;
  }

  Future<NetworkResponse> verifyPayment(
    String paymentCode,
    String reference,
  ) async {
    final response = await apiService.getRequest(
      endpoint: ApiEndpoints.verifyPaymentUrl(paymentCode),
      query: {'reference': reference},
    );

    if (response.success && response.data != null) {
      final dataMap = response.data as Map<String, dynamic>;
      return NetworkResponse(
        success: true,
        data: VerifyPaymentResponseModel.fromJson(dataMap),
        message: response.message,
      );
    }
    return response;
  }

  Future<NetworkResponse> getPaymentDetails(String paymentCode) async {
    final response = await apiService.getRequest(
      endpoint: ApiEndpoints.getPaymentDetailsUrl(paymentCode),
    );

    if (response.success && response.data != null) {
      final dataMap = response.data as Map<String, dynamic>;
      return NetworkResponse(
        success: true,
        data: PaymentDetailsModel.fromJson(dataMap),
        message: response.message,
      );
    }
    return response;
  }

  Future<NetworkResponse> markReadyForPickup(String paymentRequestId) async {
    final response = await apiService.postRequest(
      endpoint: ApiEndpoints.markReadyForPickupUrl(paymentRequestId),
      requestBody: {},
    );

    if (response.success && response.data != null) {
      final dataMap = response.data as Map<String, dynamic>;
      return NetworkResponse(
        success: true,
        data: MarkReadyForPickupResponseModel.fromJson(dataMap).toEntity(),
        message: response.message,
      );
    }
    return response;
  }

  Future<NetworkResponse> cancelRiderSearch(String paymentRequestId) async {
    final response = await apiService.postRequest(
      endpoint: ApiEndpoints.cancelRiderSearchUrl(paymentRequestId),
      requestBody: {},
    );

    if (response.success && response.data != null) {
      final dataMap = response.data as Map<String, dynamic>;
      return NetworkResponse(
        success: true,
        data: PaymentRequestResponseModel.fromJson(dataMap).toEntity(),
        message: response.message,
      );
    }
    return response;
  }

  Future<NetworkResponse> getTransactionStatus(String paymentRequestId) async {
    final response = await apiService.getRequest(
      endpoint: ApiEndpoints.getTransactionStatusUrl(paymentRequestId),
    );

    if (response.success && response.data != null) {
      try {
        final dataMap = response.data as Map<String, dynamic>;
        return NetworkResponse(
          success: true,
          data: TransactionStatusModel.fromJson(dataMap).toEntity(),
          message: response.message,
        );
      } catch (e) {
        return NetworkResponse(
          success: false,
          data: null,
          message: 'Failed to parse transaction status: ${e.toString()}',
        );
      }
    }
    return response;
  }

  Future<NetworkResponse> uploadItemImage({
    required String fileName,
    required List<int> fileBytes,
  }) async {
    final mimeType = DioMediaType('image', fileName.split('.').last);
    final response = await apiService.requestWithFile(
      endpoint: ApiEndpoints.uploadItemImageUrl,
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

  Future<NetworkResponse> shipLogisticsDelivery(
    String logisticsDeliveryId,
    ShipLogisticsEntity request,
  ) async {
    final response = await apiService.postRequest(
      endpoint: ApiEndpoints.shipLogisticsDeliveryUrl(logisticsDeliveryId),
      requestBody: ShipLogisticsModel.fromEntity(request).toJson(),
    );

    if (response.success && response.data != null) {
      final dataMap = response.data as Map<String, dynamic>;
      return NetworkResponse(
        success: true,
        data: ShipLogisticsResponseModel.fromJson(dataMap).toEntity(),
        message: response.message,
      );
    }
    return response;
  }

  Future<NetworkResponse> uploadShipmentReceipt({
    required String fileName,
    required List<int> fileBytes,
  }) async {
    final mimeType = DioMediaType('image', fileName.split('.').last);
    final response = await apiService.requestWithFile(
      endpoint: ApiEndpoints.uploadShipmentReceiptUrl,
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

  Future<NetworkResponse> getTransactions({String? status}) async {
    final query = <String, dynamic>{};
    if (status != null && status.isNotEmpty) {
      query['status'] = status;
    }

    final response = await apiService.getRequest(
      endpoint: ApiEndpoints.transactionsListUrl,
      query: query.isEmpty ? null : query,
    );

    if (response.success && response.data != null) {
      try {
        final dataMap = response.data as Map<String, dynamic>;
        return NetworkResponse(
          success: true,
          data: TransactionListModel.fromJson(dataMap).toEntityList(),
          message: response.message,
        );
      } catch (e) {
        return NetworkResponse(
          success: false,
          data: null,
          message: 'Failed to parse transactions: ${e.toString()}',
        );
      }
    }
    return response;
  }
}
