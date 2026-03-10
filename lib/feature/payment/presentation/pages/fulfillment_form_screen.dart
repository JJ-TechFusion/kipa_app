import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kipa/core/shared/widgets/buttons/animated_button.dart';
import 'package:kipa/core/shared/widgets/buttons/roundedbutton.dart';
import 'package:kipa/core/shared/widgets/custom_text.dart';
import 'package:kipa/core/shared/widgets/custom_snackbar.dart';
import 'package:kipa/core/shared/widgets/dropdown.dart';
import 'package:kipa/core/shared/widgets/address_autocomplete_field.dart';
import 'package:kipa/core/routes/route_names.dart';
import 'package:kipa/theme/app_colors.dart';
import 'package:kipa/utils/constant.dart';
import '../providers/payment_provider.dart';

const String _googleMapsApiKey = 'AIzaSyDGctg74O3Vwa0IP_o2Eh2xwKe5CSuz-k0';

class FulfillmentFormScreen extends ConsumerStatefulWidget {
  final String paymentRequestId;

  const FulfillmentFormScreen({super.key, required this.paymentRequestId});

  @override
  ConsumerState<FulfillmentFormScreen> createState() =>
      _FulfillmentFormScreenState();
}

class _FulfillmentFormScreenState extends ConsumerState<FulfillmentFormScreen> {
  String? _deliveryType;
  String? _vehicleType;
  String? _pickupState;
  String? _dropoffState;
  bool _pickupSelected = false;
  bool _dropoffSelected = false;

  static const List<String> _nigerianStates = [
    'Abia',
    'Adamawa',
    'Akwa Ibom',
    'Anambra',
    'Bauchi',
    'Bayelsa',
    'Benue',
    'Borno',
    'Cross River',
    'Delta',
    'Ebonyi',
    'Edo',
    'Ekiti',
    'Enugu',
    'FCT',
    'Gombe',
    'Imo',
    'Jigawa',
    'Kaduna',
    'Kano',
    'Katsina',
    'Kebbi',
    'Kogi',
    'Kwara',
    'Lagos',
    'Nasarawa',
    'Niger',
    'Ogun',
    'Ondo',
    'Osun',
    'Oyo',
    'Plateau',
    'Rivers',
    'Sokoto',
    'Taraba',
    'Yobe',
    'Zamfara',
  ];

  bool get _isInterState => _deliveryType == 'inter_state';

  void _submitRequest() async {
    final paymentNotifier = ref.read(paymentNotifierProvider.notifier);

    if (_deliveryType == null || _vehicleType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select delivery and vehicle type'),
        ),
      );
      return;
    }

    if (!_isInterState && (!_pickupSelected || !_dropoffSelected)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select pickup and dropoff addresses'),
        ),
      );
      return;
    }

    if (_isInterState && (_pickupState == null || _dropoffState == null)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please select pickup and dropoff states for interstate delivery',
          ),
        ),
      );
      return;
    }

    await paymentNotifier.createFulfillment(
      paymentRequestId: widget.paymentRequestId,
      deliveryType: _deliveryType!,
      vehicleType: _vehicleType!,
      pickupState: _isInterState ? _pickupState : null,
      dropoffState: _isInterState ? _dropoffState : null,
    );

    final updatedState = ref.read(paymentNotifierProvider);
    if (updatedState.fulfillmentResponse != null) {
      if (!mounted) return;
      Navigator.pushNamed(context, RouteNames.fulfillmentSuccessRoute);
    } else if (updatedState.errorMessage != null) {
      if (!mounted) return;
      CustomSnackBar.show(
        context,
        message: updatedState.errorMessage!,
        type: SnackBarType.error,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final paymentState = ref.watch(paymentNotifierProvider);
    final paymentNotifier = ref.read(paymentNotifierProvider.notifier);

    return Scaffold(
      backgroundColor: AppColor.scaffoldBackground,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: AppColor.primary,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
          ),
        ),
        title: const BodyText(
          'Request Fulfillment',
          fontWeight: FontWeight.w600,
          fontSize: 18,
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const BodyText('Delivery Details', fontWeight: FontWeight.w600),
            verticalSpace(24),

            DropDownWidget(
              label: 'Delivery Type',
              hintText: 'Select type',
              initialValue: const ['Intra-state', 'Inter-state'],
              onSelect: (val) {
                setState(
                  () => _deliveryType = val == 'Intra-state'
                      ? 'intra_state'
                      : 'inter_state',
                );
              },
              showSearch: false,
            ),
            verticalSpace(16),

            if (!_isInterState) ...[
              AddressAutocompleteField(
                label: 'Pickup Address',
                hintText: 'Enter pickup address',
                googleApiKey: _googleMapsApiKey,
                onPlaceSelected: (location) {
                  paymentNotifier.setPickupLocation(location);
                  setState(() => _pickupSelected = true);
                },
              ),
              if (_pickupSelected && paymentState.pickupLocation != null)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: BodySmall(
                    '✓ Location selected: ${paymentState.pickupLocation!.latitude.toStringAsFixed(4)}, ${paymentState.pickupLocation!.longitude.toStringAsFixed(4)}',
                    color: Colors.green,
                  ),
                ),
              verticalSpace(16),
            ],

            if (_isInterState) ...[
              DropDownWidget(
                label: 'Pickup State',
                hintText: 'Select pickup state',
                initialValue: _nigerianStates,
                onSelect: (val) {
                  setState(() => _pickupState = val);
                },
                showSearch: true,
              ),
              verticalSpace(16),
            ],

            if (!_isInterState) ...[
              AddressAutocompleteField(
                label: 'Dropoff Address',
                hintText: 'Enter dropoff address',
                googleApiKey: _googleMapsApiKey,
                onPlaceSelected: (location) {
                  paymentNotifier.setDropoffLocation(location);
                  setState(() => _dropoffSelected = true);
                },
              ),
              if (_dropoffSelected && paymentState.dropoffLocation != null)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: BodySmall(
                    '✓ Location selected: ${paymentState.dropoffLocation!.latitude.toStringAsFixed(4)}, ${paymentState.dropoffLocation!.longitude.toStringAsFixed(4)}',
                    color: Colors.green,
                  ),
                ),
              verticalSpace(16),
            ],

            if (_isInterState) ...[
              DropDownWidget(
                label: 'Dropoff State',
                hintText: 'Select dropoff state',
                initialValue: _nigerianStates,
                onSelect: (val) {
                  setState(() => _dropoffState = val);
                },
                showSearch: true,
              ),
              verticalSpace(16),
            ],

            DropDownWidget(
              label: 'Vehicle Type',
              hintText: 'Select vehicle',
              initialValue: const ['Motorcycle', 'Car'],
              onSelect: (val) {
                if (val != null) {
                  setState(() => _vehicleType = val.toString().toLowerCase());
                }
              },
              showSearch: false,
            ),

            verticalSpace(40),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 42),
              child: AnimatedButton(
                onTap: paymentState.isCreatingFulfillment
                    ? null
                    : _submitRequest,
                child: paymentState.isCreatingFulfillment
                    ? Container(
                        height: 50,
                        decoration: BoxDecoration(
                          color: AppColor.primary.withAlpha(150),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: const Center(
                          child: SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          ),
                        ),
                      )
                    : CustomButton(title: 'Submit Request', borderRadius: 30),
              ),
            ),
            verticalSpace(20),
          ],
        ),
      ),
    );
  }
}
