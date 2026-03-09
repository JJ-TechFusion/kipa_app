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
  final bool isFetchingVirtualAccountStatus;
  final bool isCreatingVirtualAccount;
  final bool isDecliningVirtualAccount;
  final VirtualAccountStatusEntity? virtualAccountStatus;
  final VirtualAccountEntity? virtualAccount;
  final String? virtualAccountErrorMessage;

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
    this.isFetchingVirtualAccountStatus = false,
    this.isCreatingVirtualAccount = false,
    this.isDecliningVirtualAccount = false,
    this.virtualAccountStatus,
    this.virtualAccount,
    this.virtualAccountErrorMessage,
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
    bool? isFetchingVirtualAccountStatus,
    bool? isCreatingVirtualAccount,
    bool? isDecliningVirtualAccount,
    VirtualAccountStatusEntity? virtualAccountStatus,
    VirtualAccountEntity? virtualAccount,
    String? virtualAccountErrorMessage,
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
      isFetchingVirtualAccountStatus:
          isFetchingVirtualAccountStatus ?? this.isFetchingVirtualAccountStatus,
      isCreatingVirtualAccount:
          isCreatingVirtualAccount ?? this.isCreatingVirtualAccount,
      isDecliningVirtualAccount:
          isDecliningVirtualAccount ?? this.isDecliningVirtualAccount,
      virtualAccountStatus: virtualAccountStatus ?? this.virtualAccountStatus,
      virtualAccount: virtualAccount ?? this.virtualAccount,
      virtualAccountErrorMessage: virtualAccountErrorMessage,
    );
  }
}
