import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/payment_request_entity.dart';
import '../../domain/usecases/create_payment_request_usecase.dart';
import '../../domain/usecases/update_payment_request_usecase.dart';
import '../../domain/usecases/delete_payment_request_usecase.dart';
import '../../domain/usecases/create_fulfillment_usecase.dart';
import '../../data/models/payment_request_model.dart';
import '../../../location/domain/entities/fulfillment_entity.dart';
import '../../../location/domain/entities/location_entity.dart';
import '../providers/payment_provider.dart';
import 'payment_state.dart';
import '../../domain/usecases/get_payment_requests_usecase.dart';
import '../../domain/usecases/get_payment_request_by_id_usecase.dart';
import '../../domain/usecases/get_payment_request_history_usecase.dart';
import '../../domain/entities/payment_buyer_entities.dart';
import '../../domain/usecases/initialize_payment_usecase.dart';
import '../../domain/usecases/verify_payment_usecase.dart';
import '../../domain/usecases/get_payment_details_usecase.dart';
import '../../domain/usecases/mark_ready_for_pickup_usecase.dart';

class PaymentNotifier extends Notifier<PaymentState> {
  late final CreatePaymentRequestUseCase _createPaymentRequestUseCase;
  late final UpdatePaymentRequestUseCase _updatePaymentRequestUseCase;
  late final DeletePaymentRequestUseCase _deletePaymentRequestUseCase;
  late final GetPaymentRequestsUseCase _getPaymentRequestsUseCase;
  late final GetPaymentRequestByIdUseCase _getPaymentRequestByIdUseCase;
  late final GetPaymentRequestHistoryUseCase _getPaymentRequestHistoryUseCase;
  late final CreateFulfillmentUseCase _createFulfillmentUseCase;
  late final InitializePaymentUseCase _initializePaymentUseCase;
  late final VerifyPaymentUseCase _verifyPaymentUseCase;
  late final GetPaymentDetailsUseCase _getPaymentDetailsUseCase;
  late final MarkReadyForPickupUseCase _markReadyForPickupUseCase;

  @override
  PaymentState build() {
    _createPaymentRequestUseCase = ref.read(
      createPaymentRequestUseCaseProvider,
    );
    _updatePaymentRequestUseCase = ref.read(
      updatePaymentRequestUseCaseProvider,
    );
    _deletePaymentRequestUseCase = ref.read(
      deletePaymentRequestUseCaseProvider,
    );
    _getPaymentRequestsUseCase = ref.read(getPaymentRequestsUseCaseProvider);
    _getPaymentRequestByIdUseCase = ref.read(
      getPaymentRequestByIdUseCaseProvider,
    );
    _getPaymentRequestHistoryUseCase = ref.read(
      getPaymentRequestHistoryUseCaseProvider,
    );
    _createFulfillmentUseCase = ref.read(createFulfillmentUseCaseProvider);
    _initializePaymentUseCase = ref.read(initializePaymentUseCaseProvider);
    _verifyPaymentUseCase = ref.read(verifyPaymentUseCaseProvider);
    _getPaymentDetailsUseCase = ref.read(getPaymentDetailsUseCaseProvider);
    _markReadyForPickupUseCase = ref.read(markReadyForPickupUseCaseProvider);
    return const PaymentState();
  }

