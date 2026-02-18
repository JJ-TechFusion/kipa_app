import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kipa/core/shared/widgets/buttons/animated_button.dart';
import 'package:kipa/core/shared/widgets/buttons/roundedbutton.dart';
import 'package:kipa/core/shared/widgets/custom_text.dart';
import 'package:kipa/core/shared/widgets/custom_snackbar.dart';
import 'package:kipa/core/shared/widgets/dropdown.dart';
import 'package:kipa/core/shared/widgets/textfields/custom_field.dart';
import 'package:kipa/theme/app_colors.dart';
import 'package:kipa/utils/constant.dart';
import '../providers/payment_provider.dart';

class ShipLogisticsFormScreen extends ConsumerStatefulWidget {
  final String logisticsDeliveryId;
  final String paymentRequestId;

  const ShipLogisticsFormScreen({
    super.key,
    required this.logisticsDeliveryId,
    required this.paymentRequestId,
  });

  @override
  ConsumerState<ShipLogisticsFormScreen> createState() =>
      _ShipLogisticsFormScreenState();
}

class _ShipLogisticsFormScreenState
    extends ConsumerState<ShipLogisticsFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _trackingNumberController = TextEditingController();
  final _trackingUrlController = TextEditingController();
  final _carrierOtherNameController = TextEditingController();
  final _imagePicker = ImagePicker();

  String? _carrier;
  DateTime? _estimatedDeliveryAt;
  File? _receiptImage;
  String? _uploadedReceiptUrl;

  static const List<String> _carriers = [
    'gig_logistics',
    'kwik_delivery',
    'abc_transport',
    'peace_mass',
    'god_is_good',
    'dhl',
    'fedex',
    'other',
  ];

  static const Map<String, String> _carrierLabels = {
    'gig_logistics': 'GIG Logistics',
    'kwik_delivery': 'Kwik Delivery',
    'abc_transport': 'ABC Transport',
    'peace_mass': 'Peace Mass Transit',
    'god_is_good': 'God Is Good Motors',
    'dhl': 'DHL',
    'fedex': 'FedEx',
    'other': 'Other',
  };

  bool get _isOtherCarrier => _carrier == 'other';

  @override
  void dispose() {
    _trackingNumberController.dispose();
    _trackingUrlController.dispose();
    _carrierOtherNameController.dispose();
    super.dispose();
  }

  Future<void> _pickReceiptImage() async {
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const BodySmall('Choose from Gallery'),
              onTap: () => Navigator.pop(context, ImageSource.gallery),
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const BodySmall('Take a Photo'),
              onTap: () => Navigator.pop(context, ImageSource.camera),
            ),
          ],
        ),
      ),
    );

    if (source == null) return;

    final picked = await _imagePicker.pickImage(
      source: source,
      maxWidth: 1024,
      maxHeight: 1024,
      imageQuality: 85,
    );

    if (picked != null) {
      setState(() {
        _receiptImage = File(picked.path);
        _uploadedReceiptUrl = null;
      });
    }
  }

  Future<String?> _uploadReceiptIfNeeded() async {
    if (_uploadedReceiptUrl != null) {
      return _uploadedReceiptUrl;
    }

    if (_receiptImage == null) {
      return null;
    }

    final paymentNotifier = ref.read(paymentNotifierProvider.notifier);
    final bytes = await _receiptImage!.readAsBytes();
    final fileName = _receiptImage!.path.split('/').last;

    final url = await paymentNotifier.uploadShipmentReceipt(
      fileName: fileName,
      fileBytes: bytes,
    );

    if (url != null) {
      setState(() {
        _uploadedReceiptUrl = url;
      });
    }

    return url;
  }

  Future<void> _selectDeliveryDate() async {
    final now = DateTime.now();
    final date = await showDatePicker(
      context: context,
      initialDate: now.add(const Duration(days: 3)),
      firstDate: now,
      lastDate: now.add(const Duration(days: 30)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColor.primary,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: AppColor.primaryText,
            ),
          ),
          child: child!,
        );
      },
    );

    if (date != null && mounted) {
      final time = await showTimePicker(
        context: context,
        initialTime: const TimeOfDay(hour: 10, minute: 0),
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: const ColorScheme.light(
                primary: AppColor.primary,
                onPrimary: Colors.white,
                surface: Colors.white,
                onSurface: AppColor.primaryText,
              ),
            ),
            child: child!,
          );
        },
      );

      if (time != null) {
        setState(() {
          _estimatedDeliveryAt = DateTime(
            date.year,
            date.month,
            date.day,
            time.hour,
            time.minute,
          );
        });
      }
    }
  }

  void _submitShipment() async {
    if (!_formKey.currentState!.validate()) return;

    if (_carrier == null) {
      CustomSnackBar.show(
        context,
        message: 'Please select a carrier',
        type: SnackBarType.error,
      );
      return;
    }

    if (_isOtherCarrier && _carrierOtherNameController.text.trim().isEmpty) {
      CustomSnackBar.show(
        context,
        message: 'Please enter carrier name',
        type: SnackBarType.error,
      );
      return;
    }

    if (_receiptImage == null && _uploadedReceiptUrl == null) {
      CustomSnackBar.show(
        context,
        message: 'Please upload shipment receipt',
        type: SnackBarType.error,
      );
      return;
    }

    if (_estimatedDeliveryAt == null) {
      CustomSnackBar.show(
        context,
        message: 'Please select estimated delivery date',
        type: SnackBarType.error,
      );
      return;
    }

    // Upload receipt first if not already uploaded
    final receiptUrl = await _uploadReceiptIfNeeded();
    if (receiptUrl == null) {
      if (!mounted) return;
      final state = ref.read(paymentNotifierProvider);
      CustomSnackBar.show(
        context,
        message: state.errorMessage ?? 'Failed to upload receipt',
        type: SnackBarType.error,
      );
      return;
    }

    final paymentNotifier = ref.read(paymentNotifierProvider.notifier);

    final success = await paymentNotifier.shipLogisticsDelivery(
      logisticsDeliveryId: widget.logisticsDeliveryId,
      carrier: _carrier!,
      carrierOtherName: _isOtherCarrier ? _carrierOtherNameController.text.trim() : null,
      trackingNumber: _trackingNumberController.text.trim(),
      trackingUrl: _trackingUrlController.text.trim(),
      shipmentReceiptUrl: receiptUrl,
      estimatedDeliveryAt: _estimatedDeliveryAt!,
    );

    if (!mounted) return;

    if (success) {
      CustomSnackBar.show(
        context,
        message: 'Item marked as shipped successfully',
        type: SnackBarType.success,
      );
      Navigator.pop(context, true);
    } else {
      final state = ref.read(paymentNotifierProvider);
      CustomSnackBar.show(
        context,
        message: state.errorMessage ?? 'Failed to mark as shipped',
        type: SnackBarType.error,
      );
    }
  }

  String _formatDateTime(DateTime dt) {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    final hour = dt.hour > 12 ? dt.hour - 12 : (dt.hour == 0 ? 12 : dt.hour);
    final period = dt.hour >= 12 ? 'PM' : 'AM';
    final minute = dt.minute.toString().padLeft(2, '0');
    return '${dt.day} ${months[dt.month - 1]}, ${dt.year} at $hour:$minute $period';
  }

  @override
  Widget build(BuildContext context) {
    final paymentState = ref.watch(paymentNotifierProvider);
    final isLoading = paymentState.isShippingLogistics ||
        paymentState.isUploadingShipmentReceipt;

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
          'Ship Item',
          fontWeight: FontWeight.w600,
          fontSize: 18,
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const BodyText('Shipping Details', fontWeight: FontWeight.w600),
              verticalSpace(8),
              const Caption(
                'Enter the shipping information from your logistics provider',
                color: AppColor.lightText,
              ),
              verticalSpace(24),

              DropDownWidget(
                label: 'Carrier',
                hintText: 'Select logistics carrier',
                initialValue: _carriers.map((c) => _carrierLabels[c] ?? c).toList(),
                onSelect: (val) {
                  final selectedKey = _carrierLabels.entries
                      .firstWhere(
                        (e) => e.value == val,
                        orElse: () => MapEntry(val ?? '', val ?? ''),
                      )
                      .key;
                  setState(() => _carrier = selectedKey);
                },
                showSearch: false,
              ),
              verticalSpace(16),

              if (_isOtherCarrier) ...[
                TextInputField(
                  controller: _carrierOtherNameController,
                  hintText: 'Enter carrier name',
                  label: 'Carrier Name',
                  validator: (value) {
                    if (_isOtherCarrier && (value == null || value.isEmpty)) {
                      return 'Please enter carrier name';
                    }
                    return null;
                  },
                ),
                verticalSpace(16),
              ],

              TextInputField(
                controller: _trackingNumberController,
                hintText: 'e.g., GIG-123456789',
                label: 'Tracking Number',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter tracking number';
                  }
                  return null;
                },
              ),
              verticalSpace(16),

              TextInputField(
                controller: _trackingUrlController,
                hintText: 'e.g., https://giglogistics.com/track/...',
                label: 'Tracking URL',
                inputType: TextInputType.url,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter tracking URL';
                  }
                  if (!Uri.tryParse(value)!.hasAbsolutePath) {
                    return 'Please enter a valid URL';
                  }
                  return null;
                },
              ),
              verticalSpace(16),

              // Receipt Image Upload
              const BodySmall(
                'Shipment Receipt',
                fontWeight: FontWeight.w500,
              ),
              verticalSpace(8),
              GestureDetector(
                onTap: isLoading ? null : _pickReceiptImage,
                child: Container(
                  width: double.infinity,
                  height: _receiptImage != null ? 200 : 120,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: _receiptImage != null
                          ? Colors.green
                          : AppColor.kipaGrey.withAlpha(90),
                      width: _receiptImage != null ? 2 : 1,
                    ),
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.white,
                  ),
                  child: _receiptImage != null
                      ? Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.file(
                                _receiptImage!,
                                width: double.infinity,
                                height: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Positioned(
                              top: 8,
                              right: 8,
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _receiptImage = null;
                                    _uploadedReceiptUrl = null;
                                  });
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: const BoxDecoration(
                                    color: Colors.red,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.close,
                                    size: 16,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            if (_uploadedReceiptUrl != null)
                              Positioned(
                                bottom: 8,
                                left: 8,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.green,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: const Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.check,
                                        size: 12,
                                        color: Colors.white,
                                      ),
                                      SizedBox(width: 4),
                                      Text(
                                        'Uploaded',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 10,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                          ],
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.cloud_upload_outlined,
                              size: 40,
                              color: AppColor.kipaGrey,
                            ),
                            verticalSpace(8),
                            const BodySmall(
                              'Tap to upload receipt image',
                              color: AppColor.lightText,
                            ),
                            verticalSpace(4),
                            const Caption(
                              'JPG, PNG (max 1MB)',
                              color: AppColor.kipaGrey,
                            ),
                          ],
                        ),
                ),
              ),
              if (paymentState.isUploadingShipmentReceipt)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            AppColor.primary,
                          ),
                        ),
                      ),
                      horizontalSpace(8),
                      const Caption(
                        'Uploading receipt...',
                        color: AppColor.primary,
                      ),
                    ],
                  ),
                ),
              verticalSpace(16),

              const BodySmall(
                'Estimated Delivery Date',
                fontWeight: FontWeight.w500,
              ),
              verticalSpace(8),
              GestureDetector(
                onTap: _selectDeliveryDate,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColor.kipaGrey.withAlpha(90)),
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.white,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      BodySmall(
                        _estimatedDeliveryAt != null
                            ? _formatDateTime(_estimatedDeliveryAt!)
                            : 'Select date and time',
                        color: _estimatedDeliveryAt != null
                            ? AppColor.primaryText
                            : AppColor.lightText,
                      ),
                      const Icon(
                        Icons.calendar_today,
                        size: 20,
                        color: AppColor.kipaGrey,
                      ),
                    ],
                  ),
                ),
              ),

              verticalSpace(40),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 42),
                child: AnimatedButton(
                  onTap: isLoading ? null : _submitShipment,
                  child: isLoading
                      ? Container(
                          height: 50,
                          decoration: BoxDecoration(
                            color: AppColor.primary.withAlpha(150),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                ),
                                horizontalSpace(12),
                                Text(
                                  paymentState.isUploadingShipmentReceipt
                                      ? 'Uploading...'
                                      : 'Shipping...',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      : CustomButton(title: 'Mark as Shipped', borderRadius: 30),
                ),
              ),
              verticalSpace(20),
            ],
          ),
        ),
      ),
    );
  }
}
