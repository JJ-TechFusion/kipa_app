import 'package:flutter/material.dart';

/// Enum representing all possible payment request statuses
enum PaymentRequestStatus {
  draft,
  linkActive,
  paidAwaitingFulfillment,
  readyForPickup,
  searchingRider,
  riderAssigned,
  inDelivery,
  delivered,
  confirmationWindow,
  completed,
  noRiderFound,
  expired,
  cancelled,
  disputed,
  refunded,
  returnRequired,
  returnSearchingRider,
  returnInProgress,
  returnDelivered,
  returnConfirmed,
  returnDamageDisputed,
  pendingRebook,
  unknown;

  /// Parse status string from API to enum
  static PaymentRequestStatus fromString(String status) {
    switch (status.toLowerCase()) {
      case 'draft':
        return PaymentRequestStatus.draft;
      case 'link_active':
        return PaymentRequestStatus.linkActive;
      case 'paid_awaiting_fulfillment':
        return PaymentRequestStatus.paidAwaitingFulfillment;
      case 'ready_for_pickup':
        return PaymentRequestStatus.readyForPickup;
      case 'searching_rider':
        return PaymentRequestStatus.searchingRider;
      case 'rider_assigned':
        return PaymentRequestStatus.riderAssigned;
      case 'in_delivery':
        return PaymentRequestStatus.inDelivery;
      case 'delivered':
        return PaymentRequestStatus.delivered;
      case 'confirmation_window':
        return PaymentRequestStatus.confirmationWindow;
      case 'completed':
        return PaymentRequestStatus.completed;
      case 'no_rider_found':
        return PaymentRequestStatus.noRiderFound;
      case 'expired':
        return PaymentRequestStatus.expired;
      case 'cancelled':
        return PaymentRequestStatus.cancelled;
      case 'disputed':
        return PaymentRequestStatus.disputed;
      case 'refunded':
        return PaymentRequestStatus.refunded;
      case 'return_required':
        return PaymentRequestStatus.returnRequired;
      case 'return_searching_rider':
        return PaymentRequestStatus.returnSearchingRider;
      case 'return_in_progress':
        return PaymentRequestStatus.returnInProgress;
      case 'return_delivered':
        return PaymentRequestStatus.returnDelivered;
      case 'return_confirmed':
        return PaymentRequestStatus.returnConfirmed;
      case 'return_damage_disputed':
        return PaymentRequestStatus.returnDamageDisputed;
      case 'pending_rebook':
        return PaymentRequestStatus.pendingRebook;
      default:
        return PaymentRequestStatus.unknown;
    }
  }

  /// Convert enum to API string format
  String toApiString() {
    switch (this) {
      case PaymentRequestStatus.draft:
        return 'draft';
      case PaymentRequestStatus.linkActive:
        return 'link_active';
      case PaymentRequestStatus.paidAwaitingFulfillment:
        return 'paid_awaiting_fulfillment';
      case PaymentRequestStatus.readyForPickup:
        return 'ready_for_pickup';
      case PaymentRequestStatus.searchingRider:
        return 'searching_rider';
      case PaymentRequestStatus.riderAssigned:
        return 'rider_assigned';
      case PaymentRequestStatus.inDelivery:
        return 'in_delivery';
      case PaymentRequestStatus.delivered:
        return 'delivered';
      case PaymentRequestStatus.confirmationWindow:
        return 'confirmation_window';
      case PaymentRequestStatus.completed:
        return 'completed';
      case PaymentRequestStatus.noRiderFound:
        return 'no_rider_found';
      case PaymentRequestStatus.expired:
        return 'expired';
      case PaymentRequestStatus.cancelled:
        return 'cancelled';
      case PaymentRequestStatus.disputed:
        return 'disputed';
      case PaymentRequestStatus.refunded:
        return 'refunded';
      case PaymentRequestStatus.returnRequired:
        return 'return_required';
      case PaymentRequestStatus.returnSearchingRider:
        return 'return_searching_rider';
      case PaymentRequestStatus.returnInProgress:
        return 'return_in_progress';
      case PaymentRequestStatus.returnDelivered:
        return 'return_delivered';
      case PaymentRequestStatus.returnConfirmed:
        return 'return_confirmed';
      case PaymentRequestStatus.returnDamageDisputed:
        return 'return_damage_disputed';
      case PaymentRequestStatus.pendingRebook:
        return 'pending_rebook';
      case PaymentRequestStatus.unknown:
        return 'unknown';
    }
  }
}

