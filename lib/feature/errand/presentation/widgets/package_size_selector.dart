import 'package:flutter/material.dart';
import 'package:kipa/core/shared/widgets/custom_text.dart';
import 'package:kipa/theme/app_colors.dart';
import 'package:kipa/utils/constant.dart';
import '../../domain/entities/errand_entity.dart';

class PackageSizeSelector extends StatelessWidget {
  final PackageSize selectedSize;
  final ValueChanged<PackageSize> onSizeSelected;

  const PackageSizeSelector({
    super.key,
    required this.selectedSize,
    required this.onSizeSelected,
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
                  color: Colors.orange.withAlpha(25),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.inventory_2_outlined,
                  color: Colors.orange,
                  size: 20,
                ),
              ),
              horizontalSpace(12),
              const BodyText(
                'Package Size',
                fontWeight: FontWeight.w600,
                color: AppColor.darkPrimary,
              ),
            ],
          ),
          verticalSpace(16),
          Row(
            children: PackageSize.values.map((size) {
              final isSelected = size == selectedSize;
              return Expanded(
                child: GestureDetector(
                  onTap: () => onSizeSelected(size),
                  child: Container(
                    margin: EdgeInsets.only(
                      right: size != PackageSize.large ? 8 : 0,
                    ),
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 8,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColor.primary.withAlpha(25)
                          : AppColor.scaffoldBackground,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color:
                            isSelected ? AppColor.primary : Colors.transparent,
                        width: 1.5,
                      ),
                    ),
                    child: Column(
                      children: [
                        Icon(
                          _getIcon(size),
                          color: isSelected ? AppColor.primary : AppColor.kipaGrey,
                          size: 24,
                        ),
                        verticalSpace(4),
                        BodySmall(
                          size.displayName,
                          fontWeight:
                              isSelected ? FontWeight.w600 : FontWeight.w400,
                          color: isSelected
                              ? AppColor.primary
                              : AppColor.darkPrimary,
                        ),
                        verticalSpace(2),
                        Caption(
                          size.description,
                          textAlign: TextAlign.center,
                          color: AppColor.lightText,
                          fontSize: 10,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  IconData _getIcon(PackageSize size) {
    switch (size) {
      case PackageSize.small:
        return Icons.mail_outline;
      case PackageSize.medium:
        return Icons.inventory_2_outlined;
      case PackageSize.large:
        return Icons.local_shipping_outlined;
    }
  }
}
