import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../state/delivery_tracking_notifier.dart';
import '../state/delivery_tracking_state.dart';
import '../state/logistics_notifier.dart';
import '../state/logistics_state.dart';

final deliveryTrackingProvider =
    NotifierProvider<DeliveryTrackingNotifier, DeliveryTrackingState>(
      DeliveryTrackingNotifier.new,
    );

final logisticsNotifierProvider =
    NotifierProvider<LogisticsNotifier, LogisticsState>(
      LogisticsNotifier.new,
    );
