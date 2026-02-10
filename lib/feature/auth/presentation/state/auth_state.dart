import '../../../../core/services/network/network_response.dart';
import '../../domain/entities/user_entity.dart';

class AuthState {
  final bool isLoading;
  final bool isResending;
  final bool isUploadingImage;
  final bool isUpdatingProfile;
  final bool isFetchingUser;
  final String? errorMessage;
  final NetworkResponse? response;
  final String? verificationId;
  final String? idempotencyKey;
  final int retryAfterSeconds;
  final String? uploadedImageUrl;
  final UserEntity? currentUser;

  const AuthState({
    this.isLoading = false,
    this.isResending = false,
    this.isUploadingImage = false,
    this.isUpdatingProfile = false,
    this.isFetchingUser = false,
    this.errorMessage,
    this.response,
    this.verificationId,
    this.idempotencyKey,
    this.retryAfterSeconds = 60,
    this.uploadedImageUrl,
    this.currentUser,
  });

  AuthState copyWith({
    bool? isLoading,
    bool? isResending,
    bool? isUploadingImage,
    bool? isUpdatingProfile,
    bool? isFetchingUser,
    String? errorMessage,
    NetworkResponse? response,
    String? verificationId,
    String? idempotencyKey,
    int? retryAfterSeconds,
    String? uploadedImageUrl,
    UserEntity? currentUser,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      isResending: isResending ?? this.isResending,
      isUploadingImage: isUploadingImage ?? this.isUploadingImage,
      isUpdatingProfile: isUpdatingProfile ?? this.isUpdatingProfile,
      isFetchingUser: isFetchingUser ?? this.isFetchingUser,
      errorMessage: errorMessage,
      response: response ?? this.response,
      verificationId: verificationId ?? this.verificationId,
      idempotencyKey: idempotencyKey ?? this.idempotencyKey,
      retryAfterSeconds: retryAfterSeconds ?? this.retryAfterSeconds,
      uploadedImageUrl: uploadedImageUrl ?? this.uploadedImageUrl,
      currentUser: currentUser ?? this.currentUser,
    );
  }
}
