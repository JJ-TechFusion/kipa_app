import '../../domain/entities/wallet_entities.dart';

class WalletModel extends WalletEntity {
  WalletModel({
    required super.availableBalance,
    required super.lockedBalance,
    required super.totalEarned,
    required super.totalWithdrawn,
  });

  factory WalletModel.fromJson(Map<String, dynamic> json) {
    return WalletModel(
      availableBalance: (json['available_balance'] ?? 0).toDouble(),
      lockedBalance: (json['locked_balance'] ?? 0).toDouble(),
      totalEarned: (json['total_earned'] ?? 0).toDouble(),
      totalWithdrawn: (json['total_withdrawn'] ?? 0).toDouble(),
    );
  }
}

class TopUpRequestModel extends TopUpRequestEntity {
  TopUpRequestModel({required super.amount});

  Map<String, dynamic> toJson() {
    return {'amount': amount};
  }
}

class TopUpResponseModel extends TopUpResponseEntity {
  TopUpResponseModel({
    required super.accessCode,
    required super.authorizationUrl,
    required super.paymentReference,
    required super.topUpId,
  });

  factory TopUpResponseModel.fromJson(Map<String, dynamic> json) {
    return TopUpResponseModel(
      accessCode: json['access_code'] ?? '',
      authorizationUrl: json['authorization_url'] ?? '',
      paymentReference: json['payment_reference'] ?? '',
      topUpId: json['top_up_id'] ?? '',
    );
  }
}

class VerifyTopUpRequestModel extends VerifyTopUpRequestEntity {
  VerifyTopUpRequestModel({required super.reference});

  Map<String, dynamic> toJson() {
    return {'reference': reference};
  }
}

class VerifyTopUpResponseModel extends VerifyTopUpResponseEntity {
  VerifyTopUpResponseModel({required super.message});

  factory VerifyTopUpResponseModel.fromJson(Map<String, dynamic> json) {
    return VerifyTopUpResponseModel(message: json['message'] ?? '');
  }
}
