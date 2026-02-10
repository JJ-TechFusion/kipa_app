import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kipa/core/routes/route_names.dart';
import 'package:kipa/core/shared/widgets/custom_text.dart';
import 'package:kipa/feature/delivery/presentation/widgets/delivery_list_item.dart';
import 'package:kipa/feature/purchases/presentation/providers/purchases_provider.dart';
import 'package:kipa/feature/sales/presentation/providers/sales_provider.dart';
import 'package:kipa/theme/app_colors.dart';
import 'package:kipa/utils/constant.dart';

class DeliveriesListScreen extends ConsumerStatefulWidget {
  const DeliveriesListScreen({super.key});

  @override
  ConsumerState<DeliveriesListScreen> createState() =>
      _DeliveriesListScreenState();
}

class _DeliveriesListScreenState extends ConsumerState<DeliveriesListScreen> {
  String _selectedStatus = 'all';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(purchasesNotifierProvider.notifier).fetchPurchases();
      ref.read(salesNotifierProvider.notifier).fetchSales();
    });
  }

  @override
  Widget build(BuildContext context) {
    final purchasesState = ref.watch(purchasesNotifierProvider);
    final salesState = ref.watch(salesNotifierProvider);

    // Filter purchases and sales based on selected status
    final allPurchases = purchasesState.purchases ?? [];
    final allSales = salesState.sales ?? [];

    final purchases = _selectedStatus == 'all'
        ? allPurchases
        : allPurchases.where((p) {
            final status = p.status.toLowerCase();
            return status == _selectedStatus;
          }).toList();

    final sales = _selectedStatus == 'all'
        ? allSales
        : allSales.where((s) {
            final status = s.orderStatus.toLowerCase();
            return status == _selectedStatus;
          }).toList();

    final isLoading =
        purchasesState.isFetchingPurchases || salesState.isFetchingSales;
    final hasData = purchases.isNotEmpty || sales.isNotEmpty;

    return Scaffold(
      backgroundColor: AppColor.scaffoldBackground,
      appBar: AppBar(
        title: const BodyText(
          'Deliveries',
          fontWeight: FontWeight.w600,
          fontSize: 18,
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          // Status filter pills
          _buildStatusFilters(),
          verticalSpace(16),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator.adaptive())
                : !hasData
                ? _buildEmptyState()
                : RefreshIndicator.adaptive(
                    onRefresh: () async {
                      await Future.wait([
                        ref
                            .read(purchasesNotifierProvider.notifier)
                            .fetchPurchases(),
                        ref.read(salesNotifierProvider.notifier).fetchSales(),
                      ]);
                    },
                    child: ListView.separated(
                      itemCount: purchases.length + sales.length,
                      separatorBuilder: (context, index) => verticalSpace(16),
                      itemBuilder: (context, index) {
                        if (index < purchases.length) {
                          final item = purchases[index];
                          return DeliveryListItem(
                            purchase: item,
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                RouteNames.deliveryDetailsRoute,
                                arguments: {
                                  'deliveryJobId': item.delivery?.jobId ?? '',
                                  'purchaseId': item.id,
                                  'isBuyer': true,
                                },
                              );
                            },
                          );
                        } else {
                          final saleIndex = index - purchases.length;
                          final item = sales[saleIndex];
                          return DeliveryListItem(
                            sale: item,
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                RouteNames.deliveryDetailsRoute,
                                arguments: {
                                  'deliveryJobId': item.deliveryJobId ?? '',
                                  'saleId': item.id,
                                  'isBuyer': false,
                                },
                              );
                            },
                          );
                        }
                      },
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusFilters() {
    final purchasesState = ref.watch(purchasesNotifierProvider);
    final salesState = ref.watch(salesNotifierProvider);

    final purchasesCounts = purchasesState.statusCounts;
    final salesCounts = salesState.statusCounts;

    final totalAll = (purchasesCounts?.all ?? 0) + (salesCounts?.all ?? 0);
    final totalCompleted =
        (purchasesCounts?.completed ?? 0) + (salesCounts?.completed ?? 0);
    final totalDisputed =
        (purchasesCounts?.disputed ?? 0) + (salesCounts?.disputed ?? 0);
    final totalInDelivery =
        (purchasesCounts?.inDelivery ?? 0) + (salesCounts?.inDelivery ?? 0);
    final totalProcessing =
        (purchasesCounts?.processing ?? 0) + (salesCounts?.processing ?? 0);

    final statuses = [
      {'label': 'All', 'value': 'all', 'count': totalAll},
      {'label': 'Processing', 'value': 'processing', 'count': totalProcessing},
      {
        'label': 'In Delivery',
        'value': 'in_delivery',
        'count': totalInDelivery,
      },
      {'label': 'Completed', 'value': 'completed', 'count': totalCompleted},
      {'label': 'Disputed', 'value': 'disputed', 'count': totalDisputed},
    ];

    return SizedBox(
      height: 28,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: statuses.length,
        separatorBuilder: (context, index) => horizontalSpace(8),
        itemBuilder: (context, index) {
          final status = statuses[index];
          final isSelected = _selectedStatus == status['value'];
          final count = status['count'] as int;

          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedStatus = status['value'] as String;
              });
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
              decoration: BoxDecoration(
                color: isSelected ? AppColor.primary : Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(
                child: Caption(
                  '${status['label']} ($count)',
                  color: isSelected ? Colors.white : AppColor.lightText,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/empty-delivery.png',
            width: 64,
            height: 64,
            color: AppColor.lightText.withValues(alpha: 0.5),
          ),
          verticalSpace(16),
          const BodyText("No deliveries found", color: AppColor.lightText),
        ],
      ),
    );
  }
}
