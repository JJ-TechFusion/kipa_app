import '../../domain/entities/bank_entity.dart';

class BankModel extends BankEntity {
  BankModel({
    required super.code,
    required super.name,
  });

  factory BankModel.fromJson(Map<String, dynamic> json) {
    return BankModel(
      code: json['code'] ?? '',
      name: json['name'] ?? '',
    );
  }
}

class BankAccountModel extends BankAccountEntity {
  BankAccountModel({
    required super.id,
    required super.bankName,
    required super.accountNumber,
    required super.accountName,
    required super.bankCode,
    required super.isDefault,
    required super.createdAt,
  });

  factory BankAccountModel.fromJson(Map<String, dynamic> json) {
    return BankAccountModel(
      id: json['id'] ?? '',
      bankName: json['bank_name'] ?? '',
      accountNumber: json['account_number'] ?? '',
      accountName: json['account_name'] ?? '',
      bankCode: json['bank_code'] ?? '',
      isDefault: json['is_default'] ?? false,
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
    );
  }
}

class AddBankAccountRequestModel extends AddBankAccountRequestEntity {
  AddBankAccountRequestModel({
    required super.bankCode,
    required super.accountNumber,
  });

  Map<String, dynamic> toJson() {
    return {
      'bank_code': bankCode,
      'account_number': accountNumber,
    };
  }
}

class ResolveAccountRequestModel extends ResolveAccountRequestEntity {
  ResolveAccountRequestModel({
    required super.accountNumber,
    required super.bankCode,
  });

  Map<String, dynamic> toJson() {
    return {
      'account_number': accountNumber,
      'bank_code': bankCode,
    };
  }
}

class ResolveAccountResponseModel extends ResolveAccountResponseEntity {
  ResolveAccountResponseModel({
    required super.accountName,
    required super.accountNumber,
  });

  factory ResolveAccountResponseModel.fromJson(Map<String, dynamic> json) {
    return ResolveAccountResponseModel(
      accountName: json['account_name'] ?? '',
      accountNumber: json['account_number'] ?? '',
    );
  }
}
