import 'package:dio/dio.dart';

import '../../../../core/constants/api_constants.dart';
import '../../../../core/services/network/app_dio.dart';
import '../../../../core/services/network/network_response.dart';
import '../../../../utils/constant.dart';
import '../../domain/entities/support_request_entity.dart';
import '../models/support_conversation_model.dart';
import '../models/support_message_model.dart';

class SupportRemoteDataSource {
  final Dio _dio;

  SupportRemoteDataSource({Dio? dio}) : _dio = dio ?? getIt<AppDio>();

  Future<NetworkResponse> getOrCreateConversation() async {
    try {
      final response = await _dio.get(ApiEndpoints.supportConversationUrl);
      final statusCode = response.statusCode ?? 500;
      final isSuccess = statusCode >= 200 && statusCode < 300;
      final payload = response.data;

      if (isSuccess && payload is Map<String, dynamic>) {
        return NetworkResponse(
          success: true,
          data: SupportConversationResponseModel.fromJson(payload).toEntity(),
          message: _extractMessage(payload),
          statusCode: statusCode,
        );
      }

      return NetworkResponse(
        success: false,
        data: payload,
        message: _extractMessage(
          payload,
          fallback: 'Failed to open support chat',
        ),
        statusCode: statusCode,
      );
    } catch (e) {
      return NetworkResponse(
        success: false,
        data: null,
        message: e.toString(),
        statusCode: 500,
      );
    }
  }

  Future<NetworkResponse> getMessages({int limit = 50}) async {
    try {
      final response = await _dio.get(
        ApiEndpoints.supportMessagesUrl,
        queryParameters: {'limit': limit},
      );
      final statusCode = response.statusCode ?? 500;
      final isSuccess = statusCode >= 200 && statusCode < 300;
      final payload = response.data;

      if (isSuccess && payload is Map<String, dynamic>) {
        return NetworkResponse(
          success: true,
          data: SupportMessageListModel.fromJson(payload).toEntity(),
          message: _extractMessage(payload),
          statusCode: statusCode,
        );
      }

      return NetworkResponse(
        success: false,
        data: payload,
        message: _extractMessage(
          payload,
          fallback: 'Failed to fetch support messages',
        ),
        statusCode: statusCode,
      );
    } catch (e) {
      return NetworkResponse(
        success: false,
        data: null,
        message: e.toString(),
        statusCode: 500,
      );
    }
  }

  Future<NetworkResponse> sendMessage(SendSupportMessageRequest request) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.supportMessagesUrl,
        data: request.toJson(),
      );
      final statusCode = response.statusCode ?? 500;
      final isSuccess = statusCode >= 200 && statusCode < 300;
      final payload = response.data;

      if (isSuccess && payload is Map<String, dynamic>) {
        return NetworkResponse(
          success: true,
          data: SupportMessageModel.fromJson(payload).toEntity(),
          message: _extractMessage(payload),
          statusCode: statusCode,
        );
      }

      return NetworkResponse(
        success: false,
        data: payload,
        message: _extractMessage(
          payload,
          fallback: 'Failed to send support message',
        ),
        statusCode: statusCode,
      );
    } catch (e) {
      return NetworkResponse(
        success: false,
        data: null,
        message: e.toString(),
        statusCode: 500,
      );
    }
  }

  Future<NetworkResponse> markMessagesAsRead() async {
    try {
      final response = await _dio.post(
        ApiEndpoints.supportMessagesReadUrl,
        data: {},
      );
      final statusCode = response.statusCode ?? 500;
      final isSuccess = statusCode >= 200 && statusCode < 300;
      final payload = response.data;

      return NetworkResponse(
        success: isSuccess,
        data: payload,
        message: _extractMessage(
          payload,
          fallback: isSuccess
              ? 'Messages marked as read'
              : 'Failed to mark messages as read',
        ),
        statusCode: statusCode,
      );
    } catch (e) {
      return NetworkResponse(
        success: false,
        data: null,
        message: e.toString(),
        statusCode: 500,
      );
    }
  }

  Future<NetworkResponse> uploadSupportMedia({
    required String fileName,
    required List<int> fileBytes,
  }) async {
    try {
      final extension = fileName.split('.').last.toLowerCase();
      final mimeType = DioMediaType('image', extension);

      final formData = FormData.fromMap({
        'file': MultipartFile.fromBytes(
          fileBytes,
          filename: fileName,
          contentType: mimeType,
        ),
      });

      final response = await _dio.post(
        ApiEndpoints.uploadDisputeEvidenceUrl,
        data: formData,
      );

      final statusCode = response.statusCode ?? 500;
      final isSuccess = statusCode >= 200 && statusCode < 300;
      final payload = response.data;

      if (isSuccess && payload is Map<String, dynamic>) {
        final url =
            payload['url']?.toString() ??
            (payload['data'] as Map<String, dynamic>?)?['url']?.toString() ??
            '';
        if (url.isNotEmpty) {
          return NetworkResponse(
            success: true,
            data: url,
            message: _extractMessage(payload),
            statusCode: statusCode,
          );
        }
      }

      return NetworkResponse(
        success: false,
        data: payload,
        message: _extractMessage(payload, fallback: 'Failed to upload image'),
        statusCode: statusCode,
      );
    } catch (e) {
      return NetworkResponse(
        success: false,
        data: null,
        message: e.toString(),
        statusCode: 500,
      );
    }
  }

  String _extractMessage(dynamic payload, {String fallback = ''}) {
    if (payload is Map<String, dynamic>) {
      final message = payload['message']?.toString();
      if (message != null && message.isNotEmpty) return message;
    }
    return fallback;
  }
}
