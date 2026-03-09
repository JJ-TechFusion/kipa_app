import '../../../../core/services/network/network_response.dart';
import '../repositories/support_repository.dart';

class GetSupportMessagesUseCase {
  final SupportRepository repository;

  GetSupportMessagesUseCase(this.repository);

  Future<NetworkResponse> call({int limit = 50}) async {
    return await repository.getMessages(limit: limit);
  }
}
