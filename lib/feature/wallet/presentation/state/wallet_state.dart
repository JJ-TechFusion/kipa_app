import '../../domain/entities/wallet_entities.dart';

class WalletState {
  final bool isFetchingWallet;
  final bool isToppingUp;
  final bool isVerifyingTopUp;
  final bool isFetchingTransactions;
  final bool isFetchingPendingFunds;
  final bool isFetchingPinStatus;
  final bool isCreatingPin;
  final bool isVerifyingPin;
  final bool isChangingPin;
  final bool isRequestingPinReset;
  final bool isConfirmingPinReset;
  final bool isFetchingSubaccount;
  final bool isCreatingSubaccount;
  final bool isWithdrawing;
  final bool isSyncing;
  final String? errorMessage;
  final String? pinErrorMessage;
  final PinResetRequestResponseEntity? pinResetResponse;
  final WalletEntity? wallet;
  final TopUpResponseEntity? topUpResponse;
  final VerifyTopUpResponseEntity? verifyTopUpResponse;
  final List<WalletTransactionEntity> transactions;
  final List<PendingFundEntity> pendingFunds;
  final PinStatusEntity? pinStatus;
  final bool isPinVerified;
  final SubaccountEntity? subaccount;

  const WalletState({
    this.isFetchingWallet = false,
    this.isToppingUp = false,
    this.isVerifyingTopUp = false,
    this.isFetchingTransactions = false,
    this.isFetchingPendingFunds = false,
    this.isFetchingPinStatus = false,
    this.isCreatingPin = false,
    this.isVerifyingPin = false,
    this.isChangingPin = false,
    this.isRequestingPinReset = false,
    this.isConfirmingPinReset = false,
    this.isFetchingSubaccount = false,
    this.isCreatingSubaccount = false,
    this.isWithdrawing = false,
    this.isSyncing = false,
    this.errorMessage,
    this.pinErrorMessage,
    this.pinResetResponse,
    this.wallet,
    this.topUpResponse,
    this.verifyTopUpResponse,
    this.transactions = const [],
    this.pendingFunds = const [],
    this.pinStatus,
    this.isPinVerified = false,
    this.subaccount,
  });

  WalletState copyWith({
    bool? isFetchingWallet,
    bool? isToppingUp,
    bool? isVerifyingTopUp,
    bool? isFetchingTransactions,
    bool? isFetchingPendingFunds,
    bool? isFetchingPinStatus,
    bool? isCreatingPin,
    bool? isVerifyingPin,
    bool? isChangingPin,
    bool? isRequestingPinReset,
    bool? isConfirmingPinReset,
    bool? isFetchingSubaccount,
    bool? isCreatingSubaccount,
    bool? isWithdrawing,
    bool? isSyncing,
    String? errorMessage,
    String? pinErrorMessage,
    PinResetRequestResponseEntity? pinResetResponse,
    WalletEntity? wallet,
    TopUpResponseEntity? topUpResponse,
    VerifyTopUpResponseEntity? verifyTopUpResponse,
    List<WalletTransactionEntity>? transactions,
    List<PendingFundEntity>? pendingFunds,
    PinStatusEntity? pinStatus,
    bool? isPinVerified,
    SubaccountEntity? subaccount,
  }) {
    return WalletState(
      isFetchingWallet: isFetchingWallet ?? this.isFetchingWallet,
      isToppingUp: isToppingUp ?? this.isToppingUp,
      isVerifyingTopUp: isVerifyingTopUp ?? this.isVerifyingTopUp,
      isFetchingTransactions:
          isFetchingTransactions ?? this.isFetchingTransactions,
      isFetchingPendingFunds:
          isFetchingPendingFunds ?? this.isFetchingPendingFunds,
      isFetchingPinStatus: isFetchingPinStatus ?? this.isFetchingPinStatus,
      isCreatingPin: isCreatingPin ?? this.isCreatingPin,
      isVerifyingPin: isVerifyingPin ?? this.isVerifyingPin,
      isChangingPin: isChangingPin ?? this.isChangingPin,
      isRequestingPinReset: isRequestingPinReset ?? this.isRequestingPinReset,
      isConfirmingPinReset: isConfirmingPinReset ?? this.isConfirmingPinReset,
      isFetchingSubaccount: isFetchingSubaccount ?? this.isFetchingSubaccount,
      isCreatingSubaccount: isCreatingSubaccount ?? this.isCreatingSubaccount,
      isWithdrawing: isWithdrawing ?? this.isWithdrawing,
      isSyncing: isSyncing ?? this.isSyncing,
      errorMessage: errorMessage,
      pinErrorMessage: pinErrorMessage,
      pinResetResponse: pinResetResponse ?? this.pinResetResponse,
      wallet: wallet ?? this.wallet,
      topUpResponse: topUpResponse ?? this.topUpResponse,
      verifyTopUpResponse: verifyTopUpResponse ?? this.verifyTopUpResponse,
      transactions: transactions ?? this.transactions,
      pendingFunds: pendingFunds ?? this.pendingFunds,
      pinStatus: pinStatus ?? this.pinStatus,
      isPinVerified: isPinVerified ?? this.isPinVerified,
      subaccount: subaccount ?? this.subaccount,
    );
  }
}
