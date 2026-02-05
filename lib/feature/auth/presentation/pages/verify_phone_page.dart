import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/routes/route_names.dart';
import '../../../../core/shared/widgets/custom_text.dart';
import '../../../../core/shared/widgets/step_indicator.dart';
import '../../../../theme/app_colors.dart';
import '../../../../utils/constant.dart';
import '../providers/auth_provider.dart';
import '../state/auth_state.dart';
import '../widgets/verification_method_card.dart';

class VerifyPhonePage extends ConsumerStatefulWidget {
  final String phoneNumber;

  const VerifyPhonePage({super.key, required this.phoneNumber});

  @override
  ConsumerState<VerifyPhonePage> createState() => _VerifyPhonePageState();
}

class _VerifyPhonePageState extends ConsumerState<VerifyPhonePage> {
  String? _selectedMethod;

  void _onMethodSelected(String method) {
    setState(() {
      _selectedMethod = method;
    });
    ref.read(authNotifierProvider.notifier).sendOtp(widget.phoneNumber, method);
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);

    ref.listen<AuthState>(authNotifierProvider, (previous, next) {
      if (previous?.isLoading == true && next.isLoading == false) {
        if (next.errorMessage != null) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(next.errorMessage!)));
        } else if (next.response?.success == true &&
            _selectedMethod != null &&
            next.response?.data?['verification_id'] != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                _selectedMethod == 'sms'
                    ? 'SMS code sent!'
                    : 'Voice call initiated!',
              ),
            ),
          );

          Future.delayed(const Duration(milliseconds: 500), () {
            if (context.mounted) {
              Navigator.pushNamed(
                context,
                RouteNames.verifyCodeRoute,
                arguments: {
                  'phoneNumber': widget.phoneNumber,
                  'method': _selectedMethod,
                  'verificationId': next.verificationId,
                  'idempotencyKey': next.idempotencyKey,
                },
              );
            }
          });
        }
      }
    });

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            verticalSpace(24),
            Stack(
              alignment: Alignment.center,
              children: [
                const Center(
                  child: StepIndicator(currentStep: 2, totalSteps: 4),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColor.onboardingPrimary,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            verticalSpace(32),

            const H3(
              'We\'ll send a verification code to your phone number',
              color: AppColor.primaryText,
            ),
            verticalSpace(32),

            VerificationMethodCard(
              icon: Icons.message,
              iconColor: AppColor.onboardingPrimary,
              title: 'SMS Code',
              description: 'Receive a 6-digit code via text',
              isSelected: _selectedMethod == 'sms',
              onTap: authState.isLoading
                  ? () {}
                  : () => _onMethodSelected('sms'),
            ),
            verticalSpace(16),

            VerificationMethodCard(
              icon: Icons.phone,
              iconColor: AppColor.onboardingPrimary,
              title: 'Voice Call',
              description: 'Receive the code via an automated call',
              isSelected: _selectedMethod == 'voice',
              onTap: authState.isLoading
                  ? () {}
                  : () => _onMethodSelected('voice'),
            ),

            if (authState.isLoading) ...[
              verticalSpace(24),
              const Center(child: CircularProgressIndicator()),
            ],

            const Spacer(),
          ],
        ),
      ),
    );
  }
}
