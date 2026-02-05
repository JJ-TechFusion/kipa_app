import 'package:flutter/material.dart';
import 'package:kipa/core/shared/widgets/buttons/animated_button.dart';
import 'package:kipa/core/shared/widgets/buttons/roundedbutton.dart';
import 'package:kipa/core/shared/widgets/custom_text.dart';
import 'package:kipa/feature/payment/presentation/widgets/buyer_info_card.dart';
import 'package:kipa/feature/payment/presentation/widgets/fund_wallet_sheet.dart';
import 'package:kipa/feature/payment/presentation/widgets/transaction_details_card.dart';
import 'package:kipa/theme/app_colors.dart';
import 'package:kipa/utils/constant.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/shared/widgets/app_webview_page.dart';
import '../../presentation/providers/payment_provider.dart';
import 'package:kipa/feature/wallet/presentation/providers/wallet_provider.dart';
import 'package:kipa/core/routes/route_names.dart';
import 'package:kipa/core/shared/widgets/custom_snackbar.dart';

class BuyerPaymentDetailsScreen extends ConsumerStatefulWidget {
  final String paymentCode;
  const BuyerPaymentDetailsScreen({super.key, required this.paymentCode});

  @override
  ConsumerState<BuyerPaymentDetailsScreen> createState() =>
      _BuyerPaymentDetailsScreenState();
}

