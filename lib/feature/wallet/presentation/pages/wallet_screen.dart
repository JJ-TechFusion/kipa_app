import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kipa/core/shared/widgets/app_webview_page.dart';
import 'package:kipa/core/shared/widgets/custom_snackbar.dart';
import 'package:kipa/core/shared/widgets/smart_image.dart';
import 'package:kipa/feature/payment/presentation/widgets/fund_wallet_sheet.dart';
import 'package:kipa/core/shared/widgets/custom_text.dart';
import 'package:kipa/core/shared/widgets/number_pad.dart';
import 'package:kipa/core/shared/widgets/widgets.dart';
import 'package:kipa/theme/app_colors.dart';
import 'package:kipa/utils/constant.dart';

import '../providers/wallet_provider.dart';

class WalletScreen extends ConsumerStatefulWidget {
  const WalletScreen({super.key});

  @override
  ConsumerState<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends ConsumerState<WalletScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(walletNotifierProvider.notifier).getWallet();
      ref.read(walletNotifierProvider.notifier).getTransactions();
      ref.read(walletNotifierProvider.notifier).getPendingFunds();
    });
  }

  void _showTopUpSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const FundWalletSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final walletState = ref.watch(walletNotifierProvider);
    final wallet = walletState.wallet;

    return Scaffold(
      appBar: AppBar(
        title: const H4("Wallet"),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: walletState.isFetchingWallet
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: () async {
                await ref.read(walletNotifierProvider.notifier).getWallet();
                await ref
                    .read(walletNotifierProvider.notifier)
                    .getTransactions();
                await ref
                    .read(walletNotifierProvider.notifier)
                    .getPendingFunds();
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      verticalSpace(20),
                      _WalletBalanceCard(
                        balance: wallet != null
                            ? formatCurrency(
                                wallet.availableBalance.toStringAsFixed(2),
                              )
                            : '₦0.00',
                        pendingBalance: wallet != null
                            ? formatCurrency(
                                wallet.lockedBalance.toStringAsFixed(2),
                              )
                            : '₦0.00',
                      ),
                      verticalSpace(24),
                      _WalletActionButtons(
                        onTopUp: _showTopUpSheet,
                        onWithdraw: () {},
                      ),
                      verticalSpace(30),
                      const BodyText(
                        "Pending Funds",
                        fontWeight: FontWeight.bold,
                      ),
                      verticalSpace(16),
                      const _PendingFundsList(),
                      verticalSpace(30),
                      const BodyText(
                        "Transactions",
                        fontWeight: FontWeight.bold,
                      ),
                      verticalSpace(16),
                      const _TransactionHistoryList(),
                      verticalSpace(80),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}

class _TopUpAmountSheet extends ConsumerStatefulWidget {
  const _TopUpAmountSheet();

  @override
  ConsumerState<_TopUpAmountSheet> createState() => _TopUpAmountSheetState();
}

class _TopUpAmountSheetState extends ConsumerState<_TopUpAmountSheet> {
  String _amount = '0';

  void _onNumberSelected(String value) {
    setState(() {
      if (_amount == '0') {
        _amount = value;
      } else {
        _amount += value;
      }
    });
  }

  void _onBackspace() {
    setState(() {
      if (_amount.length > 1) {
        _amount = _amount.substring(0, _amount.length - 1);
      } else {
        _amount = '0';
      }
    });
  }

  void _onClear() {
    setState(() {
      _amount = '0';
    });
  }

  String get _formattedAmount {
    final parsed = double.tryParse(_amount) ?? 0;
    return formatCurrency(parsed.toStringAsFixed(2));
  }

  Future<void> _handleTopUp() async {
    final amount = double.tryParse(_amount) ?? 0;
    if (amount <= 0) {
      CustomSnackBar.show(
        context,
        message: 'Please enter a valid amount',
        type: SnackBarType.error,
      );
      return;
    }

    Navigator.pop(context);

    final notifier = ref.read(walletNotifierProvider.notifier);
    await notifier.topUpWallet(amount: amount);

    final state = ref.read(walletNotifierProvider);

    if (state.topUpResponse != null && mounted) {
      final topUpResponse = state.topUpResponse!;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AppWebviewPage(
            pageUrl: topUpResponse.link,
            onPaymentComplete: () async {
              await notifier.verifyTopUp(reference: topUpResponse.txRef);

              if (mounted && context.mounted) {
                final verifyState = ref.read(walletNotifierProvider);
                if (verifyState.verifyTopUpResponse != null) {
                  CustomSnackBar.show(
                    context,
                    message: 'Wallet funded successfully!',
                    type: SnackBarType.success,
                  );
                } else if (verifyState.errorMessage != null) {
                  CustomSnackBar.show(
                    context,
                    message: verifyState.errorMessage!,
                    type: SnackBarType.error,
                  );
                }
              }
            },
          ),
        ),
      );

      notifier.clearTopUpResponse();
    } else if (state.errorMessage != null && mounted) {
      CustomSnackBar.show(
        context,
        message: state.errorMessage!,
        type: SnackBarType.error,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isToppingUp = ref.watch(
      walletNotifierProvider.select((s) => s.isToppingUp),
    );

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            verticalSpace(12),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            verticalSpace(20),
            const BodyText("Fund Wallet"),
            verticalSpace(8),
            const Caption("Enter the amount you want to add"),
            verticalSpace(30),
            H1(_formattedAmount, color: AppColor.primary, fontSize: 36),
            verticalSpace(30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: NumberPad(
                onNumberSelected: _onNumberSelected,
                onBackspace: _onBackspace,
                onClear: _onClear,
                showDecimal: true,
                textColor: Colors.black,
              ),
            ),
            verticalSpace(20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: isToppingUp ? null : _handleTopUp,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    elevation: 0,
                  ),
                  child: isToppingUp
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const BodyText(
                          "Continue",
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                ),
              ),
            ),
            verticalSpace(20),
          ],
        ),
      ),
    );
  }
}

