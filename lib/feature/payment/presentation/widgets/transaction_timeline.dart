import 'package:flutter/material.dart';
import 'package:kipa/core/shared/widgets/custom_text.dart';
import 'package:kipa/theme/app_colors.dart';
import 'package:kipa/utils/constant.dart';

class TransactionTimeline extends StatelessWidget {
  final List<TimelineStep> steps;

  const TransactionTimeline({super.key, required this.steps});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const BodyText(
          'Transaction Timeline',
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
        verticalSpace(16),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: steps.length,
          itemBuilder: (context, index) {
            return _buildStep(steps[index], index == steps.length - 1);
          },
        ),
      ],
    );
  }

  Widget _buildStep(TimelineStep step, bool isLast) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              _buildIcon(step),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    color: AppColor.kipaGrey.withAlpha(50),
                    margin: const EdgeInsets.symmetric(vertical: 4),
                  ),
                ),
            ],
          ),
          horizontalSpace(12),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BodySmall(step.title, fontWeight: FontWeight.w500),
                  if (step.subtitle != null) ...[
                    verticalSpace(2),
                    Overline(step.subtitle!, color: AppColor.lightText),
                  ],
                  if (step.extraWidget != null) ...[
                    verticalSpace(8),
                    step.extraWidget!,
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIcon(TimelineStep step) {
    if (step.isCompleted || step.isActive) {
      return Container(
        width: 22,
        height: 22,
        decoration: const BoxDecoration(
          color: AppColor.primary,
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.check, size: 14, color: Colors.white),
      );
    } else {
      // Pending/Future state
      return Container(
        width: 22,
        height: 22,
        decoration: BoxDecoration(
          color: AppColor.kipaGrey.withAlpha(50),
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.access_time,
          size: 14,
          color: AppColor.lightText,
        ),
      );
    }
  }
}

class TimelineStep {
  final String title;
  final String? subtitle;
  final bool isCompleted;
  final bool isActive;
  final Widget? extraWidget;

  TimelineStep({
    required this.title,
    this.subtitle,
    this.isCompleted = false,
    this.isActive = false,
    this.extraWidget,
  });
}
