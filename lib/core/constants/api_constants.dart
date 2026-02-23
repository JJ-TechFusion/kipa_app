class ApiEndpoints {
  static const String baseUrl = 'https://staging.getkipa.com/api/v1';

  static const String sendOtpUrl = '/auth/otp/send';
  static const String verifyOtpUrl = '/auth/otp/verify';
  static const String resendOtpUrl = '/auth/otp/resend';
  static const String uploadProfilePictureUrl = '/uploads/profile-picture';
  static const String updateProfileUrl = '/auth/profile';
  static const String getCurrentUserUrl = '/auth/me';
  static const String logoutUrl = '/auth/logout';
  static const String deleteAccountUrl = '/auth/account';
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
  static const String walletTransactionsUrl = '/wallet/transactions';
  static const String walletPendingUrl = '/wallet/pending';

  // Wallet PIN endpoints
  static const String walletPinStatusUrl = '/wallet/pin/status';
  static const String walletPinUrl = '/wallet/pin';
  static const String walletPinVerifyUrl = '/wallet/pin/verify';
  static const String walletPinResetRequestUrl = '/wallet/pin/reset/request';
  static const String walletPinResetConfirmUrl = '/wallet/pin/reset/confirm';

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

  static String readyForReturnUrl(String purchaseId) =>
      '/purchases/$purchaseId/ready-for-return';

  static String rebookDeliveryUrl(String purchaseId) =>
      '/purchases/$purchaseId/rebook';

  static String confirmReturnUrl(String orderId) =>
      '/seller/sales/$orderId/confirm-return';

  // Dispute endpoints
  static String openDisputeUrl(String purchaseId) =>
      '/purchases/$purchaseId/dispute';

  static const String disputesUrl = '/disputes';
  static String disputeByIdUrl(String id) => '/disputes/$id';

  static const String uploadDisputeEvidenceUrl = '/uploads/dispute-evidence';
  static const String uploadItemImageUrl = '/uploads/item-image';

  // Active deliveries endpoint
  static const String activeDeliveriesUrl = '/transactions/active-deliveries';

  // Device token registration
  static const String registerDeviceTokenUrl = '/users/device-token';

  // Chat endpoints
  static String chatHistoryUrl(String jobId) => '/chat/$jobId/history';
  static String markReadUrl(String jobId) => '/chat/$jobId/read';
  static String unreadCountUrl(String jobId) => '/chat/$jobId/unread';

  // Errand endpoints
  static const String errandsUrl = '/errands';
  static const String activeErrandUrl = '/errands/active';
  static String errandByIdUrl(String id) => '/errands/$id';
  static String confirmErrandUrl(String id) => '/errands/$id/confirm';
  static String completeErrandUrl(String id) => '/errands/$id/complete';

  // Logistics shipping endpoint (interstate delivery)
  static String shipLogisticsDeliveryUrl(String logisticsDeliveryId) =>
      '/logistics/$logisticsDeliveryId/ship';

  // Shipment receipt upload
  static const String uploadShipmentReceiptUrl = '/uploads/shipment-receipt';

  // Logistics deliveries (interstate)
  static const String logisticsSellerUrl = '/logistics/seller';
  static const String logisticsBuyerUrl = '/logistics/buyer';

  // Logistics delivery details
  static String logisticsDetailsUrl(String logisticsDeliveryId) =>
      '/logistics/$logisticsDeliveryId/details';

  // Logistics buyer actions
  static String claimLogisticsDeliveryUrl(String logisticsDeliveryId) =>
      '/logistics/$logisticsDeliveryId/claim-delivery';

  static String confirmLogisticsDeliveryUrl(String logisticsDeliveryId) =>
      '/logistics/$logisticsDeliveryId/confirm';

  // Delivery proof upload
  static const String uploadDeliveryProofUrl = '/uploads/shipment-receipt';

  // Logistics dispute
  static String openLogisticsDisputeUrl(String logisticsDeliveryId) =>
      '/logistics/$logisticsDeliveryId/dispute';

  // Logistics return flow
  static String returnShippedUrl(String logisticsDeliveryId) =>
      '/logistics/$logisticsDeliveryId/return-shipped';

  static String confirmLogisticsReturnUrl(String logisticsDeliveryId) =>
      '/logistics/$logisticsDeliveryId/confirm-return';
}
