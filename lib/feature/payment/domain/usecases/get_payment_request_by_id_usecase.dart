import '../../../../core/services/network/network_response.dart';
import '../repositories/payment_repository.dart';

class GetPaymentRequestByIdUseCase {
  final PaymentRepository repository;

  GetPaymentRequestByIdUseCase(this.repository);

  Future<NetworkResponse> call(String paymentRequestId) async {
    return await repository.getPaymentRequestById(paymentRequestId);
  }
}
