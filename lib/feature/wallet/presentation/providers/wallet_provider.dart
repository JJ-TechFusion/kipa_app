import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/services/network/api_services.dart';
import '../../../../utils/constant.dart';
import '../../data/datasources/wallet_remote_datasource.dart';
import '../../data/repositories/wallet_repository_impl.dart';
import '../../domain/repositories/wallet_repository.dart';
import '../../domain/usecases/get_wallet_usecase.dart';
import '../../domain/usecases/get_wallet_transactions_usecase.dart';
import '../../domain/usecases/get_pending_funds_usecase.dart';
import '../../domain/usecases/top_up_wallet_usecase.dart';
import '../../domain/usecases/verify_top_up_usecase.dart';
import '../../domain/usecases/get_pin_status_usecase.dart';
import '../../domain/usecases/create_pin_usecase.dart';
import '../../domain/usecases/verify_pin_usecase.dart';
import '../../domain/usecases/change_pin_usecase.dart';
import '../state/wallet_notifier.dart';
import '../state/wallet_state.dart';

// Data Source
final walletRemoteDataSourceProvider = Provider<WalletRemoteDataSource>((ref) {
  return WalletRemoteDataSource(getIt<ApiService>());
});

// Repository
final walletRepositoryProvider = Provider<WalletRepository>((ref) {
  return WalletRepositoryImpl(ref.read(walletRemoteDataSourceProvider));
});

// Use Cases
final getWalletUseCaseProvider = Provider<GetWalletUseCase>((ref) {
  return GetWalletUseCase(ref.read(walletRepositoryProvider));
});

final topUpWalletUseCaseProvider = Provider<TopUpWalletUseCase>((ref) {
  return TopUpWalletUseCase(ref.read(walletRepositoryProvider));
});

final verifyTopUpUseCaseProvider = Provider<VerifyTopUpUseCase>((ref) {
  return VerifyTopUpUseCase(ref.read(walletRepositoryProvider));
});

final getWalletTransactionsUseCaseProvider =
    Provider<GetWalletTransactionsUseCase>((ref) {
      return GetWalletTransactionsUseCase(ref.read(walletRepositoryProvider));
    });

final getPendingFundsUseCaseProvider = Provider<GetPendingFundsUseCase>((ref) {
  return GetPendingFundsUseCase(ref.read(walletRepositoryProvider));
});

// PIN Use Cases
final getPinStatusUseCaseProvider = Provider<GetPinStatusUseCase>((ref) {
  return GetPinStatusUseCase(ref.read(walletRepositoryProvider));
});

final createPinUseCaseProvider = Provider<CreatePinUseCase>((ref) {
  return CreatePinUseCase(ref.read(walletRepositoryProvider));
});

final verifyPinUseCaseProvider = Provider<VerifyPinUseCase>((ref) {
  return VerifyPinUseCase(ref.read(walletRepositoryProvider));
});

final changePinUseCaseProvider = Provider<ChangePinUseCase>((ref) {
  return ChangePinUseCase(ref.read(walletRepositoryProvider));
});

// Notifier
final walletNotifierProvider = NotifierProvider<WalletNotifier, WalletState>(
  WalletNotifier.new,
);
