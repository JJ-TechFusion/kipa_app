import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../../../../core/services/network/api_services.dart';
import '../../../../utils/constant.dart';
import '../../data/datasources/dashboard_remote_datasource.dart';
import '../../data/repositories/dashboard_repository_impl.dart';
import '../../domain/repositories/dashboard_repository.dart';
import '../../domain/usecases/get_active_deliveries_usecase.dart';
import '../../domain/entities/active_delivery_entity.dart';

class DashboardState {
  final bool isBalanceVisible;
  final int bottomNavIndex;
  final bool isLoadingDeliveries;
  final String? deliveriesError;
  final List<ActiveDeliveryEntity>? activeDeliveries;

  const DashboardState({
    this.isBalanceVisible = true,
    this.bottomNavIndex = 0,
    this.isLoadingDeliveries = false,
    this.deliveriesError,
    this.activeDeliveries,
  });

  DashboardState copyWith({
    bool? isBalanceVisible,
    int? bottomNavIndex,
    bool? isLoadingDeliveries,
    String? deliveriesError,
    List<ActiveDeliveryEntity>? activeDeliveries,
  }) {
    return DashboardState(
      isBalanceVisible: isBalanceVisible ?? this.isBalanceVisible,
      bottomNavIndex: bottomNavIndex ?? this.bottomNavIndex,
      isLoadingDeliveries: isLoadingDeliveries ?? this.isLoadingDeliveries,
      deliveriesError: deliveriesError,
      activeDeliveries: activeDeliveries ?? this.activeDeliveries,
    );
  }
}

class DashboardController extends StateNotifier<DashboardState> {
  final GetActiveDeliveriesUseCase _getActiveDeliveriesUseCase;

  DashboardController(this._getActiveDeliveriesUseCase)
    : super(const DashboardState());

  void toggleBalanceVisibility() {
    state = state.copyWith(isBalanceVisible: !state.isBalanceVisible);
  }

  void setBottomNavIndex(int index) {
    state = state.copyWith(bottomNavIndex: index);
  }

  Future<void> fetchActiveDeliveries() async {
    state = state.copyWith(isLoadingDeliveries: true, deliveriesError: null);

    try {
      final response = await _getActiveDeliveriesUseCase();

      if (response.success && response.data != null) {
        final deliveriesResponse =
            response.data as ActiveDeliveriesResponseEntity;
        state = state.copyWith(
          isLoadingDeliveries: false,
          activeDeliveries: deliveriesResponse.activeDeliveries,
          deliveriesError: null,
        );
      } else {
        state = state.copyWith(
          isLoadingDeliveries: false,
          deliveriesError: response.message,
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoadingDeliveries: false,
        deliveriesError: e.toString(),
      );
    }
  }
}

final dashboardRemoteDataSourceProvider = Provider<DashboardRemoteDataSource>((
  ref,
) {
  return DashboardRemoteDataSource(getIt<ApiService>());
});
final dashboardRepositoryProvider = Provider<DashboardRepository>((ref) {
  return DashboardRepositoryImpl(ref.read(dashboardRemoteDataSourceProvider));
});
final getActiveDeliveriesUseCaseProvider = Provider<GetActiveDeliveriesUseCase>(
  (ref) {
    return GetActiveDeliveriesUseCase(ref.read(dashboardRepositoryProvider));
  },
);

final dashboardProvider =
    StateNotifierProvider<DashboardController, DashboardState>((ref) {
      return DashboardController(ref.read(getActiveDeliveriesUseCaseProvider));
    });
