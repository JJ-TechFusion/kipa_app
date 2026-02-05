import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kipa/core/shared/widgets/buttons/animated_button.dart';
import 'package:kipa/core/shared/widgets/buttons/roundedbutton.dart';
import 'package:kipa/core/shared/widgets/custom_text.dart';
import 'package:kipa/core/routes/route_names.dart';
import 'package:kipa/theme/app_colors.dart';
import 'package:kipa/utils/constant.dart';

class PayViaLinkScreen extends StatefulWidget {
  const PayViaLinkScreen({super.key});

  @override
  State<PayViaLinkScreen> createState() => _PayViaLinkScreenState();
}

class _PayViaLinkScreenState extends State<PayViaLinkScreen> {
  int _selectedTab = 0; // 0: Link, 1: Code
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: AppColor.primary,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
          ),
        ),
        title: const BodyText(
          'Pay via Link',
          fontWeight: FontWeight.w600,
          fontSize: 18,
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const H4(
              'You can paste a payment link or code to proceed with your transaction',
            ),
            verticalSpace(8),
            const Caption(
              'Paste payment link or code shared by the seller',
              color: AppColor.lightText,
            ),
            verticalSpace(32),

            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                border: Border.all(color: AppColor.kipaGrey.withAlpha(50)),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: AppColor.scaffoldBackground,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Expanded(child: _buildTab(0, 'Payment Link')),
                        Expanded(child: _buildTab(1, 'Payment Code')),
                      ],
                    ),
                  ),
                  verticalSpace(32),

                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: const BoxDecoration(
                      color: Color(0xFFE8EAF6),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.link,
                      color: AppColor.primary,
                      size: 24,
                    ),
                  ),
                  verticalSpace(32),

                  // Input Field
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColor.scaffoldBackground,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _controller,
                            decoration: const InputDecoration(
                              hintText: 'Paste link here',
                              hintStyle: TextStyle(
                                fontSize: 14,
                                color: AppColor.lightText,
                              ),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () async {
                            final data = await Clipboard.getData(
                              Clipboard.kTextPlain,
                            );
                            if (data?.text != null) {
                              setState(() {
                                _controller.text = data!.text!;
                              });
                            }
                          },
                          child: const BodySmall(
                            'Paste',
                            fontWeight: FontWeight.w600,
                            color: AppColor.primaryText,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            verticalSpace(24),

            // Security Banner
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColor.successCircleBackground,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    CupertinoIcons.checkmark_shield,
                    color: AppColor.successCheckIcon,
                    size: 20,
                  ),
                  horizontalSpace(12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        BodySmall(
                          'Secure Kipa Protection',
                          fontWeight: FontWeight.w600,
                          color: AppColor.successCheckIcon,
                        ),
                        SizedBox(height: 4),
                        Caption(
                          'Your payment is protected until you confirm delivery',
                          color: AppColor.successCheckIcon,
                          fontSize: 11,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 42),
              child: AnimatedButton(
                onTap: () {
                  if (_controller.text.isEmpty) return;

                  String paymentCode = _controller.text.trim();
                  if (paymentCode.contains('/pay/')) {
                    paymentCode = paymentCode.split('/pay/').last;
                    if (paymentCode.contains('/')) {
                      paymentCode = paymentCode.split('/').first;
                    }
                  } else if (paymentCode.contains('http')) {
                    final uri = Uri.tryParse(paymentCode);
                    if (uri != null) {
                      paymentCode = uri.pathSegments.last;
                    }
                  }

                  Navigator.pushNamed(
                    context,
                    RouteNames.buyerPaymentDetailsRoute,
                    arguments: {'paymentCode': paymentCode},
                  );
                },
                child: CustomButton(
                  title: 'Continue',
                  borderRadius: 30,
                  color: AppColor.primary,
                ),
              ),
            ),
            verticalSpace(20),
          ],
        ),
      ),
    );
  }

  Widget _buildTab(int index, String title) {
    final isSelected = _selectedTab == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedTab = index),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.black.withAlpha(5),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Center(
          child: BodySmall(
            title,
            fontWeight: FontWeight.w600,
            color: isSelected ? AppColor.primaryText : AppColor.lightText,
          ),
        ),
      ),
    );
  }
}
