import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kipa/core/routes/route_names.dart';
import 'package:kipa/core/shared/widgets/buttons/roundedbutton.dart';
import 'package:kipa/core/shared/widgets/custom_snackbar.dart'
    show CustomSnackBar, SnackBarType;
import 'package:kipa/core/shared/widgets/custom_text.dart';
import 'package:kipa/core/shared/widgets/textfields/custom_field.dart';
import 'package:kipa/feature/location/domain/entities/location_entity.dart';
import 'package:kipa/theme/app_colors.dart';
import 'package:kipa/utils/constant.dart';
import '../../domain/entities/errand_entity.dart';
import '../providers/errand_provider.dart';
import '../widgets/contact_input_card.dart';
import '../widgets/location_input_card.dart';

const String _googleMapsApiKey = 'AIzaSyDGctg74O3Vwa0IP_o2Eh2xwKe5CSuz-k0';

class CreateErrandScreen extends ConsumerStatefulWidget {
  const CreateErrandScreen({super.key});

  @override
  ConsumerState<CreateErrandScreen> createState() => _CreateErrandScreenState();
}

class _CreateErrandScreenState extends ConsumerState<CreateErrandScreen> {
  final _formKey = GlobalKey<FormState>();

  LocationEntity? _pickupLocation;
  final _pickupNameController = TextEditingController();
  final _pickupPhoneController = TextEditingController();

  LocationEntity? _dropoffLocation;
  final _dropoffNameController = TextEditingController();
  final _dropoffPhoneController = TextEditingController();

  final _packageDescriptionController = TextEditingController();
  final _notesController = TextEditingController();

  bool _showPickupContact = false;
  bool _showDropoffContact = false;
  bool _showPackageDetails = false;

  String _vehicleType = 'motorcycle'; // Default to motorcycle

  @override
  void dispose() {
    _pickupNameController.dispose();
    _pickupPhoneController.dispose();
    _dropoffNameController.dispose();
    _dropoffPhoneController.dispose();
    _packageDescriptionController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  bool get _isFormValid {
    return _pickupLocation != null && _dropoffLocation != null;
  }

  Future<void> _createErrand() async {
    if (!_isFormValid) {
      CustomSnackBar.show(
        context,
        message: 'Please fill in all required fields',
        type: SnackBarType.error,
      );
      return;
    }

    final params = CreateErrandParams(
      pickupAddress: _pickupLocation!.address,
      pickupLatitude: _pickupLocation!.latitude,
      pickupLongitude: _pickupLocation!.longitude,
      pickupContactName: _pickupNameController.text.trim().isEmpty
          ? null
          : _pickupNameController.text.trim(),
      pickupContactPhone: _pickupPhoneController.text.trim().isEmpty
          ? null
          : _pickupPhoneController.text.trim(),
      dropoffAddress: _dropoffLocation!.address,
      dropoffLatitude: _dropoffLocation!.latitude,
      dropoffLongitude: _dropoffLocation!.longitude,
      dropoffContactName: _dropoffNameController.text.trim().isEmpty
          ? null
          : _dropoffNameController.text.trim(),
      dropoffContactPhone: _dropoffPhoneController.text.trim().isEmpty
          ? null
          : _dropoffPhoneController.text.trim(),
      packageDescription: _packageDescriptionController.text.trim().isEmpty
          ? null
          : _packageDescriptionController.text.trim(),
      vehicleType: _vehicleType,
      notes: _notesController.text.trim().isEmpty
          ? null
          : _notesController.text.trim(),
    );

    final errand = await ref
        .read(errandNotifierProvider.notifier)
        .createErrand(params);

    if (errand != null && mounted) {
      Navigator.pushNamed(
        context,
        RouteNames.errandSummaryRoute,
        arguments: {'errand': errand},
      );
    }
  }

  Widget _buildOptionalToggle({
    required String label,
    required bool isVisible,
    required VoidCallback onToggle,
  }) {
    return GestureDetector(
      onTap: onToggle,
      child: Row(
        children: [
          Icon(
            isVisible ? Icons.remove_circle_outline : Icons.add_circle_outline,
            size: 16,
            color: AppColor.onboardingPrimary,
          ),
          horizontalSpace(6),
          BodySmall(
            isVisible ? 'Hide $label' : 'Add $label',
            color: AppColor.onboardingPrimary,
            fontWeight: FontWeight.w600,
          ),
        ],
      ),
    );
  }

  Widget _buildVehicleOption(
    String value,
    String title,
    IconData icon,
    String description,
  ) {
    final isSelected = _vehicleType == value;
    return GestureDetector(
      onTap: () => setState(() => _vehicleType = value),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColor.primary.withAlpha(25)
              : AppColor.scaffoldBackground,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColor.primary : Colors.transparent,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? AppColor.primary : AppColor.kipaGrey,
              size: 24,
            ),
            horizontalSpace(12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BodySmall(
                    title,
                    fontWeight: FontWeight.w600,
                    color: isSelected ? AppColor.primary : AppColor.darkPrimary,
                  ),
                  Caption(description, color: AppColor.lightText, fontSize: 11),
                ],
              ),
            ),
            if (isSelected)
              const Icon(Icons.check_circle, color: AppColor.primary, size: 20),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(errandNotifierProvider);

