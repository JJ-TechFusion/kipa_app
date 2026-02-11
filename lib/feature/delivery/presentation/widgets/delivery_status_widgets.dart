import 'package:flutter/material.dart';
import 'package:kipa/core/shared/widgets/custom_text.dart';
import 'package:kipa/theme/app_colors.dart';
import 'package:kipa/utils/constant.dart';
import 'package:intl/intl.dart';
import 'package:kipa/feature/delivery/domain/enums/delivery_status.dart';

/// Helper function to get rider status text based on delivery status
String getRiderStatusText(DeliveryStatus status, {bool isBuyer = true}) {
  switch (status) {
    case DeliveryStatus.searching:
      return 'Searching for a rider';
    case DeliveryStatus.accepted:
      return isBuyer
          ? 'Rider assigned, heading to pickup'
          : 'Rider assigned, heading your way';
    case DeliveryStatus.enRoutePickup:
      return isBuyer
          ? 'Rider is on the way to pickup'
          : 'Rider is on the way to you';
    case DeliveryStatus.pickedUp:
      return isBuyer
          ? 'Item picked up, heading your way'
          : 'Item picked up by rider';
    case DeliveryStatus.inTransit:
      return isBuyer
          ? 'Your rider is on the way'
          : 'Rider is delivering your item';
    case DeliveryStatus.delivered:
      return 'Item has been delivered';
    case DeliveryStatus.buyerUnavailable:
      return 'Buyer was unavailable at delivery location';
    case DeliveryStatus.forcedReturn:
      return 'Item is being returned to seller';
    case DeliveryStatus.forcedReturnDone:
      return 'Item returned. Refund processing';
    default:
      return isBuyer ? 'Your rider is on the way' : 'Rider is on the way';
  }
}

/// Card showing "Payment Successful" with amount and date
class PaymentStatusCard extends StatelessWidget {
  final double amount;
  final DateTime date;
  final String statusText;
  final Color statusColor;

  const PaymentStatusCard({
    super.key,
    required this.amount,
    required this.date,
    this.statusText = 'Payment Successful',
    this.statusColor = const Color(0xFF0F9D58), // Green
  });

  @override
  Widget build(BuildContext context) {
    final currencyFormatter = NumberFormat.currency(
      symbol: '₦',
      decimalDigits: 2,
    );
    final dateFormatter = DateFormat('MMM d, y, h:mm a');

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
      decoration: BoxDecoration(
        color: AppColor.cardBackground2, // Light grey/white depending on theme
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: statusColor,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check_circle,
              color: Colors.white,
              size: 24,
            ),
          ),
          verticalSpace(16),
          BodyText(statusText, fontWeight: FontWeight.w600),
          verticalSpace(8),
          H3(
            currencyFormatter.format(amount),
            // fontSize: 24 is default for H3, weight is w600
          ),
          verticalSpace(8),
          Caption(dateFormatter.format(date), color: AppColor.lightText),
        ],
      ),
    );
  }
}

/// Orange card showing "Processing Ongoing" and timer
class ProcessingStatusCard extends StatelessWidget {
  final int daysLeft;
  final String description;

  const ProcessingStatusCard({
    super.key,
    required this.daysLeft,
    this.description =
        'Your seller has a maximum of 3 days to send your package for delivery or your money will be automatically refunded to you',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF3E0), // Light orange
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.access_time, color: Color(0xFFFF9800), size: 20),
              horizontalSpace(8),
              const Expanded(
                child: BodyText(
                  'Processing Ongoing',
                  fontWeight: FontWeight.w600,
                  color: Color(0xFFE65100),
                ),
              ),
              if (daysLeft > 0)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withAlpha(150),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Caption(
                    '$daysLeft days left',
                    color: const Color(0xFFE65100),
                    fontWeight: FontWeight.bold,
                  ),
                ),
            ],
          ),
          verticalSpace(12),
          Caption(description, color: const Color(0xFFE65100)),
        ],
      ),
    );
  }
}

/// Banner showing rider status based on delivery status
class RiderInfoBanner extends StatelessWidget {
  final String statusText;
  final VoidCallback? onTap;

  const RiderInfoBanner({super.key, required this.statusText, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFE8EAF6), // Light indigo
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.two_wheeler, color: AppColor.primary, size: 20),
          horizontalSpace(8),
          BodyText(
            statusText,
            color: AppColor.primary,
            fontWeight: FontWeight.w600,
          ),
        ],
      ),
    );
  }
}

class CodeCard extends StatelessWidget {
  final String code;
  final String title;
  final String subtitle;

  const CodeCard({
    super.key,
    required this.code,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final List<String> digits = code.split('');

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 14),
      decoration: BoxDecoration(
        color: AppColor.cardBackground2,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Caption(title, color: AppColor.lightText),
          verticalSpace(8),
          BodyText(subtitle, fontWeight: FontWeight.w600),
          verticalSpace(24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: digits.map((digit) {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 6),
                width: 40,
                height: 50,
                decoration: const BoxDecoration(
                  color: Colors.black,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(
                  digit,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class SafeFundsBanner extends StatelessWidget {
  final double amount;
  final String? customText;

  const SafeFundsBanner({super.key, required this.amount, this.customText});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColor.lightTeal,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                Icons.verified_user_outlined,
                color: Color(0xFF00695C),
                size: 20,
              ),
              SizedBox(width: 8),
              BodyText(
                'Funds secured in Kipa Protect',
                fontWeight: FontWeight.w600,
                color: Color(0xFF00695C),
              ),
            ],
          ),
          verticalSpace(8),
          Text(
            customText ??
                'Your payment of ₦${amount.toStringAsFixed(2)} is held safely until you confirm delivery',
            style: const TextStyle(
              color: Color(0xFF00695C),
              fontSize: 12,
              fontFamily: 'Plus Jakarta Sans',
            ),
          ),
        ],
      ),
    );
  }
}
