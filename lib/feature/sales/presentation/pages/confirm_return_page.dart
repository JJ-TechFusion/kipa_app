import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kipa/core/shared/widgets/custom_snackbar.dart';
import 'package:kipa/core/shared/widgets/widgets.dart';
import 'package:kipa/feature/sales/presentation/providers/sales_provider.dart';
import 'package:kipa/theme/app_colors.dart';
import 'package:kipa/utils/constant.dart';

class ConfirmReturnPage extends ConsumerStatefulWidget {
  final String saleId;

  const ConfirmReturnPage({super.key, required this.saleId});

  @override
  ConsumerState<ConfirmReturnPage> createState() => _ConfirmReturnPageState();
}

class _ConfirmReturnPageState extends ConsumerState<ConfirmReturnPage> {
  String _selectedCondition = 'good';
  final _notesController = TextEditingController();
  final _damageReasonController = TextEditingController();
  final _imagePicker = ImagePicker();
  final List<File> _localImages = [];
  bool _isUploading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(salesNotifierProvider.notifier).clearDamageEvidence();
    });
  }

  @override
  void dispose() {
    _notesController.dispose();
    _damageReasonController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    final XFile? pickedFile = await _imagePicker.pickImage(
      source: source,
      imageQuality: 70,
    );
    if (pickedFile != null) {
      final file = File(pickedFile.path);
      setState(() {
        _localImages.add(file);
        _isUploading = true;
      });

      final bytes = await file.readAsBytes();
      final url = await ref
          .read(salesNotifierProvider.notifier)
          .uploadDamageEvidence(fileName: pickedFile.name, fileBytes: bytes);

      setState(() {
        _isUploading = false;
        if (url == null) {
          _localImages.remove(file);
        }
      });
    }
  }

  void _showImageSourceDialog() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (sheetCtx) => SafeArea(
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
                  Navigator.pop(sheetCtx);
                  _pickImage(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt, color: AppColor.primary),
                title: const BodyText('Take a Photo'),
                onTap: () {
                  Navigator.pop(sheetCtx);
                  _pickImage(ImageSource.camera);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _submitConfirmReturn() async {
    final salesState = ref.read(salesNotifierProvider);

    if (_selectedCondition == 'damaged' &&
        _damageReasonController.text.isEmpty) {
      CustomSnackBar.show(
        context,
        message: 'Please provide a damage reason',
        type: SnackBarType.error,
      );
      return;
    }

    final confirmed = await ref
        .read(salesNotifierProvider.notifier)
        .confirmReturn(
          orderId: widget.saleId,
          condition: _selectedCondition,
          notes: _notesController.text.isNotEmpty
              ? _notesController.text
              : null,
          damageReason: _selectedCondition == 'damaged'
              ? _damageReasonController.text
              : null,
          damageEvidenceUrls: _selectedCondition == 'damaged'
              ? salesState.damageEvidenceUrls
              : [],
        );

    ref.read(salesNotifierProvider.notifier).clearDamageEvidence();

    if (confirmed && mounted) {
      CustomSnackBar.show(
        context,
        message: 'Return confirmed. Buyer will be refunded.',
        type: SnackBarType.success,
      );
      ref.read(salesNotifierProvider.notifier).fetchSaleById(widget.saleId);
      Navigator.pop(context, true);
    } else if (mounted) {
      final errorMessage =
          ref.read(salesNotifierProvider).errorMessage ??
          'Failed to confirm return';
      CustomSnackBar.show(
        context,
        message: errorMessage,
        type: SnackBarType.error,
      );
    }
  }

  Widget _buildConditionOption({
    required String label,
    required String value,
    required IconData icon,
  }) {
    final isSelected = value == _selectedCondition;
    return GestureDetector(
      onTap: () => setState(() => _selectedCondition = value),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? AppColor.primary : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
          color: isSelected ? AppColor.primary.withAlpha(20) : null,
        ),
        child: Row(
          children: [
            Icon(
              isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
              color: isSelected ? AppColor.primary : Colors.grey,
              size: 20,
            ),
            horizontalSpace(12),
            Icon(
              icon,
              color: isSelected ? AppColor.primary : Colors.grey,
              size: 20,
            ),
            horizontalSpace(8),
            BodyText(
              label,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final salesState = ref.watch(salesNotifierProvider);

    return Scaffold(
      backgroundColor: AppColor.scaffoldBackground,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            ref.read(salesNotifierProvider.notifier).clearDamageEvidence();
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
          'Confirm Return',
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
            // Item condition section
            const BodyText('Item Condition', fontWeight: FontWeight.w600),
            verticalSpace(8),
            const BodySmall(
              'Select the condition of the returned item',
              color: AppColor.lightText,
            ),
            verticalSpace(16),
            _buildConditionOption(
              label: 'Good Condition',
              value: 'good',
              icon: Icons.check_circle_outline,
            ),
            verticalSpace(12),
            _buildConditionOption(
              label: 'Damaged',
              value: 'damaged',
              icon: Icons.warning_amber_rounded,
            ),

            // Damage details section
            if (_selectedCondition == 'damaged') ...[
              verticalSpace(24),
              const BodyText('Damage Reason', fontWeight: FontWeight.w600),
              verticalSpace(8),
              TextInputField(
                hintText: 'Describe the damage...',
                controller: _damageReasonController,
                maxLines: 3,
              ),
              verticalSpace(24),

              // Evidence section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const BodyText(
                    'Damage Evidence',
                    fontWeight: FontWeight.w600,
                  ),
                  BodySmall(
                    '${salesState.damageEvidenceUrls.length} image(s)',
                    color: AppColor.lightText,
                  ),
                ],
              ),
              verticalSpace(8),
              const BodySmall(
                'Add photos showing the damage',
                color: AppColor.lightText,
              ),
              verticalSpace(16),

              // Evidence grid
              if (_localImages.isNotEmpty) ...[
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  itemCount: _localImages.length,
                  itemBuilder: (context, index) {
                    final file = _localImages[index];
                    final uploading =
                        _isUploading && index == _localImages.length - 1;
                    return Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.file(
                            file,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: double.infinity,
                          ),
                        ),
                        if (uploading)
                          Positioned.fill(
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.black45,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Center(
                                child: SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        if (!uploading &&
                            index < salesState.damageEvidenceUrls.length)
                          Positioned(
                            top: 4,
                            right: 4,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _localImages.removeAt(index);
                                });
                                if (index <
                                    salesState.damageEvidenceUrls.length) {
                                  ref
                                      .read(salesNotifierProvider.notifier)
                                      .removeDamageEvidenceUrl(
                                        salesState.damageEvidenceUrls[index],
                                      );
                                }
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

              // Add photo button
              GestureDetector(
                onTap: _isUploading ? null : _showImageSourceDialog,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColor.kipaGrey.withAlpha(100)),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: _isUploading
                      ? const Center(
                          child: SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(strokeWidth: 2),
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
            ],

            // Notes section
            verticalSpace(24),
            const BodyText('Notes (Optional)', fontWeight: FontWeight.w600),
            verticalSpace(8),
            TextInputField(
              hintText: 'Add any notes about the returned item...',
              controller: _notesController,
              maxLines: 3,
            ),

            verticalSpace(40),

            // Submit button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 42),
              child: CustomButton(
                title: 'Confirm Return',
                isLoading: salesState.isConfirmingReturn || _isUploading,
                onTap: (salesState.isConfirmingReturn || _isUploading)
                    ? null
                    : _submitConfirmReturn,
                icon: Icons.check_circle,
                borderRadius: 30,
              ),
            ),
            verticalSpace(20),
          ],
        ),
      ),
    );
  }
}
