import 'package:flutter/material.dart';
import 'package:kipa/core/shared/widgets/buttons/animated_button.dart';
import 'package:kipa/core/shared/widgets/buttons/roundedbutton.dart';
import 'package:kipa/core/shared/widgets/custom_text.dart';
import 'package:kipa/core/routes/route_names.dart';
import 'package:kipa/theme/app_colors.dart';
import 'package:kipa/utils/constant.dart';

class BuyerPaymentSuccessScreen extends StatelessWidget {
  final String? paymentRequestId;

  const BuyerPaymentSuccessScreen({super.key, this.paymentRequestId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const Spacer(flex: 2),
              SizedBox(
                width: 200,
                height: 200,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    ..._buildDecorativeDots(),
                    Container(
                      width: 100,
                      height: 100,
                      decoration: const BoxDecoration(
                        color: AppColor.primary,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 50,
                      ),
                    ),
                  ],
                ),
              ),
              verticalSpace(32),
              const BodyText(
                'Payment received successfully!',
                fontWeight: FontWeight.w600,
                fontSize: 20,
              ),
              verticalSpace(12),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: BodySmall(
                  'Your payment has been received and funds will be held in escrow until you confirm delivery',
                  textAlign: TextAlign.center,
                  color: AppColor.lightText,
                ),
              ),
              const Spacer(flex: 3),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 42),
                child: AnimatedButton(
                  onTap: () {
                    debugPrint('Payment Request ID: $paymentRequestId');
                    if (paymentRequestId != null && paymentRequestId!.isNotEmpty) {
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        RouteNames.transactionStatusRoute,
                        (route) => route.isFirst,
                        arguments: {
                          'paymentRequestId': paymentRequestId,
                        },
                      );
                    } else {
                      // Navigate to dashboard if no paymentRequestId
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        RouteNames.dashboardRoute,
                        (route) => false,
                      );
                    }
                  },
                  child: CustomButton(
                    title: 'View Transaction Details',
                    borderRadius: 30,
                  ),
                ),
              ),
              verticalSpace(20),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildDecorativeDots() {
    final List<Map<String, dynamic>> dots = [
      {
        'top': 10.0,
        'left': 60.0,
        'size': 8.0,
        'color': AppColor.primary.withAlpha(100),
      },
      {
        'top': 25.0,
        'left': 100.0,
        'size': 6.0,
        'color': Colors.orange.withAlpha(150),
      },
      {
        'top': 20.0,
        'right': 60.0,
        'size': 10.0,
        'color': AppColor.primary.withAlpha(80),
      },
      {
        'top': 40.0,
        'right': 40.0,
        'size': 6.0,
        'color': Colors.pink.withAlpha(100),
      },
      {
        'top': 80.0,
        'left': 20.0,
        'size': 8.0,
        'color': Colors.orange.withAlpha(120),
      },
      {
        'top': 100.0,
        'left': 35.0,
        'size': 6.0,
        'color': AppColor.primary.withAlpha(60),
      },
      {
        'bottom': 60.0,
        'left': 50.0,
        'size': 8.0,
        'color': AppColor.primary.withAlpha(100),
      },
      {
        'bottom': 40.0,
        'right': 55.0,
        'size': 6.0,
        'color': Colors.pink.withAlpha(80),
      },
      {
        'top': 90.0,
        'right': 25.0,
        'size': 8.0,
        'color': AppColor.primary.withAlpha(70),
      },
      {
        'bottom': 80.0,
        'right': 40.0,
        'size': 6.0,
        'color': Colors.orange.withAlpha(100),
      },
    ];

    return dots.map((dot) {
      return Positioned(
        top: dot['top'] as double?,
        left: dot['left'] as double?,
        right: dot['right'] as double?,
        bottom: dot['bottom'] as double?,
        child: Container(
          width: dot['size'] as double,
          height: dot['size'] as double,
          decoration: BoxDecoration(
            color: dot['color'] as Color,
            shape: BoxShape.circle,
          ),
        ),
      );
    }).toList();
  }
}
