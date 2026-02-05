import '../../../../core/services/network/network_response.dart';
import '../repositories/payment_repository.dart';

class VerifyPaymentUseCase {
  final PaymentRepository repository;

  VerifyPaymentUseCase(this.repository);

  Future<NetworkResponse> call(String paymentCode, String reference) async {
    return await repository.verifyPayment(paymentCode, reference);
  }
}
