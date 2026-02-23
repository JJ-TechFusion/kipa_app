import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kipa/core/shared/widgets/custom_snackbar.dart';
import 'package:kipa/core/shared/widgets/custom_text.dart';
import 'package:kipa/core/shared/widgets/image_picker_widget.dart';
import 'package:kipa/core/shared/widgets/textfields/custom_field.dart';
import 'package:kipa/core/shared/widgets/buttons/animated_button.dart';
import 'package:kipa/core/shared/widgets/buttons/roundedbutton.dart';
import 'package:kipa/feature/auth/presentation/providers/auth_provider.dart';
import 'package:kipa/feature/auth/presentation/state/auth_state.dart';
import 'package:kipa/theme/app_colors.dart';
import 'package:kipa/utils/constant.dart';

class PersonalDetailsScreen extends ConsumerStatefulWidget {
  const PersonalDetailsScreen({super.key});

  @override
  ConsumerState<PersonalDetailsScreen> createState() =>
      _PersonalDetailsScreenState();
}

class _PersonalDetailsScreenState extends ConsumerState<PersonalDetailsScreen> {
  void _showEditNameDialog() {
    final user = ref.read(authNotifierProvider).currentUser;
    if (user == null) return;

    final firstNameController = TextEditingController(text: user.firstName);
    final lastNameController = TextEditingController(text: user.lastName);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 20,
          right: 20,
          top: 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const BodyLarge('Edit Name', fontWeight: FontWeight.bold),
            verticalSpace(24),
            TextInputField(
              label: 'First Name',
              controller: firstNameController,
              inputType: TextInputType.name,
              hintText: '',
            ),
            verticalSpace(16),
            TextInputField(
              label: 'Last Name',
              controller: lastNameController,
              inputType: TextInputType.name,
              hintText: '',
            ),
            verticalSpace(24),
            AnimatedButton(
              onTap: () async {
                if (firstNameController.text.isEmpty ||
                    lastNameController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Both names are required')),
                  );
                  return;
                }

                Navigator.pop(context);

                await ref
                    .read(authNotifierProvider.notifier)
                    .updateProfile(
                      firstName: firstNameController.text,
                      lastName: lastNameController.text,
                    );
              },
              child: CustomButton(
                title: 'Save Changes',
                color: AppColor.onboardingPrimary,
                borderRadius: 28,
              ),
            ),
            verticalSpace(16),
          ],
        ),
      ),
    );
  }

  void _showEditEmailDialog() {
    final user = ref.read(authNotifierProvider).currentUser;
    if (user == null) return;

    final emailController = TextEditingController(text: user.email);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 20,
          right: 20,
          top: 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const BodyLarge('Edit Email', fontWeight: FontWeight.bold),
            verticalSpace(24),
            TextInputField(
              label: 'Email',
              controller: emailController,
              inputType: TextInputType.emailAddress,
              hintText: '',
            ),
            verticalSpace(24),
            AnimatedButton(
              onTap: () async {
                if (emailController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Email is required')),
                  );
                  return;
                }

                final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                if (!emailRegex.hasMatch(emailController.text)) {
                  CustomSnackBar.show(
                    context,
                    message: 'Invalid email format',
                    type: SnackBarType.error,
                  );
                  return;
                }

                Navigator.pop(context);

                await ref
                    .read(authNotifierProvider.notifier)
                    .updateProfile(email: emailController.text);
              },
              child: CustomButton(
                title: 'Save Changes',
                color: AppColor.onboardingPrimary,
                borderRadius: 28,
              ),
            ),
            verticalSpace(16),
          ],
        ),
      ),
    );
  }

  void _showEditPhotoDialog() {
    showModalBottomSheet(
      context: context,
      builder: (context) => _EditPhotoSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);
    final user = authState.currentUser;

    ref.listen<AuthState>(authNotifierProvider, (previous, next) {
      if (previous?.isUpdatingProfile == true &&
          next.isUpdatingProfile == false) {
        if (next.errorMessage != null) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(next.errorMessage!)));
        } else if (next.response?.success == true) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Profile updated successfully')),
          );
        }
      }
    });

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const BodyLarge("Personal Details", fontWeight: FontWeight.bold),
        centerTitle: true,
      ),
      body: user == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Stack(
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppColor.primary.withValues(alpha: 0.1),
                              width: 2,
                            ),
                            image:
                                user.profileImageUrl != null &&
                                    user.profileImageUrl!.isNotEmpty
                                ? DecorationImage(
                                    image: NetworkImage(user.profileImageUrl!),
                                    fit: BoxFit.cover,
                                  )
                                : null,
                          ),
                          child:
                              user.profileImageUrl == null ||
                                  user.profileImageUrl!.isEmpty
                              ? const Icon(Icons.person, size: 50)
                              : null,
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: _showEditPhotoDialog,
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: AppColor.onboardingPrimary,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 2,
                                ),
                              ),
                              child: const Icon(
                                Icons.camera_alt,
                                color: Colors.white,
                                size: 16,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  verticalSpace(32),

                  _DetailItem(
                    label: "Account Name",
                    value: user.fullName,
                    onEdit: _showEditNameDialog,
                  ),
                  verticalSpace(16),
                  _DetailItem(
                    label: "Phone Number",
                    value: user.phoneNumber,
                    onEdit: () {
                      CustomSnackBar.show(
                        context,
                        message: 'Phone number cannot be changed',
                        type: SnackBarType.error,
                      );
                    },
                  ),
                  verticalSpace(16),
                  _DetailItem(
                    label: "Email",
                    value: user.email,
                    onEdit: _showEditEmailDialog,
                  ),
                ],
              ),
            ),
    );
  }
}

