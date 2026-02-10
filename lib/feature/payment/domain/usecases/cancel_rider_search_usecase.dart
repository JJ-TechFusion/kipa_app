import '../../../../core/services/network/network_response.dart';
import '../repositories/payment_repository.dart';

class CancelRiderSearchUseCase {
  final PaymentRepository repository;

  CancelRiderSearchUseCase(this.repository);

  Future<NetworkResponse> call(String paymentRequestId) async {
    return await repository.cancelRiderSearch(paymentRequestId);
  }
}
