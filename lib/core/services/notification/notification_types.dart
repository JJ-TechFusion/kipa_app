enum NotificationType {
  // Order Lifecycle
  orderPaid('order_paid'),
  orderReadyPickup('order_ready_pickup'),
  riderAssigned('rider_assigned'),
  orderPickedUp('order_picked_up'),
  orderDelivered('order_delivered'),
  escrowReleased('escrow_released'),
  orderCancelled('order_cancelled'),

  // Unavailability Handling
  deliveryFailed('delivery_failed'),
  buyerUnavailable('buyer_unavailable'),
  itemReturning('item_returning'),
  itemReturned('item_returned'),
  rebookReminder('rebook_reminder'),
  rebookExpired('rebook_expired'),
  deliveryResumed('delivery_resumed'),

  // Errand Lifecycle
  errandAccepted('errand_accepted'),
  errandPickedUp('errand_picked_up'),
  errandDelivered('errand_delivered'),
  errandCompleted('errand_completed'),

  // Logistics Delivery
  logisticsShipped('logistics_shipped'),
  logisticsDeliveryClaimed('logistics_delivery_claimed'),
  logisticsConfirmReminder('logistics_confirm_reminder'),
  logisticsConfirmed('logistics_confirmed'),
  logisticsCancelled('logistics_cancelled'),
  logisticsEscalated('logistics_escalated'),
  logisticsReturnRequired('logistics_return_required'),
  logisticsReturnShipped('logistics_return_shipped'),
  logisticsReleased('logistics_released'),

  // Wallet Events
  topupSuccess('topup_success'),
  dvaTransfer('dva_transfer'),
  withdrawalInitiated('withdrawal_initiated'),
  withdrawalSuccess('withdrawal_success'),
  withdrawalFailed('withdrawal_failed'),

  // Dispute & Admin
  disputeOpened('dispute_opened'),
  disputeResolved('dispute_resolved'),
  refundProcessed('refund_processed'),
  riderVerified('rider_verified'),
  riderSuspended('rider_suspended'),
  userSuspended('user_suspended'),

  // Chat & General
  chatMessage('chat_message'),
  broadcast('broadcast'),

  // Fallback
  unknown('unknown');

  final String value;
  const NotificationType(this.value);

  static NotificationType fromString(String? type) {
    if (type == null) return NotificationType.unknown;
    return NotificationType.values.firstWhere(
      (e) => e.value == type,
      orElse: () => NotificationType.unknown,
    );
  }
}

/// Parsed notification payload from FCM.
class NotificationPayload {
  final String? title;
  final String? body;
  final NotificationType type;
  final String? jobId;
  final String? paymentRequestId;
  final String? orderId;
  final String? messageId;
  final String? senderId;
  final String? pickupCode;
  final String? dropoffCode;

  const NotificationPayload({
    this.title,
    this.body,
    required this.type,
    this.jobId,
    this.paymentRequestId,
    this.orderId,
    this.messageId,
    this.senderId,
    this.pickupCode,
    this.dropoffCode,
  });

  factory NotificationPayload.fromMap(
    Map<String, dynamic> data, {
    String? title,
    String? body,
  }) {
    return NotificationPayload(
      title: title,
      body: body,
      type: NotificationType.fromString(data['type']),
      jobId: data['job_id'],
      paymentRequestId: data['payment_request_id'],
      orderId: data['order_id'],
      messageId: data['message_id'],
      senderId: data['sender_id'],
      pickupCode: data['pickup_code'],
      dropoffCode: data['dropoff_code'],
    );
  }

  /// Determines which route to navigate to based on notification type.
  String? get targetRoute {
    switch (type) {
      // Delivery tracking
      case NotificationType.riderAssigned:
      case NotificationType.orderPickedUp:
      case NotificationType.deliveryFailed:
      case NotificationType.buyerUnavailable:
      case NotificationType.itemReturning:
      case NotificationType.deliveryResumed:
        return '/delivery-tracking';

      // Delivery details
      case NotificationType.orderDelivered:
      case NotificationType.itemReturned:
        return '/delivery-details';

      // Order / payment details
      case NotificationType.orderPaid:
      case NotificationType.orderReadyPickup:
      case NotificationType.escrowReleased:
      case NotificationType.orderCancelled:
      case NotificationType.rebookReminder:
      case NotificationType.rebookExpired:
        return '/buyer-payment-details';

      // Wallet (go to home/wallet tab)
      case NotificationType.topupSuccess:
      case NotificationType.dvaTransfer:
      case NotificationType.withdrawalInitiated:
      case NotificationType.withdrawalSuccess:
      case NotificationType.withdrawalFailed:
        return '/home';

      // Dispute
      case NotificationType.disputeOpened:
      case NotificationType.disputeResolved:
      case NotificationType.refundProcessed:
        return '/dispute';

      // Chat
      case NotificationType.chatMessage:
        return '/chat';

      default:
        return null;
    }
  }

  /// Arguments to pass when navigating.
  Map<String, dynamic>? get targetArguments {
    final args = <String, dynamic>{};
    if (jobId != null) {
      args['deliveryJobId'] = jobId;
      args['jobId'] = jobId;
    }
    if (paymentRequestId != null) {
      args['paymentRequestId'] = paymentRequestId;
    }
    if (orderId != null) args['orderId'] = orderId;
    if (type == NotificationType.chatMessage) {
      args['participantName'] = title ?? 'Chat';
    }
    return args.isEmpty ? null : args;
  }
}
