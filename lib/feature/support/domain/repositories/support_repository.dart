import '../../../../core/services/network/network_response.dart';
import '../entities/support_request_entity.dart';

abstract class SupportRepository {
  Future<NetworkResponse> getOrCreateConversation();
  Future<NetworkResponse> getMessages({int limit = 50});
  Future<NetworkResponse> sendMessage(SendSupportMessageRequest request);
  Future<NetworkResponse> markMessagesAsRead();
  Future<NetworkResponse> uploadSupportMedia({
    required String fileName,
    required List<int> fileBytes,
  });
}
