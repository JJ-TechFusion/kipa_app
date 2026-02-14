import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../state/errand_notifier.dart';
import '../state/errand_state.dart';

final errandNotifierProvider = NotifierProvider<ErrandNotifier, ErrandState>(
  ErrandNotifier.new,
);
