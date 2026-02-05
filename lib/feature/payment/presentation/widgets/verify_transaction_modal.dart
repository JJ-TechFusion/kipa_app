import 'package:flutter/material.dart';
import 'package:kipa/core/shared/widgets/buttons/roundedbutton.dart';
import 'package:kipa/core/shared/widgets/custom_text.dart';
import 'package:kipa/theme/app_colors.dart';
import 'package:kipa/utils/constant.dart';

import '../../../../core/shared/widgets/buttons/animated_button.dart';

class VerifyTransactionModal extends StatefulWidget {
  final void Function(String selectedExpiry) onGenerate;
  final String itemName;
  final String itemDescription;
  final double itemPrice;
  final String linkExpiry;

  const VerifyTransactionModal({
    super.key,
    required this.onGenerate,
    required this.itemName,
    required this.itemDescription,
    required this.itemPrice,
    required this.linkExpiry,
  });

  @override
  State<VerifyTransactionModal> createState() => _VerifyTransactionModalState();
}

class _VerifyTransactionModalState extends State<VerifyTransactionModal> {
  late String _currentLinkExpiry;

  @override
  void initState() {
    super.initState();
    _currentLinkExpiry = widget.linkExpiry;
  }

  void _toggleLinkExpiry() {
    setState(() {
      _currentLinkExpiry = _currentLinkExpiry == 'reusable'
          ? 'one_time'
          : 'reusable';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 50,
              height: 4,
              decoration: BoxDecoration(
                color: AppColor.kipaGrey.withAlpha(80),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          verticalSpace(24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const BodyText(
                'Verify Transaction Details',
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Icon(
                  Icons.close,
                  color: AppColor.lightText,
                  size: 20,
                ),
              ),
            ],
          ),
          verticalSpace(8),
          const Caption(
            'Please review transaction details carefully before creating your payment link',
          ),
          verticalSpace(24),

          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColor.scaffoldBackground,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BodyText(widget.itemName, fontWeight: FontWeight.w600),
                verticalSpace(4),
                Caption(widget.itemDescription),
                verticalSpace(16),
                _buildDetailRow(
                  'Item Price',
                  _formatCurrency(widget.itemPrice),
                ),
                verticalSpace(8),
                _buildDetailRow(
                  '1% Buyer Fee',
                  _formatCurrency(widget.itemPrice * 0.01),
                ),
                verticalSpace(8),
                _buildDetailRow(
                  'Buyer Pays Total',
                  _formatCurrency(widget.itemPrice * 1.01),
                  isBold: true,
                ),
                verticalSpace(16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const BodyText('You Receive', fontWeight: FontWeight.w600),
                    BodyText(
                      _formatCurrency(widget.itemPrice),
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ],
                ),
              ],
            ),
          ),
          verticalSpace(20),

          // Expiry info
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: AppColor.kipaGrey.withAlpha(50)),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const BodySmall(
                        'Link Expiry',
                        fontWeight: FontWeight.w600,
                      ),
                      verticalSpace(6),
                      Caption(
                        _currentLinkExpiry == 'reusable'
                            ? 'Reusable until deleted'
                            : 'After payment (one-time use)',
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: _toggleLinkExpiry,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColor.tagBackground,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Caption(
                      'Change',
                      fontSize: 10,
                      color: AppColor.lightText,
                    ),
                  ),
                ),
              ],
            ),
          ),
          verticalSpace(32),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: AnimatedButton(
              onTap: () => widget.onGenerate(_currentLinkExpiry),
              child: CustomButton(
                title: 'Generate Payment Link',
                borderRadius: 30,
              ),
            ),
          ),
          verticalSpace(20),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Caption(label, color: AppColor.lightText, fontSize: 13),
        BodyText(
          value,
          fontWeight: isBold ? FontWeight.w600 : FontWeight.w500,
          fontSize: isBold ? 14 : 13,
        ),
      ],
    );
  }

  String _formatCurrency(double amount) {
    return '₦${amount.toStringAsFixed(2).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}';
  }
}
