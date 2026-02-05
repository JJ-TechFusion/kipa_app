import '../../../../core/services/network/network_response.dart';
import '../repositories/payment_repository.dart';

class GetPaymentRequestHistoryUseCase {
  final PaymentRepository repository;

  GetPaymentRequestHistoryUseCase(this.repository);

  Future<NetworkResponse> call() async {
    return await repository.getPaymentRequestHistory();
  }
}
