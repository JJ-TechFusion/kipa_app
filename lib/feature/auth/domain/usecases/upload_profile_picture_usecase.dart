import '../../../../core/services/network/network_response.dart';
import '../repositories/auth_repository.dart';

class UploadProfilePictureUseCase {
  final AuthRepository repository;

  UploadProfilePictureUseCase(this.repository);

  Future<NetworkResponse> call(String filePath) async {
    return await repository.uploadProfilePicture(filePath);
  }
}
