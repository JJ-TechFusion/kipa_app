import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kipa/core/shared/widgets/custom_text.dart';
import 'package:kipa/theme/app_colors.dart';
import 'package:kipa/utils/constant.dart';
import '../../domain/entities/errand_entity.dart';
import '../../domain/enums/errand_status.dart';

class ActiveErrandCard extends StatelessWidget {
  final ErrandEntity errand;
  final VoidCallback onTap;

  const ActiveErrandCard({
    super.key,
    required this.errand,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final currencyFormatter = NumberFormat.currency(
      symbol: '\u20A6',
      decimalDigits: 2,
    );

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
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
                _buildStatusTag(errand.status),
                horizontalSpace(8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColor.pendingBalanceBackground,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.delivery_dining,
                        size: 12,
                        color: AppColor.primary,
                      ),
                      horizontalSpace(4),
                      Caption(
                        'Errand',
                        color: AppColor.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                BodySmall(
                  currencyFormatter.format(errand.estimatedPrice ?? 0),
                  fontWeight: FontWeight.w600,
                ),
              ],
            ),
            verticalSpace(16),
            BodySmall(
              errand.packageDescription ?? 'Package delivery',
              fontWeight: FontWeight.w500,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            verticalSpace(16),
            _buildTimeline(),
            verticalSpace(12),
            Row(
              children: [
                Icon(Icons.arrow_forward, size: 16, color: AppColor.primary),
                horizontalSpace(4),
                Caption(
                  'Tap to view details',
                  color: AppColor.primary,
                  fontWeight: FontWeight.w500,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusTag(ErrandStatus status) {
    Color bg;
    Color fg;

    switch (status) {
      case ErrandStatus.searching:
        bg = Colors.orange.withValues(alpha: 0.1);
        fg = Colors.orange;
        break;
      case ErrandStatus.accepted:
        bg = Colors.blue.withValues(alpha: 0.1);
        fg = Colors.blue;
        break;
      case ErrandStatus.pickedUp:
      case ErrandStatus.inTransit:
        bg = AppColor.primary.withValues(alpha: 0.1);
        fg = AppColor.primary;
        break;
      case ErrandStatus.delivered:
        bg = AppColor.green.withValues(alpha: 0.1);
        fg = AppColor.green;
        break;
      default:
        bg = AppColor.lightText.withValues(alpha: 0.1);
        fg = AppColor.lightText;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(color: fg, shape: BoxShape.circle),
          ),
          horizontalSpace(6),
          Caption(status.displayName, color: fg, fontWeight: FontWeight.w500),
        ],
      ),
    );
  }

  Widget _buildTimeline() {
    return IntrinsicHeight(
      child: Row(
        children: [
          Column(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: AppColor.primary,
                  shape: BoxShape.circle,
                ),
              ),
              Expanded(
                child: Container(
                  width: 1,
                  color: AppColor.lightText.withValues(alpha: 0.3),
                ),
              ),
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: AppColor.green,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ),
          horizontalSpace(12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Caption(errand.pickupAddress),
                verticalSpace(8),
                Caption(errand.dropoffAddress),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
