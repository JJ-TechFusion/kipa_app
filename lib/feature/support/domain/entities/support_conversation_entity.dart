class SupportConversationEntity {
  final String id;
  final String userId;
  final String userName;
  final String userPhone;
  final String status;
  final DateTime? lastMessageAt;
  final int unreadCount;
  final DateTime createdAt;

  const SupportConversationEntity({
    required this.id,
    required this.userId,
    required this.userName,
    required this.userPhone,
    required this.status,
    required this.lastMessageAt,
    required this.unreadCount,
    required this.createdAt,
  });
}

class SupportDisputeEntity {
  final String id;
  final String escrowId;
  final String openedBy;
  final String reason;
  final List<String> evidence;
  final String status;
  final String outcome;
  final DateTime createdAt;

  const SupportDisputeEntity({
    required this.id,
    required this.escrowId,
    required this.openedBy,
    required this.reason,
    required this.evidence,
    required this.status,
    required this.outcome,
    required this.createdAt,
  });
}

class SupportEscrowEntity {
  final String id;
  final String paymentRequestId;
  final String buyerId;
  final String sellerId;
  final double itemAmount;
  final double buyerFee;
  final double deliveryFeeEstimate;
  final double totalLocked;
  final String status;
  final DateTime? fundedAt;
  final DateTime? confirmationWindowEndsAt;
  final DateTime createdAt;

  const SupportEscrowEntity({
    required this.id,
    required this.paymentRequestId,
    required this.buyerId,
    required this.sellerId,
    required this.itemAmount,
    required this.buyerFee,
    required this.deliveryFeeEstimate,
    required this.totalLocked,
    required this.status,
    required this.fundedAt,
    required this.confirmationWindowEndsAt,
    required this.createdAt,
  });
}

class SupportPaymentRequestEntity {
  final String id;
  final String sellerId;
  final String buyerId;
  final String paymentCode;
  final String itemName;
  final String? itemDescription;
  final double itemPrice;
  final String status;
  final DateTime createdAt;

  const SupportPaymentRequestEntity({
    required this.id,
    required this.sellerId,
    required this.buyerId,
    required this.paymentCode,
    required this.itemName,
    required this.itemDescription,
    required this.itemPrice,
    required this.status,
    required this.createdAt,
  });
}

class SupportActiveDisputeEntity {
  final SupportDisputeEntity dispute;
  final SupportEscrowEntity escrow;
  final SupportPaymentRequestEntity paymentRequest;

  const SupportActiveDisputeEntity({
    required this.dispute,
    required this.escrow,
    required this.paymentRequest,
  });
}

class SupportConversationResponseEntity {
  final SupportConversationEntity conversation;
  final List<SupportActiveDisputeEntity> activeDisputes;

  const SupportConversationResponseEntity({
    required this.conversation,
    required this.activeDisputes,
  });
}
