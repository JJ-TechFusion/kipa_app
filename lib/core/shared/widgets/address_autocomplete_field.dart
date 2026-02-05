import 'package:flutter/material.dart';
import 'package:google_places_autocomplete_text_field/google_places_autocomplete_text_field.dart';
import 'package:kipa/feature/location/domain/entities/location_entity.dart';
import 'package:kipa/theme/app_colors.dart';
import 'package:kipa/core/shared/widgets/custom_text.dart';
import 'package:kipa/utils/constant.dart';

class AddressAutocompleteField extends StatefulWidget {
  final String label;
  final String hintText;
  final String googleApiKey;
  final ValueChanged<LocationEntity> onPlaceSelected;
  final String? initialValue;

  const AddressAutocompleteField({
    super.key,
    required this.label,
    required this.hintText,
    required this.googleApiKey,
    required this.onPlaceSelected,
    this.initialValue,
  });

  @override
  State<AddressAutocompleteField> createState() =>
      _AddressAutocompleteFieldState();
}

class _AddressAutocompleteFieldState extends State<AddressAutocompleteField> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BodySmall(
          widget.label,
          color: AppColor.darkPrimary,
          fontWeight: FontWeight.w500,
        ),
        verticalSpace(8),
        GooglePlacesAutoCompleteTextFormField(
          textEditingController: _controller,
          config: GoogleApiConfig(
            apiKey: widget.googleApiKey,
            countries: const ['ng'],
            debounceTime: 400,
            fetchPlaceDetailsWithCoordinates: true,
          ),
          onSuggestionClicked: (prediction) {
            _controller.text = prediction.description ?? '';
            _controller.selection = TextSelection.fromPosition(
              TextPosition(offset: _controller.text.length),
            );
          },
          onPredictionWithCoordinatesReceived: (prediction) {
            _handlePlaceSelected(prediction);
          },
          decoration: InputDecoration(
            hintText: widget.hintText,
            hintStyle: const TextStyle(color: AppColor.lightText, fontSize: 14),
            filled: true,
            fillColor: AppColor.scaffoldBackground,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColor.kipaGrey.withAlpha(50)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColor.kipaGrey.withAlpha(50)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColor.primary),
            ),
            suffixIcon: const Icon(
              Icons.location_on_outlined,
              color: AppColor.kipaGrey,
            ),
          ),
        ),
      ],
    );
  }

  void _handlePlaceSelected(Prediction prediction) {
    final lat = double.tryParse(prediction.lat ?? '');
    final lng = double.tryParse(prediction.lng ?? '');

    if (lat != null && lng != null) {
      final location = LocationEntity(
        latitude: lat,
        longitude: lng,
        address: prediction.description ?? '',
        placeId: prediction.placeId,
      );
      widget.onPlaceSelected(location);
      logMessage('AddressAutocompleteField', 'Selected: $location');
    }
  }
}
