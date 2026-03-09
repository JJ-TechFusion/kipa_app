import 'package:dio/dio.dart';
import '../../domain/entities/delivery_entities.dart';
import '../../data/models/delivery_models.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/services/network/api_services.dart';
import '../../../../core/services/network/app_dio.dart';
import '../../../../core/services/storage/secure_storage.dart';
import '../../../../utils/constant.dart';

class ChatRemoteDatasource {
  final ApiService _apiService;
  final Dio _dio;
  final SecureStorageService _storageService;

  ChatRemoteDatasource(
    this._apiService, {
    Dio? dio,
    SecureStorageService? storageService,
  }) : _dio = dio ?? getIt<AppDio>(),
       _storageService = storageService ?? getIt<SecureStorageService>();

  Future<List<ChatMessageEntity>> getChatHistory(String jobId) async {
    try {
      final currentUserId = await _storageService.readData('userId');
      final response = await _dio.get(ApiEndpoints.chatHistoryUrl(jobId));

      logMessage(
        'ChatDatasource',
        'Chat history response: statusCode=${response.statusCode}, dataType=${response.data?.runtimeType}',
      );

      if (response.statusCode == 200 && response.data != null) {
        List<dynamic> messages = [];

        if (response.data is List) {
          messages = response.data as List<dynamic>;
        } else if (response.data is Map<String, dynamic>) {
          final data = response.data as Map<String, dynamic>;
          messages =
              data['messages'] as List<dynamic>? ??
              data['data'] as List<dynamic>? ??
              [];
        }

        logMessage('ChatDatasource', 'Parsed ${messages.length} messages');
        return messages
            .map(
              (json) => ChatMessageModel.fromJson(
                json as Map<String, dynamic>,
                currentUserId: currentUserId,
              ),
            )
            .toList();
      }
      return [];
    } catch (e) {
      logMessage('ChatDatasource', 'Error fetching chat history: $e');
      return [];
    }
  }

  Future<void> markAsRead(String jobId) async {
    try {
      await _apiService.postRequest(endpoint: ApiEndpoints.markReadUrl(jobId));
    } catch (e) {
      logMessage('ChatDatasource', 'Error marking messages as read: $e');
    }
  }

  Future<int> getUnreadCount(String jobId) async {
    try {
      final response = await _apiService.getRequest(
        endpoint: ApiEndpoints.unreadCountUrl(jobId),
      );

      if (response.success || response.statusCode == 200) {
        return response.data?['count'] as int? ?? 0;
      }
      return 0;
    } catch (e) {
      logMessage('ChatDatasource', 'Error fetching unread count: $e');
      return 0;
    }
  }
}