class _WalletBalanceCard extends StatefulWidget {
  final String balance;
  final String pendingBalance;

  const _WalletBalanceCard({
    required this.balance,
    required this.pendingBalance,
  });

  @override
  State<_WalletBalanceCard> createState() => _WalletBalanceCardState();
}

class _WalletBalanceCardState extends State<_WalletBalanceCard> {
  bool _obscureBalance = false;

  void _toggleBalanceVisibility() {
    setState(() {
      _obscureBalance = !_obscureBalance;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
      decoration: BoxDecoration(
        color: AppColor.primary,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          const BodySmall("Wallet Balance", color: Colors.white70),
          verticalSpace(8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              H1(
                _obscureBalance ? "••••••" : widget.balance,
                color: Colors.white,
                fontSize: 32,
              ),
              horizontalSpace(10),
              GestureDetector(
                onTap: _toggleBalanceVisibility,
                child: Icon(
                  _obscureBalance
                      ? CupertinoIcons.eye_slash
                      : CupertinoIcons.eye,
                  color: Colors.white70,
                  size: 20,
                ),
              ),
            ],
          ),
          verticalSpace(20),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Caption(
              "Pending Balance: ${_obscureBalance ? "••••••" : widget.pendingBalance}",
              color: AppColor.lightText,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _WalletActionButtons extends StatelessWidget {
  final VoidCallback onTopUp;
  final VoidCallback onWithdraw;

  const _WalletActionButtons({required this.onTopUp, required this.onWithdraw});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _ActionButton(icon: Icons.add, label: "Top Up", onTap: onTopUp),
        horizontalSpace(40),
        _ActionButton(
          icon: Icons.arrow_downward,
          label: "Withdraw",
          onTap: onWithdraw,
        ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(30),
          child: Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              color: Color(0xFFE8EAF6),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: AppColor.primary, size: 20),
          ),
        ),
        verticalSpace(8),
        Caption(
          label,
          fontWeight: FontWeight.w500,
          color: AppColor.primaryText,
        ),
      ],
    );
  }
}

class _PendingFundsList extends ConsumerWidget {
  const _PendingFundsList();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final walletState = ref.watch(walletNotifierProvider);
    final pendingFunds = walletState.pendingFunds;

