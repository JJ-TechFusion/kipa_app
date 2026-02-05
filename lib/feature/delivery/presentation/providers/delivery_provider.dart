import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../state/delivery_tracking_notifier.dart';
import '../state/delivery_tracking_state.dart';

final deliveryTrackingProvider =
    NotifierProvider<DeliveryTrackingNotifier, DeliveryTrackingState>(
      DeliveryTrackingNotifier.new,
    );
