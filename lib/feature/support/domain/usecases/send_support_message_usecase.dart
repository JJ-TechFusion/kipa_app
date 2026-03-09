import '../../../../core/services/network/network_response.dart';
import '../entities/support_request_entity.dart';
import '../repositories/support_repository.dart';

class SendSupportMessageUseCase {
  final SupportRepository repository;

  SendSupportMessageUseCase(this.repository);

  Future<NetworkResponse> call(SendSupportMessageRequest request) async {
    return await repository.sendMessage(request);
  }
}
