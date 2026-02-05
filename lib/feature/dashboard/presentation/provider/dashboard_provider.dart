import 'package:flutter_riverpod/legacy.dart';

class DashboardState {
  final bool isBalanceVisible;
  final int bottomNavIndex;

  const DashboardState({this.isBalanceVisible = true, this.bottomNavIndex = 0});

  DashboardState copyWith({bool? isBalanceVisible, int? bottomNavIndex}) {
    return DashboardState(
      isBalanceVisible: isBalanceVisible ?? this.isBalanceVisible,
      bottomNavIndex: bottomNavIndex ?? this.bottomNavIndex,
    );
  }
}

class DashboardController extends StateNotifier<DashboardState> {
  DashboardController() : super(const DashboardState());

  void toggleBalanceVisibility() {
    state = state.copyWith(isBalanceVisible: !state.isBalanceVisible);
  }

  void setBottomNavIndex(int index) {
    state = state.copyWith(bottomNavIndex: index);
  }
}

final dashboardProvider =
    StateNotifierProvider<DashboardController, DashboardState>((ref) {
      return DashboardController();
    });
