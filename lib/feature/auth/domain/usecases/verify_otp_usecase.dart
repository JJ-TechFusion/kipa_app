import '../../../../core/services/network/network_response.dart';
import '../entities/verify_otp_request_entity.dart';
import '../repositories/auth_repository.dart';

class VerifyOtpUseCase {
  final AuthRepository repository;

  VerifyOtpUseCase(this.repository);

  Future<NetworkResponse> call(VerifyOtpRequest request) async {
    return await repository.verifyOtp(request);
  }
}
