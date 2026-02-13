import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kipa/core/shared/widgets/buttons/animated_button.dart';
import 'package:kipa/core/shared/widgets/pin_entry_screen.dart';
import 'package:kipa/core/shared/widgets/widgets.dart';
import 'package:kipa/utils/constant.dart';

import '../../../../core/shared/widgets/custom_snackbar.dart';
import '../providers/wallet_provider.dart';

class SecureWalletScreen extends ConsumerStatefulWidget {
  final VoidCallback onPinCreated;

  const SecureWalletScreen({super.key, required this.onPinCreated});

  @override
  ConsumerState<SecureWalletScreen> createState() => _SecureWalletScreenState();
}

class _SecureWalletScreenState extends ConsumerState<SecureWalletScreen> {
  void _handleSetWalletPin() {
    String? firstPin;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => _CreatePinFlow(
          onFirstPinEntered: (pin) {
            firstPin = pin;
          },
          onConfirmPin: (confirmPin) async {
            if (firstPin == confirmPin) {
              return await _createPinOnServer(confirmPin);
            } else {
              return false;
            }
          },
          onPinMismatch: () {
            CustomSnackBar.show(
              context,
              message: 'PINs do not match. Please try again.',
              type: SnackBarType.error,
            );
          },
          onPinCreated: widget.onPinCreated,
        ),
      ),
    );
  }

  Future<bool> _createPinOnServer(String pin) async {
    final notifier = ref.read(walletNotifierProvider.notifier);
    final success = await notifier.createPin(pin);

    if (success && mounted) {
      CustomSnackBar.show(
        context,
        message: 'Wallet PIN set successfully!',
        type: SnackBarType.success,
      );
    }

    return success;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          spacing: 6,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            verticalSpace(100),
            Image.asset("assets/images/wallet.png", width: 200),
            H4("Secure Your Wallet"),
            verticalSpace(4),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Caption(
                "Set up a 4-digit wallet PIN to protect your wallet and make secure payments",
                textAlign: TextAlign.center,
              ),
            ),
            Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: AnimatedButton(
                onTap: _handleSetWalletPin,
                child: CustomButton(title: "Set wallet PIN", borderRadius: 50),
              ),
            ),
            verticalSpace(30),
          ],
        ),
      ),
    );
  }
}

class _CreatePinFlow extends ConsumerStatefulWidget {
  final Function(String) onFirstPinEntered;
  final Future<bool> Function(String) onConfirmPin;
  final VoidCallback onPinMismatch;
  final VoidCallback onPinCreated;

  const _CreatePinFlow({
    required this.onFirstPinEntered,
    required this.onConfirmPin,
    required this.onPinMismatch,
    required this.onPinCreated,
  });

  @override
  ConsumerState<_CreatePinFlow> createState() => _CreatePinFlowState();
}

class _CreatePinFlowState extends ConsumerState<_CreatePinFlow> {
  bool _isConfirmStep = false;
  String? _firstPin;
  final _firstPinKey = GlobalKey<PinEntryScreenState>();
  final _confirmPinKey = GlobalKey<PinEntryScreenState>();

  void _handleFirstPinSubmit(String pin) {
    widget.onFirstPinEntered(pin);
    setState(() {
      _firstPin = pin;
      _isConfirmStep = true;
    });
  }

  Future<void> _handleConfirmPinSubmit(String confirmPin) async {
    if (_firstPin != confirmPin) {
      widget.onPinMismatch();
      setState(() {
        _isConfirmStep = false;
        _firstPin = null;
      });
      return;
    }

    final success = await widget.onConfirmPin(confirmPin);

    if (success && mounted) {
      Navigator.pop(context);
      widget.onPinCreated();
    } else if (mounted) {
      _confirmPinKey.currentState?.resetPin();
    }
  }

  @override
  Widget build(BuildContext context) {
    final walletState = ref.watch(walletNotifierProvider);
    final isLoading = walletState.isCreatingPin;
    final errorMessage = walletState.pinErrorMessage;

    if (_isConfirmStep) {
      return PinEntryScreen(
        key: _confirmPinKey,
        title: 'Confirm Wallet PIN',
        subtitle: 'Re-enter your PIN to confirm',
        pinLength: 4,
        isLoading: isLoading,
        errorMessage: errorMessage,
        onErrorDismissed: () {
          ref.read(walletNotifierProvider.notifier).clearPinError();
        },
        onSubmit: _handleConfirmPinSubmit,
      );
    }

    return PinEntryScreen(
      key: _firstPinKey,
      title: 'Create Wallet PIN',
      subtitle: 'Enter a 4-digit PIN to secure your wallet',
      pinLength: 4,
      onSubmit: _handleFirstPinSubmit,
    );
  }
}
