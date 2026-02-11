import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kipa/core/shared/widgets/custom_snackbar.dart';
import 'package:kipa/core/shared/widgets/widgets.dart';
import 'package:kipa/theme/app_colors.dart';
import 'package:kipa/utils/constant.dart';

import '../providers/purchases_provider.dart';

class DisputePage extends ConsumerStatefulWidget {
  final String purchaseId;
  final String? itemName;

  const DisputePage({super.key, required this.purchaseId, this.itemName});

  @override
  ConsumerState<DisputePage> createState() => _DisputePageState();
}

class _DisputePageState extends ConsumerState<DisputePage> {
  final _reasonController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1024,
      maxHeight: 1024,
      imageQuality: 80,
    );

    if (image != null) {
      await _uploadImage(image);
    }
  }

  Future<void> _takePhoto() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.camera,
      maxWidth: 1024,
      maxHeight: 1024,
      imageQuality: 80,
    );

    if (image != null) {
      await _uploadImage(image);
    }
  }

  Future<void> _uploadImage(XFile image) async {
    final bytes = await image.readAsBytes();

    final url = await ref
        .read(purchasesNotifierProvider.notifier)
        .uploadDisputeEvidence(fileName: image.name, fileBytes: bytes.toList());

    if (url == null && mounted) {
      final errorMessage =
          ref.read(purchasesNotifierProvider).errorMessage ??
          'Failed to upload image';
      CustomSnackBar.show(
        context,
        message: errorMessage,
        type: SnackBarType.error,
      );
    }
  }

  void _showImageSourceDialog() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const BodyText('Add Evidence', fontWeight: FontWeight.w600),
              verticalSpace(20),
              ListTile(
                leading: const Icon(
                  Icons.photo_library,
                  color: AppColor.primary,
                ),
                title: const BodyText('Choose from Gallery'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage();
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt, color: AppColor.primary),
                title: const BodyText('Take a Photo'),
                onTap: () {
                  Navigator.pop(context);
                  _takePhoto();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _submitDispute() async {
    if (!_formKey.currentState!.validate()) return;

    final purchasesState = ref.read(purchasesNotifierProvider);

    if (purchasesState.uploadedEvidenceUrls.isEmpty) {
      CustomSnackBar.show(
        context,
        message: 'Please add at least one evidence image',
        type: SnackBarType.error,
      );
      return;
    }

    final response = await ref
        .read(purchasesNotifierProvider.notifier)
        .openDispute(
          purchaseId: widget.purchaseId,
          reason: _reasonController.text.trim(),
          evidence: purchasesState.uploadedEvidenceUrls,
        );

    if (response != null && mounted) {
      CustomSnackBar.show(
        context,
        message: response.message,
        type: SnackBarType.success,
      );
      Navigator.pop(context, true);
    } else if (mounted) {
      final errorMessage =
          ref.read(purchasesNotifierProvider).errorMessage ??
          'Failed to open dispute';
      CustomSnackBar.show(
        context,
        message: errorMessage,
        type: SnackBarType.error,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final purchasesState = ref.watch(purchasesNotifierProvider);

    return Scaffold(
      backgroundColor: AppColor.scaffoldBackground,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            ref
                .read(purchasesNotifierProvider.notifier)
                .clearUploadedEvidence();
            Navigator.pop(context);
          },
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
          'Open Dispute',
          fontWeight: FontWeight.w600,
          fontSize: 18,
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 16,
                ),
                decoration: BoxDecoration(
                  color: AppColor.gradient1.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 8,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.info_outline, color: AppColor.gradient1),
                        horizontalSpace(8),
                        Expanded(
                          child: Column(
                            spacing: 5,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              BodySmall(
                                "Important Notice",
                                color: AppColor.gradient1,
                                fontWeight: FontWeight.w600,
                              ),
                              Caption(
                                "Opening a dispute will immediately freeze funds in Kipa Protect and an investigation will commence. Kindly provide all information and evidence.",
                                color: AppColor.gradient1,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              verticalSpace(20),
              Builder(
                builder: (context) {
                  final purchase = purchasesState.purchaseDetail;
                  final itemName =
                      purchase?.itemName ?? widget.itemName ?? 'Item';
                  final itemPrice = purchase?.itemPrice ?? 0.0;
                  final serviceFee = purchase?.buyerServiceFee ?? 0.0;
                  final totalAmount = purchase?.totalAmount ?? 0.0;
                  final deliveryStatus = purchase?.delivery?.status;
                  final currencyFormatter = NumberFormat.currency(
                    symbol: '₦',
                    decimalDigits: 2,
                  );

                  String? statusText;
                  Color? statusBgColor;
                  Color? statusTextColor;
                  IconData? statusIcon;

                  if (deliveryStatus != null) {
                    final normalized = deliveryStatus.toLowerCase();
                    if (normalized == 'delivered') {
                      statusText = 'Delivered';
                      statusBgColor = const Color(0xFFE0F2F1);
                      statusTextColor = const Color(0xFF00695C);
                      statusIcon = Icons.check_circle;
                    } else if (normalized == 'in_transit' ||
                        normalized == 'intransit') {
                      statusText = 'In Transit';
                      statusBgColor = const Color(0xFFE8EAF6);
                      statusTextColor = AppColor.primary;
                      statusIcon = Icons.local_shipping;
                    } else if (normalized == 'picked_up' ||
                        normalized == 'pickedup') {
                      statusText = 'Picked Up';
                      statusBgColor = const Color(0xFFE8EAF6);
                      statusTextColor = AppColor.primary;
                      statusIcon = Icons.shopping_bag;
                    }
                  }

                  return Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColor.cardBackground2,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            if (statusText != null) ...[
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: statusBgColor,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      statusIcon,
                                      size: 12,
                                      color: statusTextColor,
                                    ),
                                    horizontalSpace(4),
                                    Text(
                                      statusText,
                                      style: TextStyle(
                                        color: statusTextColor,
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              horizontalSpace(8),
                            ],
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFE0F2F1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.verified_user_outlined,
                                    size: 12,
                                    color: Color(0xFF00695C),
                                  ),
                                  SizedBox(width: 4),
                                  Text(
                                    'Kipa Protected',
                                    style: TextStyle(
                                      color: Color(0xFF00695C),
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        verticalSpace(16),
                        BodyText(
                          itemName,
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                        verticalSpace(16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Caption('Item Price'),
                            BodySmall(
                              currencyFormatter.format(itemPrice),
                              fontWeight: FontWeight.w500,
                            ),
                          ],
                        ),
                        verticalSpace(8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Caption(
                              serviceFee > 0 && itemPrice > 0
                                  ? '+${(serviceFee / itemPrice * 100).toStringAsFixed(0)}% Buyer Fee'
                                  : 'Buyer Fee',
                            ),
                            BodySmall(
                              currencyFormatter.format(serviceFee),
                              fontWeight: FontWeight.w500,
                            ),
                          ],
                        ),
                        verticalSpace(16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Caption(
                              'Total Amount',
                              fontWeight: FontWeight.w600,
                            ),
                            BodyText(currencyFormatter.format(totalAmount)),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
              verticalSpace(24),

              const BodyText('Reason for Dispute', fontWeight: FontWeight.w600),
              verticalSpace(8),
              TextInputField(
                hintText: 'Describe the issue with your order...',
                controller: _reasonController,
                maxLines: 5,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please provide a reason for the dispute';
                  }
                  if (value.trim().length < 10) {
                    return 'Please provide more details (at least 10 characters)';
                  }
                  return null;
                },
              ),
              verticalSpace(24),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const BodyText('UploadEvidence', fontWeight: FontWeight.w600),
                  BodySmall(
                    '${purchasesState.uploadedEvidenceUrls.length} image(s)',
                    color: AppColor.lightText,
                  ),
                ],
              ),
              verticalSpace(8),
              const BodySmall(
                'Add photos showing the issue with your order',
                color: AppColor.lightText,
              ),
              verticalSpace(16),

              // Evidence grid
              if (purchasesState.uploadedEvidenceUrls.isNotEmpty) ...[
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  itemCount: purchasesState.uploadedEvidenceUrls.length,
                  itemBuilder: (context, index) {
                    final url = purchasesState.uploadedEvidenceUrls[index];
                    return Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            url,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: double.infinity,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Container(
                                color: AppColor.cardBackground2,
                                child: const Center(
                                  child: CircularProgressIndicator.adaptive(
                                    strokeWidth: 2,
                                  ),
                                ),
                              );
                            },
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: AppColor.cardBackground2,
                                child: const Icon(
                                  Icons.file_upload_outlined,
                                  color: AppColor.lightText,
                                ),
                              );
                            },
                          ),
                        ),
                        Positioned(
                          top: 4,
                          right: 4,
                          child: GestureDetector(
                            onTap: () {
                              ref
                                  .read(purchasesNotifierProvider.notifier)
                                  .removeEvidenceUrl(url);
                            },
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.close,
                                size: 14,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
                verticalSpace(16),
              ],

              // Add evidence button
              GestureDetector(
                onTap: purchasesState.isUploadingEvidence
                    ? null
                    : _showImageSourceDialog,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: AppColor.kipaGrey.withAlpha(100),
                      style: BorderStyle.solid,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: purchasesState.isUploadingEvidence
                      ? const Center(
                          child: SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator.adaptive(
                              strokeWidth: 2,
                            ),
                          ),
                        )
                      : Column(
                          spacing: 8,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                color: AppColor.primary.withValues(alpha: 0.1),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.file_upload_outlined,
                                size: 25,
                                color: AppColor.lightText,
                              ),
                            ),
                            const BodySmall(
                              'Tap to upload photo',
                              color: AppColor.primaryText,
                            ),
                            Caption(
                              "JPEG, PNG, GIF, WEBP, HEIC, HEIF formats, up to 50MB",
                            ),
                          ],
                        ),
                ),
              ),

              verticalSpace(40),

              // Submit button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 42),
                child: CustomButton(
                  title: 'Submit Dispute',
                  isLoading: purchasesState.isOpeningDispute,
                  onTap: purchasesState.isOpeningDispute
                      ? null
                      : _submitDispute,
                  icon: Icons.gavel,
                  borderRadius: 30,
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
