import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kipa/core/shared/widgets/custom_text.dart';
import 'package:kipa/theme/app_colors.dart';
import 'package:kipa/utils/constant.dart';

class ErrandCodeDisplay extends StatelessWidget {
  final String title;
  final String code;
  final String subtitle;
  final Color backgroundColor;
  final bool showCopyButton;

  const ErrandCodeDisplay({
    super.key,
    required this.title,
    required this.code,
    required this.subtitle,
    this.backgroundColor = const Color(0xFFF3F4F6),
    this.showCopyButton = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          BodySmall(
            title,
            color: AppColor.lightText,
          ),
          verticalSpace(8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: code.split('').map((digit) {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: 48,
                height: 56,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColor.primary.withAlpha(50),
                  ),
                ),
                child: Center(
                  child: H4(
                    digit,
                    color: AppColor.darkPrimary,
                  ),
                ),
              );
            }).toList(),
          ),
          verticalSpace(8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Caption(
                subtitle,
                color: AppColor.lightText,
                textAlign: TextAlign.center,
              ),
              if (showCopyButton) ...[
                horizontalSpace(8),
                GestureDetector(
                  onTap: () {
                    Clipboard.setData(ClipboardData(text: code));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Code copied to clipboard'),
                        duration: Duration(seconds: 1),
                      ),
                    );
                  },
                  child: const Icon(
                    Icons.copy,
                    size: 16,
                    color: AppColor.primary,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
