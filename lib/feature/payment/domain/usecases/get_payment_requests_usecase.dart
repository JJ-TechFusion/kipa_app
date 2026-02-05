import '../../../../core/services/network/network_response.dart';
import '../repositories/payment_repository.dart';

class GetPaymentRequestsUseCase {
  final PaymentRepository repository;

  GetPaymentRequestsUseCase(this.repository);

  Future<NetworkResponse> call() async {
    return await repository.getPaymentRequests();
  }
}
