import '../../../../core/services/network/network_response.dart';
import '../repositories/sales_repository.dart';

class UploadDamageEvidenceUseCase {
  final SalesRepository repository;

  UploadDamageEvidenceUseCase(this.repository);

  Future<NetworkResponse> call({
    required String fileName,
    required List<int> fileBytes,
  }) async {
    return await repository.uploadDamageEvidence(
      fileName: fileName,
      fileBytes: fileBytes,
    );
  }
}
