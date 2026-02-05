// Wallet entities

class WalletEntity {
  final double availableBalance;
  final double lockedBalance;
  final double totalEarned;
  final double totalWithdrawn;

  WalletEntity({
    required this.availableBalance,
    required this.lockedBalance,
    required this.totalEarned,
    required this.totalWithdrawn,
  });
}

class TopUpRequestEntity {
  final double amount;

  TopUpRequestEntity({required this.amount});
}

class TopUpResponseEntity {
  final String accessCode;
  final String authorizationUrl;
  final String paymentReference;
  final String topUpId;

  TopUpResponseEntity({
    required this.accessCode,
    required this.authorizationUrl,
    required this.paymentReference,
    required this.topUpId,
  });
}

class VerifyTopUpRequestEntity {
  final String reference;

  VerifyTopUpRequestEntity({required this.reference});
}

class VerifyTopUpResponseEntity {
  final String message;

  VerifyTopUpResponseEntity({required this.message});
}
