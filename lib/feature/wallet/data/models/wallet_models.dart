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

class WalletSyncResponseModel extends WalletSyncResponseEntity {
  WalletSyncResponseModel({
    required super.previousBalance,
    required super.flutterwaveBalance,
    required super.newBalance,
    required super.amountSynced,
    required super.wasSynced,
    required super.message,
  });

  factory WalletSyncResponseModel.fromJson(Map<String, dynamic> json) {
    return WalletSyncResponseModel(
      previousBalance: (json['previous_balance'] ?? 0).toDouble(),
      flutterwaveBalance: (json['flutterwave_balance'] ?? 0).toDouble(),
      newBalance: (json['new_balance'] ?? 0).toDouble(),
      amountSynced: (json['amount_synced'] ?? 0).toDouble(),
      wasSynced: json['was_synced'] ?? false,
      message: json['message'] ?? '',
    );
  }
}

class WithdrawRequestModel extends WithdrawRequestEntity {
  WithdrawRequestModel({required super.bankAccountId, required super.amount});

  Map<String, dynamic> toJson() {
    return {'bank_account_id': bankAccountId, 'amount': amount};
  }
}

class WithdrawalModel extends WithdrawalEntity {
  WithdrawalModel({
    required super.id,
    required super.amount,
    required super.fee,
    required super.netAmount,
    required super.status,
    required super.transferRef,
    required super.paymentProvider,
    required super.createdAt,
  });

  factory WithdrawalModel.fromJson(Map<String, dynamic> json) {
    return WithdrawalModel(
      id: json['id'] ?? '',
      amount: (json['amount'] ?? 0).toDouble(),
      fee: (json['fee'] ?? 0).toDouble(),
      netAmount: (json['net_amount'] ?? 0).toDouble(),
      status: json['status'] ?? '',
      transferRef: json['transfer_ref'] ?? '',
      paymentProvider: json['payment_provider'] ?? '',
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
    );
  }
}

class VirtualAccountModel extends VirtualAccountEntity {
  VirtualAccountModel({
    required super.accountNumber,
    required super.bankName,
    required super.createdAt,
    required super.email,
    required super.isActive,
  });

  factory VirtualAccountModel.fromJson(Map<String, dynamic> json) {
    return VirtualAccountModel(
      accountNumber: json['account_number'] ?? '',
      bankName: json['bank_name'] ?? '',
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
      email: json['email'] ?? '',
      isActive: json['is_active'] ?? false,
    );
  }
}

class VirtualAccountStatusModel extends VirtualAccountStatusEntity {
  VirtualAccountStatusModel({
    required super.hasAccount,
    required super.declined,
    super.account,
  });

  factory VirtualAccountStatusModel.fromJson(Map<String, dynamic> json) {
    return VirtualAccountStatusModel(
      hasAccount: json['has_account'] ?? false,
      declined: json['declined'] ?? false,
      account: json['account'] != null
          ? VirtualAccountModel.fromJson(
              json['account'] as Map<String, dynamic>,
            )
          : null,
    );
  }
}

class CreateVirtualAccountRequestModel
    extends CreateVirtualAccountRequestEntity {
  CreateVirtualAccountRequestModel({required super.bvn});

  Map<String, dynamic> toJson() {
    return {'bvn': bvn};
  }
}
