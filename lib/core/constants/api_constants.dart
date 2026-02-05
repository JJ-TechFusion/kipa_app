class ApiEndpoints {
  static const String baseUrl = 'https://1e98c1efd4f2.ngrok-free.app/api/v1';

  static const String sendOtpUrl = '/auth/otp/send';
  static const String verifyOtpUrl = '/auth/otp/verify';
  static const String resendOtpUrl = '/auth/otp/resend';
  static const String uploadProfilePictureUrl = '/uploads/profile-picture';
  static const String updateProfileUrl = '/auth/profile';
  static const String createPaymentRequestUrl = '/payment-requests';
  static const String paymentRequestHistoryUrl = '/payment-requests/history';

  static String fulfillmentUrl(String paymentRequestId) =>
      '/payment-requests/$paymentRequestId/fulfillment';

  static String initializePaymentUrl(String paymentCode) =>
      '/pay/$paymentCode/initialize';

  static String verifyPaymentUrl(String paymentCode) =>
      '/pay/$paymentCode/verify';

  static String getPaymentDetailsUrl(String paymentCode) => '/pay/$paymentCode';

  // Wallet endpoints
  static const String walletUrl = '/wallet';
  static const String walletTopUpUrl = '/wallet/top-up';
  static const String walletTopUpVerifyUrl = '/wallet/top-up/verify';

  // Payment request actions
  static String markReadyForPickupUrl(String paymentRequestId) =>
      '/payment-requests/$paymentRequestId/ready-for-pickup';

  // Tracking endpoints
  static String getRiderInfoUrl(String deliveryJobId) =>
      '/tracking/jobs/$deliveryJobId/rider';

  static String getJobDetailsUrl(String deliveryJobId) =>
      '/tracking/jobs/$deliveryJobId';
}
