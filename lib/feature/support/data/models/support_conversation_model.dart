import '../../domain/entities/support_conversation_entity.dart';

class SupportConversationModel {
  final String id;
  final String userId;
  final String userName;
  final String userPhone;
  final String status;
  final DateTime? lastMessageAt;
  final int unreadCount;
  final DateTime createdAt;

  const SupportConversationModel({
    required this.id,
    required this.userId,
    required this.userName,
    required this.userPhone,
    required this.status,
    required this.lastMessageAt,
    required this.unreadCount,
    required this.createdAt,
  });

  factory SupportConversationModel.fromJson(Map<String, dynamic> json) {
    return SupportConversationModel(
      id: json['id']?.toString() ?? '',
      userId: json['user_id']?.toString() ?? '',
      userName: json['user_name']?.toString() ?? '',
      userPhone: json['user_phone']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      lastMessageAt: json['last_message_at'] != null
          ? DateTime.tryParse(json['last_message_at'].toString())
          : null,
      unreadCount: _toInt(json['unread_count']),
      createdAt:
          DateTime.tryParse(json['created_at']?.toString() ?? '') ??
          DateTime.now(),
    );
  }

  SupportConversationEntity toEntity() {
    return SupportConversationEntity(
      id: id,
      userId: userId,
      userName: userName,
      userPhone: userPhone,
      status: status,
      lastMessageAt: lastMessageAt,
      unreadCount: unreadCount,
      createdAt: createdAt,
    );
  }

  static int _toInt(dynamic value) {
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }
}

class SupportDisputeModel {
  final String id;
  final String escrowId;
  final String openedBy;
  final String reason;
  final List<String> evidence;
  final String status;
  final String outcome;
  final DateTime createdAt;

  const SupportDisputeModel({
    required this.id,
    required this.escrowId,
    required this.openedBy,
    required this.reason,
    required this.evidence,
    required this.status,
    required this.outcome,
    required this.createdAt,
  });

