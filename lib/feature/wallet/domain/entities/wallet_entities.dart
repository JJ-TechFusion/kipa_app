import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class WalletEntity {
  final double availableBalance;
  final double lockedBalance;
  final double totalEarned;
  final double totalWithdrawn;
  final double pendingEscrowAsBuyer;
  final double pendingEscrowAsSeller;
  final double totalPendingEscrow;
  final bool hasPin;

  WalletEntity({
    required this.availableBalance,
    required this.lockedBalance,
    required this.totalEarned,
    required this.totalWithdrawn,
    this.pendingEscrowAsBuyer = 0,
    this.pendingEscrowAsSeller = 0,
    this.totalPendingEscrow = 0,
    this.hasPin = false,
  });
}

class TopUpRequestEntity {
  final double amount;

  TopUpRequestEntity({required this.amount});
}

class TopUpResponseEntity {
  final String link;
  final String txRef;
  final String topUpId;

  TopUpResponseEntity({
    required this.link,
    required this.txRef,
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

class WalletTransactionEntity {
  final String id;
  final String type;
  final double amount;
  final double balanceAfter;
  final String referenceType;
  final String referenceId;
  final String description;
  final DateTime createdAt;

  WalletTransactionEntity({
    required this.id,
    required this.type,
    required this.amount,
    required this.balanceAfter,
    required this.referenceType,
    required this.referenceId,
    required this.description,
    required this.createdAt,
  });

  bool get isCredit => amount > 0;

  String get formattedDate => DateFormat('dd MMM, HH:mm').format(createdAt);

  String get formattedType {
    switch (type) {
      case 'top_up':
        return 'Wallet Top-Up';
      case 'escrow_fund':
        return 'Escrow Payment';
      case 'escrow_release':
        return 'Escrow Released';
      case 'withdrawal':
        return 'Withdrawal';
      default:
        return type
            .replaceAll('_', ' ')
            .split(' ')
            .map(
              (w) =>
                  w.isNotEmpty ? '${w[0].toUpperCase()}${w.substring(1)}' : '',
            )
            .join(' ');
    }
  }

  IconData get icon {
    switch (type) {
      case 'top_up':
        return Icons.add_circle_outline;
      case 'escrow_fund':
        return Icons.lock_outline;
      case 'escrow_release':
        return Icons.lock_open;
      case 'withdrawal':
        return Icons.arrow_downward;
      default:
        return Icons.account_balance_wallet_outlined;
    }
  }

  String get displayTitle =>
      description.isNotEmpty ? description : formattedType;
}

class WalletTransactionListEntity {
  final int count;
  final List<WalletTransactionEntity> transactions;

  WalletTransactionListEntity({
    required this.count,
    required this.transactions,
  });
}

class CounterPartyEntity {
  final String id;
  final String name;
  final String photoUrl;

  CounterPartyEntity({
    required this.id,
    required this.name,
    required this.photoUrl,
  });
}

class PendingFundEntity {
  final String escrowId;
  final String paymentRequestId;
  final String status;
  final double itemAmount;
  final double totalLocked;
  final String itemName;
  final String itemDescription;
  final int processingTimeHours;
  final String role;
  final CounterPartyEntity counterParty;
  final DateTime fundedAt;
  final DateTime createdAt;

  PendingFundEntity({
    required this.escrowId,
    required this.paymentRequestId,
    required this.status,
    required this.itemAmount,
    required this.totalLocked,
    required this.itemName,
    required this.itemDescription,
    required this.processingTimeHours,
    required this.role,
    required this.counterParty,
    required this.fundedAt,
    required this.createdAt,
  });

  String get formattedStatus {
    switch (status) {
      case 'funded':
        return 'Funded';
      case 'delivery_in_progress':
        return 'In Transit';
      case 'delivered':
        return 'Delivered';
      case 'confirmation_window':
        return 'Confirming';
      case 'disputed':
        return 'Disputed';
      default:
        return status
            .replaceAll('_', ' ')
            .split(' ')
            .map(
              (w) =>
                  w.isNotEmpty ? '${w[0].toUpperCase()}${w.substring(1)}' : '',
            )
            .join(' ');
    }
  }
}

class PendingFundListEntity {
  final List<PendingFundEntity> pendingFunds;
  final int count;
  final double totalPending;

  PendingFundListEntity({
    required this.pendingFunds,
    required this.count,
    required this.totalPending,
  });
}

class PinStatusEntity {
  final bool hasPin;
  final bool isLocked;
  final int attemptsLeft;
  final DateTime? pinCreatedAt;

  PinStatusEntity({
    required this.hasPin,
    required this.isLocked,
    required this.attemptsLeft,
    this.pinCreatedAt,
  });
}

class CreatePinRequestEntity {
  final String pin;

  CreatePinRequestEntity({required this.pin});
}

class VerifyPinRequestEntity {
  final String pin;

  VerifyPinRequestEntity({required this.pin});
}

class ChangePinRequestEntity {
  final String oldPin;
  final String newPin;

  ChangePinRequestEntity({required this.oldPin, required this.newPin});
}

class PinResponseEntity {
  final String message;

  PinResponseEntity({required this.message});
}

class PinResetRequestResponseEntity {
  final String message;
  final DateTime expiresAt;
  final int retryAfterSeconds;

  PinResetRequestResponseEntity({
    required this.message,
    required this.expiresAt,
    required this.retryAfterSeconds,
  });
}

class PinResetConfirmRequestEntity {
  final String otpCode;
  final String newPin;

  PinResetConfirmRequestEntity({required this.otpCode, required this.newPin});
}

class SubaccountEntity {
  final String id;
  final String accountBank;
  final String accountNumber;
  final String accountReference;
  final String barterId;
  final String businessName;
  final bool isActive;

  SubaccountEntity({
    required this.id,
    required this.accountBank,
    required this.accountNumber,
    required this.accountReference,
    required this.barterId,
    required this.businessName,
    required this.isActive,
  });
}

class CreateSubaccountRequestEntity {
  final String email;

  CreateSubaccountRequestEntity({required this.email});
}

class WalletSyncResponseEntity {
  final double previousBalance;
  final double flutterwaveBalance;
  final double newBalance;
  final double amountSynced;
  final bool wasSynced;
  final String message;

  WalletSyncResponseEntity({
    required this.previousBalance,
    required this.flutterwaveBalance,
    required this.newBalance,
    required this.amountSynced,
    required this.wasSynced,
    required this.message,
  });
}

class WithdrawRequestEntity {
  final String bankAccountId;
  final double amount;

  WithdrawRequestEntity({
    required this.bankAccountId,
    required this.amount,
  });
}

class WithdrawalEntity {
  final String id;
  final double amount;
  final double fee;
  final double netAmount;
  final String status;
  final String transferRef;
  final String paymentProvider;
  final DateTime createdAt;

  WithdrawalEntity({
    required this.id,
    required this.amount,
    required this.fee,
    required this.netAmount,
    required this.status,
    required this.transferRef,
    required this.paymentProvider,
    required this.createdAt,
  });
}
