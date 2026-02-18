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
import '../widgets/package_size_selector.dart';

const String _googleMapsApiKey = 'AIzaSyDGctg74O3Vwa0IP_o2Eh2xwKe5CSuz-k0';

class CreateErrandScreen extends ConsumerStatefulWidget {
  const CreateErrandScreen({super.key});

  @override
  ConsumerState<CreateErrandScreen> createState() => _CreateErrandScreenState();
}

class _CreateErrandScreenState extends ConsumerState<CreateErrandScreen> {
  final _formKey = GlobalKey<FormState>();

  // Pickup
  LocationEntity? _pickupLocation;
  final _pickupNameController = TextEditingController();
  final _pickupPhoneController = TextEditingController();

  // Dropoff
  LocationEntity? _dropoffLocation;
  final _dropoffNameController = TextEditingController();
  final _dropoffPhoneController = TextEditingController();

  // Package
  PackageSize _packageSize = PackageSize.small;
  final _packageDescriptionController = TextEditingController();
  final _notesController = TextEditingController();

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
    return _pickupLocation != null &&
        _pickupNameController.text.isNotEmpty &&
        _pickupPhoneController.text.isNotEmpty &&
        _dropoffLocation != null &&
        _dropoffNameController.text.isNotEmpty &&
        _dropoffPhoneController.text.isNotEmpty &&
        _packageDescriptionController.text.isNotEmpty;
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
      pickupContactName: _pickupNameController.text.trim(),
      pickupContactPhone: _pickupPhoneController.text.trim(),
      dropoffAddress: _dropoffLocation!.address,
      dropoffLatitude: _dropoffLocation!.latitude,
      dropoffLongitude: _dropoffLocation!.longitude,
      dropoffContactName: _dropoffNameController.text.trim(),
      dropoffContactPhone: _dropoffPhoneController.text.trim(),
      packageDescription: _packageDescriptionController.text.trim(),
      packageSize: _packageSize,
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
        // leading: IconButton(
        //   icon: const Icon(Icons.arrow_back, color: AppColor.darkPrimary),
        //   onPressed: () => Navigator.pop(context),
        // ),
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
              ContactInputCard(
                title: 'Pickup Contact',
                nameController: _pickupNameController,
                phoneController: _pickupPhoneController,
                nameHint: 'Who should the rider meet?',
                phoneHint: '+234 xxx xxx xxxx',
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
              ContactInputCard(
                title: 'Dropoff Contact',
                nameController: _dropoffNameController,
                phoneController: _dropoffPhoneController,
                nameHint: 'Who should receive the package?',
                phoneHint: '+234 xxx xxx xxxx',
              ),
              verticalSpace(24),
              const BodyText(
                'Package Details',
                fontWeight: FontWeight.w600,
                color: AppColor.darkPrimary,
              ),
              verticalSpace(12),
              PackageSizeSelector(
                selectedSize: _packageSize,
                onSizeSelected: (size) {
                  setState(() => _packageSize = size);
                },
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
                    TextInputField(
                      label: 'Package Description',
                      hintText: 'What are you sending?',
                      controller: _packageDescriptionController,
                      maxLines: 2,
                    ),
                    verticalSpace(12),
                    TextInputField(
                      label: 'Notes (Optional)',
                      hintText: 'Any special instructions?',
                      controller: _notesController,
                      maxLines: 2,
                    ),
                  ],
                ),
              ),
              verticalSpace(32),
              CustomButton(
                title: 'Get Estimate',
                onTap: state.isCreating ? null : _createErrand,
                isLoading: state.isCreating,
              ),
              verticalSpace(24),
            ],
          ),
        ),
      ),
    );
  }
}
