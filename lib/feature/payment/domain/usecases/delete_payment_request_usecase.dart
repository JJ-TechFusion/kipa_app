import 'package:kipa/core/services/network/network_response.dart';
import 'package:kipa/feature/payment/domain/repositories/payment_repository.dart';

class DeletePaymentRequestUseCase {
  final PaymentRepository repository;

  DeletePaymentRequestUseCase(this.repository);

  Future<NetworkResponse> call(String id) async {
    return await repository.deletePaymentRequest(id);
  }
}
