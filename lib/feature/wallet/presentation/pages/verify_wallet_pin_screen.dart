import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kipa/core/shared/widgets/pin_entry_screen.dart';

import '../providers/wallet_provider.dart';

class VerifyWalletPinScreen extends ConsumerStatefulWidget {
  final VoidCallback onPinVerified;

  const VerifyWalletPinScreen({super.key, required this.onPinVerified});

  @override
  ConsumerState<VerifyWalletPinScreen> createState() =>
      _VerifyWalletPinScreenState();
}

class _VerifyWalletPinScreenState extends ConsumerState<VerifyWalletPinScreen> {
  final _pinKey = GlobalKey<PinEntryScreenState>();

  Future<void> _handlePinSubmit(String pin) async {
    final notifier = ref.read(walletNotifierProvider.notifier);
    final success = await notifier.verifyPin(pin);

    if (success && mounted) {
      widget.onPinVerified();
    } else if (mounted) {
      _pinKey.currentState?.resetPin();
    }
  }

  @override
  Widget build(BuildContext context) {
    final walletState = ref.watch(walletNotifierProvider);
    final isLoading = walletState.isVerifyingPin;
    final errorMessage = walletState.pinErrorMessage;
    final pinStatus = walletState.pinStatus;

    String? subtitle;
    if (pinStatus != null && pinStatus.isLocked) {
      subtitle = 'Your wallet is locked. Please try again later.';
    } else if (pinStatus != null && pinStatus.attemptsLeft < 5) {
      subtitle = '${pinStatus.attemptsLeft} attempts remaining';
    } else {
      subtitle = 'Enter your 4-digit PIN to access your wallet';
    }

    return PinEntryScreen(
      key: _pinKey,
      title: 'Enter Wallet PIN',
      subtitle: subtitle,
      pinLength: 4,
      isLoading: isLoading,
      errorMessage: errorMessage,
      showBackButton: true,
      onErrorDismissed: () {
        ref.read(walletNotifierProvider.notifier).clearPinError();
      },
      onSubmit: (pinStatus?.isLocked ?? false) ? (_) {} : _handlePinSubmit,
    );
  }
}
