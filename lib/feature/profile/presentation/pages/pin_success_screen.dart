import 'package:flutter/material.dart';
import '../../../../core/shared/widgets/buttons/animated_button.dart';
import '../../../../core/shared/widgets/buttons/roundedbutton.dart';
import '../../../../core/shared/widgets/custom_text.dart';
import '../../../../theme/app_colors.dart';
import '../../../../utils/constant.dart';

class PinSuccessScreen extends StatelessWidget {
  const PinSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              const Spacer(),
              Center(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 140,
                      height: 140,
                      child: Stack(
                        children: const [
                          Positioned(
                            top: 10,
                            left: 60,
                            child: _Dot(color: Color(0xFFF9A826), size: 8),
                          ),
                          Positioned(
                            top: 25,
                            right: 20,
                            child: _Dot(color: Color(0xFFE5B9B5), size: 10),
                          ),
                          Positioned(
                            bottom: 50,
                            right: 10,
                            child: _Dot(color: Color(0xFF29C3B6), size: 10),
                          ),
                          Positioned(
                            bottom: 10,
                            right: 40,
                            child: _Dot(color: Color(0xFFC7E2DF), size: 10),
                          ),
                          Positioned(
                            bottom: 15,
                            left: 40,
                            child: _Dot(color: Color(0xFFE2B0AE), size: 10),
                          ),
                          Positioned(
                            top: 70,
                            left: 10,
                            child: _Dot(color: Color(0xFF5ED0BA), size: 8),
                          ),
                          Positioned(
                            top: 40,
                            left: 25,
                            child: _Dot(color: Color(0xFFF9B966), size: 10),
                          ),
                          Positioned(
                            top: 20,
                            left: 40,
                            child: _Dot(color: Color(0xFF4AC4A1), size: 8),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 80,
                      height: 80,
                      decoration: const BoxDecoration(
                        color: AppColor.green,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 40,
                      ),
                    ),
                  ],
                ),
              ),
              verticalSpace(32),
              const H4('PIN Changed Successfully', color: AppColor.primaryText),
              const Spacer(),
              AnimatedButton(
                onTap: () {
                  Navigator.pop(context);
                },
                child: const CustomButton(
                  title: 'Back to Security',
                  color: AppColor.onboardingPrimary,
                  borderRadius: 28,
                ),
              ),
              verticalSpace(16),
            ],
          ),
        ),
      ),
    );
  }
}

class _Dot extends StatelessWidget {
  final Color color;
  final double size;

  const _Dot({required this.color, required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}