/// Extension methods for PaymentRequestStatus
extension PaymentRequestStatusExtension on PaymentRequestStatus {
  /// Get display label for the status
  String get label {
    switch (this) {
      case PaymentRequestStatus.draft:
        return 'Draft';
      case PaymentRequestStatus.linkActive:
        return 'Payment Link Active';
      case PaymentRequestStatus.paidAwaitingFulfillment:
        return 'Paid - Awaiting Fulfillment';
      case PaymentRequestStatus.readyForPickup:
        return 'Ready for Pickup';
      case PaymentRequestStatus.searchingRider:
        return 'Searching for Rider';
      case PaymentRequestStatus.riderAssigned:
        return 'Rider Assigned';
      case PaymentRequestStatus.inDelivery:
        return 'In Delivery';
      case PaymentRequestStatus.delivered:
        return 'Delivered';
      case PaymentRequestStatus.confirmationWindow:
        return 'Awaiting Confirmation';
      case PaymentRequestStatus.completed:
        return 'Completed';
      case PaymentRequestStatus.noRiderFound:
        return 'No Rider Found';
      case PaymentRequestStatus.expired:
        return 'Expired';
      case PaymentRequestStatus.cancelled:
        return 'Cancelled';
      case PaymentRequestStatus.disputed:
        return 'Disputed';
      case PaymentRequestStatus.refunded:
        return 'Refunded';
      case PaymentRequestStatus.returnRequired:
        return 'Return Required';
      case PaymentRequestStatus.returnSearchingRider:
        return 'Finding Return Rider';
      case PaymentRequestStatus.returnInProgress:
        return 'Return in Progress';
      case PaymentRequestStatus.returnDelivered:
        return 'Return Delivered';
      case PaymentRequestStatus.returnConfirmed:
        return 'Return Confirmed';
      case PaymentRequestStatus.returnDamageDisputed:
        return 'Return Damage Disputed';
      case PaymentRequestStatus.pendingRebook:
        return 'Pending Rebook';
      case PaymentRequestStatus.unknown:
        return 'Unknown';
    }
  }

  /// Get short label for compact displays (e.g., on cards)
  String get shortLabel {
    switch (this) {
      case PaymentRequestStatus.draft:
        return 'Draft';
      case PaymentRequestStatus.linkActive:
        return 'Active';
      case PaymentRequestStatus.paidAwaitingFulfillment:
        return 'Paid';
      case PaymentRequestStatus.readyForPickup:
        return 'Ready';
      case PaymentRequestStatus.searchingRider:
        return 'Searching';
      case PaymentRequestStatus.riderAssigned:
        return 'Assigned';
      case PaymentRequestStatus.inDelivery:
        return 'In Delivery';
      case PaymentRequestStatus.delivered:
        return 'Delivered';
      case PaymentRequestStatus.confirmationWindow:
        return 'Confirming';
      case PaymentRequestStatus.completed:
        return 'Completed';
      case PaymentRequestStatus.noRiderFound:
        return 'No Rider';
      case PaymentRequestStatus.expired:
        return 'Expired';
      case PaymentRequestStatus.cancelled:
        return 'Cancelled';
      case PaymentRequestStatus.disputed:
        return 'Disputed';
      case PaymentRequestStatus.refunded:
        return 'Refunded';
      case PaymentRequestStatus.returnRequired:
        return 'Return';
      case PaymentRequestStatus.returnSearchingRider:
        return 'Return Search';
      case PaymentRequestStatus.returnInProgress:
        return 'Returning';
      case PaymentRequestStatus.returnDelivered:
        return 'Returned';
      case PaymentRequestStatus.returnConfirmed:
        return 'Return OK';
      case PaymentRequestStatus.returnDamageDisputed:
        return 'Damage Dispute';
      case PaymentRequestStatus.pendingRebook:
        return 'Rebooking';
      case PaymentRequestStatus.unknown:
        return 'Unknown';
    }
  }

