import 'package:flutter/material.dart';
import 'package:kipa/core/shared/widgets/custom_text.dart';
import 'package:kipa/core/shared/widgets/textfields/custom_field.dart';
import 'package:kipa/theme/app_colors.dart';
import 'package:kipa/utils/constant.dart';

class ContactInputCard extends StatelessWidget {
  final String title;
  final TextEditingController nameController;
  final TextEditingController phoneController;
  final String nameHint;
  final String phoneHint;

  const ContactInputCard({
    super.key,
    required this.title,
    required this.nameController,
    required this.phoneController,
    this.nameHint = 'Contact name',
    this.phoneHint = 'Phone number',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColor.kipaGrey.withAlpha(30)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColor.primary.withAlpha(25),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.person_outline,
                  color: AppColor.primary,
                  size: 20,
                ),
              ),
              horizontalSpace(12),
              BodyText(
                title,
                fontWeight: FontWeight.w600,
                color: AppColor.darkPrimary,
              ),
            ],
          ),
          verticalSpace(16),
          TextInputField(
            label: 'Name',
            hintText: nameHint,
            controller: nameController,
            inputType: TextInputType.name,
            inputAction: TextInputAction.next,
          ),
          verticalSpace(12),
          TextInputField(
            label: 'Phone',
            hintText: phoneHint,
            controller: phoneController,
            inputType: TextInputType.phone,
            inputAction: TextInputAction.done,
          ),
        ],
      ),
    );
  }
}
