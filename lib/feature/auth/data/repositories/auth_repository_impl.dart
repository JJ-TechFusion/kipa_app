import '../../../../core/services/network/network_response.dart';
import '../../domain/entities/entities.dart';

import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl(this.remoteDataSource);

  @override
  Future<NetworkResponse> sendOtp(SendOtpRequest request) async {
    return await remoteDataSource.sendOtp(request);
  }

  @override
  Future<NetworkResponse> verifyOtp(VerifyOtpRequest request) async {
    return await remoteDataSource.verifyOtp(request);
  }

  @override
  Future<NetworkResponse> resendOtp(ResendOtpRequest request) async {
    return await remoteDataSource.resendOtp(request);
  }

  @override
  Future<NetworkResponse> uploadProfilePicture(String filePath) async {
    return await remoteDataSource.uploadProfilePicture(filePath);
  }

  @override
  Future<NetworkResponse> updateProfile(UpdateProfileRequest request) async {
    return await remoteDataSource.updateProfile(request);
  }

  @override
  Future<NetworkResponse> getCurrentUser() async {
    return await remoteDataSource.getCurrentUser();
  }

  @override
  Future<NetworkResponse> logout() async {
    return await remoteDataSource.logout();
  }

  @override
  Future<NetworkResponse> deleteUser() async {
    // TODO: implement deleteUser
    // To be done.
    throw UnimplementedError();
  }
}
