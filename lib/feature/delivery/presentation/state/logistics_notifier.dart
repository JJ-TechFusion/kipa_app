import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kipa/core/constants/api_constants.dart';
import 'package:kipa/core/services/network/api_services.dart';
import 'package:kipa/utils/constant.dart';
import '../../data/models/logistics_delivery_model.dart';
import '../../domain/entities/logistics_delivery_entity.dart';
import 'logistics_state.dart';

class LogisticsNotifier extends Notifier<LogisticsState> {
  @override
  LogisticsState build() {
    return const LogisticsState();
  }

  Future<void> fetchLogisticsDeliveries() async {
    state = state.copyWith(isFetchingLogistics: true, errorMessage: null);

    try {
      final apiService = getIt<ApiService>();

      // Fetch both seller and buyer logistics in parallel
      final results = await Future.wait([
        apiService.getRequest(endpoint: ApiEndpoints.logisticsSellerUrl),
        apiService.getRequest(endpoint: ApiEndpoints.logisticsBuyerUrl),
      ]);

      final sellerResponse = results[0];
      final buyerResponse = results[1];

      final List<LogisticsDeliveryEntity> allDeliveries = [];

      if (sellerResponse.success && sellerResponse.data != null) {
        final sellerData = sellerResponse.data as Map<String, dynamic>;
        final sellerList = LogisticsDeliveryListModel.fromJson(sellerData);
        allDeliveries.addAll(sellerList.toEntity().deliveries);
      }

      if (buyerResponse.success && buyerResponse.data != null) {
        final buyerData = buyerResponse.data as Map<String, dynamic>;
        final buyerList = LogisticsDeliveryListModel.fromJson(buyerData);
        // Add buyer deliveries, avoiding duplicates by ID
        final existingIds = allDeliveries.map((d) => d.id).toSet();
        for (final delivery in buyerList.toEntity().deliveries) {
          if (!existingIds.contains(delivery.id)) {
            allDeliveries.add(delivery);
          }
        }
      }

      // Sort by created_at descending (newest first)
      allDeliveries.sort((a, b) => b.createdAt.compareTo(a.createdAt));

      state = state.copyWith(
        isFetchingLogistics: false,
        deliveries: allDeliveries,
        total: allDeliveries.length,
      );
    } catch (e) {
      state = state.copyWith(
        isFetchingLogistics: false,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> fetchLogisticsDeliveryDetails(String logisticsDeliveryId) async {
    state = state.copyWith(
      isFetchingDetails: true,
      errorMessage: null,
      clearDetails: true,
    );

    try {
      final apiService = getIt<ApiService>();
      final response = await apiService.getRequest(
        endpoint: ApiEndpoints.logisticsDetailsUrl(logisticsDeliveryId),
      );

      if (response.success && response.data != null) {
        final data = response.data as Map<String, dynamic>;
        final model = LogisticsDeliveryDetailsModel.fromJson(data);
        state = state.copyWith(
          isFetchingDetails: false,
          currentDetails: model.toEntity(),
        );
      } else {
        state = state.copyWith(
          isFetchingDetails: false,
          errorMessage: response.message.isNotEmpty
              ? response.message
              : 'Failed to load delivery details',
        );
      }
    } catch (e) {
      state = state.copyWith(
        isFetchingDetails: false,
        errorMessage: e.toString(),
      );
    }
  }

  Future<String?> uploadDeliveryProof({
    required String fileName,
    required List<int> fileBytes,
  }) async {
    try {
      final apiService = getIt<ApiService>();
      final mimeType = DioMediaType('image', fileName.split('.').last);
      final response = await apiService.requestWithFile(
        endpoint: ApiEndpoints.uploadDeliveryProofUrl,
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
        return dataMap['url']?.toString();
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<bool> claimDelivery({
    required String logisticsDeliveryId,
    required String deliveryProofUrl,
    required String notes,
  }) async {
    state = state.copyWith(isClaimingDelivery: true, errorMessage: null);

    try {
      final apiService = getIt<ApiService>();
      final response = await apiService.postRequest(
        endpoint: ApiEndpoints.claimLogisticsDeliveryUrl(logisticsDeliveryId),
        requestBody: {
          'delivery_proof_url': deliveryProofUrl,
          'notes': notes,
        },
      );

      state = state.copyWith(isClaimingDelivery: false);

      if (response.success) {
        await fetchLogisticsDeliveryDetails(logisticsDeliveryId);
        return true;
      } else {
        state = state.copyWith(errorMessage: response.message);
        return false;
      }
    } catch (e) {
      state = state.copyWith(
        isClaimingDelivery: false,
        errorMessage: e.toString(),
      );
      return false;
    }
  }

  Future<bool> confirmLogisticsDelivery({
    required String logisticsDeliveryId,
    required int rating,
    required String notes,
  }) async {
    state = state.copyWith(isConfirmingDelivery: true, errorMessage: null);

    try {
      final apiService = getIt<ApiService>();
      final response = await apiService.postRequest(
        endpoint:
            ApiEndpoints.confirmLogisticsDeliveryUrl(logisticsDeliveryId),
        requestBody: {
          'rating': rating,
          'notes': notes,
        },
      );

      state = state.copyWith(isConfirmingDelivery: false);

      if (response.success) {
        await fetchLogisticsDeliveryDetails(logisticsDeliveryId);
        await fetchLogisticsDeliveries();
        return true;
      } else {
        state = state.copyWith(errorMessage: response.message);
        return false;
      }
    } catch (e) {
      state = state.copyWith(
        isConfirmingDelivery: false,
        errorMessage: e.toString(),
      );
      return false;
    }
  }

  Future<String?> uploadDisputeEvidence({
    required String fileName,
    required List<int> fileBytes,
  }) async {
    try {
      final apiService = getIt<ApiService>();
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
        return dataMap['url']?.toString();
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<bool> openLogisticsDispute({
    required String logisticsDeliveryId,
    required String reason,
    required List<String> evidenceUrls,
  }) async {
    state = state.copyWith(isOpeningDispute: true, errorMessage: null);

    try {
      final apiService = getIt<ApiService>();
      final response = await apiService.postRequest(
        endpoint: ApiEndpoints.openLogisticsDisputeUrl(logisticsDeliveryId),
        requestBody: {
          'reason': reason,
          'evidence_urls': evidenceUrls,
        },
      );

      state = state.copyWith(isOpeningDispute: false);

      if (response.success) {
        await fetchLogisticsDeliveryDetails(logisticsDeliveryId);
        return true;
      } else {
        state = state.copyWith(errorMessage: response.message);
        return false;
      }
    } catch (e) {
      state = state.copyWith(
        isOpeningDispute: false,
        errorMessage: e.toString(),
      );
      return false;
    }
  }

  Future<bool> markReturnShipped({
    required String logisticsDeliveryId,
    required String returnCarrier,
    required String returnTrackingNumber,
  }) async {
    state = state.copyWith(isMarkingReturnShipped: true, errorMessage: null);
    try {
      final apiService = getIt<ApiService>();
      final response = await apiService.postRequest(
        endpoint: ApiEndpoints.returnShippedUrl(logisticsDeliveryId),
        requestBody: {
          'return_carrier': returnCarrier,
          'return_tracking_number': returnTrackingNumber,
        },
      );
      state = state.copyWith(isMarkingReturnShipped: false);
      if (response.success) {
        await fetchLogisticsDeliveryDetails(logisticsDeliveryId);
        return true;
      } else {
        state = state.copyWith(errorMessage: response.message);
        return false;
      }
    } catch (e) {
      state = state.copyWith(
        isMarkingReturnShipped: false,
        errorMessage: e.toString(),
      );
      return false;
    }
  }

  Future<bool> confirmLogisticsReturn({
    required String logisticsDeliveryId,
    required String condition,
    required String notes,
  }) async {
    state = state.copyWith(isConfirmingReturn: true, errorMessage: null);
    try {
      final apiService = getIt<ApiService>();
      final response = await apiService.postRequest(
        endpoint: ApiEndpoints.confirmLogisticsReturnUrl(logisticsDeliveryId),
        requestBody: {
          'condition': condition,
          'notes': notes,
        },
      );
      state = state.copyWith(isConfirmingReturn: false);
      if (response.success) {
        await fetchLogisticsDeliveryDetails(logisticsDeliveryId);
        await fetchLogisticsDeliveries();
        return true;
      } else {
        state = state.copyWith(errorMessage: response.message);
        return false;
      }
    } catch (e) {
      state = state.copyWith(
        isConfirmingReturn: false,
        errorMessage: e.toString(),
      );
      return false;
    }
  }

  void clearError() {
    state = state.copyWith(errorMessage: null);
  }
}
