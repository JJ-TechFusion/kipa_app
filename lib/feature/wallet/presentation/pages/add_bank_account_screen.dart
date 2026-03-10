import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kipa/core/shared/widgets/custom_snackbar.dart';
import 'package:kipa/core/shared/widgets/dropdown.dart';
import 'package:kipa/core/shared/widgets/widgets.dart';
import 'package:kipa/theme/app_colors.dart';
import 'package:kipa/utils/constant.dart';
import '../../../../core/shared/widgets/buttons/animated_button.dart';
import '../providers/bank_accounts_provider.dart';

class AddBankAccountScreen extends ConsumerStatefulWidget {
  const AddBankAccountScreen({super.key});

  @override
  ConsumerState<AddBankAccountScreen> createState() =>
      _AddBankAccountScreenState();
}

class _AddBankAccountScreenState extends ConsumerState<AddBankAccountScreen> {
  final _formKey = GlobalKey<FormState>();
  final _accountNumberController = TextEditingController();
  String? _selectedBankCode;
  Map<String, String> _bankCodeMap = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(bankAccountsNotifierProvider.notifier).getBanks();
    });
  }

  @override
  void dispose() {
    _accountNumberController.dispose();
    super.dispose();
  }

  Future<void> _resolveAccount() async {
    if (_accountNumberController.text.length == 10 &&
        _selectedBankCode != null) {
      await ref
          .read(bankAccountsNotifierProvider.notifier)
          .resolveAccount(_accountNumberController.text, _selectedBankCode!);
    }
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedBankCode == null) {
      CustomSnackBar.show(
        context,
        message: 'Please select a bank',
        type: SnackBarType.error,
      );
      return;
    }

    final resolvedAccount = ref
        .read(bankAccountsNotifierProvider)
        .resolvedAccount;
    if (resolvedAccount == null) {
      CustomSnackBar.show(
        context,
        message: 'Please verify your account number first',
        type: SnackBarType.error,
      );
      return;
    }

    final success = await ref
        .read(bankAccountsNotifierProvider.notifier)
        .addBankAccount(_selectedBankCode!, _accountNumberController.text);

    if (mounted) {
      if (success) {
        CustomSnackBar.show(
          context,
          message: 'Bank account added successfully',
          type: SnackBarType.success,
        );
        Navigator.pop(context);
      } else {
        final errorMessage =
            ref.read(bankAccountsNotifierProvider).errorMessage ??
            'Failed to add bank account';
        CustomSnackBar.show(
          context,
          message: errorMessage,
          type: SnackBarType.error,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(bankAccountsNotifierProvider);
    final banks = state.banks;

    if (state.isFetchingBanks) {
      _bankCodeMap = {};
    } else {
      _bankCodeMap = {for (var bank in banks) bank.name: bank.code};
    }

    final bankNames = _bankCodeMap.keys.toList()..sort();

    return Scaffold(
      appBar: AppBar(
        title: const H4('Add Bank Account'),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: state.isFetchingBanks
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const BodyText(
                      'Add your bank account details to receive withdrawals',
                      color: AppColor.lightText,
                    ),
                    verticalSpace(12),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF4E5),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Caption(
                        'Microfinance banks are not supported for withdrawals. Please add a commercial bank account instead.',
                        color: AppColor.primaryText,
                      ),
                    ),
                    verticalSpace(24),
                    DropDownWidget(
                      label: 'Select Bank',
                      hintText: 'Choose your bank',
                      initialValue: bankNames,
                      showSearch: true,
                      onSelect: (value) {
                        setState(() {
                          _selectedBankCode = _bankCodeMap[value];
                        });
                        _resolveAccount();
                      },
                    ),
                    verticalSpace(20),
                    const BodySmall(
                      'Account Number',
                      color: AppColor.darkPrimary,
                      fontWeight: FontWeight.w500,
                    ),
                    verticalSpace(8),
                    TextInputField(
                      controller: _accountNumberController,
                      hintText: "",
                      inputType: TextInputType.number,
                      onChanged: (value) {
                        if (value.length == 10) {
                          _resolveAccount();
                        } else {
                          ref
                              .read(bankAccountsNotifierProvider.notifier)
                              .clearResolvedAccount();
                        }
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter account number';
                        }
                        if (value.length != 10) {
                          return 'Account number must be 10 digits';
                        }
                        return null;
                      },
                    ),
                    verticalSpace(16),
                    if (state.isResolvingAccount)
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                            horizontalSpace(12),
                            const Caption('Verifying account...'),
                          ],
                        ),
                      )
                    else if (state.resolvedAccount != null)
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColor.green.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: AppColor.green.withValues(alpha: 0.3),
                          ),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.check_circle,
                              color: AppColor.green,
                              size: 20,
                            ),
                            horizontalSpace(12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Caption(
                                    'Account Name',
                                    color: AppColor.lightText,
                                  ),
                                  verticalSpace(2),
                                  BodySmall(
                                    state.resolvedAccount!.accountName,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    else if (state.errorMessage != null &&
                        _accountNumberController.text.length == 10 &&
                        _selectedBankCode != null)
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.red.shade50,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.red.shade200),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.error_outline,
                              color: Colors.red.shade700,
                              size: 20,
                            ),
                            horizontalSpace(12),
                            Expanded(
                              child: Caption(
                                state.errorMessage!,
                                color: Colors.red.shade700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    verticalSpace(24),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 36.0),
                      child: AnimatedButton(
                        onTap:
                            state.isAddingBankAccount ||
                                state.resolvedAccount == null
                            ? null
                            : _handleSubmit,
                        child: state.isAddingBankAccount
                            ? Center(
                                child: const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                ),
                              )
                            : CustomButton(
                                title: 'Add Bank Account',
                                borderRadius: 20,
                                color: state.resolvedAccount == null
                                    ? Colors.grey
                                    : null,
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
