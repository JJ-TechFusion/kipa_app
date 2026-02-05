import 'package:flutter/material.dart';
import 'package:kipa/core/shared/widgets/custom_text.dart';
import 'package:kipa/theme/app_colors.dart';
import 'package:kipa/utils/constant.dart';

class TransactionDetailsCard extends StatelessWidget {
  final String itemName;
  final String itemSpecs;
  final String itemPrice;
  final String buyerFee;
  final String buyerTotal;
  final String? youReceive;
  final bool isReceived;
  final String? totalLabel;
  final String? deliveryFee;

  const TransactionDetailsCard({
    super.key,
    required this.itemName,
    required this.itemSpecs,
    required this.itemPrice,
    required this.buyerFee,
    required this.buyerTotal,
    required this.isReceived,
    this.youReceive,
    this.totalLabel,
    this.deliveryFee,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColor.scaffoldBackground,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              isReceived
                  ? _buildTag(
                      'Payment Received',
                      AppColor.linkActiveBackground,
                      AppColor.linkActiveIcon,
                    )
                  : _buildTag(
                      'Awaiting Payment',
                      const Color(0xFFE8EAF6),
                      const Color(0xFF3F51B5),
                    ),
              if (isReceived) ...[
                horizontalSpace(8),
                _buildTag(
                  'Kipa Protected',
                  AppColor.kipaProtectedBackground,
                  AppColor.green,
                  icon: Icons.check_circle_outline,
                ),
              ],
            ],
          ),
          verticalSpace(16),
          BodySmall(itemName, fontWeight: FontWeight.w600),
          verticalSpace(4),
          Caption(itemSpecs),
          verticalSpace(16),
          _buildDetailRow('Item Price', itemPrice),
          verticalSpace(8),
          _buildDetailRow('+1% Buyer Fee', buyerFee),
          verticalSpace(8),
          _buildDetailRow(
            totalLabel ?? 'Buyer Pays Total',
            buyerTotal,
            isBold: true,
          ),
          if (deliveryFee != null) ...[
            verticalSpace(12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColor.processingWindowBackground,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const BodySmall(
                        'Delivery Fee',
                        fontWeight: FontWeight.w600,
                      ),
                      BodySmall(
                        deliveryFee!,
                        fontWeight: FontWeight.w600,
                      ),
                    ],
                  ),
                  verticalSpace(4),
                  const Caption(
                    'Paid separately in cash to rider',
                    fontSize: 10,
                    color: AppColor.kipaGrey2,
                  ),
                ],
              ),
            ),
          ],
          if (youReceive != null) ...[
            verticalSpace(16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const BodySmall('You Receive', fontWeight: FontWeight.w600),
                BodySmall(youReceive!, fontWeight: FontWeight.w600),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTag(String text, Color bg, Color textColor, {IconData? icon}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 12, color: textColor),
            horizontalSpace(4),
          ],
          Text(
            text,
            style: TextStyle(
              color: textColor,
              fontSize: 10,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Caption(label, color: AppColor.lightText),
        BodySmall(
          value,
          fontWeight: isBold ? FontWeight.w600 : FontWeight.w500,
        ),
      ],
    );
  }
}
