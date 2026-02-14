import 'package:kipa/core/constants/api_constants.dart';
import 'package:kipa/core/services/network/api_services.dart';
import 'package:kipa/utils/constant.dart';
import '../../domain/entities/errand_entity.dart';
import '../models/errand_models.dart';

class ErrandRemoteDatasource {
  final ApiService _apiService;

  ErrandRemoteDatasource() : _apiService = getIt<ApiService>();

  Future<ErrandEntity> createErrand(CreateErrandParams params) async {
    final response = await _apiService.postRequest(
      endpoint: ApiEndpoints.errandsUrl,
      requestBody: params.toJson(),
    );

    if (response.success && response.data != null) {
      final data = response.data as Map<String, dynamic>;
      logMessage('ErrandRemoteDatasource', 'Create errand response: $data');
      final errandData = data['errand'] as Map<String, dynamic>? ?? data;
      return ErrandModel.fromJson(errandData);
    }

    throw Exception(
      response.message.isNotEmpty
          ? response.message
          : 'Failed to create errand',
    );
  }

  Future<ErrandEntity> getErrand(String id) async {
    final response = await _apiService.getRequest(
      endpoint: ApiEndpoints.errandByIdUrl(id),
    );

    if (response.success && response.data != null) {
      final data = response.data as Map<String, dynamic>;
      logMessage('ErrandRemoteDatasource', 'Get errand response: $data');
      return _parseErrandResponse(data);
    }

    throw Exception(
      response.message.isNotEmpty ? response.message : 'Failed to get errand',
    );
  }

  Future<ErrandEntity?> getActiveErrand() async {
    final response = await _apiService.getRequest(
      endpoint: ApiEndpoints.activeErrandUrl,
    );

    if (response.success && response.data != null) {
      final data = response.data as Map<String, dynamic>;

      final errandsList = data['errands'] as List<dynamic>?;
      if (errandsList != null && errandsList.isNotEmpty) {
        final errandData = errandsList.first as Map<String, dynamic>;
        return ErrandModel.fromJson(errandData);
      }

      if (data['errand'] != null) {
        return _parseErrandResponse(data);
      }
      if (data['id'] != null) {
        return ErrandModel.fromJson(data);
      }

      return null;
    }

    return null;
  }

  Future<List<ErrandEntity>> getErrands({
    String? status,
    int? limit,
    int? offset,
  }) async {
    final query = <String, dynamic>{};
    if (status != null) query['status'] = status;
    if (limit != null) query['limit'] = limit;
    if (offset != null) query['offset'] = offset;

    final response = await _apiService.getRequest(
      endpoint: ApiEndpoints.errandsUrl,
      query: query.isNotEmpty ? query : null,
    );

    if (response.success && response.data != null) {
      final data = response.data as Map<String, dynamic>;
      final errandsList = data['errands'] as List<dynamic>? ?? [];
      return ErrandModel.fromJsonList(errandsList);
    }

    throw Exception(
      response.message.isNotEmpty ? response.message : 'Failed to get errands',
    );
  }

  Future<ErrandEntity> confirmErrand(String id) async {
    final response = await _apiService.postRequest(
      endpoint: ApiEndpoints.confirmErrandUrl(id),
    );

    if (response.success && response.data != null) {
      final data = response.data as Map<String, dynamic>;
      logMessage('ErrandRemoteDatasource', 'Confirm errand response: $data');
      return _parseErrandResponse(data);
    }

    throw Exception(
      response.message.isNotEmpty
          ? response.message
          : 'Failed to confirm errand',
    );
  }

  Future<void> completeErrand(String id, String dropoffCode) async {
    final response = await _apiService.postRequest(
      endpoint: ApiEndpoints.completeErrandUrl(id),
      requestBody: {'code': dropoffCode},
    );

    if (!response.success) {
      throw Exception(
        response.message.isNotEmpty
            ? response.message
            : 'Failed to complete errand',
      );
    }
  }

  Future<CancellationResult> cancelErrand(String id) async {
    final response = await _apiService.deleteRequest(
      endpoint: ApiEndpoints.errandByIdUrl(id),
    );

    if (response.success) {
      if (response.data != null) {
        return CancellationResultModel.fromJson(
          response.data as Map<String, dynamic>,
        );
      }
      return const CancellationResult(
        message: 'Errand cancelled successfully',
        cancellationFee: 0,
      );
    }

    throw Exception(
      response.message.isNotEmpty
          ? response.message
          : 'Failed to cancel errand',
    );
  }

  ErrandEntity _parseErrandResponse(Map<String, dynamic> data) {
    final errandData = data['errand'] as Map<String, dynamic>? ?? data;
    final deliveryJobData = data['delivery_job'] as Map<String, dynamic>?;
    final timelineData = data['timeline'] as Map<String, dynamic>?;

    if (deliveryJobData != null) {
      errandData['delivery_job'] = deliveryJobData;
    }

    if (timelineData != null) {
      errandData['timeline'] = timelineData;
    }

    return ErrandModel.fromJson(errandData);
  }
}