    if (walletState.isFetchingPendingFunds && pendingFunds.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: CircularProgressIndicator.adaptive(),
        ),
      );
    }

    if (pendingFunds.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Center(
          child: Column(
            children: [
              Icon(
                Icons.account_balance_wallet_outlined,
                size: 48,
                color: Colors.grey.shade300,
              ),
              verticalSpace(12),
              const Caption('No pending funds', color: AppColor.lightText),
            ],
          ),
        ),
      );
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      clipBehavior: Clip.none,
      child: Row(
        children: pendingFunds.map((fund) {
          return Padding(
            padding: const EdgeInsets.only(right: 16),
            child: _PendingFundCard(
              name: fund.counterParty.name,
              role: fund.role == 'buyer'
                  ? 'Buyer'
                  : (fund.role == 'seller' ? 'Seller' : fund.role),
              item: fund.itemName,
              description: fund.itemDescription,
              amount: formatCurrency(fund.itemAmount.toStringAsFixed(2)),
              status: fund.formattedStatus,
              imageUrl: fund.counterParty.photoUrl.isNotEmpty
                  ? fund.counterParty.photoUrl
                  : "/assets/images/user_placeholder.png",
              expectedRelease: fund.createdAt.add(
                Duration(hours: fund.processingTimeHours),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _PendingFundCard extends StatelessWidget {
  final String name;
  final String role;
  final String item;
  final String description;
  final String amount;
  final String status;
  final String imageUrl;
  final DateTime expectedRelease;

  const _PendingFundCard({
    required this.name,
    required this.role,
    required this.item,
    required this.description,
    required this.amount,
    required this.status,
    required this.imageUrl,
    required this.expectedRelease,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 320,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFE0E7FF),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Overline(
                  status,
                  color: AppColor.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              horizontalSpace(8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFE0F2F1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.verified_user_outlined,
                      size: 10,
                      color: AppColor.green,
                    ),
                    horizontalSpace(4),
                    const Overline(
                      "Kipa Protected",
                      color: AppColor.green,
                      fontWeight: FontWeight.w600,
                    ),
                  ],
                ),
              ),
            ],
          ),
          verticalSpace(12),
          Row(
            children: [
              ClipOval(
                child: SmartImage(
                  imageUrl: imageUrl,
                  width: 40,
                  height: 40,
                  fit: BoxFit.cover,
                ),
              ),
              horizontalSpace(12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BodyText(name, fontWeight: FontWeight.bold),
                  Caption(role),
                ],
              ),
            ],
          ),
          verticalSpace(12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BodySmall(item, fontWeight: FontWeight.w600),
                  verticalSpace(8),
                  Caption(description, fontSize: 10),
                  verticalSpace(4),
                  Caption(
                    "Expected Release: ${expectedRelease.toIso8601String()}",
                    fontSize: 10,
                  ),
                ],
              ),
              BodySmall(amount, fontWeight: FontWeight.bold),
            ],
          ),
        ],
      ),
    );
  }
}

class _TransactionHistoryList extends ConsumerWidget {
  const _TransactionHistoryList();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final walletState = ref.watch(walletNotifierProvider);
    final transactions = walletState.transactions;

    if (walletState.isFetchingTransactions && transactions.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: CircularProgressIndicator.adaptive(),
        ),
      );
    }

    if (transactions.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Center(
          child: Column(
            children: [
              Icon(
                Icons.receipt_long_outlined,
                size: 48,
                color: Colors.grey.shade300,
              ),
              verticalSpace(12),
              const Caption('No transactions yet', color: AppColor.lightText),
            ],
          ),
        ),
      );
    }

    return Column(
      children: transactions.map((tx) {
        final formattedAmount =
            '${tx.isCredit ? '+' : ''}${formatCurrency(tx.amount.abs().toStringAsFixed(2))}';
        return _TransactionTile(
          title: tx.displayTitle,
          date: tx.formattedDate,
          amount: formattedAmount,
          isCredit: tx.isCredit,
          icon: tx.icon,
        );
      }).toList(),
    );
  }
}

class _TransactionTile extends StatelessWidget {
  final String title;
  final String date;
  final String amount;
  final bool isCredit;
  final IconData icon;

  const _TransactionTile({
    required this.title,
    required this.date,
    required this.amount,
    required this.isCredit,
    this.icon = Icons.account_balance_wallet_outlined,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isCredit ? const Color(0xFFE8F5E9) : Colors.grey.shade100,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: isCredit ? AppColor.green : AppColor.primary,
              size: 14,
            ),
          ),
          horizontalSpace(16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BodySmall(title, fontWeight: FontWeight.w500),
                verticalSpace(4),
                Caption(date),
              ],
            ),
          ),
          BodySmall(
            amount,
            fontWeight: FontWeight.bold,
            color: isCredit ? AppColor.green : Colors.black,
          ),
        ],
      ),
    );
  }
}
