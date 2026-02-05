import '../../../../core/services/network/network_response.dart';
import '../entities/update_profile_request_entity.dart';
import '../repositories/auth_repository.dart';

class UpdateProfileUseCase {
  final AuthRepository repository;

  UpdateProfileUseCase(this.repository);

  Future<NetworkResponse> call(UpdateProfileRequest request) async {
    return await repository.updateProfile(request);
  }
}
