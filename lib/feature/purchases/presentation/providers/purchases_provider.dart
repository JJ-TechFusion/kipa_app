import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/services/network/api_services.dart';
import '../../../../utils/constant.dart';
import '../../data/datasources/purchases_remote_datasource.dart';
import '../../data/repositories/purchases_repository_impl.dart';
import '../../domain/repositories/purchases_repository.dart';
import '../../domain/usecases/get_purchases_usecase.dart';
import '../../domain/usecases/get_purchase_by_id_usecase.dart';
import '../../domain/usecases/confirm_delivery_usecase.dart';
import '../../domain/usecases/ready_for_return_usecase.dart';
import '../../domain/usecases/rebook_delivery_usecase.dart';
import '../../domain/usecases/upload_dispute_evidence_usecase.dart';
import '../../domain/usecases/open_dispute_usecase.dart';
import '../state/purchases_notifier.dart';
import '../state/purchases_state.dart';

final purchasesRemoteDataSourceProvider = Provider<PurchasesRemoteDataSource>((
  ref,
) {
  return PurchasesRemoteDataSource(getIt<ApiService>());
});
final purchasesRepositoryProvider = Provider<PurchasesRepository>((ref) {
  return PurchasesRepositoryImpl(ref.read(purchasesRemoteDataSourceProvider));
});
final getPurchasesUseCaseProvider = Provider<GetPurchasesUseCase>((ref) {
  return GetPurchasesUseCase(ref.read(purchasesRepositoryProvider));
});

final getPurchaseByIdUseCaseProvider = Provider<GetPurchaseByIdUseCase>((ref) {
  return GetPurchaseByIdUseCase(ref.read(purchasesRepositoryProvider));
});

final confirmDeliveryUseCaseProvider = Provider<ConfirmDeliveryUseCase>((ref) {
  return ConfirmDeliveryUseCase(ref.read(purchasesRepositoryProvider));
});

final readyForReturnUseCaseProvider = Provider<ReadyForReturnUseCase>((ref) {
  return ReadyForReturnUseCase(ref.read(purchasesRepositoryProvider));
});

final rebookDeliveryUseCaseProvider = Provider<RebookDeliveryUseCase>((ref) {
  return RebookDeliveryUseCase(ref.read(purchasesRepositoryProvider));
});

final uploadDisputeEvidenceUseCaseProvider =
    Provider<UploadDisputeEvidenceUseCase>((ref) {
      return UploadDisputeEvidenceUseCase(
        ref.read(purchasesRepositoryProvider),
      );
    });

final openDisputeUseCaseProvider = Provider<OpenDisputeUseCase>((ref) {
  return OpenDisputeUseCase(ref.read(purchasesRepositoryProvider));
});
final purchasesNotifierProvider =
    NotifierProvider<PurchasesNotifier, PurchasesState>(PurchasesNotifier.new);
