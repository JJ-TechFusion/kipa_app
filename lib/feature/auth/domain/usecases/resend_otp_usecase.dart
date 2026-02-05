import '../../../../core/services/network/network_response.dart';
import '../entities/resend_otp_request_entity.dart';
import '../repositories/auth_repository.dart';

class ResendOtpUseCase {
  final AuthRepository repository;

  ResendOtpUseCase(this.repository);

  Future<NetworkResponse> call(ResendOtpRequest request) async {
    return await repository.resendOtp(request);
  }
}
