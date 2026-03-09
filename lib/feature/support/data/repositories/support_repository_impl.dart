import '../../../../core/services/network/network_response.dart';
import '../../domain/entities/support_request_entity.dart';
import '../../domain/repositories/support_repository.dart';
import '../datasources/support_remote_datasource.dart';

class SupportRepositoryImpl implements SupportRepository {
  final SupportRemoteDataSource remoteDataSource;

  SupportRepositoryImpl(this.remoteDataSource);

  @override
  Future<NetworkResponse> getOrCreateConversation() async {
    return await remoteDataSource.getOrCreateConversation();
  }

  @override
  Future<NetworkResponse> getMessages({int limit = 50}) async {
    return await remoteDataSource.getMessages(limit: limit);
  }

  @override
  Future<NetworkResponse> sendMessage(SendSupportMessageRequest request) async {
    return await remoteDataSource.sendMessage(request);
  }

  @override
  Future<NetworkResponse> markMessagesAsRead() async {
    return await remoteDataSource.markMessagesAsRead();
  }

  @override
  Future<NetworkResponse> uploadSupportMedia({
    required String fileName,
    required List<int> fileBytes,
  }) async {
    return await remoteDataSource.uploadSupportMedia(
      fileName: fileName,
      fileBytes: fileBytes,
    );
  }
}