  factory SupportDisputeModel.fromJson(Map<String, dynamic> json) {
    return SupportDisputeModel(
      id: json['id']?.toString() ?? '',
      escrowId: json['escrow_id']?.toString() ?? '',
      openedBy: json['opened_by']?.toString() ?? '',
      reason: json['reason']?.toString() ?? '',
      evidence:
          (json['evidence'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      status: json['status']?.toString() ?? '',
      outcome: json['outcome']?.toString() ?? '',
      createdAt:
          DateTime.tryParse(json['created_at']?.toString() ?? '') ??
          DateTime.now(),
    );
  }

  SupportDisputeEntity toEntity() {
    return SupportDisputeEntity(
      id: id,
      escrowId: escrowId,
      openedBy: openedBy,
      reason: reason,
      evidence: evidence,
      status: status,
      outcome: outcome,
      createdAt: createdAt,
    );
  }
}

class SupportEscrowModel {
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

  const SupportEscrowModel({
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

  factory SupportEscrowModel.fromJson(Map<String, dynamic> json) {
    return SupportEscrowModel(
      id: json['id']?.toString() ?? '',
      paymentRequestId: json['payment_request_id']?.toString() ?? '',
      buyerId: json['buyer_id']?.toString() ?? '',
      sellerId: json['seller_id']?.toString() ?? '',
      itemAmount: _toDouble(json['item_amount']),
      buyerFee: _toDouble(json['buyer_fee']),
      deliveryFeeEstimate: _toDouble(json['delivery_fee_estimate']),
      totalLocked: _toDouble(json['total_locked']),
      status: json['status']?.toString() ?? '',
      fundedAt: json['funded_at'] != null
          ? DateTime.tryParse(json['funded_at'].toString())
          : null,
      confirmationWindowEndsAt: json['confirmation_window_ends_at'] != null
          ? DateTime.tryParse(json['confirmation_window_ends_at'].toString())
          : null,
      createdAt:
          DateTime.tryParse(json['created_at']?.toString() ?? '') ??
          DateTime.now(),
    );
  }

  SupportEscrowEntity toEntity() {
    return SupportEscrowEntity(
      id: id,
      paymentRequestId: paymentRequestId,
      buyerId: buyerId,
      sellerId: sellerId,
      itemAmount: itemAmount,
      buyerFee: buyerFee,
      deliveryFeeEstimate: deliveryFeeEstimate,
      totalLocked: totalLocked,
      status: status,
      fundedAt: fundedAt,
      confirmationWindowEndsAt: confirmationWindowEndsAt,
      createdAt: createdAt,
    );
  }
}

class SupportPaymentRequestModel {
  final String id;
  final String sellerId;
  final String buyerId;
  final String paymentCode;
  final String itemName;
  final String? itemDescription;
  final double itemPrice;
  final String status;
  final DateTime createdAt;

  const SupportPaymentRequestModel({
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

  factory SupportPaymentRequestModel.fromJson(Map<String, dynamic> json) {
    return SupportPaymentRequestModel(
      id: json['id']?.toString() ?? '',
      sellerId: json['seller_id']?.toString() ?? '',
      buyerId: json['buyer_id']?.toString() ?? '',
      paymentCode: json['payment_code']?.toString() ?? '',
      itemName: json['item_name']?.toString() ?? '',
      itemDescription: json['item_description']?.toString(),
      itemPrice: _toDouble(json['item_price']),
      status: json['status']?.toString() ?? '',
      createdAt:
          DateTime.tryParse(json['created_at']?.toString() ?? '') ??
          DateTime.now(),
    );
  }

  SupportPaymentRequestEntity toEntity() {
    return SupportPaymentRequestEntity(
      id: id,
      sellerId: sellerId,
      buyerId: buyerId,
      paymentCode: paymentCode,
      itemName: itemName,
      itemDescription: itemDescription,
      itemPrice: itemPrice,
      status: status,
      createdAt: createdAt,
    );
  }
}

class SupportActiveDisputeModel {
  final SupportDisputeModel dispute;
  final SupportEscrowModel escrow;
  final SupportPaymentRequestModel paymentRequest;

  const SupportActiveDisputeModel({
    required this.dispute,
    required this.escrow,
    required this.paymentRequest,
  });

  factory SupportActiveDisputeModel.fromJson(Map<String, dynamic> json) {
    return SupportActiveDisputeModel(
      dispute: SupportDisputeModel.fromJson(
        json['dispute'] as Map<String, dynamic>? ?? {},
      ),
      escrow: SupportEscrowModel.fromJson(
        json['escrow'] as Map<String, dynamic>? ?? {},
      ),
      paymentRequest: SupportPaymentRequestModel.fromJson(
        json['payment_request'] as Map<String, dynamic>? ?? {},
      ),
    );
  }

  SupportActiveDisputeEntity toEntity() {
    return SupportActiveDisputeEntity(
      dispute: dispute.toEntity(),
      escrow: escrow.toEntity(),
      paymentRequest: paymentRequest.toEntity(),
    );
  }
}

class SupportConversationResponseModel {
  final SupportConversationModel conversation;
  final List<SupportActiveDisputeModel> activeDisputes;

  const SupportConversationResponseModel({
    required this.conversation,
    required this.activeDisputes,
  });

  factory SupportConversationResponseModel.fromJson(Map<String, dynamic> json) {
    return SupportConversationResponseModel(
      conversation: SupportConversationModel.fromJson(
        json['conversation'] as Map<String, dynamic>? ?? {},
      ),
      activeDisputes:
          (json['active_disputes'] as List<dynamic>?)
              ?.map(
                (e) => SupportActiveDisputeModel.fromJson(
                  e as Map<String, dynamic>,
                ),
              )
              .toList() ??
          [],
    );
  }

  SupportConversationResponseEntity toEntity() {
    return SupportConversationResponseEntity(
      conversation: conversation.toEntity(),
      activeDisputes: activeDisputes.map((e) => e.toEntity()).toList(),
    );
  }
}

double _toDouble(dynamic value) {
  if (value is int) return value.toDouble();
  if (value is double) return value;
  if (value is String) return double.tryParse(value) ?? 0.0;
  return 0.0;
}
