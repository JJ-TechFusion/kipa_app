import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kipa/feature/wallet/presentation/pages/secure_wallet_screen.dart';
import 'package:kipa/feature/wallet/presentation/pages/verify_wallet_pin_screen.dart';
import 'package:kipa/feature/wallet/presentation/pages/wallet_screen.dart';

import '../providers/wallet_provider.dart';

class WalletPinGateScreen extends ConsumerStatefulWidget {
  const WalletPinGateScreen({super.key});

  @override
  ConsumerState<WalletPinGateScreen> createState() =>
      _WalletPinGateScreenState();
}

class _WalletPinGateScreenState extends ConsumerState<WalletPinGateScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkPinStatus();
    });
  }

  Future<void> _checkPinStatus() async {
    await ref.read(walletNotifierProvider.notifier).getPinStatus();
  }

  void _onPinCreatedOrVerified() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final walletState = ref.watch(walletNotifierProvider);
    final pinStatus = walletState.pinStatus;
    final isPinVerified = walletState.isPinVerified;

    if (walletState.isFetchingPinStatus) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (pinStatus == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (!pinStatus.hasPin) {
      return SecureWalletScreen(onPinCreated: _onPinCreatedOrVerified);
    }

    if (!isPinVerified) {
      return VerifyWalletPinScreen(onPinVerified: _onPinCreatedOrVerified);
    }

    return const WalletScreen();
  }
}
