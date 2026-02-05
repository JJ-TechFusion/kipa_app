import 'package:flutter/material.dart';

/// Enum representing all possible delivery job statuses
enum DeliveryStatus {
  created,
  searching,
  accepted,
  enRoutePickup,
  pickedUp,
  inTransit,
  delivered,
  paidOut,
  timeout,
  cancelled,
  failed,
  returnDamageDisputed,
  buyerUnavailable,
  sellerUnavailable,
  forcedReturn,
  forcedReturnDone,
  returnDelivered,
  returnConfirmed,
  returnRefunded,
  unknown;

  /// Parse status string from API to enum
  static DeliveryStatus fromString(String status) {
    switch (status.toLowerCase()) {
      case 'created':
        return DeliveryStatus.created;
      case 'searching':
      case 'searching_rider': // Payment request status alias
        return DeliveryStatus.searching;
      case 'accepted':
      case 'rider_assigned': // Payment request status alias
        return DeliveryStatus.accepted;
      case 'en_route_pickup':
        return DeliveryStatus.enRoutePickup;
      case 'picked_up':
        return DeliveryStatus.pickedUp;
      case 'in_transit':
      case 'in_delivery': // Payment request status alias
        return DeliveryStatus.inTransit;
      case 'delivered':
        return DeliveryStatus.delivered;
      case 'paid_out':
        return DeliveryStatus.paidOut;
      case 'timeout':
        return DeliveryStatus.timeout;
      case 'cancelled':
        return DeliveryStatus.cancelled;
      case 'failed':
        return DeliveryStatus.failed;
      case 'return_damage_disputed':
        return DeliveryStatus.returnDamageDisputed;
      case 'buyer_unavailable':
        return DeliveryStatus.buyerUnavailable;
      case 'seller_unavailable':
        return DeliveryStatus.sellerUnavailable;
      case 'forced_return':
        return DeliveryStatus.forcedReturn;
      case 'forced_return_done':
        return DeliveryStatus.forcedReturnDone;
      case 'return_delivered':
        return DeliveryStatus.returnDelivered;
      case 'return_confirmed':
        return DeliveryStatus.returnConfirmed;
      case 'return_refunded':
        return DeliveryStatus.returnRefunded;
      default:
        return DeliveryStatus.unknown;
    }
  }

  /// Convert enum to API string format
  String toApiString() {
    switch (this) {
      case DeliveryStatus.created:
        return 'created';
      case DeliveryStatus.searching:
        return 'searching';
      case DeliveryStatus.accepted:
        return 'accepted';
      case DeliveryStatus.enRoutePickup:
        return 'en_route_pickup';
      case DeliveryStatus.pickedUp:
        return 'picked_up';
      case DeliveryStatus.inTransit:
        return 'in_transit';
      case DeliveryStatus.delivered:
        return 'delivered';
      case DeliveryStatus.paidOut:
        return 'paid_out';
      case DeliveryStatus.timeout:
        return 'timeout';
      case DeliveryStatus.cancelled:
        return 'cancelled';
      case DeliveryStatus.failed:
        return 'failed';
      case DeliveryStatus.returnDamageDisputed:
        return 'return_damage_disputed';
      case DeliveryStatus.buyerUnavailable:
        return 'buyer_unavailable';
      case DeliveryStatus.sellerUnavailable:
        return 'seller_unavailable';
      case DeliveryStatus.forcedReturn:
        return 'forced_return';
      case DeliveryStatus.forcedReturnDone:
        return 'forced_return_done';
      case DeliveryStatus.returnDelivered:
        return 'return_delivered';
      case DeliveryStatus.returnConfirmed:
        return 'return_confirmed';
      case DeliveryStatus.returnRefunded:
        return 'return_refunded';
      case DeliveryStatus.unknown:
        return 'unknown';
    }
  }
}

/// Extension methods for DeliveryStatus
extension DeliveryStatusExtension on DeliveryStatus {
  /// Get display label for the status
  String get label {
    switch (this) {
      case DeliveryStatus.created:
        return 'Order Created';
      case DeliveryStatus.searching:
        return 'Searching for Rider';
      case DeliveryStatus.accepted:
        return 'Rider Accepted';
      case DeliveryStatus.enRoutePickup:
        return 'Heading to Pickup';
      case DeliveryStatus.pickedUp:
        return 'Item Collected';
      case DeliveryStatus.inTransit:
        return 'In Delivery';
      case DeliveryStatus.delivered:
        return 'Delivered';
      case DeliveryStatus.paidOut:
        return 'Completed';
      case DeliveryStatus.timeout:
        return 'Search Timeout';
      case DeliveryStatus.cancelled:
        return 'Cancelled';
      case DeliveryStatus.failed:
        return 'Failed';
      case DeliveryStatus.buyerUnavailable:
        return 'Buyer Unavailable';
      case DeliveryStatus.sellerUnavailable:
        return 'Seller Unavailable';
      case DeliveryStatus.returnDamageDisputed:
        return 'Damage Disputed';
      case DeliveryStatus.forcedReturn:
        return 'Returning Item';
      case DeliveryStatus.forcedReturnDone:
        return 'Return Complete';
      case DeliveryStatus.returnDelivered:
        return 'Return Delivered';
      case DeliveryStatus.returnConfirmed:
        return 'Return Confirmed';
      case DeliveryStatus.returnRefunded:
        return 'Refunded';
      case DeliveryStatus.unknown:
        return 'Unknown';
    }
  }

