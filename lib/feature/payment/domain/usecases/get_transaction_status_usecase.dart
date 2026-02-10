import '../../../../core/services/network/network_response.dart';
import '../repositories/payment_repository.dart';

class GetTransactionStatusUseCase {
  final PaymentRepository repository;

  GetTransactionStatusUseCase(this.repository);

  Future<NetworkResponse> call(String paymentRequestId) async {
    return await repository.getTransactionStatus(paymentRequestId);
  }
}
