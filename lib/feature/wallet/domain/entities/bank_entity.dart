class BankEntity {
  final String code;
  final String name;

  BankEntity({required this.code, required this.name});
}

class BankAccountEntity {
  final String id;
  final String bankName;
  final String accountNumber;
  final String accountName;
  final String bankCode;
  final bool isDefault;
  final DateTime createdAt;

  BankAccountEntity({
    required this.id,
    required this.bankName,
    required this.accountNumber,
    required this.accountName,
    required this.bankCode,
    required this.isDefault,
    required this.createdAt,
  });
}

class AddBankAccountRequestEntity {
  final String bankCode;
  final String accountNumber;

  AddBankAccountRequestEntity({
    required this.bankCode,
    required this.accountNumber,
  });
}

class ResolveAccountRequestEntity {
  final String accountNumber;
  final String bankCode;

  ResolveAccountRequestEntity({
    required this.accountNumber,
    required this.bankCode,
  });
}

class ResolveAccountResponseEntity {
  final String accountName;
  final String accountNumber;

  ResolveAccountResponseEntity({
    required this.accountName,
    required this.accountNumber,
  });
}
