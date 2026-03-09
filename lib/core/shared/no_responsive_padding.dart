import 'package:flutter/material.dart';

class NoResponsivePadding extends InheritedWidget {
  const NoResponsivePadding({super.key, required super.child});

  static bool of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<NoResponsivePadding>() !=
        null;
  }

  @override
  bool updateShouldNotify(NoResponsivePadding oldWidget) => false;
}
