import 'package:flutter/material.dart';
import 'package:kipa/core/shared/responsive_helper.dart';

class ResponsiveWrapper extends StatelessWidget {
  final Widget child;

  const ResponsiveWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return OrientationBuilder(
          builder: (context, orientation) {
            final systemPadding = MediaQuery.of(context).padding;
            final responsivePadding = ResponsiveHelper.getResponsivePadding(
              context,
            );

            // Use system safe area for top/bottom, responsive padding for left/right
            final combinedPadding = EdgeInsets.only(
              top: systemPadding.top > 0
                  ? systemPadding.top
                  : responsivePadding.top,
              bottom: systemPadding.bottom > 0
                  ? systemPadding.bottom
                  : responsivePadding.bottom,
              left: responsivePadding.left,
              right: responsivePadding.right,
            );

            return MediaQuery(
              data: MediaQuery.of(context).copyWith(
                padding: combinedPadding,
                viewPadding: combinedPadding,
              ),
              child: child,
            );
          },
        );
      },
    );
  }
}