  Future<void> createPaymentRequest({
    required String itemName,
    required String itemDescription,
    required double itemPrice,
    required List<String> itemImages,
    required int processingTimeHours,
    required bool isReusable,
    int? maxUses,
  }) async {
    state = state.copyWith(isCreatingPaymentRequest: true, errorMessage: null);

    try {
      final request = CreatePaymentRequestEntity(
        itemName: itemName,
        itemDescription: itemDescription,
        itemPrice: itemPrice,
        itemImages: itemImages,
        processingTimeHours: processingTimeHours,
        isReusable: isReusable,
        maxUses: maxUses,
      );

      final response = await _createPaymentRequestUseCase(request);

      if (response.success && response.data != null) {
        state = state.copyWith(
          isCreatingPaymentRequest: false,
          createdPaymentRequest: response.data as PaymentRequestResponseEntity?,
        );
      } else {
        state = state.copyWith(
          isCreatingPaymentRequest: false,
          errorMessage: response.message,
        );
      }
    } catch (e) {
      state = state.copyWith(
        isCreatingPaymentRequest: false,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> updatePaymentRequest({
    required String id,
    required String itemName,
    required String itemDescription,
    required double itemPrice,
    required List<String> itemImages,
    required int processingTimeHours,
    required bool isReusable,
    int? maxUses,
  }) async {
    state = state.copyWith(isUpdatingPaymentRequest: true, errorMessage: null);

    try {
      final Map<String, dynamic> data = {
        'item_name': itemName,
        'item_description': itemDescription,
        'item_price': itemPrice,
        'item_images': itemImages,
        'processing_time_hours': processingTimeHours,
        'is_reusable': isReusable,
        if (maxUses != null) 'max_uses': maxUses,
      };

      final response = await _updatePaymentRequestUseCase(id, data);

      if (response.success && response.data != null) {
        final responseData = response.data as Map<String, dynamic>;

        state = state.copyWith(
          isUpdatingPaymentRequest: false,
          createdPaymentRequest: PaymentRequestResponseModel.fromJson(
            responseData['data'] as Map<String, dynamic>,
          ).toEntity(),
        );
      } else {
        state = state.copyWith(
          isUpdatingPaymentRequest: false,
          errorMessage: response.message,
        );
      }
    } catch (e) {
      state = state.copyWith(
        isUpdatingPaymentRequest: false,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> deletePaymentRequest(String id) async {
    state = state.copyWith(isDeletingPaymentRequest: true, errorMessage: null);

    try {
      final response = await _deletePaymentRequestUseCase(id);

      if (response.success) {
        state = state.copyWith(
          isDeletingPaymentRequest: false,
          deleteResponse: response,
        );
      } else {
        state = state.copyWith(
          isDeletingPaymentRequest: false,
          errorMessage: response.message,
        );
      }
    } catch (e) {
      state = state.copyWith(
        isDeletingPaymentRequest: false,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> fetchPaymentRequests() async {
    state = state.copyWith(isFetchingPaymentRequests: true, errorMessage: null);

    try {
      final response = await _getPaymentRequestsUseCase();

      if (response.success && response.data != null) {
        final listEntity = response.data as PaymentRequestListEntity;
        state = state.copyWith(
          isFetchingPaymentRequests: false,
          paymentRequests: listEntity.paymentRequests,
        );
      } else {
        state = state.copyWith(
          isFetchingPaymentRequests: false,
          errorMessage: response.message,
        );
      }
    } catch (e) {
      state = state.copyWith(
        isFetchingPaymentRequests: false,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> fetchPaymentRequestDetails(String paymentRequestId) async {
    state = state.copyWith(
      isFetchingPaymentRequestDetails: true,
      errorMessage: null,
    );

    try {
      final response = await _getPaymentRequestByIdUseCase(paymentRequestId);

      if (response.success && response.data != null) {
        final entity = response.data as PaymentRequestResponseEntity;
        state = state.copyWith(
          isFetchingPaymentRequestDetails: false,
          paymentRequestDetails: entity,
        );
      } else {
        state = state.copyWith(
          isFetchingPaymentRequestDetails: false,
          errorMessage: response.message,
        );
      }
    } catch (e) {
      state = state.copyWith(
        isFetchingPaymentRequestDetails: false,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> fetchPaymentRequestHistory() async {
    state = state.copyWith(isFetchingPaymentHistory: true, errorMessage: null);

    try {
      final response = await _getPaymentRequestHistoryUseCase();

      if (response.success && response.data != null) {
        final listEntity = response.data as PaymentRequestListEntity;
        state = state.copyWith(
          isFetchingPaymentHistory: false,
          paymentRequestHistory: listEntity.paymentRequests,
        );
      } else {
        state = state.copyWith(
          isFetchingPaymentHistory: false,
          errorMessage: response.message,
        );
      }
    } catch (e) {
      state = state.copyWith(
        isFetchingPaymentHistory: false,
        errorMessage: e.toString(),
      );
    }
  }

  void setPickupLocation(LocationEntity location) {
    state = state.copyWith(pickupLocation: location);
  }

  void setDropoffLocation(LocationEntity location) {
    state = state.copyWith(dropoffLocation: location);
  }

  Future<void> createFulfillment({
    required String paymentRequestId,
    required String deliveryType,
    required String vehicleType,
  }) async {
    final pickup = state.pickupLocation;
    final dropoff = state.dropoffLocation;

    if (pickup == null || dropoff == null) {
      state = state.copyWith(
        errorMessage: 'Please select both pickup and dropoff locations',
      );
      return;
    }

    state = state.copyWith(isCreatingFulfillment: true, errorMessage: null);

    try {
      final request = CreateFulfillmentEntity.fromLocations(
        deliveryType: deliveryType,
        pickup: pickup,
        dropoff: dropoff,
        vehicleType: vehicleType,
      );

      final response = await _createFulfillmentUseCase(
        paymentRequestId,
        request,
      );

      if (response.success && response.data != null) {
        state = state.copyWith(
          isCreatingFulfillment: false,
          fulfillmentResponse: response.data as FulfillmentResponseEntity?,
        );
      } else {
        state = state.copyWith(
          isCreatingFulfillment: false,
          errorMessage: response.message,
        );
      }
    } catch (e) {
      state = state.copyWith(
        isCreatingFulfillment: false,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> initializePayment({
    required String paymentCode,
    required String paymentMethod,
  }) async {
    state = state.copyWith(isInitializingPayment: true, errorMessage: null);

    try {
      final request = InitializePaymentEntity(paymentMethod: paymentMethod);
      final response = await _initializePaymentUseCase(paymentCode, request);

      if (response.success && response.data != null) {
        state = state.copyWith(
          isInitializingPayment: false,
          initializePaymentResponse:
              response.data as InitializePaymentResponseEntity?,
        );
      } else {
        state = state.copyWith(
          isInitializingPayment: false,
          errorMessage: response.message,
        );
      }
    } catch (e) {
      state = state.copyWith(
        isInitializingPayment: false,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> verifyPayment({
    required String paymentCode,
    required String reference,
  }) async {
    state = state.copyWith(isVerifyingPayment: true, errorMessage: null);

    try {
      final response = await _verifyPaymentUseCase(paymentCode, reference);

      if (response.success && response.data != null) {
        state = state.copyWith(
          isVerifyingPayment: false,
          verifyPaymentResponse: response.data as VerifyPaymentResponseEntity?,
        );
      } else {
        state = state.copyWith(
          isVerifyingPayment: false,
          errorMessage: response.message,
        );
      }
    } catch (e) {
      state = state.copyWith(
        isVerifyingPayment: false,
        errorMessage: e.toString(),
      );
    }
  }

  void clearError() {
    state = state.copyWith(errorMessage: null);
  }

  void clearPaymentRequest() {
    state = const PaymentState();
  }

  Future<void> getPaymentDetails({required String paymentCode}) async {
    state = state.copyWith(isFetchingPaymentDetails: true, errorMessage: null);

    try {
      final response = await _getPaymentDetailsUseCase(paymentCode);

      if (response.success && response.data != null) {
        state = state.copyWith(
          isFetchingPaymentDetails: false,
          paymentDetails: response.data as PaymentDetailsEntity?,
        );
      } else {
        state = state.copyWith(
          isFetchingPaymentDetails: false,
          errorMessage: response.message,
        );
      }
    } catch (e) {
      state = state.copyWith(
        isFetchingPaymentDetails: false,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> markReadyForPickup({required String paymentRequestId}) async {
    state = state.copyWith(isMarkingReadyForPickup: true, errorMessage: null);

    try {
      final response = await _markReadyForPickupUseCase(paymentRequestId);

      if (response.success && response.data != null) {
        final markReadyResponse =
            response.data as MarkReadyForPickupResponseEntity;
        state = state.copyWith(
          isMarkingReadyForPickup: false,
          markReadyResponse: markReadyResponse,
        );
        await fetchPaymentRequests();
      } else {
        state = state.copyWith(
          isMarkingReadyForPickup: false,
          errorMessage: response.message,
        );
      }
    } catch (e) {
      state = state.copyWith(
        isMarkingReadyForPickup: false,
        errorMessage: e.toString(),
      );
    }
  }
}
