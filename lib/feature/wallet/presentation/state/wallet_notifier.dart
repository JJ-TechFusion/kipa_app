import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/wallet_entities.dart';
import '../../domain/usecases/get_wallet_usecase.dart';
import '../../domain/usecases/top_up_wallet_usecase.dart';
import '../../domain/usecases/verify_top_up_usecase.dart';
import '../providers/wallet_provider.dart';
import 'wallet_state.dart';

class WalletNotifier extends Notifier<WalletState> {
  late final GetWalletUseCase _getWalletUseCase;
  late final TopUpWalletUseCase _topUpWalletUseCase;
  late final VerifyTopUpUseCase _verifyTopUpUseCase;

  @override
  WalletState build() {
    _getWalletUseCase = ref.read(getWalletUseCaseProvider);
    _topUpWalletUseCase = ref.read(topUpWalletUseCaseProvider);
    _verifyTopUpUseCase = ref.read(verifyTopUpUseCaseProvider);
    return const WalletState();
  }

  Future<void> getWallet() async {
    state = state.copyWith(isFetchingWallet: true, errorMessage: null);

    try {
      final response = await _getWalletUseCase();

      if (response.success && response.data != null) {
        state = state.copyWith(
          isFetchingWallet: false,
          wallet: response.data as WalletEntity?,
        );
      } else {
        state = state.copyWith(
          isFetchingWallet: false,
          errorMessage: response.message,
        );
      }
    } catch (e) {
      state = state.copyWith(
        isFetchingWallet: false,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> topUpWallet({required double amount}) async {
    state = state.copyWith(isToppingUp: true, errorMessage: null);

    try {
      final response = await _topUpWalletUseCase(amount);

      if (response.success && response.data != null) {
        state = state.copyWith(
          isToppingUp: false,
          topUpResponse: response.data as TopUpResponseEntity?,
        );
      } else {
        state = state.copyWith(
          isToppingUp: false,
          errorMessage: response.message,
        );
      }
    } catch (e) {
      state = state.copyWith(isToppingUp: false, errorMessage: e.toString());
    }
  }

  Future<void> verifyTopUp({required String reference}) async {
    state = state.copyWith(isVerifyingTopUp: true, errorMessage: null);

    try {
      final response = await _verifyTopUpUseCase(reference);

      if (response.success && response.data != null) {
        state = state.copyWith(
          isVerifyingTopUp: false,
          verifyTopUpResponse: response.data as VerifyTopUpResponseEntity?,
        );
        // Refresh wallet balance after successful top-up
        await getWallet();
      } else {
        state = state.copyWith(
          isVerifyingTopUp: false,
          errorMessage: response.message,
        );
      }
    } catch (e) {
      state = state.copyWith(
        isVerifyingTopUp: false,
        errorMessage: e.toString(),
      );
    }
  }

  void clearTopUpResponse() {
    state = state.copyWith(topUpResponse: null);
  }

  void clearError() {
    state = state.copyWith(errorMessage: null);
  }
}
