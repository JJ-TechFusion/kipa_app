import 'package:flutter/material.dart';
import 'package:kipa/core/shared/widgets/buttons/roundedbutton.dart';
import 'package:kipa/core/shared/widgets/custom_text.dart';
import 'package:kipa/core/shared/widgets/smart_image.dart';
import 'package:kipa/theme/app_colors.dart';
import 'package:kipa/utils/constant.dart';

class PromoBanner extends StatelessWidget {
  final VoidCallback onBookRiderTap;

  const PromoBanner({super.key, required this.onBookRiderTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 150,
      decoration: BoxDecoration(
        color: AppColor.primary,
        borderRadius: BorderRadius.circular(20),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            Positioned(
              right: 5,
              bottom: 0,

              width: MediaQuery.of(context).size.width * 0.4,
              child: SmartImage(
                imageUrl: 'assets/images/delivery.png',
                fit: BoxFit.contain,
                backgroundColor: Colors.transparent,
                placeholder: const Icon(
                  Icons.delivery_dining,
                  size: 60,
                  color: Colors.white24,
                ),
                errorWidget: const Icon(
                  Icons.delivery_dining,
                  size: 60,
                  color: Colors.white24,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.45,
                    child: const BodyText(
                      'Request riders for deliveries, pickups, and more',
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      maxLines: 3,
                    ),
                  ),
                  verticalSpace(16),
                  SizedBox(
                    width: 120,
                    child: CustomButton(
                      title: 'Book a rider',
                      onTap: onBookRiderTap,
                      color: Colors.white,
                      textColor: AppColor.primaryText,
                      size: 13,
                      borderRadius: 20,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
