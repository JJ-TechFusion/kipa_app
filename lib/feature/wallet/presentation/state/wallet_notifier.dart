import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/wallet_entities.dart';
import '../../domain/usecases/get_wallet_usecase.dart';
import '../../domain/usecases/get_wallet_transactions_usecase.dart';
import '../../domain/usecases/get_pending_funds_usecase.dart';
import '../../domain/usecases/top_up_wallet_usecase.dart';
import '../../domain/usecases/verify_top_up_usecase.dart';
import '../../domain/usecases/get_pin_status_usecase.dart';
import '../../domain/usecases/create_pin_usecase.dart';
import '../../domain/usecases/verify_pin_usecase.dart';
import '../../domain/usecases/change_pin_usecase.dart';
import '../../domain/usecases/request_pin_reset_usecase.dart';
import '../../domain/usecases/confirm_pin_reset_usecase.dart';
import '../../domain/usecases/withdraw_usecase.dart';
import '../../domain/usecases/sync_wallet_usecase.dart';
import '../../domain/usecases/get_virtual_account_status_usecase.dart';
import '../../domain/usecases/create_virtual_account_usecase.dart';
import '../../domain/usecases/get_virtual_account_usecase.dart';
import '../../domain/usecases/decline_virtual_account_usecase.dart';
import '../providers/wallet_provider.dart';
import 'wallet_state.dart';

class WalletNotifier extends Notifier<WalletState> {
  late final GetWalletUseCase _getWalletUseCase;
  late final TopUpWalletUseCase _topUpWalletUseCase;
  late final VerifyTopUpUseCase _verifyTopUpUseCase;
  late final GetWalletTransactionsUseCase _getWalletTransactionsUseCase;
  late final GetPendingFundsUseCase _getPendingFundsUseCase;
  late final GetPinStatusUseCase _getPinStatusUseCase;
  late final CreatePinUseCase _createPinUseCase;
  late final VerifyPinUseCase _verifyPinUseCase;
  late final ChangePinUseCase _changePinUseCase;
  late final RequestPinResetUseCase _requestPinResetUseCase;
  late final ConfirmPinResetUseCase _confirmPinResetUseCase;
  late final WithdrawUseCase _withdrawUseCase;
  late final SyncWalletUseCase _syncWalletUseCase;
  late final GetVirtualAccountStatusUseCase _getVirtualAccountStatusUseCase;
  late final CreateVirtualAccountUseCase _createVirtualAccountUseCase;
  late final GetVirtualAccountUseCase _getVirtualAccountUseCase;
  late final DeclineVirtualAccountUseCase _declineVirtualAccountUseCase;