class _BuyerPaymentDetailsScreenState
    extends ConsumerState<BuyerPaymentDetailsScreen> {
  int _selectedPaymentMethod = 0; // 0: Wallet, 1: Paystack
  bool _isConditionsAccepted = false;
  bool _isEscrowAccepted = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(paymentNotifierProvider.notifier)
          .getPaymentDetails(paymentCode: widget.paymentCode);
      ref.read(walletNotifierProvider.notifier).getWallet();
    });
  }

  String _formatAmount(double amount) {
    return '₦${amount.toStringAsFixed(2).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')}';
  }

  @override
  Widget build(BuildContext context) {
    final paymentState = ref.watch(paymentNotifierProvider);
    final details = paymentState.paymentDetails;
    final walletState = ref.watch(walletNotifierProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: AppColor.primary,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
          ),
        ),
        title: const BodyText(
          'Pay via Link',
          fontWeight: FontWeight.w600,
          fontSize: 18,
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: paymentState.isFetchingPaymentDetails
          ? const Center(child: CircularProgressIndicator())
          : paymentState.errorMessage != null && details == null
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(paymentState.errorMessage ?? 'Failed to load details'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      ref
                          .read(paymentNotifierProvider.notifier)
                          .getPaymentDetails(paymentCode: widget.paymentCode);
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  verticalSpace(10),
                  TransactionDetailsCard(
                    itemName: details?.items.isNotEmpty == true
                        ? details!.items.first.name
                        : 'Payment',
                    itemSpecs: details?.description ?? '',
                    itemPrice: _formatAmount(
                      details?.items.isNotEmpty == true
                          ? details!.items.first.price
                          : 0,
                    ),
                    buyerFee: _formatAmount(
                      (details?.totalAmount ?? 0) -
                          (details?.items.isNotEmpty == true
                              ? details!.items.first.price
                              : 0),
                    ),
                    deliveryFee:
                        details?.fulfillment?.estimatedDeliveryFee != null
                        ? _formatAmount(
                            details!.fulfillment!.estimatedDeliveryFee!,
                          )
                        : null,
                    buyerTotal: _formatAmount(details?.totalAmount ?? 0),
                    totalLabel: 'You Pay (in app)',

                    isReceived: false,
                  ),
                  verticalSpace(32),

                  BuyerInfoCard(
                    name: details?.seller?.name ?? 'Seller',
                    email: details?.seller?.email ?? '',
                    phone: details?.seller?.phone ?? '',
                    onCall: () {},
                    title: 'Seller Information',
                    roleLabel: 'Seller',
                  ),
                  verticalSpace(32),

                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColor.processingWindowBackground,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(
                              Icons.access_time,
                              size: 16,
                              color: AppColor.primaryText,
                            ),
                            SizedBox(width: 8),
                            BodyText(
                              'Processing Time',
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                          ],
                        ),
                        verticalSpace(8),
                        const Caption(
                          'It will take within 0-3 days for your seller to dispatch your item for delivery. You will be refunded if your item is not dispatched within this time-frame',
                          fontSize: 11,
                          color: AppColor.kipaGrey2,
                        ),
                      ],
                    ),
                  ),
                  verticalSpace(32),

                  const BodyText('Payment Method', fontWeight: FontWeight.w600),
                  verticalSpace(16),

                  _buildPaymentMethodOption(
                    index: 0,
                    title: 'Wallet',
                    subtitle:
                        'Balance: ${_formatAmount(walletState.wallet?.availableBalance ?? 0)}',
                    icon: Icons.account_balance_wallet_outlined,
                  ),
                  verticalSpace(12),
                  _buildPaymentMethodOption(
                    index: 1,
                    title: 'Pay Online',
                    subtitle: 'Pay with Paystack',
                    icon: Icons.language,
                  ),

                  verticalSpace(32),

                  _buildCheckboxRow(
                    value: _isConditionsAccepted,
                    onChanged: (val) =>
                        setState(() => _isConditionsAccepted = val!),
                    text:
                        'I have reviewed the item description and above information and I confirm that this is what I am ordering',
                  ),
                  verticalSpace(16),
                  _buildCheckboxRow(
                    value: _isEscrowAccepted,
                    onChanged: (val) =>
                        setState(() => _isEscrowAccepted = val!),
                    text:
                        'I agree to the Terms & Conditions and acknowledge that the funds will be held in escrow until after I have confirmed delivery',
                    isRich: true,
                  ),
                  verticalSpace(40),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 42),
                    child: AnimatedButton(
                      onTap: () async {
                        if (!_isConditionsAccepted || !_isEscrowAccepted) {
                          if (!context.mounted) return;
                          CustomSnackBar.show(
                            context,
                            message: 'Please accept terms and conditions',
                            type: SnackBarType.warning,
                          );
                          return;
                        }

                        final notifier = ref.read(
                          paymentNotifierProvider.notifier,
                        );

                        if (_selectedPaymentMethod == 0) {
                          await notifier.initializePayment(
                            paymentCode: widget.paymentCode,
                            paymentMethod: 'wallet',
                          );
                        } else {
                          await notifier.initializePayment(
                            paymentCode: widget.paymentCode,
                            paymentMethod: 'card',
                          );
                        }

                        if (!context.mounted) return;

                        final state = ref.read(paymentNotifierProvider);

                        if (state.errorMessage != null) {
                          CustomSnackBar.show(
                            context,
                            message: state.errorMessage!,
                            type: SnackBarType.error,
                          );
                          notifier.clearError();
                          return;
                        }

                        if (state.initializePaymentResponse != null) {
                          final response = state.initializePaymentResponse!;

                          if (_selectedPaymentMethod == 1) {
                            if (!context.mounted) return;
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => AppWebviewPage(
                                  pageUrl: response.authorizationUrl,
                                ),
                              ),
                            );

                            if (!context.mounted) return;

                            await notifier.verifyPayment(
                              paymentCode: widget.paymentCode,
                              reference: response.reference,
                            );

                            if (!context.mounted) return;

                            final verifyState = ref.read(
                              paymentNotifierProvider,
                            );
                            if (verifyState.errorMessage != null) {
                              CustomSnackBar.show(
                                context,
                                message: verifyState.errorMessage!,
                                type: SnackBarType.error,
                              );
                            } else if (verifyState.verifyPaymentResponse !=
                                null) {
                              Navigator.pushNamedAndRemoveUntil(
                                context,
                                RouteNames.buyerPaymentSuccessRoute,
                                (route) => route.isFirst,
                              );
                            }
                          } else {
                            // Wallet payment success
                            if (!context.mounted) return;
                            Navigator.pushNamedAndRemoveUntil(
                              context,
                              RouteNames.buyerPaymentSuccessRoute,
                              (route) => route.isFirst,
                            );
                          }
                        }
                      },

                      child: Consumer(
                        builder: (context, ref, child) {
                          final state = ref.watch(paymentNotifierProvider);
                          return CustomButton(
                            title: state.isInitializingPayment
                                ? 'Processing...'
                                : 'Pay ${_formatAmount(details?.totalAmount ?? 0)}',
                            borderRadius: 30,
                            isLoading: state.isInitializingPayment,
                          );
                        },
                      ),
                    ),
                  ),
                  verticalSpace(20),
                ],
              ),
            ),
    );
  }

  Widget _buildPaymentMethodOption({
    required int index,
    required String title,
    required String subtitle,
    required IconData icon,
  }) {
    final isSelected = _selectedPaymentMethod == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedPaymentMethod = index),
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
              child: Icon(icon, color: AppColor.primary, size: 16),
            ),
            horizontalSpace(16),
            Expanded(
              child: Column(
                spacing: 4,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BodySmall(title, fontWeight: FontWeight.w600),
                  if (subtitle.isNotEmpty) ...[
                    verticalSpace(2),
                    Caption(subtitle, color: AppColor.lightText),
                  ],
                ],
              ),
            ),
            if (index == 0) ...[
              GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (c) => const FundWalletSheet(),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColor.processingWindowBackground,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    'Fund Wallet',
                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              horizontalSpace(8),
            ],
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

  Widget _buildCheckboxRow({
    required bool value,
    required Function(bool?) onChanged,
    required String text,
    bool isRich = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColor.scaffoldBackground,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 24,
            height: 24,
            child: Checkbox(
              value: value,
              onChanged: onChanged,
              activeColor: AppColor.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
          horizontalSpace(12),
          Expanded(
            child: isRich
                ? RichText(
                    text: const TextSpan(
                      style: TextStyle(
                        color: AppColor.kipaGrey2,
                        fontSize: 12,
                        fontFamily: 'Plus Jakarta Sans',
                      ),
                      children: [
                        TextSpan(text: 'I agree to the '),
                        TextSpan(
                          text: 'Terms & Conditions',
                          style: TextStyle(
                            color: AppColor.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        TextSpan(
                          text:
                              ' and acknowledge that the funds will be held in escrow until after I have confirmed delivery',
                        ),
                      ],
                    ),
                  )
                : Caption(text, color: AppColor.kipaGrey2, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
