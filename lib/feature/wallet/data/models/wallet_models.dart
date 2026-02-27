import '../../domain/entities/wallet_entities.dart';

class WalletModel extends WalletEntity {
  WalletModel({
    required super.availableBalance,
    required super.lockedBalance,
    required super.totalEarned,
    required super.totalWithdrawn,
    super.pendingEscrowAsBuyer,
    super.pendingEscrowAsSeller,
    super.totalPendingEscrow,
    super.hasPin,
  });

  factory WalletModel.fromJson(Map<String, dynamic> json) {
    return WalletModel(
      availableBalance: (json['available_balance'] ?? 0).toDouble(),
      lockedBalance: (json['locked_balance'] ?? 0).toDouble(),
      totalEarned: (json['total_earned'] ?? 0).toDouble(),
      totalWithdrawn: (json['total_withdrawn'] ?? 0).toDouble(),
      pendingEscrowAsBuyer: (json['pending_escrow_as_buyer'] ?? 0).toDouble(),
      pendingEscrowAsSeller: (json['pending_escrow_as_seller'] ?? 0).toDouble(),
      totalPendingEscrow: (json['total_pending_escrow'] ?? 0).toDouble(),
      hasPin: json['has_pin'] ?? false,
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
    required super.link,
    required super.txRef,
    required super.topUpId,
  });

  factory TopUpResponseModel.fromJson(Map<String, dynamic> json) {
    return TopUpResponseModel(
      link: json['authorization_url'] ?? json['link'] ?? '',
      txRef: json['payment_reference'] ?? json['tx_ref'] ?? '',
      topUpId: json['top_up_id'] ?? '',
    );
  }
}

class VerifyTopUpRequestModel extends VerifyTopUpRequestEntity {
  VerifyTopUpRequestModel({required super.reference});

  Map<String, dynamic> toJson() {
    return {'tx_ref': reference};
  }
}

class VerifyTopUpResponseModel extends VerifyTopUpResponseEntity {
  VerifyTopUpResponseModel({required super.message});

  factory VerifyTopUpResponseModel.fromJson(Map<String, dynamic> json) {
    return VerifyTopUpResponseModel(message: json['message'] ?? '');
  }
}

class WalletTransactionModel extends WalletTransactionEntity {
  WalletTransactionModel({
    required super.id,
    required super.type,
    required super.amount,
    required super.balanceAfter,
    required super.referenceType,
    required super.referenceId,
    required super.description,
    required super.createdAt,
  });

  factory WalletTransactionModel.fromJson(Map<String, dynamic> json) {
    return WalletTransactionModel(
      id: json['id'] ?? '',
      type: json['type'] ?? '',
      amount: (json['amount'] ?? 0).toDouble(),
      balanceAfter: (json['balance_after'] ?? 0).toDouble(),
      referenceType: json['reference_type'] ?? '',
      referenceId: json['reference_id'] ?? '',
      description: json['description'] ?? '',
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
    );
  }
}

class WalletTransactionListModel extends WalletTransactionListEntity {
  WalletTransactionListModel({
    required super.count,
    required super.transactions,
  });

  factory WalletTransactionListModel.fromJson(Map<String, dynamic> json) {
    final transactionsList =
        (json['transactions'] as List<dynamic>?)
            ?.map(
              (e) => WalletTransactionModel.fromJson(e as Map<String, dynamic>),
            )
            .toList() ??
        [];
    return WalletTransactionListModel(
      count: json['count'] ?? 0,
      transactions: transactionsList,
    );
  }
}

class CounterPartyModel extends CounterPartyEntity {
  CounterPartyModel({
    required super.id,
    required super.name,
    required super.photoUrl,
  });

  factory CounterPartyModel.fromJson(Map<String, dynamic> json) {
    return CounterPartyModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      photoUrl: json['photo_url'] ?? '',
    );
  }
}

