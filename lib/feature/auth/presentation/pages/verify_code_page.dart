import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pinput/pinput.dart';
import '../../../../core/routes/route_names.dart';
import '../../../../core/shared/widgets/buttons/animated_button.dart';
import '../../../../core/shared/widgets/buttons/roundedbutton.dart';
import '../../../../core/shared/widgets/custom_text.dart';
import '../../../../core/shared/widgets/step_indicator.dart';
import '../../../../theme/app_colors.dart';
import '../../../../utils/constant.dart';
import '../providers/auth_provider.dart';
import '../state/auth_state.dart';

class VerifyCodePage extends ConsumerStatefulWidget {
  final String phoneNumber;
  final String method;
  final String? verificationId;
  final String? idempotencyKey;

  const VerifyCodePage({
    super.key,
    required this.phoneNumber,
    required this.method,
    this.verificationId,
    this.idempotencyKey,
  });

  @override
  ConsumerState<VerifyCodePage> createState() => _VerifyCodePageState();
}

class _VerifyCodePageState extends ConsumerState<VerifyCodePage> {
  final TextEditingController _pinController = TextEditingController();

  @override
  void dispose() {
    _pinController.dispose();
    super.dispose();
  }

  void _onVerify() {
    if (_pinController.text.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter the 6-digit code')),
      );
      return;
    }

    if (widget.verificationId == null || widget.idempotencyKey == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Session expired. Please try again.')),
      );
      return;
    }

    ref
        .read(authNotifierProvider.notifier)
        .verifyOtp(
          phoneNumber: widget.phoneNumber,
          otpCode: _pinController.text,
          verificationId: widget.verificationId!,
          idempotencyKey: widget.idempotencyKey!,
        );
  }

  void _onResendCode() {
    ref.read(authNotifierProvider.notifier).resendOtp(widget.phoneNumber);
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
        } else if (next.response?.success == true) {
          final isNewUser = next.response?.data?['is_new_user'] ?? false;

          if (isNewUser) {
            Navigator.pushNamed(
              context,
              RouteNames.userInfoRoute,
              arguments: {'phoneNumber': widget.phoneNumber},
            );
          } else {
            Navigator.pushReplacementNamed(context, RouteNames.homeRoute);
          }
        }
      }

      if (previous?.isResending == true && next.isResending == false) {
        if (next.errorMessage != null) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(next.errorMessage!)));
        } else if (next.response?.success == true) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Code resent successfully')),
          );
        }
      }
    });

    final defaultPinTheme = PinTheme(
      width: 60,
      height: 60,
      textStyle: const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: AppColor.primaryText,
      ),
      decoration: BoxDecoration(
        color: AppColor.neutral.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(100),
        border: Border.all(color: AppColor.neutral),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration?.copyWith(
        // border: Border.all(color: AppColor.onboardingPrimary, width: 2),
        color: AppColor.onboardingPrimary.withValues(alpha: 0.1),
      ),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration?.copyWith(
        color: AppColor.onboardingPrimary.withValues(alpha: 0.1),
        // border: Border.all(color: AppColor.onboardingPrimary),
      ),
    );

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
                  child: StepIndicator(currentStep: 3, totalSteps: 4),
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
              'Enter the 6-Digit Code sent to\nyour phone number',
              color: AppColor.primaryText,
            ),
            verticalSpace(45),

            Center(
              child: Pinput(
                controller: _pinController,
                length: 6,
                defaultPinTheme: defaultPinTheme,
                focusedPinTheme: focusedPinTheme,
                submittedPinTheme: submittedPinTheme,
                showCursor: true,
                onCompleted: (pin) => _onVerify(),
              ),
            ),
            verticalSpace(24),

            Center(
              child: TextButton(
                onPressed: authState.isResending ? null : _onResendCode,
                child: BodyText(
                  authState.isResending
                      ? 'Resending...'
                      : 'Resend OTP (${authState.retryAfterSeconds}s)',
                  color: AppColor.upholdGrey,
                ),
              ),
            ),

            const Spacer(),

            AnimatedButton(
              onTap: authState.isLoading ? () {} : _onVerify,
              child: CustomButton(
                title: authState.isLoading ? 'Verifying...' : 'Verify',
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
}
