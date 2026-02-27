import '../../../../core/services/network/network_response.dart';
import '../repositories/payment_repository.dart';

class GetTransactionsUseCase {
  final PaymentRepository repository;

  GetTransactionsUseCase(this.repository);

  Future<NetworkResponse> call({String? status}) {
    return repository.getTransactions(status: status);
  }
}