class PendingFundModel extends PendingFundEntity {
  PendingFundModel({
    required super.escrowId,
    required super.paymentRequestId,
    required super.status,
    required super.itemAmount,
    required super.totalLocked,
    required super.itemName,
    required super.itemDescription,
    required super.processingTimeHours,
    required super.role,
    required super.counterParty,
    required super.fundedAt,
    required super.createdAt,
  });

  factory PendingFundModel.fromJson(Map<String, dynamic> json) {
    return PendingFundModel(
      escrowId: json['escrow_id'] ?? '',
      paymentRequestId: json['payment_request_id'] ?? '',
      status: json['status'] ?? '',
      itemAmount: (json['item_amount'] ?? 0).toDouble(),
      totalLocked: (json['total_locked'] ?? 0).toDouble(),
      itemName: json['item_name'] ?? '',
      itemDescription: json['item_description'] ?? '',
      processingTimeHours: json['processing_time_hours'] ?? 0,
      role: json['role'] ?? '',
      counterParty: CounterPartyModel.fromJson(
        json['counter_party'] as Map<String, dynamic>? ?? {},
      ),
      fundedAt: DateTime.tryParse(json['funded_at'] ?? '') ?? DateTime.now(),
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
    );
  }
}

class PendingFundListModel extends PendingFundListEntity {
  PendingFundListModel({
    required super.pendingFunds,
    required super.count,
    required super.totalPending,
  });

  factory PendingFundListModel.fromJson(Map<String, dynamic> json) {
    final funds =
        (json['pending_funds'] as List<dynamic>?)
            ?.map((e) => PendingFundModel.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [];
    return PendingFundListModel(
      pendingFunds: funds,
      count: json['count'] ?? 0,
      totalPending: (json['total_pending'] ?? 0).toDouble(),
    );
  }
}

class PinStatusModel extends PinStatusEntity {
  PinStatusModel({
    required super.hasPin,
    required super.isLocked,
    required super.attemptsLeft,
    super.pinCreatedAt,
  });

  factory PinStatusModel.fromJson(Map<String, dynamic> json) {
    return PinStatusModel(
      hasPin: json['has_pin'] ?? false,
      isLocked: json['is_locked'] ?? false,
      attemptsLeft: json['attempts_left'] ?? 5,
      pinCreatedAt: json['pin_created_at'] != null
          ? DateTime.tryParse(json['pin_created_at'])
          : null,
    );
  }
}

class CreatePinRequestModel extends CreatePinRequestEntity {
  CreatePinRequestModel({required super.pin});

  Map<String, dynamic> toJson() {
    return {'pin': pin};
  }
}

class VerifyPinRequestModel extends VerifyPinRequestEntity {
  VerifyPinRequestModel({required super.pin});

  Map<String, dynamic> toJson() {
    return {'pin': pin};
  }
}

class ChangePinRequestModel extends ChangePinRequestEntity {
  ChangePinRequestModel({required super.oldPin, required super.newPin});

  Map<String, dynamic> toJson() {
    return {'old_pin': oldPin, 'new_pin': newPin};
  }
}

class PinResponseModel extends PinResponseEntity {
  PinResponseModel({required super.message});

  factory PinResponseModel.fromJson(Map<String, dynamic> json) {
    return PinResponseModel(message: json['message'] ?? '');
  }
}

class PinResetRequestResponseModel extends PinResetRequestResponseEntity {
  PinResetRequestResponseModel({
    required super.message,
    required super.expiresAt,
    required super.retryAfterSeconds,
  });

  factory PinResetRequestResponseModel.fromJson(Map<String, dynamic> json) {
    return PinResetRequestResponseModel(
      message: json['message'] ?? '',
      expiresAt: DateTime.tryParse(json['expires_at'] ?? '') ?? DateTime.now(),
      retryAfterSeconds: json['retry_after_seconds'] ?? 60,
    );
  }
}

class PinResetConfirmRequestModel extends PinResetConfirmRequestEntity {
  PinResetConfirmRequestModel({required super.otpCode, required super.newPin});

  Map<String, dynamic> toJson() {
    return {'otp_code': otpCode, 'new_pin': newPin};
  }
}
