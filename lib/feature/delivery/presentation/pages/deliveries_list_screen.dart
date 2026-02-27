import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kipa/core/routes/route_names.dart';
import 'package:kipa/core/shared/widgets/custom_text.dart';
import 'package:kipa/feature/auth/presentation/providers/auth_provider.dart';
import 'package:kipa/feature/delivery/presentation/providers/delivery_provider.dart';
import 'package:kipa/feature/delivery/presentation/widgets/delivery_list_item.dart';
import 'package:kipa/feature/delivery/presentation/widgets/logistics_delivery_card.dart';
import 'package:kipa/feature/errand/domain/enums/errand_status.dart';
import 'package:kipa/feature/errand/presentation/providers/errand_provider.dart';
import 'package:kipa/feature/errand/presentation/widgets/errand_list_item.dart';
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

class _DeliveriesListScreenState extends ConsumerState<DeliveriesListScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _selectedStatus = 'all';
  int? _initialTabIndex;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _selectedStatus = 'all';
      });
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(purchasesNotifierProvider.notifier).fetchPurchases();
      ref.read(salesNotifierProvider.notifier).fetchSales();
      ref.read(errandNotifierProvider.notifier).fetchErrands();
      ref.read(logisticsNotifierProvider.notifier).fetchLogisticsDeliveries();

      if (_initialTabIndex != null) {
        _tabController.animateTo(_initialTabIndex!);
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    if (args != null && args['initialTab'] != null) {
      _initialTabIndex = args['initialTab'] as int;
    }
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
          Row(
            children: [
              _buildTabItem(0, "Intra-state"),
              horizontalSpace(12),
              _buildTabItem(1, "Inter-state"),
              horizontalSpace(12),
              _buildTabItem(2, "Errands"),
            ],
          ),
          verticalSpace(16),
          _buildStatusFilters(),
          verticalSpace(16),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildIntraStateList(),
                _buildInterStateList(),
                _buildErrandsList(),
              ],
            ),
          ),
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

  Widget _buildStatusFilters() {
    if (_tabController.index == 0) {
      return _buildIntraStateStatusFilters();
    } else if (_tabController.index == 1) {
      return _buildInterStateStatusFilters();
    } else {
      return _buildErrandStatusFilters();
    }
  }

  Widget _buildInterStateStatusFilters() {
    final logisticsState = ref.watch(logisticsNotifierProvider);

    final statuses = [
      {'label': 'All', 'value': 'all', 'count': logisticsState.allCount},
      {
        'label': 'Awaiting',
        'value': 'awaiting_shipment',
        'count': logisticsState.awaitingShipmentCount,
      },
      {
        'label': 'Shipped',
        'value': 'shipped',
        'count': logisticsState.shippedCount,
      },
      {
        'label': 'Delivered',
        'value': 'delivered',
        'count': logisticsState.deliveredCount,
      },
    ];

    return _buildFilterPills(statuses);
  }

  Widget _buildIntraStateStatusFilters() {
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

    return _buildFilterPills(statuses);
  }

  Widget _buildErrandStatusFilters() {
    final errandState = ref.watch(errandNotifierProvider);
    final errands = errandState.errands;

    final totalAll = errands.length;
    final totalActive = errands.where((e) => e.status.isActive).length;
    final totalCompleted = errands
        .where((e) => e.status.name == 'completed')
        .length;
    final totalCancelled = errands
        .where((e) => e.status.name == 'cancelled')
        .length;

    final statuses = [
      {'label': 'All', 'value': 'all', 'count': totalAll},
      {'label': 'Active', 'value': 'active', 'count': totalActive},
      {'label': 'Completed', 'value': 'completed', 'count': totalCompleted},
      {'label': 'Cancelled', 'value': 'cancelled', 'count': totalCancelled},
    ];

    return _buildFilterPills(statuses);
  }

  Widget _buildFilterPills(List<Map<String, dynamic>> statuses) {
    return SizedBox(
      height: 28,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: statuses.length,
        separatorBuilder: (context, index) => horizontalSpace(8),
        itemBuilder: (context, index) {
          final status = statuses[index];
          final isSelected = _selectedStatus == status['value'];

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
                  '${status['label']}',
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

  Widget _buildIntraStateList() {
    final purchasesState = ref.watch(purchasesNotifierProvider);
    final salesState = ref.watch(salesNotifierProvider);

    final allPurchases = (purchasesState.purchases ?? [])
        .where((p) => p.deliveryType != 'inter_state')
        .toList();
    final allSales = (salesState.sales ?? [])
        .where((s) => s.deliveryType != 'inter_state')
        .toList();

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

    if (isLoading) {
      return const Center(child: CircularProgressIndicator.adaptive());
    }

    if (!hasData) {
      return _buildEmptyState('No deliveries found', Icons.local_shipping);
    }

    return RefreshIndicator.adaptive(
      onRefresh: () async {
        await Future.wait([
          ref.read(purchasesNotifierProvider.notifier).fetchPurchases(),
          ref.read(salesNotifierProvider.notifier).fetchSales(),
        ]);
      },
      child: ListView.separated(
        itemCount: purchases.length + sales.length,
        separatorBuilder: (context, index) => verticalSpace(16),
        itemBuilder: (context, index) {
          if (index < purchases.length) {
            final item = purchases[index];
            final riderAssigned = item.delivery?.riderAssigned ?? false;
            return DeliveryListItem(
              purchase: item,
              onTap: riderAssigned ? () {
                Navigator.pushNamed(
                  context,
                  RouteNames.deliveryDetailsRoute,
                  arguments: {
                    'deliveryJobId': item.delivery?.jobId ?? '',
                    'purchaseId': item.id,
                    'isBuyer': true,
                  },
                );
              } : null,
            );
          } else {
            final saleIndex = index - purchases.length;
            final item = sales[saleIndex];
            final orderStatus = item.orderStatus.toLowerCase();
            final riderAssigned = orderStatus == 'in_delivery' || orderStatus == 'completed' || orderStatus == 'delivered';
            return DeliveryListItem(
              sale: item,
              onTap: riderAssigned ? () {
                Navigator.pushNamed(
                  context,
                  RouteNames.deliveryDetailsRoute,
                  arguments: {
                    'deliveryJobId': item.deliveryJobId ?? '',
                    'saleId': item.id,
                    'isBuyer': false,
                  },
                );
              } : null,
            );
          }
        },
      ),
    );
  }

  Widget _buildErrandsList() {
    final errandState = ref.watch(errandNotifierProvider);
    final allErrands = errandState.errands;

    final errands = _selectedStatus == 'all'
        ? allErrands
        : allErrands.where((e) {
            if (_selectedStatus == 'active') {
              return e.status.isActive;
            }
            return e.status.name == _selectedStatus;
          }).toList();

    final isLoading = errandState.isFetchingErrands;

    if (isLoading) {
      return const Center(child: CircularProgressIndicator.adaptive());
    }

    if (errands.isEmpty) {
      return _buildEmptyState('No errands found', Icons.delivery_dining);
    }

    return RefreshIndicator.adaptive(
      onRefresh: () async {
        await ref.read(errandNotifierProvider.notifier).fetchErrands();
      },
      child: ListView.separated(
        itemCount: errands.length,
        separatorBuilder: (context, index) => verticalSpace(16),
        itemBuilder: (context, index) {
          final errand = errands[index];
          return ErrandListItem(
            errand: errand,
            onTap: () {
              switch (errand.status) {
                case ErrandStatus.searching:
                  Navigator.pushNamed(
                    context,
                    RouteNames.errandSearchingRoute,
                    arguments: {'errand': errand},
                  );
                  break;
                case ErrandStatus.accepted:
                case ErrandStatus.pickedUp:
                case ErrandStatus.inTransit:
                  Navigator.pushNamed(
                    context,
                    RouteNames.errandTrackingRoute,
                    arguments: {'errand': errand},
                  );
                  break;
                case ErrandStatus.delivered:
                  Navigator.pushNamed(
                    context,
                    RouteNames.errandCompleteRoute,
                    arguments: {'errand': errand},
                  );
                  break;
                default:
                  // completed, cancelled, draft
                  Navigator.pushNamed(
                    context,
                    RouteNames.errandDetailsRoute,
                    arguments: {'errandId': errand.id},
                  );
              }
            },
          );
        },
      ),
    );
  }

  Widget _buildInterStateList() {
    final logisticsState = ref.watch(logisticsNotifierProvider);
    final authState = ref.watch(authNotifierProvider);
    final currentUserId = authState.currentUser?.id ?? '';

    final allDeliveries = logisticsState.deliveries;

    final deliveries = _selectedStatus == 'all'
        ? allDeliveries
        : allDeliveries.where((d) => d.status == _selectedStatus).toList();

    final isLoading = logisticsState.isFetchingLogistics;

    if (isLoading) {
      return const Center(child: CircularProgressIndicator.adaptive());
    }

    if (deliveries.isEmpty) {
      return _buildEmptyState(
        'No interstate deliveries found',
        Icons.local_shipping,
      );
    }

    return RefreshIndicator.adaptive(
      onRefresh: () async {
        await ref
            .read(logisticsNotifierProvider.notifier)
            .fetchLogisticsDeliveries();
      },
      child: ListView.separated(
        itemCount: deliveries.length,
        separatorBuilder: (context, index) => verticalSpace(16),
        itemBuilder: (context, index) {
          final delivery = deliveries[index];
          final isSeller = delivery.seller.id == currentUserId;

          return LogisticsDeliveryCard(
            delivery: delivery,
            currentUserId: currentUserId,
            onMarkShipped: isSeller && delivery.canMarkShipped
                ? () {
                    Navigator.pushNamed(
                      context,
                      RouteNames.shipLogisticsFormRoute,
                      arguments: {
                        'logisticsDeliveryId': delivery.id,
                        'paymentRequestId': delivery.paymentRequestId,
                      },
                    ).then((result) {
                      if (result == true) {
                        ref
                            .read(logisticsNotifierProvider.notifier)
                            .fetchLogisticsDeliveries();
                      }
                    });
                  }
                : null,
            onTap: () {
              Navigator.pushNamed(
                context,
                RouteNames.logisticsDeliveryDetailsRoute,
                arguments: {'logisticsDeliveryId': delivery.id},
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildEmptyState(String message, IconData icon) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 64,
            color: AppColor.lightText.withValues(alpha: 0.5),
          ),
          verticalSpace(16),
          BodyText(message, color: AppColor.lightText),
        ],
      ),
    );
  }
}
