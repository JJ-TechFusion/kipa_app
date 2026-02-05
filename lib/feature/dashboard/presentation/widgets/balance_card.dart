import 'package:flutter/material.dart';
import 'package:kipa/core/shared/widgets/custom_text.dart';
import 'package:kipa/theme/app_colors.dart';
import 'package:intl/intl.dart';

class BalanceCard extends StatelessWidget {
  final double balance;
  final double pendingBalance;
  final bool isVisible;
  final VoidCallback onVisibilityToggle;

  const BalanceCard({
    super.key,
    required this.balance,
    required this.pendingBalance,
    required this.isVisible,
    required this.onVisibilityToggle,
  });

  String _formatCurrency(double amount) {
    final formatter = NumberFormat.currency(symbol: '₦', decimalDigits: 2);
    return formatter.format(amount);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const BodySmall(
          'Available Balance',
          color: AppColor.primaryText,
          fontWeight: FontWeight.w500,
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            H1(
              isVisible ? _formatCurrency(balance) : '₦****',
              color: AppColor.primaryText,
              textAlign: TextAlign.center,
            ),
            const SizedBox(width: 12),
            GestureDetector(
              onTap: onVisibilityToggle,
              child: Icon(
                isVisible
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                color: AppColor.lightText,
                size: 22,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: AppColor.pendingBalanceBackground,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Caption(
            'Pending Balance: ${isVisible ? _formatCurrency(pendingBalance) : '₦****'}',
            color: AppColor.primary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