  /// Get color for the status badge/chip
  Color get color {
    switch (this) {
      case PaymentRequestStatus.draft:
        return Colors.grey;
      case PaymentRequestStatus.linkActive:
        return Colors.blue;
      case PaymentRequestStatus.paidAwaitingFulfillment:
        return Colors.orange;
      case PaymentRequestStatus.readyForPickup:
        return Colors.purple;
      case PaymentRequestStatus.searchingRider:
        return Colors.blue;
      case PaymentRequestStatus.riderAssigned:
        return Colors.blue;
      case PaymentRequestStatus.inDelivery:
        return const Color(0xFF6A5AE0); // AppColor.primary
      case PaymentRequestStatus.delivered:
        return Colors.teal;
      case PaymentRequestStatus.confirmationWindow:
        return Colors.amber;
      case PaymentRequestStatus.completed:
        return Colors.green;
      case PaymentRequestStatus.noRiderFound:
        return Colors.red;
      case PaymentRequestStatus.expired:
        return Colors.grey;
      case PaymentRequestStatus.cancelled:
        return Colors.red;
      case PaymentRequestStatus.disputed:
        return Colors.red;
      case PaymentRequestStatus.refunded:
        return Colors.orange;
      case PaymentRequestStatus.returnRequired:
        return Colors.purple;
      case PaymentRequestStatus.returnSearchingRider:
        return Colors.purple;
      case PaymentRequestStatus.returnInProgress:
        return Colors.purple;
      case PaymentRequestStatus.returnDelivered:
        return Colors.purple;
      case PaymentRequestStatus.returnConfirmed:
        return Colors.green;
      case PaymentRequestStatus.returnDamageDisputed:
        return Colors.red;
      case PaymentRequestStatus.pendingRebook:
        return Colors.amber;
      case PaymentRequestStatus.unknown:
        return Colors.grey;
    }
  }

  /// Check if status is in an active/ongoing state
  bool get isActive {
    return this == PaymentRequestStatus.linkActive ||
        this == PaymentRequestStatus.paidAwaitingFulfillment ||
        this == PaymentRequestStatus.readyForPickup ||
        this == PaymentRequestStatus.searchingRider ||
        this == PaymentRequestStatus.riderAssigned ||
        this == PaymentRequestStatus.inDelivery ||
        this == PaymentRequestStatus.delivered ||
        this == PaymentRequestStatus.confirmationWindow;
  }

  /// Check if status indicates completion (success or failure)
  bool get isComplete {
    return this == PaymentRequestStatus.completed ||
        this == PaymentRequestStatus.cancelled ||
        this == PaymentRequestStatus.expired ||
        this == PaymentRequestStatus.refunded ||
        this == PaymentRequestStatus.returnConfirmed;
  }

  /// Check if status indicates an error or problem
  bool get hasError {
    return this == PaymentRequestStatus.noRiderFound ||
        this == PaymentRequestStatus.cancelled ||
        this == PaymentRequestStatus.disputed ||
        this == PaymentRequestStatus.returnDamageDisputed;
  }

  /// Check if status is related to returns
  bool get isReturnFlow {
    return this == PaymentRequestStatus.returnRequired ||
        this == PaymentRequestStatus.returnSearchingRider ||
        this == PaymentRequestStatus.returnInProgress ||
        this == PaymentRequestStatus.returnDelivered ||
        this == PaymentRequestStatus.returnConfirmed ||
        this == PaymentRequestStatus.returnDamageDisputed;
  }

  /// Check if payment has been received
  bool get isPaid {
    return this == PaymentRequestStatus.paidAwaitingFulfillment ||
        this == PaymentRequestStatus.readyForPickup ||
        this == PaymentRequestStatus.searchingRider ||
        this == PaymentRequestStatus.riderAssigned ||
        this == PaymentRequestStatus.inDelivery ||
        this == PaymentRequestStatus.delivered ||
        this == PaymentRequestStatus.confirmationWindow ||
        this == PaymentRequestStatus.completed;
  }

  /// Check if seller action is required
  bool get requiresSellerAction {
    return this == PaymentRequestStatus.paidAwaitingFulfillment ||
        this == PaymentRequestStatus.pendingRebook;
  }

