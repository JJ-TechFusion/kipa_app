import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';

class StepIndicator extends StatelessWidget {
  final int currentStep;
  final int totalSteps;

  const StepIndicator({
    super.key,
    required this.currentStep,
    required this.totalSteps,
  });

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 120),
      child: Row(
        children: List.generate(
          totalSteps,
          (index) => Expanded(
            child: Container(
              margin: EdgeInsets.only(right: index < totalSteps - 1 ? 8 : 0),
              height: 4,
              decoration: BoxDecoration(
                color: index < currentStep
                    ? AppColor.primary
                    : AppColor.neutral,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
