import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kipa/core/shared/widgets/custom_snackbar.dart';
import 'package:kipa/core/shared/widgets/custom_text.dart';
import 'package:kipa/core/shared/widgets/widgets.dart';
import 'package:kipa/theme/app_colors.dart';
import 'package:kipa/utils/constant.dart';
import '../providers/bank_accounts_provider.dart';
import 'add_bank_account_screen.dart';

class BankAccountsListScreen extends ConsumerStatefulWidget {
  const BankAccountsListScreen({super.key});

  @override
  ConsumerState<BankAccountsListScreen> createState() =>
      _BankAccountsListScreenState();
}

class _BankAccountsListScreenState
    extends ConsumerState<BankAccountsListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(bankAccountsNotifierProvider.notifier).getBankAccounts();
    });
  }

  Future<void> _handleSetDefault(String id) async {
    final success = await ref
        .read(bankAccountsNotifierProvider.notifier)
        .setDefaultBankAccount(id);

    if (mounted) {
      if (success) {
        CustomSnackBar.show(
          context,
          message: 'Default account updated',
          type: SnackBarType.success,
        );
      } else {
        final errorMessage =
            ref.read(bankAccountsNotifierProvider).errorMessage ??
            'Failed to update default account';
        CustomSnackBar.show(
          context,
          message: errorMessage,
          type: SnackBarType.error,
        );
      }
    }
  }

  Future<void> _handleDelete(String id) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog.adaptive(
        title: const Text('Delete Bank Account'),
        content: const Text(
          'Are you sure you want to delete this bank account?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      final success = await ref
          .read(bankAccountsNotifierProvider.notifier)
          .deleteBankAccount(id);

      if (mounted) {
        if (success) {
          CustomSnackBar.show(
            context,
            message: 'Bank account deleted',
            type: SnackBarType.success,
          );
        } else {
          final errorMessage =
              ref.read(bankAccountsNotifierProvider).errorMessage ??
              'Failed to delete bank account';
          CustomSnackBar.show(
            context,
            message: errorMessage,
            type: SnackBarType.error,
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(bankAccountsNotifierProvider);
    final bankAccounts = state.bankAccounts;

    return Scaffold(
      appBar: AppBar(
        title: const H4('Bank Accounts'),
        centerTitle: true,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        elevation: 0,
      ),
      body: state.isFetchingBankAccounts && bankAccounts.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: () async {
                await ref
                    .read(bankAccountsNotifierProvider.notifier)
                    .getBankAccounts();
              },
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (bankAccounts.isEmpty)
                      Expanded(
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.account_balance,
                                size: 64,
                                color: Colors.grey.shade300,
                              ),
                              verticalSpace(16),
                              const Caption(
                                'No bank accounts added yet',
                                color: AppColor.lightText,
                              ),
                              verticalSpace(8),
                              const Caption(
                                'Add a bank account to receive withdrawals',
                                color: AppColor.lightText,
                              ),
                            ],
                          ),
                        ),
                      )
                    else
                      Expanded(
                        child: ListView.builder(
                          itemCount: bankAccounts.length,
                          itemBuilder: (context, index) {
                            final account = bankAccounts[index];
                            return _BankAccountCard(
                              account: account,
                              onSetDefault: () => _handleSetDefault(account.id),
                              onDelete: () => _handleDelete(account.id),
                            );
                          },
                        ),
                      ),
                  ],
                ),
              ),
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddBankAccountScreen(),
            ),
          );
        },
        backgroundColor: AppColor.primary,
        label: const BodySmall(
          'Add Bank Account',
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
        icon: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

class _BankAccountCard extends StatelessWidget {
  final dynamic account;
  final VoidCallback onSetDefault;
  final VoidCallback onDelete;

  const _BankAccountCard({
    required this.account,
    required this.onSetDefault,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: account.isDefault
              ? AppColor.primary.withValues(alpha: 0.3)
              : Colors.grey.shade200,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColor.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.account_balance,
                  color: AppColor.primary,
                  size: 20,
                ),
              ),
              horizontalSpace(12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BodySmall(account.bankName, fontWeight: FontWeight.w600),
                    verticalSpace(4),
                    Caption(account.accountNumber),
                  ],
                ),
              ),
              if (account.isDefault)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColor.green.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Overline(
                    'Default',
                    color: AppColor.green,
                    fontWeight: FontWeight.w600,
                  ),
                ),
            ],
          ),
          verticalSpace(12),
          Caption(account.accountName, color: AppColor.lightText),
          verticalSpace(4),
          Row(
            children: [
              if (!account.isDefault)
                Expanded(
                  child: OutlinedButton(
                    onPressed: onSetDefault,
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColor.primary),
                      foregroundColor: AppColor.primary,
                    ),
                    child: const BodySmall(
                      'Set as Default',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              if (!account.isDefault) horizontalSpace(12),
              if (!account.isDefault)
                GestureDetector(
                  onTap: onDelete,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColor.errorColor),
                    ),
                    child: const Icon(
                      Icons.delete_outline,
                      size: 18,
                      color: AppColor.errorColor,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
