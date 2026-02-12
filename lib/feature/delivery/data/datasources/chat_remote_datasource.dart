import '../../domain/entities/delivery_entities.dart';
import '../../data/models/delivery_models.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/services/network/api_services.dart';
import '../../../../utils/constant.dart';

class ChatRemoteDatasource {
  final ApiService _apiService;

  ChatRemoteDatasource(this._apiService);

  Future<List<ChatMessageEntity>> getChatHistory(String jobId) async {
    try {
      final response = await _apiService.getRequest(
        endpoint: ApiEndpoints.chatHistoryUrl(jobId),
      );

      if (response.success || response.statusCode == 200) {
        final messages = response.data as List<dynamic>? ?? [];
        return messages
            .map(
              (json) => ChatMessageModel.fromJson(json as Map<String, dynamic>),
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
