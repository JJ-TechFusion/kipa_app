import '../../../../core/services/network/network_response.dart';
import '../repositories/purchases_repository.dart';

class UploadDisputeEvidenceUseCase {
  final PurchasesRepository repository;

  UploadDisputeEvidenceUseCase(this.repository);

  Future<NetworkResponse> call({
    required String fileName,
    required List<int> fileBytes,
  }) async {
    return await repository.uploadDisputeEvidence(
      fileName: fileName,
      fileBytes: fileBytes,
    );
  }
}
