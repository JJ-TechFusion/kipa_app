enum ErrandStatus {
  draft,
  searching,
  accepted,
  pickedUp,
  inTransit,
  delivered,
  completed,
  cancelled;

  static ErrandStatus fromString(String status) {
    switch (status.toLowerCase()) {
      case 'draft':
        return ErrandStatus.draft;
      case 'searching':
        return ErrandStatus.searching;
      case 'accepted':
        return ErrandStatus.accepted;
      case 'picked_up':
        return ErrandStatus.pickedUp;
      case 'in_transit':
        return ErrandStatus.inTransit;
      case 'delivered':
        return ErrandStatus.delivered;
      case 'completed':
        return ErrandStatus.completed;
      case 'cancelled':
        return ErrandStatus.cancelled;
      default:
        return ErrandStatus.draft;
    }
  }

  String get value {
    switch (this) {
      case ErrandStatus.draft:
        return 'draft';
      case ErrandStatus.searching:
        return 'searching';
      case ErrandStatus.accepted:
        return 'accepted';
      case ErrandStatus.pickedUp:
        return 'picked_up';
      case ErrandStatus.inTransit:
        return 'in_transit';
      case ErrandStatus.delivered:
        return 'delivered';
      case ErrandStatus.completed:
        return 'completed';
      case ErrandStatus.cancelled:
        return 'cancelled';
    }
  }

  String get displayName {
    switch (this) {
      case ErrandStatus.draft:
        return 'Draft';
      case ErrandStatus.searching:
        return 'Finding Rider';
      case ErrandStatus.accepted:
        return 'Rider Assigned';
      case ErrandStatus.pickedUp:
        return 'Picked Up';
      case ErrandStatus.inTransit:
        return 'In Transit';
      case ErrandStatus.delivered:
        return 'Delivered';
      case ErrandStatus.completed:
        return 'Completed';
      case ErrandStatus.cancelled:
        return 'Cancelled';
    }
  }

  bool get canCancel {
    return this == ErrandStatus.draft ||
        this == ErrandStatus.searching ||
        this == ErrandStatus.accepted;
  }

  bool get isActive {
    return this != ErrandStatus.completed && this != ErrandStatus.cancelled;
  }

  bool get hasRider {
    return this == ErrandStatus.accepted ||
        this == ErrandStatus.pickedUp ||
        this == ErrandStatus.inTransit ||
        this == ErrandStatus.delivered;
  }
}
