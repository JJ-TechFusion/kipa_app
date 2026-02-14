import '../../../../core/services/network/network_response.dart';
import '../entities/entities.dart';

abstract class AuthRepository {
  Future<NetworkResponse> sendOtp(SendOtpRequest request);
  Future<NetworkResponse> verifyOtp(VerifyOtpRequest request);
  Future<NetworkResponse> resendOtp(ResendOtpRequest request);
  Future<NetworkResponse> uploadProfilePicture(String filePath);
  Future<NetworkResponse> updateProfile(UpdateProfileRequest request);
  Future<NetworkResponse> getCurrentUser();
  Future<NetworkResponse> logout();
  Future<NetworkResponse> deleteUser();
}
