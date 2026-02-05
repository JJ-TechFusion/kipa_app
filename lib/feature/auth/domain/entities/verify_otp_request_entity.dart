class VerifyOtpRequest {
  final String phoneNumber;
  final String verificationId;
  final String otpCode;
  final String deviceId;
  final String idempotencyKey;

  VerifyOtpRequest({
    required this.phoneNumber,
    required this.verificationId,
    required this.otpCode,
    required this.deviceId,
    required this.idempotencyKey,
  });

  Map<String, dynamic> toJson() => {
    'phone_number': phoneNumber,
    'verification_id': verificationId,
    'otp_code': otpCode,
    'device_id': deviceId,
    'idempotency_key': idempotencyKey,
  };
}
