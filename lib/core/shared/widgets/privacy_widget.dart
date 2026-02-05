import 'package:flutter/material.dart';

import 'package:kipa/theme/app_colors.dart';
import 'package:kipa/core/shared/widgets/custom_text.dart';
import 'widgets.dart';

class PrivacyWidget extends StatelessWidget {
  final String title;
  final String description;
  final Color? borderColor;
  final Color? containerColor;
  final Color? iconColor;
  final Color? titleColor;
  final Color? descriptionColor;
  const PrivacyWidget({
    super.key,
    required this.title,
    required this.description,
    this.borderColor,
    this.containerColor,
    this.iconColor,
    this.titleColor,
    this.descriptionColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: containerColor ?? AppColor.warning.withAlpha(15),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: borderColor ?? AppColor.warning),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 16),
      child: Row(
        spacing: 10,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.shield_outlined, color: iconColor ?? AppColor.warning),
          Expanded(
            child: Column(
              spacing: 10,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BodyText(title, fontWeight: FontWeight.w600, color: titleColor),
                BodySmall(
                  description,
                  color: descriptionColor ?? AppColor.lightText,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
