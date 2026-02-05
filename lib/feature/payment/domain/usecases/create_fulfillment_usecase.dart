import '../../../../core/services/network/network_response.dart';
import '../../../location/domain/entities/fulfillment_entity.dart';
import '../repositories/payment_repository.dart';

class CreateFulfillmentUseCase {
  final PaymentRepository repository;

  CreateFulfillmentUseCase(this.repository);

  Future<NetworkResponse> call(
    String paymentRequestId,
    CreateFulfillmentEntity request,
  ) async {
    return await repository.createFulfillment(paymentRequestId, request);
  }
}
