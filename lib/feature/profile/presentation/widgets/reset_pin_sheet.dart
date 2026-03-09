import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kipa/core/shared/widgets/custom_snackbar.dart';
import 'package:pinput/pinput.dart';
import '../../../../core/shared/widgets/buttons/animated_button.dart';
import '../../../../core/shared/widgets/buttons/roundedbutton.dart';
import '../../../../core/shared/widgets/custom_text.dart';
import '../../../../theme/app_colors.dart';
import '../../../../utils/constant.dart';
import '../../../wallet/presentation/providers/wallet_provider.dart';
import '../../../wallet/presentation/state/wallet_state.dart';
import '../pages/pin_success_screen.dart';

class ResetPinSheet extends ConsumerStatefulWidget {
  const ResetPinSheet({super.key});

  @override
  ConsumerState<ResetPinSheet> createState() => _ResetPinSheetState();
}

class _ResetPinSheetState extends ConsumerState<ResetPinSheet> {
  final TextEditingController _otpController = TextEditingController();
  final TextEditingController _newPinController = TextEditingController();
  final TextEditingController _confirmPinController = TextEditingController();

  int _currentStep = 0; // 0: request OTP, 1: enter OTP + new PIN

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _requestOtp();
    });
  }

  @override
  void dispose() {
    _otpController.dispose();
    _newPinController.dispose();
    _confirmPinController.dispose();
    super.dispose();
  }

  Future<void> _requestOtp() async {
    final success = await ref
        .read(walletNotifierProvider.notifier)
        .requestPinReset();

    if (success && mounted) {
      setState(() {
        _currentStep = 1;
      });
      CustomSnackBar.show(
        context,
        message: 'OTP sent to your phone',
        type: SnackBarType.success,
      );
    }
  }

  Future<void> _handleConfirm() async {
    if (_otpController.text.length != 6) {
      CustomSnackBar.show(
        context,
        message: 'Please enter the 6-digit OTP',
        type: SnackBarType.error,
      );
      return;
    }
    if (_newPinController.text.length != 4) {
      CustomSnackBar.show(
        context,
        message: 'Please enter a 4-digit new PIN',
        type: SnackBarType.error,
      );
      return;
    }
    if (_confirmPinController.text != _newPinController.text) {
      CustomSnackBar.show(
        context,
        message: 'PINs do not match',
        type: SnackBarType.error,
      );
      return;
    }
    final success = await ref
        .read(walletNotifierProvider.notifier)
        .confirmPinReset(_otpController.text, _newPinController.text);

    if (success && mounted) {
      Navigator.pop(context);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const PinSuccessScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final walletState = ref.watch(walletNotifierProvider);
    final isLoading =
        walletState.isRequestingPinReset || walletState.isConfirmingPinReset;
    ref.listen<WalletState>(walletNotifierProvider, (previous, next) {
      if (previous?.isRequestingPinReset == true &&
          next.isRequestingPinReset == false) {
        if (next.pinErrorMessage != null) {
          CustomSnackBar.show(
            context,
            message: next.pinErrorMessage!,
            type: SnackBarType.error,
          );
        }
      }

      if (previous?.isConfirmingPinReset == true &&
          next.isConfirmingPinReset == false) {
        if (next.pinErrorMessage != null) {
          CustomSnackBar.show(
            context,
            message: next.pinErrorMessage!,
            type: SnackBarType.error,
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
      decoration: const BoxDecoration(
        color: Color(0xFFF5F5F5),
        shape: BoxShape.circle,
      ),
    );

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 20,
        right: 20,
        top: 12,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 48,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          verticalSpace(24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const BodyLarge('Reset Wallet PIN', fontWeight: FontWeight.bold),
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Icon(
                  Icons.close,
                  color: AppColor.kipaGrey,
                  size: 24,
                ),
              ),
            ],
          ),
          verticalSpace(8),
          if (_currentStep == 0)
            const BodySmall('Requesting OTP...', color: AppColor.lightText)
          else
            const BodySmall(
              'Enter the OTP sent to your phone and set a new PIN',
              color: AppColor.lightText,
            ),
          verticalSpace(40),

          if (_currentStep == 0)
            const Center(child: CircularProgressIndicator())
          else
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const BodySmall('Enter OTP Code', fontWeight: FontWeight.w500),
                verticalSpace(12),
                Center(
                  child: Pinput(
                    controller: _otpController,
                    length: 6,
                    defaultPinTheme: defaultPinTheme,
                    focusedPinTheme: defaultPinTheme.copyWith(
                      decoration: defaultPinTheme.decoration?.copyWith(
                        border: Border.all(color: AppColor.onboardingPrimary),
                      ),
                    ),
                    showCursor: true,
                  ),
                ),
                verticalSpace(32),
                const BodySmall('Enter New PIN', fontWeight: FontWeight.w500),
                verticalSpace(12),
                Center(
                  child: Pinput(
                    controller: _newPinController,
                    length: 4,
                    defaultPinTheme: defaultPinTheme,
                    focusedPinTheme: defaultPinTheme.copyWith(
                      decoration: defaultPinTheme.decoration?.copyWith(
                        border: Border.all(color: AppColor.onboardingPrimary),
                      ),
                    ),
                    obscureText: true,
                    obscuringCharacter: '●',
                    showCursor: true,
                  ),
                ),
                verticalSpace(24),
                const BodySmall('Confirm New PIN', fontWeight: FontWeight.w500),
                verticalSpace(12),
                Center(
                  child: Pinput(
                    controller: _confirmPinController,
                    length: 4,
                    defaultPinTheme: defaultPinTheme,
                    focusedPinTheme: defaultPinTheme.copyWith(
                      decoration: defaultPinTheme.decoration?.copyWith(
                        border: Border.all(color: AppColor.onboardingPrimary),
                      ),
                    ),
                    obscureText: true,
                    obscuringCharacter: '●',
                    showCursor: true,
                  ),
                ),
              ],
            ),

          verticalSpace(48),
          if (_currentStep == 1)
            AnimatedButton(
              onTap: isLoading ? () {} : _handleConfirm,
              child: CustomButton(
                title: isLoading ? 'Resetting PIN...' : 'Reset PIN',
                color: AppColor.onboardingPrimary,
                borderRadius: 28,
              ),
            ),
          verticalSpace(32),
        ],
      ),
    );
  }
}
