import 'package:flutter/material.dart';
import 'package:kipa/core/shared/widgets/custom_text.dart';
import 'package:kipa/theme/app_colors.dart';
import 'package:kipa/utils/constant.dart';

class LinkCreatedSuccessScreen extends StatefulWidget {
  final bool isEdit;

  const LinkCreatedSuccessScreen({super.key, this.isEdit = false});

  @override
  State<LinkCreatedSuccessScreen> createState() =>
      _LinkCreatedSuccessScreenState();
}

class _LinkCreatedSuccessScreenState extends State<LinkCreatedSuccessScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        Navigator.popUntil(context, (route) => route.isFirst);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 120,
                height: 120,
                child: Image.asset(
                  "assets/images/success.png",
                  fit: BoxFit.contain,
                ),
              ),
              verticalSpace(32),
              BodyText(
                widget.isEdit
                    ? 'Payment Link Updated!'
                    : 'Payment Link Created!',
                fontWeight: FontWeight.w600,
                fontSize: 20,
              ),
              verticalSpace(8),
              const BodySmall(
                'Redirecting to dashboard...',
                textAlign: TextAlign.center,
                color: AppColor.lightText,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
