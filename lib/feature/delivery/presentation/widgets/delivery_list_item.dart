import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kipa/core/shared/widgets/custom_text.dart';
import 'package:kipa/feature/purchases/domain/entities/purchase_entity.dart';
import 'package:kipa/feature/sales/domain/entities/sale_entity.dart';
import 'package:kipa/theme/app_colors.dart';
import 'package:kipa/utils/constant.dart';

class DeliveryListItem extends StatelessWidget {
  final PurchaseEntity? purchase;
  final SaleEntity? sale;
  final VoidCallback onTap;

  const DeliveryListItem({
    super.key,
    this.purchase,
    this.sale,
    required this.onTap,
  }) : assert(
         purchase != null || sale != null,
         'Either purchase or sale must be provided',
       );

  @override
  Widget build(BuildContext context) {
    final itemName = purchase?.itemName ?? sale?.itemName ?? '';
    final itemDescription = purchase?.itemDescription ?? '';
    final totalAmount = purchase?.totalAmount ?? sale?.totalAmount ?? 0.0;
    final buyerServiceFee = purchase?.buyerServiceFee ?? 0.0;
    final createdAt = purchase?.createdAt ?? sale?.createdAt ?? DateTime.now();
    final orderStatus = purchase?.status ?? sale?.orderStatus ?? '';
    final prStatus = purchase?.prStatus ?? sale?.prStatus ?? '';

    final pickupAddress = purchase?.pickupAddress ?? sale?.pickupAddress ?? 'Pickup Point';
    final dropoffAddress = purchase?.dropoffAddress ?? sale?.dropoffAddress ?? 'Destination';

    final currencyFormatter = NumberFormat.currency(
      symbol: '₦',
      decimalDigits: 2,
    );
    final dateFormatter = DateFormat('MMM d, yyyy');
    final timeFormatter = DateFormat('h:mm a');

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
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                if (orderStatus.isNotEmpty)
                  _buildStatusTag(orderStatus),
                if (orderStatus.isNotEmpty && prStatus.isNotEmpty)
                  horizontalSpace(6),
                if (prStatus.isNotEmpty)
                  _buildStatusTag(prStatus),
                if (prStatus.isNotEmpty || orderStatus.isNotEmpty)
                  horizontalSpace(6),
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      BodySmall(itemName, fontWeight: FontWeight.w500),
                      verticalSpace(4),
                      if (itemDescription.isNotEmpty) Caption(itemDescription),
                    ],
                  ),
                ),
                horizontalSpace(12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    BodySmall(
                      currencyFormatter.format(totalAmount),
                      fontWeight: FontWeight.w500,
                    ),
                    if (buyerServiceFee > 0) ...[
                      verticalSpace(4),
                      Caption(
                        '+${currencyFormatter.format(buyerServiceFee)} buyer fee',
                        fontWeight: FontWeight.w500,
                      ),
                    ],
                  ],
                ),
              ],
            ),
            verticalSpace(24),

            _buildTimeline(pickup: pickupAddress, dropoff: dropoffAddress),
            verticalSpace(24),

            Row(
              children: [
                Caption(dateFormatter.format(createdAt)),
                horizontalSpace(8),
                Container(
                  width: 4,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColor.lightText,
                    shape: BoxShape.circle,
                  ),
                ),
                horizontalSpace(8),
                Caption(timeFormatter.format(createdAt)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusTag(String rawStatus) {
    final text = rawStatus.replaceAll('_', ' ').capitalize();
    final lower = text.toLowerCase();
    Color bg;
    Color fg;
    if (lower == 'completed' || lower == 'delivered' || lower == 'refunded') {
      bg = AppColor.kipaProtectedBackground;
      fg = AppColor.green;
    } else if (lower == 'disputed' || lower == 'cancelled' || lower == 'failed') {
      bg = Colors.red.withValues(alpha: 0.1);
      fg = Colors.red;
    } else {
      bg = AppColor.pendingBalanceBackground;
      fg = AppColor.primary;
    }
    return _buildTag(text, bg, fg);
  }

  Widget _buildTag(
    String text,
    Color bgColor,
    Color textColor, {
    IconData? icon,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
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
          Caption(text, color: textColor, fontWeight: FontWeight.w500),
        ],
      ),
    );
  }

  Widget _buildTimeline({required String pickup, required String dropoff}) {
    return IntrinsicHeight(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Column(
              children: [
                _buildTimelineIcon(Icons.my_location, AppColor.primary),
                Expanded(
                  child: Container(
                    width: 1,
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    child: CustomPaint(painter: DottedLinePainter()),
                  ),
                ),
                _buildTimelineIcon(Icons.location_on_outlined, AppColor.green),
              ],
            ),
            horizontalSpace(12),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLocationText(pickup, 'Pickup point'),
                  verticalSpace(32),
                  _buildLocationText(dropoff, 'Destination'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimelineIcon(IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: color, size: 12),
    );
  }

  Widget _buildLocationText(String address, String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BodySmall(
          address,
          fontWeight: FontWeight.w600,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        Caption(label),
      ],
    );
  }
}

class DottedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = AppColor.lightText.withValues(alpha: 0.3)
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round;

    double dashHeight = 2, dashSpace = 2, startY = 0;
    while (startY < size.height) {
      canvas.drawLine(Offset(0, startY), Offset(0, startY + dashHeight), paint);
      startY += dashHeight + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

extension StringExtension on String {
  String capitalize() {
    if (isEmpty) return this;
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }
}
