import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/services/device/device_info_service.dart';
import '../../../../core/services/storage/secure_storage.dart';
import '../../../../utils/constant.dart';
import '../../domain/entities/auth_request_entity.dart';
import '../../domain/entities/resend_otp_request_entity.dart';
import '../../domain/entities/update_profile_request_entity.dart';
import '../../domain/entities/verify_otp_request_entity.dart';
import '../../domain/usecases/resend_otp_usecase.dart';
import '../../domain/usecases/send_otp_usecase.dart';
import '../../domain/usecases/upload_profile_picture_usecase.dart';
import '../../domain/usecases/update_profile_usecase.dart';
import '../../domain/usecases/verify_otp_usecase.dart';
import '../../domain/usecases/get_current_user_usecase.dart';
import '../../domain/entities/user_entity.dart';
import '../providers/auth_provider.dart';
import 'auth_state.dart';

class AuthNotifier extends Notifier<AuthState> {
  late final SendOtpUseCase _sendOtpUseCase;
  late final VerifyOtpUseCase _verifyOtpUseCase;
  late final ResendOtpUseCase _resendOtpUseCase;
  late final UploadProfilePictureUseCase _uploadProfilePictureUseCase;
  late final UpdateProfileUseCase _updateProfileUseCase;
  late final GetCurrentUserUseCase _getCurrentUserUseCase;
  late final DeviceInfoService _deviceInfoService;

  @override
  AuthState build() {
    _sendOtpUseCase = ref.read(sendOtpUseCaseProvider);
    _verifyOtpUseCase = ref.read(verifyOtpUseCaseProvider);
    _resendOtpUseCase = ref.read(resendOtpUseCaseProvider);
    _uploadProfilePictureUseCase = ref.read(
      uploadProfilePictureUseCaseProvider,
    );
    _updateProfileUseCase = ref.read(updateProfileUseCaseProvider);
    _getCurrentUserUseCase = ref.read(getCurrentUserUseCaseProvider);
    _deviceInfoService = ref.read(deviceInfoServiceProvider);
    return const AuthState();
  }

  Future<void> sendOtp(String phoneNumber, String deliveryMethod) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final deviceId = await _deviceInfoService.getDeviceId();

      final request = SendOtpRequest(
        phoneNumber: phoneNumber,
        deliveryMethod: deliveryMethod,
        deviceId: deviceId,
      );

      final response = await _sendOtpUseCase(request);

      if (response.success) {
        state = state.copyWith(
          isLoading: false,
          response: response,
          verificationId: response.data?['verification_id'],
          idempotencyKey: response.data?['idempotency_key'],
          retryAfterSeconds: response.data?['retry_after_seconds'] ?? 60,
        );
      } else {
        state = state.copyWith(
          isLoading: false,
          errorMessage: response.message,
        );
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  Future<void> verifyOtp({
    required String phoneNumber,
    required String otpCode,
    required String verificationId,
    required String idempotencyKey,
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final deviceId = await _deviceInfoService.getDeviceId();

      final request = VerifyOtpRequest(
        phoneNumber: phoneNumber,
        verificationId: verificationId,
        otpCode: otpCode,
        deviceId: deviceId,
        idempotencyKey: idempotencyKey,
      );

      final response = await _verifyOtpUseCase(request);

      if (response.success) {
        // Store tokens
        final accessToken = response.data?['access_token'];
        final refreshToken = response.data?['refresh_token'];
        final isNewUser = response.data?['is_new_user'] ?? false;

        final secureStorage = getIt<SecureStorageService>();
        if (accessToken != null) {
          await secureStorage.writeData('access_token', accessToken);
        }
        if (refreshToken != null) {
          await secureStorage.writeData('refresh_token', refreshToken);
        }

        // If not a new user, profile is already complete
        if (!isNewUser) {
          await secureStorage.writeData('profile_completed', 'true');
        }

        state = state.copyWith(isLoading: false, response: response);
      } else {
        state = state.copyWith(
          isLoading: false,
          errorMessage: response.message,
        );
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  Future<void> resendOtp(String phoneNumber) async {
    state = state.copyWith(isResending: true, errorMessage: null);

    try {
      final deviceId = await _deviceInfoService.getDeviceId();

      final request = ResendOtpRequest(
        phoneNumber: phoneNumber,
        deviceId: deviceId,
      );

      final response = await _resendOtpUseCase(request);

      if (response.success) {
        state = state.copyWith(
          isResending: false,
          response: response,
          retryAfterSeconds: response.data?['retry_after_seconds'] ?? 60,
        );
      } else {
        state = state.copyWith(
          isResending: false,
          errorMessage: response.message,
        );
      }
    } catch (e) {
      state = state.copyWith(isResending: false, errorMessage: e.toString());
    }
  }

  void clearError() {
    state = state.copyWith(errorMessage: null);
  }

  Future<void> uploadProfilePicture(String filePath) async {
    state = state.copyWith(isUploadingImage: true, errorMessage: null);

    try {
      final response = await _uploadProfilePictureUseCase(filePath);

      if (response.success) {
        final imageUrl = response.data?['url'];
        state = state.copyWith(
          isUploadingImage: false,
          uploadedImageUrl: imageUrl,
          response: response,
        );
      } else {
        state = state.copyWith(
          isUploadingImage: false,
          errorMessage: response.message,
        );
      }
    } catch (e) {
      state = state.copyWith(
        isUploadingImage: false,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> updateProfile({
    required String firstName,
    required String lastName,
    required String email,
    String? profilePhotoUrl,
  }) async {
    state = state.copyWith(isUpdatingProfile: true, errorMessage: null);

    try {
      final request = UpdateProfileRequest(
        firstName: firstName,
        lastName: lastName,
        email: email,
        profilePhotoUrl: profilePhotoUrl,
      );

      final response = await _updateProfileUseCase(request);

      if (response.success) {
        // Mark profile as completed
        final secureStorage = getIt<SecureStorageService>();
        await secureStorage.writeData('profile_completed', 'true');

        state = state.copyWith(isUpdatingProfile: false, response: response);
      } else {
        state = state.copyWith(
          isUpdatingProfile: false,
          errorMessage: response.message,
        );
      }
    } catch (e) {
      state = state.copyWith(
        isUpdatingProfile: false,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> fetchCurrentUser() async {
    state = state.copyWith(isFetchingUser: true, errorMessage: null);

    try {
      final response = await _getCurrentUserUseCase();

      if (response.success && response.data != null) {
        state = state.copyWith(
          isFetchingUser: false,
          currentUser: response.data as UserEntity,
        );
      } else {
        state = state.copyWith(
          isFetchingUser: false,
          errorMessage: response.message,
        );
      }
    } catch (e) {
      state = state.copyWith(
        isFetchingUser: false,
        errorMessage: e.toString(),
      );
    }
  }
}
