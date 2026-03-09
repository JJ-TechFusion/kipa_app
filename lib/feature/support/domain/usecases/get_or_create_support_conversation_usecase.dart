import '../../../../core/services/network/network_response.dart';
import '../repositories/support_repository.dart';

class GetOrCreateSupportConversationUseCase {
  final SupportRepository repository;

  GetOrCreateSupportConversationUseCase(this.repository);

  Future<NetworkResponse> call() async {
    return await repository.getOrCreateConversation();
  }
}
