import '../../../../core/services/network/network_response.dart';
import '../entities/payment_request_entity.dart';
import '../repositories/payment_repository.dart';

class CreatePaymentRequestUseCase {
  final PaymentRepository repository;

  CreatePaymentRequestUseCase(this.repository);

  Future<NetworkResponse> call(CreatePaymentRequestEntity request) async {
    return await repository.createPaymentRequest(request);
  }
}
