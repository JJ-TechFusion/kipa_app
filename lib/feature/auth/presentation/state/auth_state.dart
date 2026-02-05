import '../../../../core/services/network/network_response.dart';

class AuthState {
  final bool isLoading;
  final bool isResending;
  final bool isUploadingImage;
  final bool isUpdatingProfile;
  final String? errorMessage;
  final NetworkResponse? response;
  final String? verificationId;
  final String? idempotencyKey;
  final int retryAfterSeconds;
  final String? uploadedImageUrl;

  const AuthState({
    this.isLoading = false,
    this.isResending = false,
    this.isUploadingImage = false,
    this.isUpdatingProfile = false,
    this.errorMessage,
    this.response,
    this.verificationId,
    this.idempotencyKey,
    this.retryAfterSeconds = 60,
    this.uploadedImageUrl,
  });

  AuthState copyWith({
    bool? isLoading,
    bool? isResending,
    bool? isUploadingImage,
    bool? isUpdatingProfile,
    String? errorMessage,
    NetworkResponse? response,
    String? verificationId,
    String? idempotencyKey,
    int? retryAfterSeconds,
    String? uploadedImageUrl,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      isResending: isResending ?? this.isResending,
      isUploadingImage: isUploadingImage ?? this.isUploadingImage,
      isUpdatingProfile: isUpdatingProfile ?? this.isUpdatingProfile,
      errorMessage: errorMessage,
      response: response ?? this.response,
      verificationId: verificationId ?? this.verificationId,
      idempotencyKey: idempotencyKey ?? this.idempotencyKey,
      retryAfterSeconds: retryAfterSeconds ?? this.retryAfterSeconds,
      uploadedImageUrl: uploadedImageUrl ?? this.uploadedImageUrl,
    );
  }
}
