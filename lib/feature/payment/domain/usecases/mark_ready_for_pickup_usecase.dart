import '../../../../core/services/network/network_response.dart';
import '../repositories/payment_repository.dart';

class MarkReadyForPickupUseCase {
  final PaymentRepository repository;

  MarkReadyForPickupUseCase(this.repository);

  Future<NetworkResponse> call(String paymentRequestId) async {
    return await repository.markReadyForPickup(paymentRequestId);
  }
}
