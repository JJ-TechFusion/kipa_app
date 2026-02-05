import 'package:flutter/material.dart';
import 'package:kipa/core/shared/widgets/custom_text.dart';
import 'package:kipa/theme/app_colors.dart';
import 'package:kipa/utils/constant.dart';

class BuyerInfoCard extends StatelessWidget {
  final String name;
  final String email;
  final String phone;
  final VoidCallback onCall;
  final String? title;
  final String? roleLabel;

  const BuyerInfoCard({
    super.key,
    required this.name,
    required this.email,
    required this.phone,
    required this.onCall,
    this.title = 'Buyer Information',
    this.roleLabel = 'Buyer',
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null) ...[
          BodyText(title!, fontWeight: FontWeight.w600, fontSize: 14),
          verticalSpace(16),
        ],
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(color: AppColor.kipaGrey.withAlpha(50)),
            borderRadius: BorderRadius.circular(16),
            color: Colors.white,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: const BoxDecoration(
                      color: Color(0xFFC62828), // Dark Red for avatar
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        name.substring(0, 2).toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  horizontalSpace(12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        BodySmall(name, fontWeight: FontWeight.w600),
                        verticalSpace(2),
                        Caption(
                          roleLabel ?? 'Buyer',
                          color: AppColor.lightText,
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: onCall,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: AppColor.cardBackground2,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.call,
                            size: 14,
                            color: AppColor.primaryText,
                          ),
                          horizontalSpace(8),
                          const Caption(
                            'Call',
                            fontWeight: FontWeight.w600,
                            color: AppColor.primaryText,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              verticalSpace(16),
              _buildInfoRow('Phone Number', phone),
              verticalSpace(12),
              _buildInfoRow('Email', email),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 4,
      children: [
        Caption(
          label,
          color: AppColor.primaryText,
          fontWeight: FontWeight.w600,
        ),
        Caption(value, color: AppColor.lightText),
      ],
    );
  }
}
