import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/services/network/api_services.dart';
import '../../../../utils/constant.dart';
import '../../data/datasources/payment_remote_datasource.dart';
import '../../data/repositories/payment_repository_impl.dart';
import '../../domain/repositories/payment_repository.dart';
import '../../domain/usecases/create_payment_request_usecase.dart';
import '../../domain/usecases/update_payment_request_usecase.dart';
import '../../domain/usecases/delete_payment_request_usecase.dart';
import '../../domain/usecases/get_payment_requests_usecase.dart';
import '../../domain/usecases/get_payment_request_by_id_usecase.dart';
import '../../domain/usecases/get_payment_request_history_usecase.dart';
import '../../domain/usecases/create_fulfillment_usecase.dart';
import '../../domain/usecases/initialize_payment_usecase.dart';
import '../../domain/usecases/verify_payment_usecase.dart';
import '../../domain/usecases/get_payment_details_usecase.dart';
import '../../domain/usecases/mark_ready_for_pickup_usecase.dart';
import '../../domain/usecases/cancel_rider_search_usecase.dart';
import '../../domain/usecases/get_transaction_status_usecase.dart';
import '../../domain/usecases/upload_item_image_usecase.dart';
import '../../domain/usecases/ship_logistics_delivery_usecase.dart';
import '../../domain/usecases/upload_shipment_receipt_usecase.dart';
import '../state/payment_notifier.dart';
import '../state/payment_state.dart';
import '../state/transaction_status_notifier.dart';
import '../state/transaction_status_state.dart';

// Data Sources
final paymentRemoteDataSourceProvider = Provider<PaymentRemoteDataSource>((
  ref,
) {
  return PaymentRemoteDataSource(getIt<ApiService>());
});

// Repository
final paymentRepositoryProvider = Provider<PaymentRepository>((ref) {
  return PaymentRepositoryImpl(ref.read(paymentRemoteDataSourceProvider));
});

// Use Cases
final createPaymentRequestUseCaseProvider =
    Provider<CreatePaymentRequestUseCase>((ref) {
      return CreatePaymentRequestUseCase(ref.read(paymentRepositoryProvider));
    });

final updatePaymentRequestUseCaseProvider =
    Provider<UpdatePaymentRequestUseCase>((ref) {
      return UpdatePaymentRequestUseCase(ref.read(paymentRepositoryProvider));
    });

final deletePaymentRequestUseCaseProvider =
    Provider<DeletePaymentRequestUseCase>((ref) {
      return DeletePaymentRequestUseCase(ref.read(paymentRepositoryProvider));
    });

final getPaymentRequestsUseCaseProvider = Provider<GetPaymentRequestsUseCase>((
  ref,
) {
  return GetPaymentRequestsUseCase(ref.read(paymentRepositoryProvider));
});

final getPaymentRequestByIdUseCaseProvider =
    Provider<GetPaymentRequestByIdUseCase>((ref) {
      return GetPaymentRequestByIdUseCase(ref.read(paymentRepositoryProvider));
    });

final getPaymentRequestHistoryUseCaseProvider =
    Provider<GetPaymentRequestHistoryUseCase>((ref) {
      return GetPaymentRequestHistoryUseCase(
        ref.read(paymentRepositoryProvider),
      );
    });

final createFulfillmentUseCaseProvider = Provider<CreateFulfillmentUseCase>((
  ref,
) {
  return CreateFulfillmentUseCase(ref.read(paymentRepositoryProvider));
});

final initializePaymentUseCaseProvider = Provider<InitializePaymentUseCase>((
  ref,
) {
  return InitializePaymentUseCase(ref.read(paymentRepositoryProvider));
});

final verifyPaymentUseCaseProvider = Provider<VerifyPaymentUseCase>((ref) {
  return VerifyPaymentUseCase(ref.read(paymentRepositoryProvider));
});

final getPaymentDetailsUseCaseProvider = Provider<GetPaymentDetailsUseCase>((
  ref,
) {
  return GetPaymentDetailsUseCase(ref.read(paymentRepositoryProvider));
});

final markReadyForPickupUseCaseProvider = Provider<MarkReadyForPickupUseCase>((
  ref,
) {
  return MarkReadyForPickupUseCase(ref.read(paymentRepositoryProvider));
});

final cancelRiderSearchUseCaseProvider = Provider<CancelRiderSearchUseCase>((
  ref,
) {
  return CancelRiderSearchUseCase(ref.read(paymentRepositoryProvider));
});

final getTransactionStatusUseCaseProvider =
    Provider<GetTransactionStatusUseCase>((ref) {
  return GetTransactionStatusUseCase(ref.read(paymentRepositoryProvider));
});

final uploadItemImageUseCaseProvider = Provider<UploadItemImageUseCase>((ref) {
  return UploadItemImageUseCase(ref.read(paymentRepositoryProvider));
});

final shipLogisticsDeliveryUseCaseProvider =
    Provider<ShipLogisticsDeliveryUseCase>((ref) {
  return ShipLogisticsDeliveryUseCase(ref.read(paymentRepositoryProvider));
});

final uploadShipmentReceiptUseCaseProvider =
    Provider<UploadShipmentReceiptUseCase>((ref) {
  return UploadShipmentReceiptUseCase(ref.read(paymentRepositoryProvider));
});

final paymentNotifierProvider = NotifierProvider<PaymentNotifier, PaymentState>(
  PaymentNotifier.new,
);

final transactionStatusNotifierProvider =
    NotifierProvider<TransactionStatusNotifier, TransactionStatusState>(
  TransactionStatusNotifier.new,
);
