import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/services/network/api_services.dart';
import '../../../../utils/constant.dart';
import '../../data/datasources/disputes_remote_datasource.dart';
import '../../data/repositories/disputes_repository_impl.dart';
import '../../domain/repositories/disputes_repository.dart';
import '../../domain/usecases/get_disputes_usecase.dart';
import '../../domain/usecases/get_dispute_by_id_usecase.dart';
import '../state/disputes_notifier.dart';
import '../state/disputes_state.dart';

// Data Sources
final disputesRemoteDataSourceProvider = Provider<DisputesRemoteDataSource>((
  ref,
) {
  return DisputesRemoteDataSource(getIt<ApiService>());
});

// Repository
final disputesRepositoryProvider = Provider<DisputesRepository>((ref) {
  return DisputesRepositoryImpl(ref.read(disputesRemoteDataSourceProvider));
});

// Use Cases
final getDisputesUseCaseProvider = Provider<GetDisputesUseCase>((ref) {
  return GetDisputesUseCase(ref.read(disputesRepositoryProvider));
});

final getDisputeByIdUseCaseProvider = Provider<GetDisputeByIdUseCase>((ref) {
  return GetDisputeByIdUseCase(ref.read(disputesRepositoryProvider));
});

// Notifier
final disputesNotifierProvider =
    NotifierProvider<DisputesNotifier, DisputesState>(DisputesNotifier.new);
