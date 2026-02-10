class ApiEndpoints {
  static const String baseUrl =
      'https://bdcc-102-90-100-233.ngrok-free.app/api/v1';

  static const String sendOtpUrl = '/auth/otp/send';
  static const String verifyOtpUrl = '/auth/otp/verify';
  static const String resendOtpUrl = '/auth/otp/resend';
  static const String uploadProfilePictureUrl = '/uploads/profile-picture';
  static const String updateProfileUrl = '/auth/profile';
  static const String getCurrentUserUrl = '/auth/me';
  static const String createPaymentRequestUrl = '/payment-requests';
  static const String paymentRequestHistoryUrl = '/payment-requests/history';

  static String fulfillmentUrl(String paymentRequestId) =>
      '/payment-requests/$paymentRequestId/fulfillment';

  static String initializePaymentUrl(String paymentCode) =>
      '/pay/$paymentCode/initialize';

  static String verifyPaymentUrl(String paymentCode) =>
      '/pay/$paymentCode/verify';

  static String getPaymentDetailsUrl(String paymentCode) => '/pay/$paymentCode';

  static String getTransactionStatusUrl(String paymentRequestId) =>
      '/transactions/$paymentRequestId';

  // Wallet endpoints
  static const String walletUrl = '/wallet';
  static const String walletTopUpUrl = '/wallet/top-up';
  static const String walletTopUpVerifyUrl = '/wallet/top-up/verify';

  // Payment request actions
  static String markReadyForPickupUrl(String paymentRequestId) =>
      '/payment-requests/$paymentRequestId/ready-for-pickup';

  static String cancelRiderSearchUrl(String paymentRequestId) =>
      '/payment-requests/$paymentRequestId/cancel-search';

  // Tracking endpoints
  static String getRiderInfoUrl(String deliveryJobId) =>
      '/tracking/jobs/$deliveryJobId/rider';

  static String getJobDetailsUrl(String deliveryJobId) =>
      '/tracking/jobs/$deliveryJobId';

  static String getRiderLocationUrl(String deliveryJobId) =>
      '/tracking/jobs/$deliveryJobId/location';

  static String getLocationHistoryUrl(String deliveryJobId) =>
      '/tracking/jobs/$deliveryJobId/location/history';

  // Seller sales endpoints
  static const String sellerSalesUrl = '/seller/sales';
  static String sellerSaleByIdUrl(String orderId) => '/seller/sales/$orderId';

  // Buyer purchases endpoints
  static const String buyerPurchasesUrl = '/purchases';
  static String buyerPurchaseByIdUrl(String purchaseId) =>
      '/purchases/$purchaseId';
  static String confirmDeliveryUrl(String purchaseId) =>
      '/purchases/$purchaseId/confirm';

  // Active deliveries endpoint
  static const String activeDeliveriesUrl = '/transactions/active-deliveries';
}
