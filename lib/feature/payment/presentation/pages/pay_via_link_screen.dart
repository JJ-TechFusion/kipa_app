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
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

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
          'Pay via Code',
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
            const H4('Paste a payment code to proceed with your transaction'),
            verticalSpace(8),
            const Caption(
              'Paste the payment code shared by the seller',
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
                  verticalSpace(8),

                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: const BoxDecoration(
                      color: Color(0xFFE8EAF6),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.tag,
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
                              hintText: 'Paste code here',
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
                  verticalSpace(8),
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

                  final paymentCode = _controller.text.trim();

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
}
