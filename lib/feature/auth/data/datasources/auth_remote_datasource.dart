import 'dart:io';
import 'package:dio/dio.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/services/network/api_services.dart';
import '../../../../core/services/network/network_response.dart';
import '../../domain/entities/auth_request_entity.dart';
import '../../domain/entities/verify_otp_request_entity.dart';
import '../../domain/entities/resend_otp_request_entity.dart';
import '../../domain/entities/update_profile_request_entity.dart';
import '../models/user_model.dart';

class AuthRemoteDataSource {
  final ApiService apiService;

  AuthRemoteDataSource(this.apiService);

  Future<NetworkResponse> sendOtp(SendOtpRequest request) async {
    return await apiService.postRequest(
      endpoint: ApiEndpoints.sendOtpUrl,
      requestBody: request.toJson(),
      isProtected: false,
    );
  }

  Future<NetworkResponse> verifyOtp(VerifyOtpRequest request) async {
    return await apiService.postRequest(
      endpoint: ApiEndpoints.verifyOtpUrl,
      requestBody: request.toJson(),
      isProtected: false,
    );
  }

  Future<NetworkResponse> resendOtp(ResendOtpRequest request) async {
    return await apiService.postRequest(
      endpoint: ApiEndpoints.resendOtpUrl,
      requestBody: request.toJson(),
      isProtected: false,
    );
  }

  Future<NetworkResponse> uploadProfilePicture(String filePath) async {
    final file = File(filePath);
    final fileName = file.path.split('/').last;
    final fileBytes = await file.readAsBytes();

    return await apiService.requestWithFile(
      endpoint: ApiEndpoints.uploadProfilePictureUrl,
      fileName: 'file',
      fileBytes: fileBytes,
      mimeType: DioMediaType('image', fileName.split('.').last),
      isProtected: true,
    );
  }

  Future<NetworkResponse> updateProfile(UpdateProfileRequest request) async {
    return await apiService.patchRequest(
      endpoint: ApiEndpoints.updateProfileUrl,
      requestBody: request.toJson(),
      isProtected: true,
    );
  }

  Future<NetworkResponse> getCurrentUser() async {
    final response = await apiService.getRequest(
      endpoint: ApiEndpoints.getCurrentUserUrl,
      isProtected: true,
    );

    if (response.success && response.data != null) {
      final dataMap = response.data as Map<String, dynamic>;
      return NetworkResponse(
        success: true,
        data: UserModel.fromJson(dataMap).toEntity(),
        message: response.message,
      );
    }
    return response;
  }

  Future<NetworkResponse> logout() async {
    return await apiService.postRequest(
      endpoint: ApiEndpoints.logoutUrl,
      requestBody: {},
      isProtected: true,
    );
  }
}
