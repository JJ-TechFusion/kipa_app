class SendOtpRequest {
  final String phoneNumber;
  final String deliveryMethod;
  final String deviceId;

  SendOtpRequest({
    required this.phoneNumber,
    required this.deliveryMethod,
    required this.deviceId,
  });

  Map<String, dynamic> toJson() => {
    'phone_number': phoneNumber,
    'delivery_method': deliveryMethod,
    'device_id': deviceId,
  };
}
