import 'package:flutter/material.dart';
import 'package:kipa/core/shared/responsive_helper.dart';

/// Wraps body content with responsive horizontal padding.
/// Use this on screen body content (not Scaffold) to get consistent padding
/// while allowing AppBar to extend edge-to-edge.
class ResponsiveBodyPadding extends StatelessWidget {
  final Widget child;

  const ResponsiveBodyPadding({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final padding = ResponsiveHelper.getResponsivePadding(context);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: padding.left),
      child: child,
    );
  }
}
