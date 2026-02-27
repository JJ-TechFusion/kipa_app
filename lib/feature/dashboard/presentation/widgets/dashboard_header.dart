import 'package:flutter/material.dart';
import 'package:kipa/core/shared/widgets/custom_text.dart';
import 'package:kipa/core/shared/widgets/smart_image.dart';
import 'package:kipa/theme/app_colors.dart';

class DashboardHeader extends StatelessWidget {
  final String userName;
  final String? profileImageUrl;
  final VoidCallback? onNotificationTap;
  final VoidCallback? onProfileTap;

  const DashboardHeader({
    super.key,
    required this.userName,
    this.profileImageUrl,
    this.onNotificationTap,
    this.onProfileTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: onProfileTap,
          child: ClipOval(
            child: SmartImage(
              imageUrl: profileImageUrl ?? 'assets/images/user.png',
              width: 48,
              height: 48,
              fit: BoxFit.cover,
              fallbackIcon: Icons.person,
              fallbackIconSize: 24,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BodyLarge(
                'Hi $userName,',
                color: AppColor.primaryText,
                fontWeight: FontWeight.w500,
              ),
              const SizedBox(height: 4),
              const BodySmall(
                'What would you like to do today?',
                color: AppColor.lightText,
              ),
            ],
          ),
        ),
        // IconButton(
        //   onPressed: onNotificationTap,
        //   icon: const Icon(
        //     CupertinoIcons.bell,
        //     color: AppColor.primaryText,
        //     size: 24,
        //   ),
        // ),
      ],
    );
  }
}
