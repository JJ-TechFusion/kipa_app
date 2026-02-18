import '../../../../core/services/network/network_response.dart';
import '../entities/ship_logistics_entity.dart';
import '../repositories/payment_repository.dart';

class ShipLogisticsDeliveryUseCase {
  final PaymentRepository repository;

  ShipLogisticsDeliveryUseCase(this.repository);

  Future<NetworkResponse> call(
    String logisticsDeliveryId,
    ShipLogisticsEntity request,
  ) async {
    return await repository.shipLogisticsDelivery(logisticsDeliveryId, request);
  }
}
