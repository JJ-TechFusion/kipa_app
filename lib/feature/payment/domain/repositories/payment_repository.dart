import '../../../../core/services/network/network_response.dart';
import '../../../location/domain/entities/fulfillment_entity.dart';
import '../entities/payment_buyer_entities.dart';
import '../entities/payment_request_entity.dart';

abstract class PaymentRepository {
  Future<NetworkResponse> createPaymentRequest(
    CreatePaymentRequestEntity request,
  );

  Future<NetworkResponse> updatePaymentRequest(
    String id,
    Map<String, dynamic> data,
  );

  Future<NetworkResponse> deletePaymentRequest(String id);

  Future<NetworkResponse> getPaymentRequests();

  Future<NetworkResponse> getPaymentRequestById(String paymentRequestId);

  Future<NetworkResponse> getPaymentRequestHistory();

  Future<NetworkResponse> createFulfillment(
    String paymentRequestId,
    CreateFulfillmentEntity request,
  );

  Future<NetworkResponse> initializePayment(
    String paymentCode,
    InitializePaymentEntity request,
  );

  Future<NetworkResponse> verifyPayment(String paymentCode, String reference);

  Future<NetworkResponse> getPaymentDetails(String paymentCode);

  Future<NetworkResponse> markReadyForPickup(String paymentRequestId);

  Future<NetworkResponse> cancelRiderSearch(String paymentRequestId);

  Future<NetworkResponse> getTransactionStatus(String paymentRequestId);

  Future<NetworkResponse> uploadItemImage({
    required String fileName,
    required List<int> fileBytes,
  });
}
