import '../../../../core/services/network/network_response.dart';
import '../entities/auth_request_entity.dart';
import '../repositories/auth_repository.dart';

class SendOtpUseCase {
  final AuthRepository repository;

  SendOtpUseCase(this.repository);

  Future<NetworkResponse> call(SendOtpRequest request) async {
    return await repository.sendOtp(request);
  }
}
