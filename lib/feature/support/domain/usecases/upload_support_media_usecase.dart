import '../../../../core/services/network/network_response.dart';
import '../repositories/support_repository.dart';

class UploadSupportMediaUseCase {
  final SupportRepository repository;

  UploadSupportMediaUseCase(this.repository);

  Future<NetworkResponse> call({
    required String fileName,
    required List<int> fileBytes,
  }) async {
    return await repository.uploadSupportMedia(
      fileName: fileName,
      fileBytes: fileBytes,
    );
  }
}
