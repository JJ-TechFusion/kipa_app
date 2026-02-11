import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/services/network/api_services.dart';
import '../../../../utils/constant.dart';
import '../../data/datasources/sales_remote_datasource.dart';
import '../../data/repositories/sales_repository_impl.dart';
import '../../domain/repositories/sales_repository.dart';
import '../../domain/usecases/get_sales_usecase.dart';
import '../../domain/usecases/get_sale_by_id_usecase.dart';
import '../../domain/usecases/confirm_return_usecase.dart';
import '../../domain/usecases/upload_damage_evidence_usecase.dart';
import '../state/sales_notifier.dart';
import '../state/sales_state.dart';

// Data Sources
final salesRemoteDataSourceProvider = Provider<SalesRemoteDataSource>((ref) {
  return SalesRemoteDataSource(getIt<ApiService>());
});

// Repository
final salesRepositoryProvider = Provider<SalesRepository>((ref) {
  return SalesRepositoryImpl(ref.read(salesRemoteDataSourceProvider));
});

// Use Cases
final getSalesUseCaseProvider = Provider<GetSalesUseCase>((ref) {
  return GetSalesUseCase(ref.read(salesRepositoryProvider));
});

final getSaleByIdUseCaseProvider = Provider<GetSaleByIdUseCase>((ref) {
  return GetSaleByIdUseCase(ref.read(salesRepositoryProvider));
});

final confirmReturnUseCaseProvider = Provider<ConfirmReturnUseCase>((ref) {
  return ConfirmReturnUseCase(ref.read(salesRepositoryProvider));
});

final uploadDamageEvidenceUseCaseProvider = Provider<UploadDamageEvidenceUseCase>((ref) {
  return UploadDamageEvidenceUseCase(ref.read(salesRepositoryProvider));
});

// Notifier
final salesNotifierProvider = NotifierProvider<SalesNotifier, SalesState>(
  SalesNotifier.new,
);
