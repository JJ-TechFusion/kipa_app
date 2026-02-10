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
  final IconData? chatIcon;
  final VoidCallback? onChat;
  final String? imageUrl;

  const BuyerInfoCard({
    super.key,
    required this.name,
    required this.email,
    required this.phone,
    required this.onCall,
    this.title = 'Buyer Information',
    this.roleLabel = 'Buyer',
    this.chatIcon,
    this.onChat,
    this.imageUrl,
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
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (imageUrl != null && imageUrl!.isNotEmpty)
                    ClipOval(
                      child: SizedBox(
                        width: 40,
                        height: 40,
                        child: Image.network(
                          imageUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              width: 40,
                              height: 40,
                              decoration: const BoxDecoration(
                                color: Color(0xFFC62828), // Dark Red for avatar
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Text(
                                  name.isNotEmpty
                                      ? name
                                            .substring(
                                              0,
                                              name.length >= 2 ? 2 : 1,
                                            )
                                            .toUpperCase()
                                      : '?',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    )
                  else
                    Container(
                      width: 40,
                      height: 40,
                      decoration: const BoxDecoration(
                        color: Color(0xFFC62828), // Dark Red for avatar
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          name.isNotEmpty
                              ? name
                                    .substring(0, name.length >= 2 ? 2 : 1)
                                    .toUpperCase()
                              : '?',
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
                  Row(
                    children: [
                      if (chatIcon != null) ...[
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: AppColor.cardBackground2,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: GestureDetector(
                            onTap: onChat,
                            child: Icon(
                              chatIcon,
                              size: 14,
                              color: AppColor.primaryText,
                            ),
                          ),
                        ),
                        horizontalSpace(8),
                      ],
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
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              verticalSpace(16),
              _buildInfoRow('Phone Number', phone),
              if (email.isNotEmpty) ...[
                verticalSpace(12),
                _buildInfoRow('Email', email),
              ],
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
        Caption(value.isNotEmpty ? value : 'N/A', color: AppColor.lightText),
      ],
    );
  }
}
