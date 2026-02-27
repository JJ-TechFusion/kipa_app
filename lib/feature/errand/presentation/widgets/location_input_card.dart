import 'package:flutter/material.dart';
import 'package:kipa/core/shared/widgets/address_autocomplete_field.dart';
import 'package:kipa/core/shared/widgets/custom_text.dart';
import 'package:kipa/feature/location/domain/entities/location_entity.dart';
import 'package:kipa/theme/app_colors.dart';
import 'package:kipa/utils/constant.dart';

class LocationInputCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color iconColor;
  final String googleApiKey;
  final String addressHint;
  final String? initialAddress;
  final ValueChanged<LocationEntity> onAddressSelected;

  const LocationInputCard({
    super.key,
    required this.title,
    required this.icon,
    required this.iconColor,
    required this.googleApiKey,
    required this.addressHint,
    required this.onAddressSelected,
    this.initialAddress,
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
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: iconColor.withAlpha(25),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: iconColor, size: 16),
              ),
              horizontalSpace(12),
              BodySmall(
                title,
                fontWeight: FontWeight.w600,
                color: AppColor.darkPrimary,
              ),
            ],
          ),
          verticalSpace(16),
          AddressAutocompleteField(
            label: 'Address',
            hintText: addressHint,
            googleApiKey: googleApiKey,
            initialValue: initialAddress,
            onPlaceSelected: onAddressSelected,
          ),
        ],
      ),
    );
  }
}
