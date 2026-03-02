import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/routes/route_names.dart';
import '../../../../core/shared/widgets/buttons/animated_button.dart';
import '../../../../core/shared/widgets/buttons/roundedbutton.dart';
import '../../../../core/shared/widgets/custom_text.dart';
import '../../../../core/shared/widgets/step_indicator.dart';
import '../../../../core/shared/widgets/textfields/custom_field.dart';
import '../../../../theme/app_colors.dart';
import '../../../../utils/constant.dart';
import '../widgets/country_picker_bottom_sheet.dart';

class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({super.key});

  @override
  ConsumerState<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> {
  final TextEditingController _phoneController = TextEditingController();
  String _selectedCountryCode = '+234';
  String _selectedCountryFlag = '🇳🇬';

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  void _showCountryPicker() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => CountryPickerBottomSheet(
        onCountrySelected: (code, flag) {
          setState(() {
            _selectedCountryCode = code;
            _selectedCountryFlag = flag;
          });
          Navigator.pop(context);
        },
      ),
    );
  }

  void _onNextPressed() {
    if (_phoneController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your phone number')),
      );
      return;
    }

    final fullPhoneNumber = '$_selectedCountryCode${_phoneController.text}';

    Navigator.pushNamed(
      context,
      RouteNames.verifyPhoneRoute,
      arguments: {'phoneNumber': fullPhoneNumber},
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              verticalSpace(24),
              const Center(child: StepIndicator(currentStep: 1, totalSteps: 4)),
              verticalSpace(32),

              const H3('Enter your phone number', color: AppColor.primaryText),
              verticalSpace(32),

              TextInputField(
                label: 'Phone Number',
                hintText: '8012345678',
                controller: _phoneController,
                inputType: TextInputType.phone,
                prefixIcon: GestureDetector(
                  onTap: _showCountryPicker,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _selectedCountryFlag,
                          style: const TextStyle(fontSize: 20),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _selectedCountryCode,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const Icon(Icons.arrow_drop_down, size: 20),
                      ],
                    ),
                  ),
                ),
              ),

              const Spacer(),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: AnimatedButton(
                  onTap: _onNextPressed,
                  child: const CustomButton(
                    title: 'Next',
                    color: AppColor.onboardingPrimary,
                    borderRadius: 28,
                  ),
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