  /// Get color for the status badge
  Color get color {
    switch (this) {
      case DeliveryStatus.created:
        return Colors.grey;
      case DeliveryStatus.searching:
        return Colors.blue;
      case DeliveryStatus.accepted:
        return Colors.blue;
      case DeliveryStatus.enRoutePickup:
        return Colors.orange;
      case DeliveryStatus.pickedUp:
      case DeliveryStatus.inTransit:
        return const Color(0xFF6A5AE0); // AppColor.primary
      case DeliveryStatus.delivered:
      case DeliveryStatus.paidOut:
      case DeliveryStatus.returnRefunded:
        return Colors.green;
      case DeliveryStatus.timeout:
      case DeliveryStatus.cancelled:
      case DeliveryStatus.failed:
        return Colors.red;
      case DeliveryStatus.buyerUnavailable:
      case DeliveryStatus.sellerUnavailable:
        return Colors.orange;
      case DeliveryStatus.returnDamageDisputed:
      case DeliveryStatus.forcedReturn:
      case DeliveryStatus.forcedReturnDone:
      case DeliveryStatus.returnDelivered:
      case DeliveryStatus.returnConfirmed:
        return Colors.purple;
      case DeliveryStatus.unknown:
        return Colors.grey;
    }
  }

  /// Check if status is in active delivery phase (should show ETA)
  bool get shouldShowEta {
    return this == DeliveryStatus.accepted ||
        this == DeliveryStatus.enRoutePickup ||
        this == DeliveryStatus.pickedUp ||
        this == DeliveryStatus.inTransit;
  }

  /// Check if rider is heading to pickup location
  bool get isHeadingToPickup {
    return this == DeliveryStatus.accepted ||
        this == DeliveryStatus.enRoutePickup;
  }

  /// Check if rider is heading to dropoff location
  bool get isHeadingToDropoff {
    return this == DeliveryStatus.pickedUp || this == DeliveryStatus.inTransit;
  }

  /// Check if delivery is complete (success or failure)
  bool get isComplete {
    return this == DeliveryStatus.delivered ||
        this == DeliveryStatus.paidOut ||
        this == DeliveryStatus.cancelled ||
        this == DeliveryStatus.failed ||
        this == DeliveryStatus.timeout;
  }

  /// Check if status indicates a problem
  bool get hasError {
    return this == DeliveryStatus.timeout ||
        this == DeliveryStatus.cancelled ||
        this == DeliveryStatus.failed ||
        this == DeliveryStatus.buyerUnavailable ||
        this == DeliveryStatus.sellerUnavailable;
  }

  /// Check if rider info should be fetched for this status
  bool get shouldFetchRiderInfo {
    return this == DeliveryStatus.accepted ||
        this == DeliveryStatus.enRoutePickup ||
        this == DeliveryStatus.pickedUp ||
        this == DeliveryStatus.inTransit;
  }

  /// Get order index for status progression (main flow only)
  int get progressionOrder {
    const order = [
      DeliveryStatus.created,
      DeliveryStatus.searching,
      DeliveryStatus.accepted,
      DeliveryStatus.enRoutePickup,
      DeliveryStatus.pickedUp,
      DeliveryStatus.inTransit,
      DeliveryStatus.delivered,
      DeliveryStatus.paidOut,
    ];
    final index = order.indexOf(this);
    return index >= 0 ? index : -1;
  }

  /// Check if this status comes after another status in progression
  bool isAfter(DeliveryStatus other) {
    final thisOrder = progressionOrder;
    final otherOrder = other.progressionOrder;
    if (thisOrder < 0 || otherOrder < 0) return false;
    return thisOrder > otherOrder;
  }

  /// Check if this status is at or after another status in progression
  bool isAtOrAfter(DeliveryStatus other) {
    final thisOrder = progressionOrder;
    final otherOrder = other.progressionOrder;
    if (thisOrder < 0) return false;
    return thisOrder >= otherOrder;
  }
}
