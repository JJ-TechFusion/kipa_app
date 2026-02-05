import 'package:kipa/core/services/network/network_response.dart';
import 'package:kipa/feature/payment/domain/repositories/payment_repository.dart';

class UpdatePaymentRequestUseCase {
  final PaymentRepository repository;

  UpdatePaymentRequestUseCase(this.repository);

  Future<NetworkResponse> call(String id, Map<String, dynamic> data) async {
    return await repository.updatePaymentRequest(id, data);
  }
}
