import '../../../../core/services/network/network_response.dart';
import '../../../location/domain/entities/fulfillment_entity.dart';
import '../../domain/entities/payment_request_entity.dart';
import '../../domain/repositories/payment_repository.dart';
import '../datasources/payment_remote_datasource.dart';
import '../../domain/entities/payment_buyer_entities.dart';
import '../../domain/entities/ship_logistics_entity.dart';

class PaymentRepositoryImpl implements PaymentRepository {
  final PaymentRemoteDataSource remoteDataSource;

  PaymentRepositoryImpl(this.remoteDataSource);

  @override
  Future<NetworkResponse> createPaymentRequest(
    CreatePaymentRequestEntity request,
  ) async {
    return await remoteDataSource.createPaymentRequest(request);
  }

  @override
  Future<NetworkResponse> updatePaymentRequest(
    String id,
    Map<String, dynamic> data,
  ) async {
    return await remoteDataSource.updatePaymentRequest(id, data);
  }

  @override
  Future<NetworkResponse> deletePaymentRequest(String id) async {
    return await remoteDataSource.deletePaymentRequest(id);
  }

  @override
  Future<NetworkResponse> getPaymentRequests() async {
    return await remoteDataSource.getPaymentRequests();
  }

  @override
  Future<NetworkResponse> getPaymentRequestById(String paymentRequestId) async {
    return await remoteDataSource.getPaymentRequestById(paymentRequestId);
  }

  @override
  Future<NetworkResponse> getPaymentRequestHistory() async {
    return await remoteDataSource.getPaymentRequestHistory();
  }

  @override
  Future<NetworkResponse> createFulfillment(
    String paymentRequestId,
    CreateFulfillmentEntity request,
  ) async {
    return await remoteDataSource.createFulfillment(paymentRequestId, request);
  }

  @override
  Future<NetworkResponse> initializePayment(
    String paymentCode,
    InitializePaymentEntity request,
  ) async {
    return await remoteDataSource.initializePayment(paymentCode, request);
  }

  @override
  Future<NetworkResponse> verifyPayment(
    String paymentCode,
    String reference,
  ) async {
    return await remoteDataSource.verifyPayment(paymentCode, reference);
  }

  @override
  Future<NetworkResponse> getPaymentDetails(String paymentCode) async {
    return await remoteDataSource.getPaymentDetails(paymentCode);
  }

  @override
  Future<NetworkResponse> markReadyForPickup(String paymentRequestId) async {
    return await remoteDataSource.markReadyForPickup(paymentRequestId);
  }

  @override
  Future<NetworkResponse> cancelRiderSearch(String paymentRequestId) async {
    return await remoteDataSource.cancelRiderSearch(paymentRequestId);
  }

  @override
  Future<NetworkResponse> getTransactionStatus(String paymentRequestId) async {
    return await remoteDataSource.getTransactionStatus(paymentRequestId);
  }

  @override
  Future<NetworkResponse> uploadItemImage({
    required String fileName,
    required List<int> fileBytes,
  }) async {
    return await remoteDataSource.uploadItemImage(
      fileName: fileName,
      fileBytes: fileBytes,
    );
  }

  @override
  Future<NetworkResponse> shipLogisticsDelivery(
    String logisticsDeliveryId,
    ShipLogisticsEntity request,
  ) async {
    return await remoteDataSource.shipLogisticsDelivery(
      logisticsDeliveryId,
      request,
    );
  }

  @override
  Future<NetworkResponse> uploadShipmentReceipt({
    required String fileName,
    required List<int> fileBytes,
  }) async {
    return await remoteDataSource.uploadShipmentReceipt(
      fileName: fileName,
      fileBytes: fileBytes,
    );
  }
}
