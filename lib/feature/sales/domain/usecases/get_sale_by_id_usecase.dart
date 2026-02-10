import '../../../../core/services/network/network_response.dart';
import '../repositories/sales_repository.dart';

class GetSaleByIdUseCase {
  final SalesRepository repository;

  GetSaleByIdUseCase(this.repository);

  Future<NetworkResponse> call(String orderId) async {
    return await repository.getSaleById(orderId);
  }
}