class _DetailItem extends StatelessWidget {
  final String label;
  final String value;
  final VoidCallback onEdit;

  const _DetailItem({
    required this.label,
    required this.value,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              spacing: 8,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BodySmall(label, fontWeight: FontWeight.bold),
                Caption(value, color: AppColor.lightText),
              ],
            ),
          ),
          InkWell(
            onTap: onEdit,
            child: const Icon(
              Icons.edit_outlined,
              color: AppColor.lightText,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }
}

class _EditPhotoSheet extends ConsumerStatefulWidget {
  @override
  ConsumerState<_EditPhotoSheet> createState() => _EditPhotoSheetState();
}

class _EditPhotoSheetState extends ConsumerState<_EditPhotoSheet> {
  File? _selectedImage;

  void _onImageSelected(File? image) {
    setState(() {
      _selectedImage = image;
    });
  }

  Future<void> _savePhoto() async {
    if (_selectedImage == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please select an image')));
      return;
    }

    // Upload image
    await ref
        .read(authNotifierProvider.notifier)
        .uploadProfilePicture(_selectedImage!.path);

    final authState = ref.read(authNotifierProvider);
    if (authState.uploadedImageUrl != null) {
      // Update profile with new image URL
      await ref
          .read(authNotifierProvider.notifier)
          .updateProfile(profilePhotoUrl: authState.uploadedImageUrl);

      if (mounted) {
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);
    final user = authState.currentUser;
    final isLoading = authState.isUploadingImage || authState.isUpdatingProfile;

    // Listen for upload errors
    ref.listen<AuthState>(authNotifierProvider, (previous, next) {
      if (previous?.isUploadingImage == true &&
          next.isUploadingImage == false) {
        if (next.errorMessage != null && next.uploadedImageUrl == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Upload failed: ${next.errorMessage}')),
          );
        }
      }
    });

    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const BodyLarge('Change Profile Photo', fontWeight: FontWeight.bold),
          verticalSpace(24),
          ImagePickerWidget(
            size: 120,
            onImageSelected: _onImageSelected,
            initialImageUrl: user?.profileImageUrl,
          ),
          verticalSpace(24),
          AnimatedButton(
            onTap: isLoading ? () {} : _savePhoto,
            child: CustomButton(
              title: isLoading ? 'Uploading...' : 'Save Photo',
              color: AppColor.onboardingPrimary,
              borderRadius: 28,
            ),
          ),
          verticalSpace(16),
        ],
      ),
    );
  }
}
