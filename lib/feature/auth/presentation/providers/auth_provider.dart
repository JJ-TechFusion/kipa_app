import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/services/device/device_info_service.dart';
import '../../../../core/services/network/api_services.dart';
import '../../../../utils/constant.dart';
import '../../data/datasources/auth_remote_datasource.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/send_otp_usecase.dart';
import '../../domain/usecases/verify_otp_usecase.dart';
import '../../domain/usecases/resend_otp_usecase.dart';
import '../../domain/usecases/upload_profile_picture_usecase.dart';
import '../../domain/usecases/update_profile_usecase.dart';
import '../state/auth_notifier.dart';
import '../state/auth_state.dart';

// Device Info Service
final deviceInfoServiceProvider = Provider<DeviceInfoService>((ref) {
  return DeviceInfoService();
});

// Data Sources
final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
  return AuthRemoteDataSource(getIt<ApiService>());
});

// Repository
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(ref.read(authRemoteDataSourceProvider));
});

// Use Cases
final sendOtpUseCaseProvider = Provider<SendOtpUseCase>((ref) {
  return SendOtpUseCase(ref.read(authRepositoryProvider));
});

final verifyOtpUseCaseProvider = Provider<VerifyOtpUseCase>((ref) {
  return VerifyOtpUseCase(ref.read(authRepositoryProvider));
});

final resendOtpUseCaseProvider = Provider<ResendOtpUseCase>((ref) {
  return ResendOtpUseCase(ref.read(authRepositoryProvider));
});

final uploadProfilePictureUseCaseProvider =
    Provider<UploadProfilePictureUseCase>((ref) {
      return UploadProfilePictureUseCase(ref.read(authRepositoryProvider));
    });

final updateProfileUseCaseProvider = Provider<UpdateProfileUseCase>((ref) {
  return UpdateProfileUseCase(ref.read(authRepositoryProvider));
});

// State Notifier
final authNotifierProvider = NotifierProvider<AuthNotifier, AuthState>(() {
  return AuthNotifier();
});
