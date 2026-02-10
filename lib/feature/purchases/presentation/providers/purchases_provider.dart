import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/services/network/api_services.dart';
import '../../../../utils/constant.dart';
import '../../data/datasources/purchases_remote_datasource.dart';
import '../../data/repositories/purchases_repository_impl.dart';
import '../../domain/repositories/purchases_repository.dart';
import '../../domain/usecases/get_purchases_usecase.dart';
import '../../domain/usecases/get_purchase_by_id_usecase.dart';
import '../../domain/usecases/confirm_delivery_usecase.dart';
import '../state/purchases_notifier.dart';
import '../state/purchases_state.dart';

// Data Sources
final purchasesRemoteDataSourceProvider =
    Provider<PurchasesRemoteDataSource>((ref) {
  return PurchasesRemoteDataSource(getIt<ApiService>());
});

// Repository
final purchasesRepositoryProvider = Provider<PurchasesRepository>((ref) {
  return PurchasesRepositoryImpl(ref.read(purchasesRemoteDataSourceProvider));
});

// Use Cases
final getPurchasesUseCaseProvider = Provider<GetPurchasesUseCase>((ref) {
  return GetPurchasesUseCase(ref.read(purchasesRepositoryProvider));
});

final getPurchaseByIdUseCaseProvider = Provider<GetPurchaseByIdUseCase>((ref) {
  return GetPurchaseByIdUseCase(ref.read(purchasesRepositoryProvider));
});

final confirmDeliveryUseCaseProvider = Provider<ConfirmDeliveryUseCase>((ref) {
  return ConfirmDeliveryUseCase(ref.read(purchasesRepositoryProvider));
});

// Notifier
final purchasesNotifierProvider =
    NotifierProvider<PurchasesNotifier, PurchasesState>(
  PurchasesNotifier.new,
);
