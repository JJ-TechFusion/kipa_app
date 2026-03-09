import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kipa/core/shared/widgets/buttons/roundedbutton.dart';
import 'package:kipa/core/shared/widgets/custom_text.dart';
import 'package:kipa/core/routes/route_names.dart';
import 'package:kipa/theme/app_colors.dart';
import 'package:kipa/utils/constant.dart';
import '../../../../core/shared/widgets/buttons/animated_button.dart';
import '../../../../core/shared/widgets/custom_snackbar.dart';
import '../providers/payment_provider.dart';

class FulfillmentSuccessScreen extends ConsumerStatefulWidget {
  const FulfillmentSuccessScreen({super.key});

  @override
  ConsumerState<FulfillmentSuccessScreen> createState() =>
      _FulfillmentSuccessScreenState();
}

class _FulfillmentSuccessScreenState
    extends ConsumerState<FulfillmentSuccessScreen> {
  void _onBackToHome() {
    Navigator.pushNamedAndRemoveUntil(
      context,
      RouteNames.homeRoute,
      (route) => false,
    );
  }

  void _copyCode(String paymentCode) {
    Clipboard.setData(ClipboardData(text: paymentCode));
    CustomSnackBar.show(
      context,
      message: 'Code copied!',
      type: SnackBarType.success,
    );
  }

  @override
  Widget build(BuildContext context) {
    final paymentState = ref.watch(paymentNotifierProvider);
    final fulfillmentResponse = paymentState.fulfillmentResponse;
    final paymentCode = fulfillmentResponse?.paymentCode ?? 'No code';

    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const BodyText(
            'Fulfillment Request',
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              verticalSpace(40),
              SizedBox(
                width: 120,
                height: 120,
                child: Image.asset(
                  "assets/images/success.png",
                  fit: BoxFit.contain,
                ),
              ),
              verticalSpace(32),
              const BodyText(
                'Request created successfully!',
                fontWeight: FontWeight.w500,
              ),
              verticalSpace(8),
              const BodySmall(
                'Share this payment code with your buyer to activate Kipa Protect',
                textAlign: TextAlign.center,
                color: AppColor.lightText,
              ),
              if (fulfillmentResponse != null) ...[
                verticalSpace(16),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: AppColor.pendingBalanceBackground,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      _buildInfoRow('Item', fulfillmentResponse.itemName),
                      _buildInfoRow(
                        'Delivery Fee',
                        '₦${fulfillmentResponse.estimatedDeliveryFee.toStringAsFixed(2)}',
                      ),
                      _buildInfoRow(
                        'Total',
                        '₦${fulfillmentResponse.estimatedTotal.toStringAsFixed(2)}',
                      ),
                    ],
                  ),
                ),
              ],
              verticalSpace(24),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColor.kipaGrey.withAlpha(50)),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: const BoxDecoration(
                        color: AppColor.pendingBalanceBackground,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.numbers, color: AppColor.primary),
                    ),
                    verticalSpace(16),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: AppColor.linkCopyBackground,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              paymentCode,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontSize: 13),
                            ),
                          ),
                          horizontalSpace(8),
                          GestureDetector(
                            onTap: () => _copyCode(paymentCode),
                            child: const Icon(
                              Icons.copy,
                              size: 18,
                              color: AppColor.kipaGrey,
                            ),
                          ),
                        ],
                      ),
                    ),
                    verticalSpace(16),
                    CustomButton(
                      title: 'Copy Code',
                      icon: Icons.copy,
                      onTap: () => _copyCode(paymentCode),
                      borderRadius: 12,
                      size: 14,
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 42),
                child: AnimatedButton(
                  onTap: _onBackToHome,
                  child: CustomButton(title: 'Back to Home', borderRadius: 30),
                ),
              ),
              verticalSpace(20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          BodySmall(label, color: AppColor.lightText),
          BodySmall(value, fontWeight: FontWeight.w600),
        ],
      ),
    );
  }
}
