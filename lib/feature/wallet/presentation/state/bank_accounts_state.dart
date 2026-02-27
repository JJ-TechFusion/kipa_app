import '../../domain/entities/bank_entity.dart';

class BankAccountsState {
  final bool isFetchingBanks;
  final bool isFetchingBankAccounts;
  final bool isResolvingAccount;
  final bool isAddingBankAccount;
  final bool isSettingDefault;
  final bool isDeletingBankAccount;
  final String? errorMessage;
  final List<BankEntity> banks;
  final List<BankAccountEntity> bankAccounts;
  final ResolveAccountResponseEntity? resolvedAccount;

  const BankAccountsState({
    this.isFetchingBanks = false,
    this.isFetchingBankAccounts = false,
    this.isResolvingAccount = false,
    this.isAddingBankAccount = false,
    this.isSettingDefault = false,
    this.isDeletingBankAccount = false,
    this.errorMessage,
    this.banks = const [],
    this.bankAccounts = const [],
    this.resolvedAccount,
  });

  BankAccountsState copyWith({
    bool? isFetchingBanks,
    bool? isFetchingBankAccounts,
    bool? isResolvingAccount,
    bool? isAddingBankAccount,
    bool? isSettingDefault,
    bool? isDeletingBankAccount,
    String? errorMessage,
    List<BankEntity>? banks,
    List<BankAccountEntity>? bankAccounts,
    ResolveAccountResponseEntity? resolvedAccount,
  }) {
    return BankAccountsState(
      isFetchingBanks: isFetchingBanks ?? this.isFetchingBanks,
      isFetchingBankAccounts:
          isFetchingBankAccounts ?? this.isFetchingBankAccounts,
      isResolvingAccount: isResolvingAccount ?? this.isResolvingAccount,
      isAddingBankAccount: isAddingBankAccount ?? this.isAddingBankAccount,
      isSettingDefault: isSettingDefault ?? this.isSettingDefault,
      isDeletingBankAccount:
          isDeletingBankAccount ?? this.isDeletingBankAccount,
      errorMessage: errorMessage,
      banks: banks ?? this.banks,
      bankAccounts: bankAccounts ?? this.bankAccounts,
      resolvedAccount: resolvedAccount,
    );
  }
}
