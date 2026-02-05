import 'package:flutter/material.dart';
import '../../domain/entities/entities.dart';
import '../../../../utils/constant.dart';
import '../../../../core/shared/widgets/custom_text.dart';
import '../../../../core/shared/responsive_helper.dart';
import '../../../../theme/app_colors.dart';

class OnboardingPageWidget extends StatelessWidget {
  final OnboardingPageEntity page;

  const OnboardingPageWidget({super.key, required this.page});

  @override
  Widget build(BuildContext context) {
    final isLandscape = ResponsiveHelper.isLandscape(context);
    final screenHeight = MediaQuery.of(context).size.height;

    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: SizedBox(
            height: screenHeight,
            child: Padding(
              padding: EdgeInsets.only(
                left: 32.0,
                right: 32.0,
                top: isLandscape ? 16.0 : 24.0,
                bottom: isLandscape ? 16.0 : screenHeight * 0.20,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    constraints: BoxConstraints(
                      maxWidth: isLandscape ? 200 : 300,
                      maxHeight: isLandscape ? 200 : 300,
                    ),
                    child: Image.asset(
                      page.imageAsset,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: isLandscape ? 200 : 300,
                          height: isLandscape ? 200 : 300,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.5),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Icon(
                            Icons.image,
                            size: 80,
                            color: Colors.grey.shade400,
                          ),
                        );
                      },
                    ),
                  ),
                  verticalSpace(isLandscape ? 20 : 32),

                  H3(
                    page.title,
                    color: AppColor.onboardingTitleText,
                    textAlign: TextAlign.center,
                  ),
                  verticalSpace(16),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: BodyText(
                      page.description,
                      color: AppColor.onboardingDescriptionText,
                      textAlign: TextAlign.center,
                      fontSize: TextSizes.bodyMedium,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
