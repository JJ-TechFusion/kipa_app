import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:kipa/core/shared/widgets/custom_text.dart';
import 'package:kipa/core/routes/route_names.dart';
import 'package:kipa/theme/app_colors.dart';
import 'package:kipa/utils/constant.dart';
import '../../domain/entities/transaction_list_entity.dart';
import '../providers/payment_provider.dart';

class TransactionsListScreen extends ConsumerStatefulWidget {
  const TransactionsListScreen({super.key});

  @override
  ConsumerState<TransactionsListScreen> createState() =>
      _TransactionsListScreenState();
}

class _TransactionsListScreenState
    extends ConsumerState<TransactionsListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      ref.read(transactionsListNotifierProvider.notifier).fetchTransactions();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(transactionsListNotifierProvider);
    final notifier = ref.read(transactionsListNotifierProvider.notifier);

    return Scaffold(
      backgroundColor: AppColor.scaffoldBackground,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              verticalSpace(16),
              Center(child: const H4('Transactions')),
              verticalSpace(16),
              Row(
                children: [
                  _buildFilterChip(
                    'All',
                    'all',
                    state.selectedFilter,
                    notifier,
                  ),
                  horizontalSpace(8),
                  _buildFilterChip(
                    'Active',
                    'active',
                    state.selectedFilter,
                    notifier,
                  ),
                  horizontalSpace(8),
                  _buildFilterChip(
                    'Completed',
                    'completed',
                    state.selectedFilter,
                    notifier,
                  ),
                ],
              ),
              verticalSpace(16),
              Expanded(
                child: state.isFetching
                    ? const Center(child: CircularProgressIndicator())
                    : state.errorMessage != null
                    ? _buildErrorState(state.errorMessage!, notifier)
                    : state.transactions == null || state.transactions!.isEmpty
                    ? _buildEmptyState()
                    : RefreshIndicator(
                        onRefresh: () => notifier.fetchTransactions(),
                        child: ListView.separated(
                          itemCount: state.transactions!.length,
                          separatorBuilder: (_, _) => verticalSpace(12),
                          itemBuilder: (context, index) {
                            return _buildTransactionCard(
                              context,
                              state.transactions![index],
                            );
                          },
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterChip(
    String label,
    String value,
    String selected,
    dynamic notifier,
  ) {
    final isSelected = value == selected;
    return GestureDetector(
      onTap: () => notifier.setFilter(value),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColor.primary : Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Caption(
          label,
          color: isSelected ? Colors.white : AppColor.primaryText,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
        ),
      ),
    );
  }

  Widget _buildTransactionCard(
    BuildContext context,
    TransactionListItemEntity transaction,
  ) {
    final currencyFormatter = NumberFormat.currency(
      symbol: '\u20A6',
      decimalDigits: 2,
    );
    final dateFormatter = DateFormat('MMM d, yyyy');

    final statusColor = _statusColor(transaction.status);
    final initials = transaction.counterpartyName
        .trim()
        .split(' ')
        .where((w) => w.isNotEmpty)
        .take(2)
        .map((w) => w[0].toUpperCase())
        .join();

    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          RouteNames.transactionStatusRoute,
          arguments: {'paymentRequestId': transaction.paymentRequestId},
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 22,
              backgroundColor: AppColor.primary.withAlpha(30),
              child: Text(
                initials,
                style: const TextStyle(
                  color: AppColor.primary,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ),
            horizontalSpace(12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BodySmall(
                    transaction.itemName,
                    fontWeight: FontWeight.w600,
                    color: AppColor.primaryText,
                  ),
                  verticalSpace(10),
                  Caption(
                    '${transaction.counterpartyRole}: ${transaction.counterpartyName}',
                    color: AppColor.lightText,
                  ),
                  verticalSpace(2),
                  Caption(
                    dateFormatter.format(transaction.createdAt),
                    color: AppColor.lightText,
                  ),
                ],
              ),
            ),
            Column(
              spacing: 8,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                BodySmall(
                  currencyFormatter.format(transaction.itemPrice),
                  fontWeight: FontWeight.w600,
                  color: AppColor.primaryText,
                ),
                verticalSpace(6),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withAlpha(25),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Caption(
                    transaction.statusText,
                    color: statusColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.receipt_long_outlined,
            size: 64,
            color: AppColor.kipaGrey.withAlpha(80),
          ),
          verticalSpace(16),
          const BodySmall('No transactions yet', color: AppColor.lightText),
        ],
      ),
    );
  }

  Widget _buildErrorState(String message, dynamic notifier) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.error_outline, size: 48, color: Colors.red.withAlpha(150)),
          verticalSpace(12),
          BodySmall(message, color: AppColor.lightText),
          verticalSpace(12),
          TextButton(
            onPressed: () => notifier.fetchTransactions(),
            child: const BodySmall('Retry', color: AppColor.primary),
          ),
        ],
      ),
    );
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'pending':
      case 'awaiting_payment':
        return const Color(0xFFF59E0B);
      case 'paid':
      case 'in_transit':
      case 'processing':
        return AppColor.primary;
      case 'completed':
      case 'delivered':
        return const Color(0xFF10B981);
      case 'refunded':
        return const Color(0xFF8B5CF6);
      case 'cancelled':
      case 'disputed':
        return const Color(0xFFEF4444);
      default:
        return AppColor.kipaGrey;
    }
  }
}
