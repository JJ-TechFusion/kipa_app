import 'package:flutter/material.dart';
import 'package:kipa/theme/app_colors.dart';

import 'widgets.dart';

class IconTextWidget extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final Color? iconColor;
  final Color? textColor;
  final Color? subtitleColor;
  final double? iconSize;
  final FontWeight? fontWeight;
  final CrossAxisAlignment crossAxisAlignment;
  final TextAlign? textAlign;

  const IconTextWidget({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.iconColor,
    this.textColor,
    this.subtitleColor,
    this.iconSize,
    this.fontWeight,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.textAlign,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 10,
      crossAxisAlignment: crossAxisAlignment,
      children: [
        Icon(
          icon,
          color: iconColor ?? AppColor.primaryText,
          size: iconSize ?? 16,
        ),
        if (subtitle != null)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 5,
            children: [
              BodySmall(
                title,
                color: textColor ?? AppColor.primaryText,
                fontWeight: fontWeight ?? FontWeight.w500,
                textAlign: textAlign,
              ),
              Caption(
                subtitle!,
                color: subtitleColor ?? AppColor.lightText,
                fontWeight: FontWeight.w400,
              ),
            ],
          )
        else
          BodySmall(
            title,
            color: textColor ?? AppColor.primaryText,
            fontWeight: fontWeight ?? FontWeight.w400,
          ),
      ],
    );
  }
}
