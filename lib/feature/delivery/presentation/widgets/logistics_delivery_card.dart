import 'package:flutter/material.dart';
import 'package:kipa/core/shared/widgets/custom_text.dart';
import 'package:kipa/core/shared/widgets/buttons/roundedbutton.dart';
import 'package:kipa/theme/app_colors.dart';
import 'package:kipa/utils/constant.dart';
import '../../domain/entities/logistics_delivery_entity.dart';

class LogisticsDeliveryCard extends StatelessWidget {
  final LogisticsDeliveryEntity delivery;
  final String currentUserId;
  final VoidCallback? onMarkShipped;
  final VoidCallback? onTap;

  const LogisticsDeliveryCard({
    super.key,
    required this.delivery,
    required this.currentUserId,
    this.onMarkShipped,
    this.onTap,
  });

  bool get isSeller => delivery.seller.id == currentUserId;
  bool get isBuyer => delivery.buyer.id == currentUserId;

  Color get statusColor {
    switch (delivery.status) {
      case 'awaiting_shipment':
        return Colors.orange;
      case 'shipped':
        return AppColor.primary;
      case 'delivered':
        return Colors.green;
      default:
        return AppColor.kipaGrey;
    }
  }

  IconData get statusIcon {
    switch (delivery.status) {
      case 'awaiting_shipment':
        return Icons.pending_actions;
      case 'shipped':
        return Icons.local_shipping;
      case 'delivered':
        return Icons.check_circle;
      default:
        return Icons.info;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColor.cardBackground2,
          borderRadius: BorderRadius.circular(16),
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
            // Status and role badges
            Row(
              children: [
                _buildStatusBadge(),
                horizontalSpace(8),
                _buildRoleBadge(),
                const Spacer(),
                if (delivery.isShipDeadlineExceeded)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.red.withAlpha(20),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Caption(
                      'Deadline Exceeded',
                      color: Colors.red,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
              ],
            ),
            verticalSpace(12),

            // Item name and price
            BodySmall(delivery.itemName, fontWeight: FontWeight.w600),
            verticalSpace(4),
            Caption(
              'N${delivery.itemPrice.toStringAsFixed(2)}',
              color: AppColor.primary,
              fontWeight: FontWeight.w600,
            ),
            verticalSpace(12),

            // Route info
            Row(
              children: [
                Icon(Icons.location_on, size: 14, color: Colors.green),
                horizontalSpace(4),
                Expanded(
                  child: Caption(
                    delivery.pickupState,
                    color: AppColor.kipaGrey2,
                  ),
                ),
                Icon(Icons.arrow_forward, size: 14, color: AppColor.kipaGrey),
                horizontalSpace(4),
                Icon(Icons.location_on, size: 14, color: Colors.red),
                horizontalSpace(4),
                Expanded(
                  child: Caption(
                    delivery.dropoffState,
                    color: AppColor.kipaGrey2,
                  ),
                ),
              ],
            ),
            verticalSpace(8),

            // Carrier info (if shipped)
            if (delivery.isShipped &&
                delivery.carrierDisplayName.isNotEmpty) ...[
              Row(
                children: [
                  const Icon(
                    Icons.local_shipping,
                    size: 14,
                    color: AppColor.primary,
                  ),
                  horizontalSpace(4),
                  Caption(
                    delivery.carrierDisplayName,
                    color: AppColor.kipaGrey2,
                    fontWeight: FontWeight.w500,
                  ),
                  if (delivery.trackingNumber != null) ...[
                    horizontalSpace(8),
                    Caption(
                      '(${delivery.trackingNumber})',
                      color: AppColor.kipaGrey,
                    ),
                  ],
                ],
              ),
              verticalSpace(8),
            ],

            // Counterparty info
            Row(
              children: [
                Icon(
                  isSeller ? Icons.person : Icons.store,
                  size: 14,
                  color: AppColor.kipaGrey,
                ),
                horizontalSpace(4),
                Caption(
                  isSeller
                      ? 'Buyer: ${delivery.buyer.fullName}'
                      : 'Seller: ${delivery.seller.fullName}',
                  color: AppColor.kipaGrey2,
                ),
              ],
            ),
            verticalSpace(12),

            // Ship deadline
            if (delivery.isAwaitingShipment) ...[
              Row(
                children: [
                  Icon(
                    Icons.schedule,
                    size: 14,
                    color: delivery.isShipDeadlineExceeded
                        ? Colors.red
                        : AppColor.kipaGrey,
                  ),
                  horizontalSpace(4),
                  Caption(
                    'Ship by: ${_formatDateTime(delivery.shipDeadline)}',
                    color: delivery.isShipDeadlineExceeded
                        ? Colors.red
                        : AppColor.kipaGrey2,
                  ),
                ],
              ),
              verticalSpace(12),
            ],

            // Actions
            if (isSeller && delivery.canMarkShipped)
              SizedBox(
                width: double.infinity,
                child: CustomButton(
                  title: 'Mark as Shipped',
                  onTap: onMarkShipped,
                  color: AppColor.primary,
                  textColor: Colors.white,
                  borderRadius: 12,
                  size: 14,
                ),
              )
            else if (isBuyer &&
                delivery.isShipped &&
                delivery.trackingUrl != null)
              SizedBox(
                width: double.infinity,
                child: CustomButton(
                  title: 'Track Shipment',
                  onTap: onTap,
                  color: AppColor.primary.withAlpha(20),
                  textColor: AppColor.primary,
                  borderColor: AppColor.primary,
                  borderRadius: 12,
                  size: 14,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: statusColor.withAlpha(30),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(statusIcon, size: 12, color: statusColor),
          horizontalSpace(4),
          Caption(
            delivery.statusDisplay,
            color: statusColor,
            fontWeight: FontWeight.w600,
          ),
        ],
      ),
    );
  }

  Widget _buildRoleBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isSeller
            ? Colors.purple.withAlpha(20)
            : Colors.teal.withAlpha(20),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Caption(
        isSeller ? 'Selling' : 'Buying',
        color: isSeller ? Colors.purple : Colors.teal,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  String _formatDateTime(DateTime dt) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    final hour = dt.hour > 12 ? dt.hour - 12 : (dt.hour == 0 ? 12 : dt.hour);
    final period = dt.hour >= 12 ? 'PM' : 'AM';
    return '${dt.day} ${months[dt.month - 1]} at $hour:${dt.minute.toString().padLeft(2, '0')} $period';
  }
}
