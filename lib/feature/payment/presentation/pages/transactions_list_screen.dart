import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:kipa/core/shared/widgets/buttons/roundedbutton.dart';
import 'package:kipa/core/shared/widgets/custom_text.dart';
import 'package:kipa/core/routes/route_names.dart';
import 'package:kipa/feature/delivery/domain/entities/delivery_entities.dart';
import 'package:kipa/feature/payment/domain/enums/payment_request_status.dart';
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
    final status = PaymentRequestStatus.fromString(transaction.status);
    final isInterState =
        transaction.deliveryType.toLowerCase() == 'inter_state';
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
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
            if (transaction.isSeller) ...[
              if (isInterState) ...[
                if (status.canMarkReady &&
                    transaction.logisticsDeliveryId != null) ...[
                  verticalSpace(16),
                  _buildMarkAsShippedButton(transaction),
                ],
              ] else ...[
                if (status.canMarkReady) ...[
                  verticalSpace(16),
                  _buildReadyForPickupButton(transaction),
                ] else if (status == PaymentRequestStatus.searchingRider) ...[
                  verticalSpace(16),
                  _buildSearchingIndicator(transaction),
                ] else if (status.shouldShowTracking) ...[
                  verticalSpace(16),
                  _buildTrackDeliveryButton(transaction, status),
                ],
              ],
            ],
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
      case 'paid_awaiting_fulfillment':
      case 'ready_for_pickup':
      case 'searching_rider':
      case 'rider_assigned':
      case 'in_transit':
      case 'in_delivery':
      case 'processing':
        return AppColor.primary;
      case 'delivered':
      case 'confirmation_window':
        return const Color(0xFF10B981).withAlpha(200);
      case 'completed':
        return const Color(0xFF10B981);
      case 'refunded':
        return const Color(0xFF8B5CF6);
      case 'cancelled':
      case 'disputed':
      case 'no_rider_found':
        return const Color(0xFFEF4444);
      default:
        return AppColor.kipaGrey;
    }
  }

  Widget _buildMarkAsShippedButton(TransactionListItemEntity transaction) {
    return SizedBox(
      width: double.infinity,
      child: CustomButton(
        title: 'Mark as Shipped',
        onTap: () {
          Navigator.pushNamed(
            context,
            RouteNames.shipLogisticsFormRoute,
            arguments: {
              'logisticsDeliveryId': transaction.logisticsDeliveryId,
              'paymentRequestId': transaction.paymentRequestId,
            },
          ).then((result) {
            if (result == true) {
              ref
                  .read(transactionsListNotifierProvider.notifier)
                  .fetchTransactions();
            }
          });
        },
        color: AppColor.primary,
        textColor: Colors.white,
        borderRadius: 15,
        size: 14,
      ),
    );
  }

  Widget _buildReadyForPickupButton(TransactionListItemEntity transaction) {
    return SizedBox(
      width: double.infinity,
      child: CustomButton(
        title: 'Ready for Pickup',
        onTap: () async {
          Navigator.pushNamed(
            context,
            RouteNames.riderSearchRoute,
            arguments: {
              'paymentRequestId': transaction.paymentRequestId,
              'pickupAddress': transaction.pickupAddress,
              'dropoffAddress': transaction.dropoffAddress,
              'pickupLat': transaction.pickupLat,
              'pickupLng': transaction.pickupLng,
              'dropoffLat': transaction.dropoffLat,
              'dropoffLng': transaction.dropoffLng,
            },
          );

          ref
              .read(paymentNotifierProvider.notifier)
              .markReadyForPickup(
                paymentRequestId: transaction.paymentRequestId,
              );
        },
        color: AppColor.primary,
        textColor: Colors.white,
        borderRadius: 15,
        size: 14,
      ),
    );
  }

  Widget _buildSearchingIndicator(TransactionListItemEntity transaction) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            Navigator.pushNamed(
              context,
              RouteNames.riderSearchRoute,
              arguments: {
                'paymentRequestId': transaction.paymentRequestId,
                'pickupAddress': transaction.pickupAddress,
                'dropoffAddress': transaction.dropoffAddress,
                'pickupLat': transaction.pickupLat,
                'pickupLng': transaction.pickupLng,
                'dropoffLat': transaction.dropoffLat,
                'dropoffLng': transaction.dropoffLng,
              },
            );
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: AppColor.primary.withAlpha(20),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: AppColor.primary.withAlpha(60)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(AppColor.primary),
                  ),
                ),
                horizontalSpace(8),
                const BodySmall(
                  'Searching for rider...',
                  fontWeight: FontWeight.w600,
                  color: AppColor.primary,
                ),
                horizontalSpace(4),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 12,
                  color: AppColor.primary,
                ),
              ],
            ),
          ),
        ),
        verticalSpace(8),
        GestureDetector(
          onTap: () async {
            final confirmed = await showDialog<bool>(
              context: context,
              builder: (context) => AlertDialog.adaptive(
                title: const BodySmall(
                  'Cancel Search?',
                  color: AppColor.primary,
                  lineHeight: 2,
                ),
                content: const BodySmall(
                  'Are you sure you want to cancel the rider search?',
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: const BodyText('No'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context, true),
                    child: const BodyText(
                      'Yes, Cancel',
                      color: AppColor.errorColor,
                    ),
                  ),
                ],
              ),
            );

            if (confirmed == true) {
              await ref
                  .read(paymentNotifierProvider.notifier)
                  .cancelRiderSearch(
                    paymentRequestId: transaction.paymentRequestId,
                  );
              ref
                  .read(transactionsListNotifierProvider.notifier)
                  .fetchTransactions();
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: Colors.red.withAlpha(15),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.red.withAlpha(40)),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.close, size: 16, color: Colors.red),
                SizedBox(width: 6),
                BodySmall(
                  'Cancel Search',
                  fontWeight: FontWeight.w500,
                  color: Colors.red,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTrackDeliveryButton(
    TransactionListItemEntity transaction,
    PaymentRequestStatus status,
  ) {
    final deliveryJobId =
        transaction.deliveryJobId ?? transaction.paymentRequestId;

    return SizedBox(
      width: double.infinity,
      child: CustomButton(
        title: status == PaymentRequestStatus.inDelivery
            ? 'Track Delivery'
            : 'View Rider',
        onTap: () {
          String initialStatus = 'searching';
          if (status == PaymentRequestStatus.riderAssigned ||
              status == PaymentRequestStatus.inDelivery) {
            initialStatus = 'accepted';
          }

          final initialJob = DeliveryJobEntity(
            id: deliveryJobId,
            paymentRequestId: transaction.paymentRequestId,
            status: initialStatus,
            rider: null,
            pickupAddress: transaction.pickupAddress ?? '',
            dropoffAddress: transaction.dropoffAddress ?? '',
            pickupLat: transaction.pickupLat,
            pickupLng: transaction.pickupLng,
            dropoffLat: transaction.dropoffLat,
            dropoffLng: transaction.dropoffLng,
            estimatedArrival: null,
            createdAt: transaction.createdAt,
          );

          Navigator.pushNamed(
            context,
            RouteNames.deliveryTrackingRoute,
            arguments: {
              'deliveryJobId': deliveryJobId,
              'initialJob': initialJob,
            },
          );
        },
        color: Colors.green,
        textColor: Colors.white,
        borderRadius: 15,
        size: 14,
      ),
    );
  }
}
