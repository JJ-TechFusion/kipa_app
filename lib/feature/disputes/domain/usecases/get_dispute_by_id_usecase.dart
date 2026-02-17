import '../../../../core/services/network/network_response.dart';
import '../repositories/disputes_repository.dart';

class GetDisputeByIdUseCase {
  final DisputesRepository repository;

  GetDisputeByIdUseCase(this.repository);

  Future<NetworkResponse> call(String id) => repository.getDisputeById(id);
}
