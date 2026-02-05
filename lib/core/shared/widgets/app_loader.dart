import 'package:flutter/material.dart';
import 'package:kipa/theme/app_colors.dart';

class PageLoader extends StatelessWidget {
  const PageLoader({super.key, required this.child, required this.isLoading});
  final Widget child;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (isLoading)
          Container(
            color: AppColor.lightText.withValues(alpha: 0.7),
            child: const Center(child: CircularProgressIndicator()),
          ),
      ],
    );
  }
}
