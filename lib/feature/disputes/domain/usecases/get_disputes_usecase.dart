import '../../../../core/services/network/network_response.dart';
import '../repositories/disputes_repository.dart';

class GetDisputesUseCase {
  final DisputesRepository repository;

  GetDisputesUseCase(this.repository);

  Future<NetworkResponse> call() => repository.getDisputes();
}
