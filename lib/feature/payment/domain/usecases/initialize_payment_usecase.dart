import '../../../../core/services/network/network_response.dart';
import '../entities/payment_buyer_entities.dart';
import '../repositories/payment_repository.dart';

class InitializePaymentUseCase {
  final PaymentRepository repository;

  InitializePaymentUseCase(this.repository);

  Future<NetworkResponse> call(
    String paymentCode,
    InitializePaymentEntity request,
  ) async {
    return await repository.initializePayment(paymentCode, request);
  }
}