  /// Check if buyer action is required
  bool get requiresBuyerAction {
    return this == PaymentRequestStatus.linkActive ||
        this == PaymentRequestStatus.confirmationWindow;
  }

  /// Check if delivery tracking should be shown
  bool get shouldShowTracking {
    return this == PaymentRequestStatus.searchingRider ||
        this == PaymentRequestStatus.riderAssigned ||
        this == PaymentRequestStatus.inDelivery ||
        this == PaymentRequestStatus.delivered ||
        this == PaymentRequestStatus.returnSearchingRider ||
        this == PaymentRequestStatus.returnInProgress;
  }

  /// Check if "Mark Ready for Pickup" action is available
  bool get canMarkReady {
    return this == PaymentRequestStatus.paidAwaitingFulfillment;
  }

  /// Check if payment link can be shared
  bool get canShareLink {
    return this == PaymentRequestStatus.linkActive;
  }

  /// Check if request can be cancelled
  bool get canCancel {
    return this == PaymentRequestStatus.draft ||
        this == PaymentRequestStatus.linkActive ||
        this == PaymentRequestStatus.paidAwaitingFulfillment;
  }

  /// Get icon for the status
  IconData get icon {
    switch (this) {
      case PaymentRequestStatus.draft:
        return Icons.edit_outlined;
      case PaymentRequestStatus.linkActive:
        return Icons.link;
      case PaymentRequestStatus.paidAwaitingFulfillment:
        return Icons.payment;
      case PaymentRequestStatus.readyForPickup:
        return Icons.check_circle_outline;
      case PaymentRequestStatus.searchingRider:
        return Icons.search;
      case PaymentRequestStatus.riderAssigned:
        return Icons.person_pin_circle;
      case PaymentRequestStatus.inDelivery:
        return Icons.local_shipping;
      case PaymentRequestStatus.delivered:
        return Icons.done_all;
      case PaymentRequestStatus.confirmationWindow:
        return Icons.schedule;
      case PaymentRequestStatus.completed:
        return Icons.check_circle;
      case PaymentRequestStatus.noRiderFound:
        return Icons.error_outline;
      case PaymentRequestStatus.expired:
        return Icons.timer_off;
      case PaymentRequestStatus.cancelled:
        return Icons.cancel;
      case PaymentRequestStatus.disputed:
        return Icons.warning;
      case PaymentRequestStatus.refunded:
        return Icons.money_off;
      case PaymentRequestStatus.returnRequired:
      case PaymentRequestStatus.returnSearchingRider:
      case PaymentRequestStatus.returnInProgress:
        return Icons.keyboard_return;
      case PaymentRequestStatus.returnDelivered:
      case PaymentRequestStatus.returnConfirmed:
        return Icons.check_circle_outline;
      case PaymentRequestStatus.returnDamageDisputed:
        return Icons.report_problem;
      case PaymentRequestStatus.pendingRebook:
        return Icons.refresh;
      case PaymentRequestStatus.unknown:
        return Icons.help_outline;
    }
  }

  /// Get progression order for main flow statuses
  int get progressionOrder {
    const order = [
      PaymentRequestStatus.draft,
      PaymentRequestStatus.linkActive,
      PaymentRequestStatus.paidAwaitingFulfillment,
      PaymentRequestStatus.readyForPickup,
      PaymentRequestStatus.searchingRider,
      PaymentRequestStatus.riderAssigned,
      PaymentRequestStatus.inDelivery,
      PaymentRequestStatus.delivered,
      PaymentRequestStatus.confirmationWindow,
      PaymentRequestStatus.completed,
    ];
    final index = order.indexOf(this);
    return index >= 0 ? index : -1;
  }

  /// Check if this status comes after another status in progression
  bool isAfter(PaymentRequestStatus other) {
    final thisOrder = progressionOrder;
    final otherOrder = other.progressionOrder;
    if (thisOrder < 0 || otherOrder < 0) return false;
    return thisOrder > otherOrder;
  }

  /// Check if this status is at or after another status in progression
  bool isAtOrAfter(PaymentRequestStatus other) {
    final thisOrder = progressionOrder;
    final otherOrder = other.progressionOrder;
    if (thisOrder < 0) return false;
    return thisOrder >= otherOrder;
  }
}