    ref.listen(errandNotifierProvider, (prev, next) {
      if (next.errorMessage != null &&
          prev?.errorMessage != next.errorMessage) {
        CustomSnackBar.show(
          context,
          message: next.errorMessage!,
          type: SnackBarType.error,
        );
        Future.microtask(() {
          ref.read(errandNotifierProvider.notifier).clearMessages();
        });
      }
    });

    return Scaffold(
      backgroundColor: AppColor.scaffoldBackground,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const BodyText(
          'Book a Rider',
          fontWeight: FontWeight.w600,
          color: AppColor.darkPrimary,
        ),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const BodyText(
                'Pickup Details',
                fontWeight: FontWeight.w600,
                color: AppColor.darkPrimary,
              ),
              verticalSpace(12),
              LocationInputCard(
                title: 'Pickup Location',
                icon: Icons.location_on,
                iconColor: Colors.green,
                googleApiKey: _googleMapsApiKey,
                addressHint: 'Enter pickup address',
                onAddressSelected: (location) {
                  setState(() => _pickupLocation = location);
                },
              ),
              verticalSpace(12),
              _buildOptionalToggle(
                label: 'Pickup Contact',
                isVisible: _showPickupContact,
                onToggle: () =>
                    setState(() => _showPickupContact = !_showPickupContact),
              ),
              AnimatedSize(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeInOut,
                child: _showPickupContact
                    ? Padding(
                        padding: const EdgeInsets.only(top: 12),
                        child: ContactInputCard(
                          title: 'Pickup Contact',
                          nameController: _pickupNameController,
                          phoneController: _pickupPhoneController,
                          nameHint: 'Who should the rider meet?',
                          phoneHint: '+234 xxx xxx xxxx',
                        ),
                      )
                    : const SizedBox.shrink(),
              ),

              verticalSpace(24),

              const BodyText(
                'Dropoff Details',
                fontWeight: FontWeight.w600,
                color: AppColor.darkPrimary,
              ),
              verticalSpace(12),
              LocationInputCard(
                title: 'Dropoff Location',
                icon: Icons.flag,
                iconColor: Colors.red,
                googleApiKey: _googleMapsApiKey,
                addressHint: 'Enter dropoff address',
                onAddressSelected: (location) {
                  setState(() => _dropoffLocation = location);
                },
              ),
              verticalSpace(12),
              _buildOptionalToggle(
                label: 'Dropoff Contact',
                isVisible: _showDropoffContact,
                onToggle: () =>
                    setState(() => _showDropoffContact = !_showDropoffContact),
              ),
              AnimatedSize(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeInOut,
                child: _showDropoffContact
                    ? Padding(
                        padding: const EdgeInsets.only(top: 12),
                        child: ContactInputCard(
                          title: 'Dropoff Contact',
                          nameController: _dropoffNameController,
                          phoneController: _dropoffPhoneController,
                          nameHint: 'Who should receive the package?',
                          phoneHint: '+234 xxx xxx xxxx',
                        ),
                      )
                    : const SizedBox.shrink(),
              ),

              verticalSpace(24),
              const BodyText(
                'Vehicle Type',
                fontWeight: FontWeight.w600,
                color: AppColor.darkPrimary,
              ),
              verticalSpace(12),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColor.kipaGrey.withAlpha(30)),
                ),
                child: Column(
                  children: [
                    _buildVehicleOption(
                      'motorcycle',
                      'Motorcycle',
                      Icons.motorcycle,
                      'Best for small packages',
                    ),
                    verticalSpace(12),
                    _buildVehicleOption(
                      'car',
                      'Car',
                      Icons.directions_car,
                      'Best for larger items',
                    ),
                  ],
                ),
              ),

              verticalSpace(24),

              _buildOptionalToggle(
                label: 'Package Details',
                isVisible: _showPackageDetails,
                onToggle: () =>
                    setState(() => _showPackageDetails = !_showPackageDetails),
              ),
              AnimatedSize(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeInOut,
                child: _showPackageDetails
                    ? Padding(
                        padding: const EdgeInsets.only(top: 12),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: AppColor.kipaGrey.withAlpha(30),
                            ),
                          ),
                          child: Column(
                            children: [
                              TextInputField(
                                label: 'Package Description',
                                hintText: 'What are you sending?',
                                controller: _packageDescriptionController,
                                maxLines: 2,
                              ),
                              verticalSpace(12),
                              TextInputField(
                                label: 'Pickup Instructions',
                                hintText:
                                    'Any special instructions for pickup?',
                                controller: _notesController,
                                maxLines: 2,
                              ),
                            ],
                          ),
                        ),
                      )
                    : const SizedBox.shrink(),
              ),

              verticalSpace(32),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 36.0),
                child: CustomButton(
                  title: 'Get Estimate',
                  onTap: state.isCreating ? null : _createErrand,
                  isLoading: state.isCreating,
                  borderRadius: 20,
                ),
              ),
              verticalSpace(24),
            ],
          ),
        ),
      ),
    );
  }
}
