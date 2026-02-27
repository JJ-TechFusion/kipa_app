import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/bank_entity.dart';
import '../../domain/usecases/get_banks_usecase.dart';
import '../../domain/usecases/get_bank_accounts_usecase.dart';
import '../../domain/usecases/resolve_account_usecase.dart';
import '../../domain/usecases/add_bank_account_usecase.dart';
import '../../domain/usecases/set_default_bank_account_usecase.dart';
import '../../domain/usecases/delete_bank_account_usecase.dart';
import '../providers/bank_accounts_provider.dart';
import 'bank_accounts_state.dart';

class BankAccountsNotifier extends Notifier<BankAccountsState> {
  late final GetBanksUseCase _getBanksUseCase;
  late final GetBankAccountsUseCase _getBankAccountsUseCase;
  late final ResolveAccountUseCase _resolveAccountUseCase;
  late final AddBankAccountUseCase _addBankAccountUseCase;
  late final SetDefaultBankAccountUseCase _setDefaultBankAccountUseCase;
  late final DeleteBankAccountUseCase _deleteBankAccountUseCase;

  @override
  BankAccountsState build() {
    _getBanksUseCase = ref.read(getBanksUseCaseProvider);
    _getBankAccountsUseCase = ref.read(getBankAccountsUseCaseProvider);
    _resolveAccountUseCase = ref.read(resolveAccountUseCaseProvider);
    _addBankAccountUseCase = ref.read(addBankAccountUseCaseProvider);
    _setDefaultBankAccountUseCase = ref.read(
      setDefaultBankAccountUseCaseProvider,
    );
    _deleteBankAccountUseCase = ref.read(deleteBankAccountUseCaseProvider);
    return const BankAccountsState();
  }

  Future<void> getBanks() async {
    state = state.copyWith(isFetchingBanks: true, errorMessage: null);

    try {
      final response = await _getBanksUseCase();

      if (response.success && response.data != null) {
        final banks = response.data as List<BankEntity>;
        state = state.copyWith(isFetchingBanks: false, banks: banks);
      } else {
        state = state.copyWith(
          isFetchingBanks: false,
          errorMessage: response.message,
        );
      }
    } catch (e) {
      state = state.copyWith(
        isFetchingBanks: false,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> getBankAccounts() async {
    state = state.copyWith(isFetchingBankAccounts: true, errorMessage: null);

    try {
      final response = await _getBankAccountsUseCase();

      if (response.success && response.data != null) {
        final accounts = response.data as List<BankAccountEntity>;
        state = state.copyWith(
          isFetchingBankAccounts: false,
          bankAccounts: accounts,
        );
      } else {
        state = state.copyWith(
          isFetchingBankAccounts: false,
          errorMessage: response.message,
        );
      }
    } catch (e) {
      state = state.copyWith(
        isFetchingBankAccounts: false,
        errorMessage: e.toString(),
      );
    }
  }

  Future<bool> resolveAccount(String accountNumber, String bankCode) async {
    state = state.copyWith(isResolvingAccount: true, errorMessage: null);

    try {
      final response = await _resolveAccountUseCase(accountNumber, bankCode);

      if (response.success && response.data != null) {
        final resolvedAccount = response.data as ResolveAccountResponseEntity;
        state = state.copyWith(
          isResolvingAccount: false,
          resolvedAccount: resolvedAccount,
        );
        return true;
      } else {
        state = state.copyWith(
          isResolvingAccount: false,
          errorMessage: response.message,
        );
        return false;
      }
    } catch (e) {
      state = state.copyWith(
        isResolvingAccount: false,
        errorMessage: e.toString(),
      );
      return false;
    }
  }

  void clearResolvedAccount() {
    state = state.copyWith(resolvedAccount: null);
  }

  Future<bool> addBankAccount(String bankCode, String accountNumber) async {
    state = state.copyWith(isAddingBankAccount: true, errorMessage: null);

    try {
      final response = await _addBankAccountUseCase(bankCode, accountNumber);

      if (response.success) {
        state = state.copyWith(
          isAddingBankAccount: false,
          resolvedAccount: null,
        );
        await getBankAccounts();
        return true;
      } else {
        state = state.copyWith(
          isAddingBankAccount: false,
          errorMessage: response.message,
        );
        return false;
      }
    } catch (e) {
      state = state.copyWith(
        isAddingBankAccount: false,
        errorMessage: e.toString(),
      );
      return false;
    }
  }

  Future<bool> setDefaultBankAccount(String id) async {
    state = state.copyWith(isSettingDefault: true, errorMessage: null);

    try {
      final response = await _setDefaultBankAccountUseCase(id);

      if (response.success) {
        state = state.copyWith(isSettingDefault: false);
        await getBankAccounts();
        return true;
      } else {
        state = state.copyWith(
          isSettingDefault: false,
          errorMessage: response.message,
        );
        return false;
      }
    } catch (e) {
      state = state.copyWith(
        isSettingDefault: false,
        errorMessage: e.toString(),
      );
      return false;
    }
  }

  Future<bool> deleteBankAccount(String id) async {
    state = state.copyWith(isDeletingBankAccount: true, errorMessage: null);

    try {
      final response = await _deleteBankAccountUseCase(id);

      if (response.success) {
        state = state.copyWith(isDeletingBankAccount: false);
        await getBankAccounts();
        return true;
      } else {
        state = state.copyWith(
          isDeletingBankAccount: false,
          errorMessage: response.message,
        );
        return false;
      }
    } catch (e) {
      state = state.copyWith(
        isDeletingBankAccount: false,
        errorMessage: e.toString(),
      );
      return false;
    }
  }

  void clearError() {
    state = state.copyWith(errorMessage: null);
  }
}
