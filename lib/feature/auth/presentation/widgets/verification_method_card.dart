import 'package:flutter/material.dart';
import '../../../../core/shared/widgets/custom_text.dart';
import '../../../../theme/app_colors.dart';
import '../../../../utils/constant.dart';

class VerificationMethodCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String description;
  final bool isSelected;
  final VoidCallback onTap;

  const VerificationMethodCard({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.description,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColor.onboardingPrimary.withValues(alpha: 0.05)
              : Colors.white,
          border: Border.all(
            color: isSelected ? AppColor.onboardingPrimary : AppColor.neutral,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: iconColor, size: 24),
            ),
            horizontalSpace(16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BodyText(
                    title,
                    fontWeight: FontWeight.w600,
                    color: AppColor.primaryText,
                  ),
                  verticalSpace(4),
                  BodySmall(description, color: AppColor.upholdGrey),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
