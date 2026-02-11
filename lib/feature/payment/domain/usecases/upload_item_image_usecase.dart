import '../../../../core/services/network/network_response.dart';
import '../repositories/payment_repository.dart';

class UploadItemImageUseCase {
  final PaymentRepository repository;

  UploadItemImageUseCase(this.repository);

  Future<NetworkResponse> call({
    required String fileName,
    required List<int> fileBytes,
  }) async {
    return await repository.uploadItemImage(
      fileName: fileName,
      fileBytes: fileBytes,
    );
  }
}