  @override
  WalletState build() {
    _getWalletUseCase = ref.read(getWalletUseCaseProvider);
    _topUpWalletUseCase = ref.read(topUpWalletUseCaseProvider);
    _verifyTopUpUseCase = ref.read(verifyTopUpUseCaseProvider);
    _getWalletTransactionsUseCase = ref.read(
      getWalletTransactionsUseCaseProvider,
    );
    _getPendingFundsUseCase = ref.read(getPendingFundsUseCaseProvider);
    _getPinStatusUseCase = ref.read(getPinStatusUseCaseProvider);
    _createPinUseCase = ref.read(createPinUseCaseProvider);
    _verifyPinUseCase = ref.read(verifyPinUseCaseProvider);
    _changePinUseCase = ref.read(changePinUseCaseProvider);
    _requestPinResetUseCase = ref.read(requestPinResetUseCaseProvider);
    _confirmPinResetUseCase = ref.read(confirmPinResetUseCaseProvider);
    _withdrawUseCase = ref.read(withdrawUseCaseProvider);
    _syncWalletUseCase = ref.read(syncWalletUseCaseProvider);
    _getVirtualAccountStatusUseCase = ref.read(getVirtualAccountStatusUseCaseProvider);
    _createVirtualAccountUseCase = ref.read(createVirtualAccountUseCaseProvider);
    _getVirtualAccountUseCase = ref.read(getVirtualAccountUseCaseProvider);
    _declineVirtualAccountUseCase = ref.read(declineVirtualAccountUseCaseProvider);
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

  Future<void> getTransactions() async {
    state = state.copyWith(isFetchingTransactions: true, errorMessage: null);

    try {
      final response = await _getWalletTransactionsUseCase();

      if (response.success && response.data != null) {
        final listEntity = response.data as WalletTransactionListEntity;
        state = state.copyWith(
          isFetchingTransactions: false,
          transactions: listEntity.transactions,
        );
      } else {
        state = state.copyWith(
          isFetchingTransactions: false,
          errorMessage: response.message,
        );
      }
    } catch (e) {
      state = state.copyWith(
        isFetchingTransactions: false,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> getPendingFunds() async {
    state = state.copyWith(isFetchingPendingFunds: true, errorMessage: null);

    try {
      final response = await _getPendingFundsUseCase();

      if (response.success && response.data != null) {
        final listEntity = response.data as PendingFundListEntity;
        state = state.copyWith(
          isFetchingPendingFunds: false,
          pendingFunds: listEntity.pendingFunds,
        );
      } else {
        state = state.copyWith(
          isFetchingPendingFunds: false,
          errorMessage: response.message,
        );
      }
    } catch (e) {
      state = state.copyWith(
        isFetchingPendingFunds: false,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> getPinStatus() async {
    state = state.copyWith(isFetchingPinStatus: true, pinErrorMessage: null);

    try {
      final response = await _getPinStatusUseCase();

      if (response.success && response.data != null) {
        state = state.copyWith(
          isFetchingPinStatus: false,
          pinStatus: response.data as PinStatusEntity?,
        );
      } else {
        state = state.copyWith(
          isFetchingPinStatus: false,
          pinErrorMessage: response.message,
        );
      }
    } catch (e) {
      state = state.copyWith(
        isFetchingPinStatus: false,
        pinErrorMessage: e.toString(),
      );
    }
  }

  Future<bool> createPin(String pin) async {
    state = state.copyWith(isCreatingPin: true, pinErrorMessage: null);

    try {
      final response = await _createPinUseCase(pin);

      if (response.success) {
        state = state.copyWith(
          isCreatingPin: false,
          isPinVerified: true,
        );
        await getPinStatus();
        return true;
      } else {
        state = state.copyWith(
          isCreatingPin: false,
          pinErrorMessage: response.message,
        );
        return false;
      }
    } catch (e) {
      state = state.copyWith(
        isCreatingPin: false,
        pinErrorMessage: e.toString(),
      );
      return false;
    }
  }

  Future<bool> verifyPin(String pin) async {
    state = state.copyWith(isVerifyingPin: true, pinErrorMessage: null);

    try {
      final response = await _verifyPinUseCase(pin);

      if (response.success) {
        state = state.copyWith(
          isVerifyingPin: false,
          isPinVerified: true,
        );
        await getPinStatus();
        return true;
      } else {
        state = state.copyWith(
          isVerifyingPin: false,
          pinErrorMessage: response.message,
        );
        await getPinStatus();
        return false;
      }
    } catch (e) {
      state = state.copyWith(
        isVerifyingPin: false,
        pinErrorMessage: e.toString(),
      );
      return false;
    }
  }

  Future<bool> changePin(String oldPin, String newPin) async {
    state = state.copyWith(isChangingPin: true, pinErrorMessage: null);

    try {
      final response = await _changePinUseCase(oldPin, newPin);

      if (response.success) {
        state = state.copyWith(isChangingPin: false);
        return true;
      } else {
        state = state.copyWith(
          isChangingPin: false,
          pinErrorMessage: response.message,
        );
        return false;
      }
    } catch (e) {
      state = state.copyWith(
        isChangingPin: false,
        pinErrorMessage: e.toString(),
      );
      return false;
    }
  }

  void clearPinError() {
    state = state.copyWith(pinErrorMessage: null);
  }

  void resetPinVerification() {
    state = state.copyWith(isPinVerified: false);
  }

  Future<bool> requestPinReset() async {
    state = state.copyWith(isRequestingPinReset: true, pinErrorMessage: null);

    try {
      final response = await _requestPinResetUseCase();

      if (response.success && response.data != null) {
        state = state.copyWith(
          isRequestingPinReset: false,
          pinResetResponse: response.data as PinResetRequestResponseEntity,
        );
        return true;
      } else {
        state = state.copyWith(
          isRequestingPinReset: false,
          pinErrorMessage: response.message,
        );
        return false;
      }
    } catch (e) {
      state = state.copyWith(
        isRequestingPinReset: false,
        pinErrorMessage: e.toString(),
      );
      return false;
    }
  }

  Future<bool> confirmPinReset(String otpCode, String newPin) async {
    state = state.copyWith(isConfirmingPinReset: true, pinErrorMessage: null);

    try {
      final response = await _confirmPinResetUseCase(otpCode, newPin);

      if (response.success) {
        state = state.copyWith(isConfirmingPinReset: false);
        await getPinStatus();
        return true;
      } else {
        state = state.copyWith(
          isConfirmingPinReset: false,
          pinErrorMessage: response.message,
        );
        return false;
      }
    } catch (e) {
      state = state.copyWith(
        isConfirmingPinReset: false,
        pinErrorMessage: e.toString(),
      );
      return false;
    }
  }

  Future<bool> withdraw(String bankAccountId, double amount) async {
    state = state.copyWith(isWithdrawing: true, errorMessage: null);

    try {
      final response = await _withdrawUseCase(bankAccountId, amount);

      if (response.success) {
        state = state.copyWith(isWithdrawing: false);
        await getWallet();
        return true;
      } else {
        state = state.copyWith(
          isWithdrawing: false,
          errorMessage: response.message,
        );
        return false;
      }
    } catch (e) {
      state = state.copyWith(
        isWithdrawing: false,
        errorMessage: e.toString(),
      );
      return false;
    }
  }

  Future<WalletSyncResponseEntity?> syncWallet() async {
    state = state.copyWith(isSyncing: true, errorMessage: null);

    try {
      final response = await _syncWalletUseCase();

      if (response.success && response.data != null) {
        state = state.copyWith(isSyncing: false);
        await getWallet();
        return response.data as WalletSyncResponseEntity?;
      } else {
        state = state.copyWith(
          isSyncing: false,
          errorMessage: response.message,
        );
        return null;
      }
    } catch (e) {
      state = state.copyWith(
        isSyncing: false,
        errorMessage: e.toString(),
      );
      return null;
    }
  }

  // Virtual Account Methods
  Future<void> getVirtualAccountStatus() async {
    state = state.copyWith(
      isFetchingVirtualAccountStatus: true,
      virtualAccountErrorMessage: null,
    );

    try {
      final response = await _getVirtualAccountStatusUseCase();

      if (response.success && response.data != null) {
        final statusEntity = response.data as VirtualAccountStatusEntity;
        state = state.copyWith(
          isFetchingVirtualAccountStatus: false,
          virtualAccountStatus: statusEntity,
          virtualAccount: statusEntity.account,
        );
      } else {
        state = state.copyWith(
          isFetchingVirtualAccountStatus: false,
          virtualAccountErrorMessage: response.message,
        );
      }
    } catch (e) {
      state = state.copyWith(
        isFetchingVirtualAccountStatus: false,
        virtualAccountErrorMessage: e.toString(),
      );
    }
  }

  Future<bool> createVirtualAccount(String bvn) async {
    state = state.copyWith(
      isCreatingVirtualAccount: true,
      virtualAccountErrorMessage: null,
    );

    try {
      final response = await _createVirtualAccountUseCase(bvn);

      if (response.success && response.data != null) {
        state = state.copyWith(
          isCreatingVirtualAccount: false,
          virtualAccount: response.data as VirtualAccountEntity?,
        );
        // Refresh the status
        await getVirtualAccountStatus();
        return true;
      } else {
        state = state.copyWith(
          isCreatingVirtualAccount: false,
          virtualAccountErrorMessage: response.message,
        );
        return false;
      }
    } catch (e) {
      state = state.copyWith(
        isCreatingVirtualAccount: false,
        virtualAccountErrorMessage: e.toString(),
      );
      return false;
    }
  }

  Future<void> getVirtualAccount() async {
    try {
      final response = await _getVirtualAccountUseCase();

      if (response.success && response.data != null) {
        state = state.copyWith(
          virtualAccount: response.data as VirtualAccountEntity?,
        );
      }
    } catch (e) {
      // Silently fail
    }
  }

  Future<bool> declineVirtualAccount() async {
    state = state.copyWith(
      isDecliningVirtualAccount: true,
      virtualAccountErrorMessage: null,
    );

    try {
      final response = await _declineVirtualAccountUseCase();

      if (response.success) {
        // Optimistically update the local state to hide the prompt immediately
        final updatedStatus = VirtualAccountStatusEntity(
          hasAccount: state.virtualAccountStatus?.hasAccount ?? false,
          declined: true,
          account: state.virtualAccountStatus?.account,
        );
        state = state.copyWith(
          isDecliningVirtualAccount: false,
          virtualAccountStatus: updatedStatus,
        );
        return true;
      } else {
        state = state.copyWith(
          isDecliningVirtualAccount: false,
          virtualAccountErrorMessage: response.message,
        );
        return false;
      }
    } catch (e) {
      state = state.copyWith(
        isDecliningVirtualAccount: false,
        virtualAccountErrorMessage: e.toString(),
      );
      return false;
    }
  }

  void clearVirtualAccountError() {
    state = state.copyWith(virtualAccountErrorMessage: null);
  }
}
