import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/routes/route_names.dart';
import '../../../../core/shared/widgets/buttons/animated_button.dart';
import '../../../../core/shared/widgets/buttons/roundedbutton.dart';
import '../../../../core/shared/widgets/custom_text.dart';
import '../../../../core/shared/widgets/image_picker_widget.dart';
import '../../../../core/shared/widgets/step_indicator.dart';
import '../../../../core/shared/widgets/textfields/custom_field.dart';
import '../../../../theme/app_colors.dart';
import '../../../../utils/constant.dart';
import '../providers/auth_provider.dart';
import '../state/auth_state.dart';

class UserInfoPage extends ConsumerStatefulWidget {
  final String phoneNumber;

  const UserInfoPage({super.key, required this.phoneNumber});

  @override
  ConsumerState<UserInfoPage> createState() => _UserInfoPageState();
}

class _UserInfoPageState extends ConsumerState<UserInfoPage> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  File? _profileImage;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _onImageSelected(File? image) {
    setState(() {
      _profileImage = image;
    });
  }

  Future<void> _onContinue() async {
    if (_firstNameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your first name')),
      );
      return;
    }

    if (_lastNameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your last name')),
      );
      return;
    }

    if (_emailController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please enter your email')));
      return;
    }

    if (_profileImage != null) {
      await ref
          .read(authNotifierProvider.notifier)
          .uploadProfilePicture(_profileImage!.path);

      final authState = ref.read(authNotifierProvider);
      if (authState.uploadedImageUrl != null) {
        await ref
            .read(authNotifierProvider.notifier)
            .updateProfile(
              firstName: _firstNameController.text,
              lastName: _lastNameController.text,
              email: _emailController.text,
              profilePhotoUrl: authState.uploadedImageUrl,
            );
      }
    } else {
      await ref
          .read(authNotifierProvider.notifier)
          .updateProfile(
            firstName: _firstNameController.text,
            lastName: _lastNameController.text,
            email: _emailController.text,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);

    // We will listen for profile update completion
    ref.listen<AuthState>(authNotifierProvider, (previous, next) {
      if (previous?.isUploadingImage == true &&
          next.isUploadingImage == false) {
        if (next.errorMessage != null && next.uploadedImageUrl == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Image upload failed: ${next.errorMessage}'),
            ),
          );
        }
      }

      // We will handle profile update completion
      if (previous?.isUpdatingProfile == true &&
          next.isUpdatingProfile == false) {
        if (next.errorMessage != null) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(next.errorMessage!)));
        } else if (next.response?.success == true) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            RouteNames.homeRoute,
            (route) => false,
          );
        }
      }
    });

    final isLoading = authState.isUploadingImage || authState.isUpdatingProfile;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              verticalSpace(24),
              const Center(child: StepIndicator(currentStep: 4, totalSteps: 4)),
              verticalSpace(32),

              const H3(
                'Tell us some basic information to proceed',
                color: AppColor.primaryText,
              ),
              verticalSpace(32),

              Center(
                child: ImagePickerWidget(
                  size: 100,
                  onImageSelected: _onImageSelected,
                ),
              ),
              verticalSpace(24),

              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      TextInputField(
                        label: 'First Name',
                        hintText: 'Enter your first name',
                        controller: _firstNameController,
                        inputType: TextInputType.name,
                      ),
                      verticalSpace(16),

                      TextInputField(
                        label: 'Last Name',
                        hintText: 'Enter your last name',
                        controller: _lastNameController,
                        inputType: TextInputType.name,
                      ),
                      verticalSpace(16),

                      TextInputField(
                        label: 'Email',
                        hintText: 'Enter your email',
                        controller: _emailController,
                        inputType: TextInputType.emailAddress,
                      ),
                    ],
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: AnimatedButton(
                  onTap: isLoading ? () {} : _onContinue,
                  child: CustomButton(
                    title: isLoading ? 'Saving...' : 'Complete',
                    color: AppColor.onboardingPrimary,
                    borderRadius: 28,
                  ),
                ),
              ),
              verticalSpace(16),
            ],
          ),
        ),
      ),
    );
  }
}
