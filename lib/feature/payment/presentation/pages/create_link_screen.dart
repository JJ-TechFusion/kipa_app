import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kipa/core/shared/widgets/buttons/animated_button.dart';
import 'package:kipa/core/shared/widgets/buttons/roundedbutton.dart';
import 'package:kipa/core/shared/widgets/custom_text.dart';
import 'package:kipa/core/shared/widgets/dropdown.dart';
import 'package:kipa/core/shared/widgets/image_picker_widget.dart';
import 'package:kipa/core/shared/widgets/textfields/custom_field.dart';
import 'package:kipa/core/routes/route_names.dart';
import 'package:kipa/feature/payment/presentation/providers/payment_provider.dart';
import 'package:kipa/feature/payment/presentation/widgets/verify_transaction_modal.dart';
import 'package:kipa/theme/app_colors.dart';
import 'package:kipa/utils/constant.dart';

class CreateLinkActionScreen extends ConsumerStatefulWidget {
  final bool isEdit;
  final Map<String, dynamic>? paymentRequest;

  const CreateLinkActionScreen({
    super.key,
    this.isEdit = false,
    this.paymentRequest,
  });

  @override
  ConsumerState<CreateLinkActionScreen> createState() =>
      _CreateLinkActionScreenState();
}

class _CreateLinkActionScreenState
    extends ConsumerState<CreateLinkActionScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  String? _processingTime;
  String _linkExpiry = 'reusable';
  File? _selectedImage;
  Future<String?>? _imageUploadFuture;
  String? _uploadedImageUrl;

  @override
  void initState() {
    super.initState();
    if (widget.isEdit && widget.paymentRequest != null) {
      _populateFields();
    }
  }

  static const Map<String, int> _processingTimeMap = {
    '24 hours': 24,
    '48 hours': 48,
    '3 days': 72,
    '1 week': 168,
  };

  void _populateFields() {
    final data = widget.paymentRequest!;
    _nameController.text = data['itemName'] ?? '';
    _descController.text = data['itemDescription'] ?? '';
    _priceController.text = (data['amount'] ?? '0').toString().replaceAll(
      ',',
      '',
    );

    final processingHours = data['processingTimeHours'] as int? ?? 24;
    _processingTime = _processingTimeMap.entries
        .firstWhere(
          (e) => e.value == processingHours,
          orElse: () => _processingTimeMap.entries.first,
        )
        .key;

    final isReusable = data['isReusable'] as bool? ?? true;
    _linkExpiry = isReusable ? 'reusable' : 'one_time';
  }

  void _onImageSelected(File? file) {
    if (file == null) return;
    setState(() {
      _selectedImage = file;
      _uploadedImageUrl = null;
    });
    // Start uploading immediately in the background
    _imageUploadFuture = _uploadImage(file);
  }

  Future<String?> _uploadImage(File file) async {
    final bytes = await file.readAsBytes();
    final fileName = file.path.split('/').last;
    final url = await ref
        .read(paymentNotifierProvider.notifier)
        .uploadItemImage(fileName: fileName, fileBytes: bytes);
    if (mounted) {
      setState(() => _uploadedImageUrl = url);
    }
    return url;
  }

  @override
  Widget build(BuildContext context) {
    final paymentState = ref.watch(paymentNotifierProvider);

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
        title: BodyText(
          widget.isEdit ? 'Edit Link Details' : 'Create payment link',
          fontWeight: FontWeight.w600,
          fontSize: 18,
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (!widget.isEdit) ...[_buildInfoBox(), verticalSpace(24)],

                Center(
                  child: Stack(
                    children: [
                      ImagePickerWidget(
                        size: 80,
                        onImageSelected: _onImageSelected,
                      ),
                      if (paymentState.isUploadingItemImage)
                        Positioned.fill(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.black.withAlpha(100),
                              shape: BoxShape.circle,
                            ),
                            child: const Center(
                              child: SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                verticalSpace(8),
                const Center(
                  child: Caption(
                    'Add Item Image',
                    color: AppColor.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                verticalSpace(24),

                TextInputField(
                  label: 'Item Name',
                  hintText: 'e.g., iPhone 15 Pro Max',
                  controller: _nameController,
                ),
                verticalSpace(16),
                TextInputField(
                  label: 'Item Description',
                  hintText: 'e.g., 256GB Natural Titanium',
                  controller: _descController,
                  helperText:
                      'Provide a detailed description to help resolve disputes',
                ),

                verticalSpace(16),
                TextInputField(
                  label: 'Item Price (₦)',
                  hintText: '0.0',
                  controller: _priceController,
                  inputType: TextInputType.number,
                  helperText: 'Include all applicable taxes and fees',
                ),

                verticalSpace(16),
                DropDownWidget(
                  label: 'Processing Time',
                  hintText: _processingTime ?? 'Select time-frame',
                  initialValue: const [
                    '24 hours',
                    '48 hours',
                    '3 days',
                    '1 week',
                  ],
                  onSelect: (val) {
                    setState(() => _processingTime = val);
                  },
                  showSearch: false,
                ),
                verticalSpace(4),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: const Caption(
                    'How long you need to prepare the item before handing over for delivery',
                    fontSize: 10,
                  ),
                ),

                verticalSpace(16),
                const BodySmall(
                  'Link Expiry',
                  color: AppColor.darkPrimary,
                  fontWeight: FontWeight.w500,
                ),
                verticalSpace(12),
                _buildExpiryOption(
                  value: 'reusable',
                  title: 'Reusable link',
                  subtitle: 'Useable until deleted',
                ),
                verticalSpace(12),
                _buildExpiryOption(
                  value: 'one_time',
                  title: 'After Payment',
                  subtitle: 'Link expires after one use',
                ),

                verticalSpace(30),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: AnimatedButton(
                    onTap: _handleGenerateLink,
                    child: CustomButton(
                      title: widget.isEdit
                          ? 'Save Changes'
                          : 'Generate Payment Link',
                      borderRadius: 30,
                    ),
                  ),
                ),
                verticalSpace(20),
              ],
            ),
          ),

          if (paymentState.isCreatingPaymentRequest ||
              paymentState.isUploadingItemImage)
            Container(
              color: Colors.black.withValues(alpha: 0.5),
              child: const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(AppColor.primary),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildInfoBox() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColor.infoBoxBackground,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.info_outline,
                size: 18,
                color: AppColor.kipaGrey2,
              ),
              horizontalSpace(8),
              const BodyText(
                'Important Information',
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ],
          ),
          verticalSpace(8),
          _buildInfoBullet('Funds are held until delivery is verified'),
          _buildInfoBullet(
            'Only platform riders or supported logistics allowed',
          ),
          _buildInfoBullet('Keep evidence (photos, chats, receipts)'),
          _buildInfoBullet('Dispute windows apply after delivery'),
          _buildInfoBullet(
            'Interstate deliveries insured only by logistics partners',
          ),
        ],
      ),
    );
  }

  Widget _buildInfoBullet(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4, left: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• ', style: TextStyle(color: AppColor.kipaGrey2)),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(color: AppColor.kipaGrey2, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleGenerateLink() async {
    if (_nameController.text.isEmpty) {
      _showError('Please enter item name');
      return;
    }
    if (_descController.text.isEmpty) {
      _showError('Please enter item description');
      return;
    }
    if (_priceController.text.isEmpty) {
      _showError('Please enter item price');
      return;
    }
    if (_processingTime == null) {
      _showError('Please select processing time');
      return;
    }

    // If image was selected, wait for its background upload to finish
    List<String> itemImageUrls = [];
    if (_selectedImage != null) {
      // Await the in-flight upload if it hasn't completed yet
      final url = _uploadedImageUrl ?? await _imageUploadFuture;
      if (url != null) {
        itemImageUrls = [url];
      } else if (mounted) {
        final errorMessage =
            ref.read(paymentNotifierProvider).errorMessage ??
            'Failed to upload image';
        _showError(errorMessage);
        return;
      }
    }

    if (!mounted) return;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => VerifyTransactionModal(
        onGenerate: (selectedExpiry) =>
            _createPaymentRequest(selectedExpiry, itemImageUrls),
        itemName: _nameController.text,
        itemDescription: _descController.text,
        itemPrice: double.tryParse(_priceController.text) ?? 0.0,
        linkExpiry: _linkExpiry,
      ),
    );
  }

  Future<void> _createPaymentRequest(
    String linkExpiry,
    List<String> itemImageUrls,
  ) async {
    Navigator.pop(context);

    int processingHours = _processingTimeMap[_processingTime!] ?? 24;

    if (widget.isEdit && widget.paymentRequest != null) {
      await ref
          .read(paymentNotifierProvider.notifier)
          .updatePaymentRequest(
            id: widget.paymentRequest!['id'] as String,
            itemName: _nameController.text,
            itemDescription: _descController.text,
            itemPrice: double.tryParse(_priceController.text) ?? 0.0,
            itemImages: itemImageUrls.isNotEmpty ? itemImageUrls : null,
            processingTimeHours: processingHours,
            isReusable: linkExpiry == 'reusable',
            maxUses: linkExpiry == 'reusable' ? 5 : null,
          );
    } else {
      await ref
          .read(paymentNotifierProvider.notifier)
          .createPaymentRequest(
            itemName: _nameController.text,
            itemDescription: _descController.text,
            itemPrice: double.tryParse(_priceController.text) ?? 0.0,
            itemImages: itemImageUrls,
            processingTimeHours: processingHours,
            isReusable: linkExpiry == 'reusable',
            maxUses: linkExpiry == 'reusable' ? 5 : null,
          );
    }

    final paymentState = ref.read(paymentNotifierProvider);

    if (paymentState.errorMessage != null) {
      _showError(paymentState.errorMessage!);
      return;
    }

    if (paymentState.createdPaymentRequest != null) {
      if (mounted) {
        Navigator.pushNamed(
          context,
          RouteNames.linkCreatedSuccessRoute,
          arguments: {'isEdit': widget.isEdit},
        );
      }
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  Widget _buildExpiryOption({
    required String value,
    required String title,
    required String subtitle,
  }) {
    final isSelected = _linkExpiry == value;
    return GestureDetector(
      onTap: () => setState(() => _linkExpiry = value),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        decoration: BoxDecoration(
          border: Border.all(color: AppColor.kipaGrey.withAlpha(50)),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(
              isSelected ? Icons.check_circle : Icons.radio_button_unchecked,
              color: isSelected ? AppColor.primary : AppColor.kipaGrey,
            ),
            horizontalSpace(12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 8,
              children: [
                BodyText(title, fontWeight: FontWeight.w500, fontSize: 14),
                Caption(subtitle),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
