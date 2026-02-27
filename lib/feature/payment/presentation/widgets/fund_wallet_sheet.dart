import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kipa/core/shared/widgets/app_webview_page.dart';
import 'package:kipa/core/shared/widgets/buttons/animated_button.dart';
import 'package:kipa/core/shared/widgets/buttons/roundedbutton.dart';
import 'package:kipa/core/shared/widgets/custom_text.dart';
import 'package:kipa/core/shared/widgets/custom_snackbar.dart';
import 'package:kipa/core/shared/widgets/textfields/custom_field.dart';
import 'package:kipa/feature/wallet/presentation/providers/wallet_provider.dart';
import 'package:kipa/theme/app_colors.dart';
import 'package:kipa/utils/constant.dart';

class FundWalletSheet extends ConsumerStatefulWidget {
  const FundWalletSheet({super.key});

  @override
  ConsumerState<FundWalletSheet> createState() => _FundWalletSheetState();
}

class _FundWalletSheetState extends ConsumerState<FundWalletSheet> {
  int _step = 0; // 0: Options, 1: Amount input
  int _selectedOption = 0;
  final _amountController = TextEditingController();

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _processTopUp() async {
    final amountText = _amountController.text.trim();
    if (amountText.isEmpty) {
      CustomSnackBar.show(
        context,
        message: 'Please enter an amount',
        type: SnackBarType.warning,
      );
      return;
    }

    final amount = double.tryParse(amountText);
    if (amount == null || amount <= 0) {
      CustomSnackBar.show(
        context,
        message: 'Please enter a valid amount',
        type: SnackBarType.warning,
      );
      return;
    }

    final notifier = ref.read(walletNotifierProvider.notifier);
    await notifier.topUpWallet(amount: amount);

    if (!mounted) return;

    final state = ref.read(walletNotifierProvider);

    if (state.errorMessage != null) {
      if (!mounted) return;
      CustomSnackBar.show(
        context,
        message: state.errorMessage!,
        type: SnackBarType.error,
      );
      notifier.clearError();
      return;
    }

    if (state.topUpResponse != null) {
      final response = state.topUpResponse!;
      bool paymentCompleted = false;

      if (!mounted) return;
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => AppWebviewPage(
            pageUrl: response.link,
            onPaymentComplete: () {
              paymentCompleted = true;
            },
          ),
        ),
      );

      if (!mounted) return;

      if (!paymentCompleted) {
        CustomSnackBar.show(
          context,
          message: 'Payment was cancelled',
          type: SnackBarType.warning,
        );
        notifier.clearTopUpResponse();
        return;
      }

      await notifier.verifyTopUp(reference: response.txRef);

      if (!mounted) return;

      final verifyState = ref.read(walletNotifierProvider);

      if (verifyState.verifyTopUpResponse != null) {
        if (!mounted) return;
        CustomSnackBar.show(
          context,
          message: 'Wallet funded successfully!',
          type: SnackBarType.success,
        );
        notifier.clearTopUpResponse();
        Navigator.pop(context);
      } else if (verifyState.errorMessage != null) {
        if (!mounted) return;
        CustomSnackBar.show(
          context,
          message: verifyState.errorMessage!,
          type: SnackBarType.error,
        );
        notifier.clearError();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final walletState = ref.watch(walletNotifierProvider);

    return Container(
      padding: const EdgeInsets.all(20),
      height: MediaQuery.of(context).size.height * 0.4,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColor.kipaGrey.withAlpha(50),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          verticalSpace(24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (_step > 0)
                GestureDetector(
                  onTap: () => setState(() => _step--),
                  child: const Icon(Icons.arrow_back, size: 24),
                )
              else
                const SizedBox(width: 24),

              BodyText(
                _step == 0 ? 'Payment Options' : 'Fund Wallet',
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Icon(Icons.close, color: AppColor.lightText),
              ),
            ],
          ),
          verticalSpace(32),

          if (_step == 0)
            Expanded(child: _buildOptionsStep())
          else
            Expanded(
              child: _buildAmountStep(
                walletState.isToppingUp || walletState.isVerifyingTopUp,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildOptionsStep() {
    return Column(
      children: [
        const Align(
          alignment: Alignment.centerLeft,
          child: BodySmall(
            'Choose a Payment Method',
            fontWeight: FontWeight.w600,
          ),
        ),
        verticalSpace(4),
        const Align(
          alignment: Alignment.centerLeft,
          child: Caption(
            'Fund your wallet with Flutterwave.',
            color: AppColor.lightText,
          ),
        ),
        verticalSpace(24),
        _buildOptionItem(
          0,
          'Flutterwave',
          'For local and international payments',
        ),

        const Spacer(),
      ],
    );
  }

  Widget _buildAmountStep(bool isLoading) {
    return Column(
      children: [
        const Align(
          alignment: Alignment.centerLeft,
          child: BodyText(
            'Top-up your wallet with any amount',
            color: AppColor.lightText,
          ),
        ),
        verticalSpace(24),
        TextInputField(
          label: '',
          hintText: 'Enter Amount',
          inputType: TextInputType.number,
          controller: _amountController,
          suffixIcon: Container(
            margin: const EdgeInsets.all(8),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFFE8EAF6),
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Caption(
              'NGN',
              color: AppColor.primary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const Spacer(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: AnimatedButton(
            onTap: isLoading ? null : _processTopUp,
            child: CustomButton(
              title: isLoading ? 'Processing...' : 'Continue',
              borderRadius: 30,
              color: AppColor.primary,
              isLoading: isLoading,
            ),
          ),
        ),
        verticalSpace(20),
      ],
    );
  }

  Widget _buildOptionItem(int index, String title, String subtitle) {
    final isSelected = _selectedOption == index;
    return GestureDetector(
      onTap: () {
        setState(() => _selectedOption = index);
        Future.delayed(const Duration(milliseconds: 300), () {
          setState(() => _step = 1);
        });
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: AppColor.kipaGrey.withAlpha(50)),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: const BoxDecoration(
                color: Color(0xFFE8EAF6),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.language,
                color: AppColor.primary,
                size: 20,
              ),
            ),
            horizontalSpace(16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BodyText(title, fontWeight: FontWeight.w600),
                  verticalSpace(2),
                  Caption(subtitle, color: AppColor.lightText),
                ],
              ),
            ),
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? AppColor.primary : AppColor.kipaGrey,
                ),
              ),
              child: isSelected
                  ? const Center(
                      child: Icon(
                        Icons.circle,
                        size: 12,
                        color: AppColor.primary,
                      ),
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
