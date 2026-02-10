import '../../../../core/services/network/network_response.dart';
import '../repositories/sales_repository.dart';

class GetSalesUseCase {
  final SalesRepository repository;

  GetSalesUseCase(this.repository);

  Future<NetworkResponse> call() async {
    return await repository.getSales();
  }
}
