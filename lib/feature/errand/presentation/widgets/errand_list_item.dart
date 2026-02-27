import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kipa/core/shared/widgets/custom_text.dart';
import 'package:kipa/theme/app_colors.dart';
import 'package:kipa/utils/constant.dart';
import '../../domain/entities/errand_entity.dart';
import '../../domain/enums/errand_status.dart';

class ErrandListItem extends StatelessWidget {
  final ErrandEntity errand;
  final VoidCallback onTap;

  const ErrandListItem({
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
                _buildStatusTag(errand.status),
                horizontalSpace(6),
                _buildTag(
                  'Errand',
                  AppColor.pendingBalanceBackground,
                  AppColor.primary,
                  icon: Icons.delivery_dining,
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
                      BodySmall(
                        errand.packageDescription ?? 'Package delivery',
                        fontWeight: FontWeight.w500,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (errand.packageSize != null) ...[
                        verticalSpace(4),
                        Caption(errand.packageSize!.displayName),
                      ],
                    ],
                  ),
                ),
                horizontalSpace(12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    BodySmall(
                      currencyFormatter.format(errand.estimatedPrice ?? 0),
                      fontWeight: FontWeight.w500,
                    ),
                    if (errand.estimatedDistanceKm != null) ...[
                      verticalSpace(4),
                      Caption(
                        '${errand.estimatedDistanceKm!.toStringAsFixed(1)} km',
                        fontWeight: FontWeight.w500,
                      ),
                    ],
                  ],
                ),
              ],
            ),
            verticalSpace(24),

            _buildTimeline(
              pickup: errand.pickupAddress,
              dropoff: errand.dropoffAddress,
            ),
            verticalSpace(24),

            Row(
              children: [
                Caption(dateFormatter.format(errand.createdAt)),
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
                Caption(timeFormatter.format(errand.createdAt)),
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

    if (status == ErrandStatus.completed || status == ErrandStatus.delivered) {
      bg = AppColor.kipaProtectedBackground;
      fg = AppColor.green;
    } else if (status == ErrandStatus.cancelled) {
      bg = Colors.red.withValues(alpha: 0.1);
      fg = Colors.red;
    } else {
      bg = AppColor.pendingBalanceBackground;
      fg = AppColor.primary;
    }

    return _buildTag(status.displayName, bg, fg);
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
                    child: CustomPaint(painter: _DottedLinePainter()),
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

class _DottedLinePainter extends CustomPainter {
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
