import '../../../../core/services/network/network_response.dart';
import '../repositories/support_repository.dart';

class MarkSupportMessagesReadUseCase {
  final SupportRepository repository;

  MarkSupportMessagesReadUseCase(this.repository);

  Future<NetworkResponse> call() async {
    return await repository.markMessagesAsRead();
  }
}
