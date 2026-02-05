import 'package:flutter/material.dart';
import 'package:kipa/core/shared/widgets/custom_text.dart';
import 'package:kipa/feature/dashboard/presentation/widgets/active_delivery_card.dart';
import 'package:kipa/theme/app_colors.dart';

class ActiveDeliveriesList extends StatelessWidget {
  final List<Map<String, dynamic>> deliveries;
  final VoidCallback onViewAllTap;
  final Function(int) onDeliveryTap;

  const ActiveDeliveriesList({
    super.key,
    required this.deliveries,
    required this.onViewAllTap,
    required this.onDeliveryTap,
  });

  @override
  Widget build(BuildContext context) {
    if (deliveries.isEmpty) {
      return _buildEmptyState();
    }

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const BodyText(
              'Active Deliveries',
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
            GestureDetector(
              onTap: onViewAllTap,
              child: const BodySmall('View all', color: AppColor.lightText),
            ),
          ],
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 190,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: deliveries.length,
            separatorBuilder: (context, index) => const SizedBox(width: 16),
            itemBuilder: (context, index) {
              return SizedBox(
                width: 350, // Fixed width for cards in horizontal list
                child: ActiveDeliveryCard(
                  deliveryData: deliveries[index],
                  onTap: () => onDeliveryTap(index),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(24),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.inbox_outlined,
            size: 48,
            color: AppColor.lightText.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 16),
          const BodySmall(
            "You have no active deliveries",
            color: AppColor.lightText,
          ),
        ],
      ),
    );
  }
}
