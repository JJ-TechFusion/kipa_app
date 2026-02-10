import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kipa/core/shared/widgets/buttons/roundedbutton.dart';
import 'package:kipa/core/shared/widgets/custom_text.dart';
import 'package:kipa/core/shared/widgets/custom_snackbar.dart';
import 'package:kipa/feature/payment/presentation/widgets/payment_link_card.dart';
import 'package:kipa/core/routes/route_names.dart';
import 'package:kipa/theme/app_colors.dart';
import 'package:kipa/utils/constant.dart';
import '../providers/payment_provider.dart';

class PaymentLinkListScreen extends ConsumerStatefulWidget {
  const PaymentLinkListScreen({super.key});

  @override
  ConsumerState<PaymentLinkListScreen> createState() =>
      _PaymentLinkListScreenState();
}

class _PaymentLinkListScreenState extends ConsumerState<PaymentLinkListScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {});
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(paymentNotifierProvider.notifier).fetchPaymentRequests();
      ref.read(paymentNotifierProvider.notifier).fetchPaymentRequestHistory();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.scaffoldBackground,
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
          'Create payment link',
          fontWeight: FontWeight.w600,
          fontSize: 18,
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Column(
        children: [
          verticalSpace(20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                _buildTabItem(0, "Active Links"),
                horizontalSpace(20),
                _buildTabItem(1, "Link History"),
              ],
            ),
          ),
          verticalSpace(20),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [_buildActiveLinks(), _buildLinkHistory()],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 42, vertical: 16),
            child: CustomButton(
              title: 'Create Payment Request',
              onTap: () {
                Navigator.pushNamed(
                  context,
                  RouteNames.createLinkActionRoute,
                  arguments: {'isEdit': false},
                ).then((_) {
                  ref
                      .read(paymentNotifierProvider.notifier)
                      .fetchPaymentRequests();
                });
              },
              borderRadius: 30,
            ),
          ),
          verticalSpace(20),
        ],
      ),
    );
  }

  Widget _buildTabItem(int index, String title) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _tabController.animateTo(index);
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: _tabController.index == index
              ? AppColor.pendingBalanceBackground
              : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: BodySmall(
          title,
          color: _tabController.index == index
              ? AppColor.primary
              : AppColor.lightText,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildActiveLinks() {
    final state = ref.watch(paymentNotifierProvider);

    if (state.isFetchingPaymentRequests) {
      return const Center(
        child: CircularProgressIndicator(color: AppColor.primary),
      );
    }

    if (state.errorMessage != null && state.paymentRequests == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: AppColor.kipaGrey),
            verticalSpace(16),
            BodyText(
              'Error: ${state.errorMessage}',
              color: AppColor.kipaGrey,
              textAlign: TextAlign.center,
            ),
            verticalSpace(16),
            TextButton(
              onPressed: () {
                ref
                    .read(paymentNotifierProvider.notifier)
                    .fetchPaymentRequests();
              },
              child: const BodySmall('Retry', color: AppColor.primary),
            ),
          ],
        ),
      );
    }

    final links = state.paymentRequests ?? [];

    if (links.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.link_off, size: 48, color: AppColor.kipaGrey),
            verticalSpace(16),
            const BodyText('No active payment links', color: AppColor.kipaGrey),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: links.length,
      separatorBuilder: (context, index) => verticalSpace(16),
      itemBuilder: (context, index) {
        final link = links[index];

        return PaymentLinkCard(
          data: {
            'id': link.id,
            'status': link.status,
            'date': 'Created ${_formatDate(link.createdAt)}',
            'itemName': link.itemName,
            'specs': link.itemDescription,
            'amount': link.itemPrice.toStringAsFixed(2),
            'isReusable': link.isReusable,
            'pickupAddress': link.pickupAddress,
            'dropoffAddress': link.dropoffAddress,
            'delivery_job_id': link.deliveryJobId,
            'pickup_lat': link.pickupLat,
            'pickup_lng': link.pickupLng,
            'dropoff_lat': link.dropoffLat,
            'dropoff_lng': link.dropoffLng,
          },
          onReuse: () {
            Navigator.pushNamed(
              context,
              RouteNames.fulfillmentFormRoute,
              arguments: {
                'paymentRequestId': link.id,
                'itemName': link.itemName,
                'itemPrice': link.itemPrice,
              },
            );
          },
          onEdit: () {
            Navigator.pushNamed(
              context,
              RouteNames.createLinkActionRoute,
              arguments: {
                'isEdit': true,
                'paymentRequest': {
                  'id': link.id,
                  'itemName': link.itemName,
                  'itemDescription': link.itemDescription,
                  'amount': link.itemPrice,
                  'processingTimeHours': 24,
                  'isReusable': link.isReusable,
                },
              },
            ).then((_) {
              ref.read(paymentNotifierProvider.notifier).fetchPaymentRequests();
            });
          },
          onDelete: () => _confirmDelete(context, link.id),
        );
      },
    );
  }

  Widget _buildLinkHistory() {
    final state = ref.watch(paymentNotifierProvider);

    if (state.isFetchingPaymentHistory) {
      return const Center(
        child: CircularProgressIndicator(color: AppColor.primary),
      );
    }

    if (state.errorMessage != null && state.paymentRequestHistory == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: AppColor.kipaGrey),
            verticalSpace(16),
            BodyText(
              'Error: ${state.errorMessage}',
              color: AppColor.kipaGrey,
              textAlign: TextAlign.center,
            ),
            verticalSpace(16),
            TextButton(
              onPressed: () {
                ref
                    .read(paymentNotifierProvider.notifier)
                    .fetchPaymentRequestHistory();
              },
              child: const BodySmall('Retry', color: AppColor.primary),
            ),
          ],
        ),
      );
    }

    final history = state.paymentRequestHistory ?? [];

    if (history.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.history, size: 48, color: AppColor.kipaGrey),
            verticalSpace(16),
            const BodyText('No payment link history', color: AppColor.kipaGrey),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: history.length,
      separatorBuilder: (context, index) => verticalSpace(16),
      itemBuilder: (context, index) {
        final link = history[index];

        return PaymentLinkCard(
          data: {
            'id': link.id,
            'status': link.status,
            'date': 'Created ${_formatDate(link.createdAt)}',
            'itemName': link.itemName,
            'specs': link.itemDescription,
            'amount': link.itemPrice.toStringAsFixed(2),
            'delivery_job_id': link.deliveryJobId,
            'pickup_lat': link.pickupLat,
            'pickup_lng': link.pickupLng,
            'dropoff_lat': link.dropoffLat,
            'dropoff_lng': link.dropoffLng,
          },
          onReuse: () {
            Navigator.pushNamed(
              context,
              RouteNames.fulfillmentFormRoute,
              arguments: {
                'paymentRequestId': link.id,
                'itemName': link.itemName,
                'itemPrice': link.itemPrice,
              },
            );
          },
          onEdit: () {},
          onDelete: () {},
        );
      },
    );
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${date.day} ${months[date.month - 1]}, ${date.year}';
  }

  void _confirmDelete(BuildContext context, String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog.adaptive(
        title: const BodyText('Delete Link?', fontWeight: FontWeight.w600),
        content: const Caption(
          'Are you sure you want to delete this payment link? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Caption('Cancel', color: AppColor.kipaGrey),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await ref
                  .read(paymentNotifierProvider.notifier)
                  .deletePaymentRequest(id);

              final state = ref.read(paymentNotifierProvider);
              if (state.deleteResponse?.success == true) {
                if (context.mounted) {
                  CustomSnackBar.show(
                    context,
                    message: 'Payment link deleted successfully',
                    type: SnackBarType.success,
                  );
                  // Refresh the list
                  ref
                      .read(paymentNotifierProvider.notifier)
                      .fetchPaymentRequests();
                }
              } else if (state.errorMessage != null) {
                if (context.mounted) {
                  CustomSnackBar.show(
                    context,
                    message: 'Error: ${state.errorMessage}',
                    type: SnackBarType.error,
                  );
                }
              }
            },
            child: const Caption('Delete', color: Colors.red),
          ),
        ],
      ),
    );
  }
}
