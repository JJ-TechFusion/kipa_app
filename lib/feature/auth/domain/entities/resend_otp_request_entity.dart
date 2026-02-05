class ResendOtpRequest {
  final String phoneNumber;
  final String deviceId;

  ResendOtpRequest({required this.phoneNumber, required this.deviceId});

  Map<String, dynamic> toJson() => {
    'phone_number': phoneNumber,
    'device_id': deviceId,
  };
}
