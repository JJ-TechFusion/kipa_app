import 'package:flutter/material.dart';

import 'package:kipa/theme/app_colors.dart';
import 'package:kipa/core/shared/widgets/custom_text.dart';
import 'widgets.dart';

class RowIconTextWidget extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color? iconColor;

  const RowIconTextWidget({
    super.key,
    required this.icon,
    required this.title,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: (Row(
        spacing: 10,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon, color: iconColor ?? AppColor.green, size: 18),
          BodyText(title),
        ],
      )),
    );
  }
}
