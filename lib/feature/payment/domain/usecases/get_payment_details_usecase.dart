import '../../../../core/services/network/network_response.dart';
import '../repositories/payment_repository.dart';

class GetPaymentDetailsUseCase {
  final PaymentRepository repository;

  GetPaymentDetailsUseCase(this.repository);

  Future<NetworkResponse> call(String paymentCode) async {
    return await repository.getPaymentDetails(paymentCode);
  }
}
