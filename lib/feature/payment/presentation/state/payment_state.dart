import '../../domain/entities/payment_request_entity.dart';
import '../../domain/entities/payment_buyer_entities.dart';
import '../../../location/domain/entities/fulfillment_entity.dart';
import '../../../location/domain/entities/location_entity.dart';
import '../../../../core/services/network/network_response.dart';

class PaymentState {
  final bool isLoading;
  final bool isCreatingPaymentRequest;
  final bool isUpdatingPaymentRequest;
  final bool isDeletingPaymentRequest;
  final bool isFetchingPaymentRequests;
  final bool isFetchingPaymentHistory;
  final bool isFetchingPaymentRequestDetails;
  final bool isCreatingFulfillment;
  final bool isInitializingPayment;
  final bool isVerifyingPayment;
  final bool isMarkingReadyForPickup;
  final bool isCancellingRiderSearch;
  final bool isUploadingItemImage;
  final String? errorMessage;
  final PaymentRequestResponseEntity? createdPaymentRequest;
  final NetworkResponse? deleteResponse;
  final List<PaymentRequestResponseEntity>? paymentRequests;
  final PaymentRequestResponseEntity? paymentRequestDetails;
  final List<PaymentRequestResponseEntity>? paymentRequestHistory;
  final FulfillmentResponseEntity? fulfillmentResponse;
  final LocationEntity? pickupLocation;
  final LocationEntity? dropoffLocation;
  final InitializePaymentResponseEntity? initializePaymentResponse;
  final VerifyPaymentResponseEntity? verifyPaymentResponse;
  final PaymentDetailsEntity? paymentDetails;
  final bool isFetchingPaymentDetails;
  final MarkReadyForPickupResponseEntity? markReadyResponse;

  const PaymentState({
    this.isLoading = false,
    this.isCreatingPaymentRequest = false,
    this.isUpdatingPaymentRequest = false,
    this.isDeletingPaymentRequest = false,
    this.isFetchingPaymentRequests = false,
    this.isFetchingPaymentRequestDetails = false,
    this.isFetchingPaymentHistory = false,
    this.isCreatingFulfillment = false,
    this.isInitializingPayment = false,
    this.isVerifyingPayment = false,
    this.isMarkingReadyForPickup = false,
    this.isCancellingRiderSearch = false,
    this.isUploadingItemImage = false,
    this.isFetchingPaymentDetails = false,
    this.errorMessage,
    this.createdPaymentRequest,
    this.deleteResponse,
    this.paymentRequests,
    this.paymentRequestDetails,
    this.paymentRequestHistory,
    this.fulfillmentResponse,
    this.pickupLocation,
    this.dropoffLocation,
    this.initializePaymentResponse,
    this.verifyPaymentResponse,
    this.paymentDetails,
    this.markReadyResponse,
  });

  PaymentState copyWith({
    bool? isLoading,
    bool? isCreatingPaymentRequest,
    bool? isUpdatingPaymentRequest,
    bool? isDeletingPaymentRequest,
    bool? isFetchingPaymentRequests,
    bool? isFetchingPaymentRequestDetails,
    bool? isFetchingPaymentHistory,
    bool? isCreatingFulfillment,
    bool? isInitializingPayment,
    bool? isVerifyingPayment,
    bool? isMarkingReadyForPickup,
    bool? isCancellingRiderSearch,
    bool? isUploadingItemImage,
    bool? isFetchingPaymentDetails,
    String? errorMessage,
    PaymentRequestResponseEntity? createdPaymentRequest,
    NetworkResponse? deleteResponse,
    List<PaymentRequestResponseEntity>? paymentRequests,
    PaymentRequestResponseEntity? paymentRequestDetails,
    List<PaymentRequestResponseEntity>? paymentRequestHistory,
    FulfillmentResponseEntity? fulfillmentResponse,
    LocationEntity? pickupLocation,
    LocationEntity? dropoffLocation,
    InitializePaymentResponseEntity? initializePaymentResponse,
    VerifyPaymentResponseEntity? verifyPaymentResponse,
    PaymentDetailsEntity? paymentDetails,
    MarkReadyForPickupResponseEntity? markReadyResponse,
  }) {
    return PaymentState(
      isLoading: isLoading ?? this.isLoading,
      isCreatingPaymentRequest:
          isCreatingPaymentRequest ?? this.isCreatingPaymentRequest,
      isUpdatingPaymentRequest:
          isUpdatingPaymentRequest ?? this.isUpdatingPaymentRequest,
      isDeletingPaymentRequest:
          isDeletingPaymentRequest ?? this.isDeletingPaymentRequest,
      isFetchingPaymentRequests:
          isFetchingPaymentRequests ?? this.isFetchingPaymentRequests,
      isFetchingPaymentRequestDetails:
          isFetchingPaymentRequestDetails ?? this.isFetchingPaymentRequestDetails,
      isFetchingPaymentHistory:
          isFetchingPaymentHistory ?? this.isFetchingPaymentHistory,
      isCreatingFulfillment:
          isCreatingFulfillment ?? this.isCreatingFulfillment,
      isInitializingPayment:
          isInitializingPayment ?? this.isInitializingPayment,
      isVerifyingPayment: isVerifyingPayment ?? this.isVerifyingPayment,
      isMarkingReadyForPickup:
          isMarkingReadyForPickup ?? this.isMarkingReadyForPickup,
      isCancellingRiderSearch:
          isCancellingRiderSearch ?? this.isCancellingRiderSearch,
      isUploadingItemImage: isUploadingItemImage ?? this.isUploadingItemImage,
      isFetchingPaymentDetails:
          isFetchingPaymentDetails ?? this.isFetchingPaymentDetails,
      errorMessage: errorMessage,
      createdPaymentRequest:
          createdPaymentRequest ?? this.createdPaymentRequest,
      deleteResponse: deleteResponse ?? this.deleteResponse,
      paymentRequests: paymentRequests ?? this.paymentRequests,
      paymentRequestDetails:
          paymentRequestDetails ?? this.paymentRequestDetails,
      paymentRequestHistory:
          paymentRequestHistory ?? this.paymentRequestHistory,
      fulfillmentResponse: fulfillmentResponse ?? this.fulfillmentResponse,
      pickupLocation: pickupLocation ?? this.pickupLocation,
      dropoffLocation: dropoffLocation ?? this.dropoffLocation,
      initializePaymentResponse:
          initializePaymentResponse ?? this.initializePaymentResponse,
      verifyPaymentResponse:
          verifyPaymentResponse ?? this.verifyPaymentResponse,
      paymentDetails: paymentDetails ?? this.paymentDetails,
      markReadyResponse: markReadyResponse ?? this.markReadyResponse,
    );
  }
}
