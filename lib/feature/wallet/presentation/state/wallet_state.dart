import '../../domain/entities/wallet_entities.dart';

class WalletState {
  final bool isFetchingWallet;
  final bool isToppingUp;
  final bool isVerifyingTopUp;
  final String? errorMessage;
  final WalletEntity? wallet;
  final TopUpResponseEntity? topUpResponse;
  final VerifyTopUpResponseEntity? verifyTopUpResponse;

  const WalletState({
    this.isFetchingWallet = false,
    this.isToppingUp = false,
    this.isVerifyingTopUp = false,
    this.errorMessage,
    this.wallet,
    this.topUpResponse,
    this.verifyTopUpResponse,
  });

  WalletState copyWith({
    bool? isFetchingWallet,
    bool? isToppingUp,
    bool? isVerifyingTopUp,
    String? errorMessage,
    WalletEntity? wallet,
    TopUpResponseEntity? topUpResponse,
    VerifyTopUpResponseEntity? verifyTopUpResponse,
  }) {
    return WalletState(
      isFetchingWallet: isFetchingWallet ?? this.isFetchingWallet,
      isToppingUp: isToppingUp ?? this.isToppingUp,
      isVerifyingTopUp: isVerifyingTopUp ?? this.isVerifyingTopUp,
      errorMessage: errorMessage,
      wallet: wallet ?? this.wallet,
      topUpResponse: topUpResponse ?? this.topUpResponse,
      verifyTopUpResponse: verifyTopUpResponse ?? this.verifyTopUpResponse,
    );
  }
}
