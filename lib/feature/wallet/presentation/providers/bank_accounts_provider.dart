import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/usecases/get_banks_usecase.dart';
import '../../domain/usecases/get_bank_accounts_usecase.dart';
import '../../domain/usecases/resolve_account_usecase.dart';
import '../../domain/usecases/add_bank_account_usecase.dart';
import '../../domain/usecases/set_default_bank_account_usecase.dart';
import '../../domain/usecases/delete_bank_account_usecase.dart';
import '../../../wallet/presentation/providers/wallet_provider.dart';
import '../state/bank_accounts_notifier.dart';
import '../state/bank_accounts_state.dart';

final getBanksUseCaseProvider = Provider<GetBanksUseCase>((ref) {
  return GetBanksUseCase(ref.read(walletRepositoryProvider));
});

final getBankAccountsUseCaseProvider = Provider<GetBankAccountsUseCase>((ref) {
  return GetBankAccountsUseCase(ref.read(walletRepositoryProvider));
});

final resolveAccountUseCaseProvider = Provider<ResolveAccountUseCase>((ref) {
  return ResolveAccountUseCase(ref.read(walletRepositoryProvider));
});

final addBankAccountUseCaseProvider = Provider<AddBankAccountUseCase>((ref) {
  return AddBankAccountUseCase(ref.read(walletRepositoryProvider));
});

final setDefaultBankAccountUseCaseProvider =
    Provider<SetDefaultBankAccountUseCase>((ref) {
      return SetDefaultBankAccountUseCase(ref.read(walletRepositoryProvider));
    });

final deleteBankAccountUseCaseProvider =
    Provider<DeleteBankAccountUseCase>((ref) {
      return DeleteBankAccountUseCase(ref.read(walletRepositoryProvider));
    });

final bankAccountsNotifierProvider =
    NotifierProvider<BankAccountsNotifier, BankAccountsState>(
  BankAccountsNotifier.new,
);
