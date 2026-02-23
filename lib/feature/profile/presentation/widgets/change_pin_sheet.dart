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

class ChangePinSheet extends ConsumerStatefulWidget {
  const ChangePinSheet({super.key});

  @override
  ConsumerState<ChangePinSheet> createState() => _ChangePinSheetState();
}

class _ChangePinSheetState extends ConsumerState<ChangePinSheet> {
  final TextEditingController _oldPinController = TextEditingController();
  final TextEditingController _newPinController = TextEditingController();
  final TextEditingController _confirmPinController = TextEditingController();

  int _currentStep = 0;

  @override
  void dispose() {
    _oldPinController.dispose();
    _newPinController.dispose();
    _confirmPinController.dispose();
    super.dispose();
  }

  Future<void> _handleContinue() async {
    if (_currentStep == 0) {
      if (_oldPinController.text.length == 4) {
        setState(() {
          _currentStep = 1;
        });
      } else {
        CustomSnackBar.show(
          context,
          message: 'Please enter your 4-digit old PIN',
          type: SnackBarType.error,
        );
      }
    } else if (_currentStep == 1) {
      if (_newPinController.text.length == 4) {
        if (_newPinController.text == _oldPinController.text) {
          CustomSnackBar.show(
            context,
            message: 'New PIN must be different from old PIN',
            type: SnackBarType.error,
          );
          return;
        }
        setState(() {
          _currentStep = 2;
        });
      } else {
        CustomSnackBar.show(
          context,
          message: 'Please enter your 4-digit new PIN',
          type: SnackBarType.error,
        );
      }
    } else if (_currentStep == 2) {
      if (_confirmPinController.text.length == 4) {
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
            .changePin(_oldPinController.text, _newPinController.text);

        if (success && mounted) {
          Navigator.pop(context);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const PinSuccessScreen()),
          );
        }
      } else {
        CustomSnackBar.show(
          context,
          message: 'Please confirm your 4-digit new PIN',
          type: SnackBarType.error,
        );
      }
    }
  }

  void _handleBack() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
    } else {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final walletState = ref.watch(walletNotifierProvider);
    final isLoading = walletState.isChangingPin;

    ref.listen<WalletState>(walletNotifierProvider, (previous, next) {
      if (previous?.isChangingPin == true && next.isChangingPin == false) {
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

    String title;
    String subtitle;
    TextEditingController currentController;

    switch (_currentStep) {
      case 0:
        title = 'Enter Old PIN';
        subtitle = 'Please enter your current wallet PIN';
        currentController = _oldPinController;
        break;
      case 1:
        title = 'Enter New PIN';
        subtitle = 'Please enter your new 4-digit PIN';
        currentController = _newPinController;
        break;
      case 2:
        title = 'Confirm New PIN';
        subtitle = 'Please re-enter your new PIN to confirm';
        currentController = _confirmPinController;
        break;
      default:
        title = 'Change Wallet PIN';
        subtitle = 'Enter your old PIN';
        currentController = _oldPinController;
    }

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
            children: [
              if (_currentStep > 0)
                GestureDetector(
                  onTap: _handleBack,
                  child: const Icon(
                    Icons.arrow_back,
                    color: AppColor.primaryText,
                    size: 24,
                  ),
                )
              else
                const SizedBox(width: 24),
              horizontalSpace(12),
              Expanded(child: BodyLarge(title, fontWeight: FontWeight.bold)),
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
          BodySmall(subtitle, color: AppColor.lightText),
          verticalSpace(40),
          Center(
            child: Pinput(
              controller: currentController,
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
              onCompleted: (pin) {},
            ),
          ),
          verticalSpace(48),
          AnimatedButton(
            onTap: isLoading ? () {} : _handleContinue,
            child: CustomButton(
              title: isLoading
                  ? 'Processing...'
                  : (_currentStep == 2 ? 'Change PIN' : 'Continue'),
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
