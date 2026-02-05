import 'package:flutter/material.dart';
import 'package:kipa/core/shared/widgets/custom_text.dart';
import 'package:kipa/core/shared/widgets/smart_image.dart';
import 'package:kipa/theme/app_colors.dart';
import 'package:kipa/utils/constant.dart';

class ActiveDeliveryCard extends StatelessWidget {
  final Map<String, dynamic> deliveryData;
  final VoidCallback onTap;

  const ActiveDeliveryCard({
    super.key,
    required this.deliveryData,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColor.cardBackground,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: AppColor.cardShadow,
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _buildTag(
                  'In Transit',
                  AppColor.pendingBalanceBackground,
                  AppColor.primary,
                ),
                const SizedBox(width: 8),
                _buildTag(
                  'Kipa Protected',
                  AppColor.kipaProtectedBackground,
                  AppColor.green,
                  icon: Icons.verified_user_outlined,
                ),
              ],
            ),
            verticalSpace(16),
            Row(
              children: [
                ClipOval(
                  child: SmartImage(
                    imageUrl:
                        deliveryData['buyerImage'] ??
                        'assets/images/user_placeholder.png',
                    width: 40,
                    height: 40,
                    fallbackIcon: Icons.person,
                    fallbackIconSize: 20,
                  ),
                ),
                horizontalSpace(12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 4,
                  children: [
                    BodySmall(
                      deliveryData['buyerName'] ?? 'Buyer Name',
                      fontWeight: FontWeight.w600,
                    ),
                    const Caption('Buyer'),
                  ],
                ),
              ],
            ),
            verticalSpace(16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 2,
                    children: [
                      BodySmall(
                        deliveryData['itemName'] ?? 'Item Name',
                        fontWeight: FontWeight.w600,
                      ),
                      verticalSpace(4),
                      Caption(
                        deliveryData['itemSpecs'] ?? 'Specs',
                        color: AppColor.lightText,
                      ),
                    ],
                  ),
                ),
                BodySmall(
                  displayPrice(deliveryData['price']),
                  color: AppColor.primaryText,
                ),
              ],
            ),
            verticalSpace(16),
            Row(
              children: [
                Icon(Icons.pedal_bike, size: 16, color: AppColor.lightText),
                horizontalSpace(8),

                Caption('Rider assigned', color: AppColor.lightText),
                Spacer(),
                Caption('Dec 30, 4:05PM', color: AppColor.lightText),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTag(
    String text,
    Color bgColor,
    Color textColor, {
    IconData? icon,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 12, color: textColor),
            horizontalSpace(4),
          ],
          Caption(text, color: textColor, fontSize: 10),
        ],
      ),
    );
  }

  String displayPrice(dynamic price) {
    return '₦${price ?? '0.00'}';
  }
}
