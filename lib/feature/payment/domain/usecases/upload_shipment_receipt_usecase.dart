import '../../../../core/services/network/network_response.dart';
import '../repositories/payment_repository.dart';

class UploadShipmentReceiptUseCase {
  final PaymentRepository repository;

  UploadShipmentReceiptUseCase(this.repository);

  Future<NetworkResponse> call({
    required String fileName,
    required List<int> fileBytes,
  }) async {
    return await repository.uploadShipmentReceipt(
      fileName: fileName,
      fileBytes: fileBytes,
    );
  }
}
