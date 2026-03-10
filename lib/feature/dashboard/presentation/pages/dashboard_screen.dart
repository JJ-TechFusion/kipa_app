import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:kipa/core/shared/widgets/custom_text.dart';
import 'package:kipa/feature/dashboard/presentation/provider/dashboard_provider.dart';
import 'package:kipa/feature/dashboard/presentation/widgets/active_deliveries_list.dart';
import 'package:kipa/feature/dashboard/presentation/widgets/balance_card.dart';
import 'package:kipa/feature/dashboard/presentation/widgets/dashboard_action_card.dart';
import 'package:kipa/feature/dashboard/presentation/widgets/dashboard_bottom_nav.dart';
import 'package:kipa/feature/dashboard/presentation/widgets/dashboard_header.dart';
import 'package:kipa/feature/dashboard/presentation/widgets/promo_banner.dart';
import 'package:kipa/feature/support/presentation/pages/support_screen.dart';
import 'package:kipa/feature/wallet/presentation/providers/wallet_provider.dart';
import 'package:kipa/feature/auth/presentation/providers/auth_provider.dart';
import 'package:kipa/feature/profile/presentation/pages/profile_screen.dart';
import 'package:kipa/core/routes/route_names.dart';
import 'package:kipa/theme/app_colors.dart';
import 'package:kipa/utils/constant.dart';
import '../../../delivery/presentation/pages/deliveries_list_screen.dart';
import '../../../delivery/presentation/providers/delivery_provider.dart';
import '../../../payment/presentation/pages/transactions_list_screen.dart';
import '../../../payment/presentation/providers/payment_provider.dart';
import '../../../purchases/presentation/providers/purchases_provider.dart';
import '../../../sales/presentation/providers/sales_provider.dart';
import '../../../errand/presentation/providers/errand_provider.dart';
import '../../../errand/presentation/widgets/active_errand_card.dart';
import '../../../errand/domain/enums/errand_status.dart';
import '../../../disputes/presentation/providers/disputes_provider.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _loadDashboardData();
    });
  }

  Future<void> _loadDashboardData() async {
    await Future.wait([
      ref.read(authNotifierProvider.notifier).fetchCurrentUser(),
      ref.read(walletNotifierProvider.notifier).getWallet(),
      ref.read(dashboardProvider.notifier).fetchActiveDeliveries(),
      ref.read(errandNotifierProvider.notifier).fetchActiveErrand(),
    ]);
  }

  void _refreshTabData(int index) {
    switch (index) {
      case 1: // Deliveries tab
        ref.read(purchasesNotifierProvider.notifier).fetchPurchases();
        ref.read(salesNotifierProvider.notifier).fetchSales();
        ref.read(errandNotifierProvider.notifier).fetchErrands();
        ref.read(logisticsNotifierProvider.notifier).fetchLogisticsDeliveries();
        break;
      case 2: // Kipa Protect (Transactions) tab
        ref.read(transactionsListNotifierProvider.notifier).fetchTransactions();
        break;
      case 3: // Support tab
        ref.read(disputesNotifierProvider.notifier).fetchDisputes();
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(dashboardProvider);
    final controller = ref.read(dashboardProvider.notifier);
    final walletState = ref.watch(walletNotifierProvider);
    final authState = ref.watch(authNotifierProvider);
    final errandState = ref.watch(errandNotifierProvider);

    ref.listen(errandNotifierProvider, (prev, next) {
      if (next.activeErrand != null &&
          prev?.activeErrand == null &&
          next.activeErrand!.status.isActive &&
          next.activeErrand!.status != ErrandStatus.draft) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            final status = next.activeErrand!.status;
            if (status == ErrandStatus.searching) {
              Navigator.pushNamed(
                context,
                RouteNames.errandSearchingRoute,
                arguments: {'errand': next.activeErrand},
              );
            } else if (status == ErrandStatus.delivered) {
              Navigator.pushNamed(
                context,
                RouteNames.errandCompleteRoute,
                arguments: {'errand': next.activeErrand},
              );
            } else if (status.hasRider) {
              Navigator.pushNamed(
                context,
                RouteNames.errandTrackingRoute,
                arguments: {'errand': next.activeErrand},
              );
            }
          }
        });
      }
    });

    final activeDeliveries =
        state.activeDeliveries?.map((delivery) {
          final dateFormat = DateFormat('MMM dd, h:mma');
          final timestamp = delivery.acceptedAt ?? delivery.createdAt;
          return {
            'buyerName': delivery.counterparty.name,
            'buyerImage': delivery.counterparty.imageUrl,
            'itemName': delivery.itemName,
            'itemSpecs': delivery.itemDescription,
            'price': delivery.itemPrice,
            'status': delivery.riderStatusText,
            'deliveryJobId': delivery.deliveryJobId,
            'paymentRequestId': delivery.paymentRequestId,
            'isBuyer': delivery.isBuyer,
            'timestamp': dateFormat.format(timestamp),
            'buyerRole': delivery.counterparty.role,
          };
        }).toList() ??
        [];

    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: IndexedStack(
              index: state.bottomNavIndex,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: SafeArea(
                    child: RefreshIndicator(
                      color: AppColor.primary,
                      onRefresh: _loadDashboardData,
                      child: SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            DashboardHeader(
                              userName: authState.currentUser?.firstName ?? '',
                              profileImageUrl:
                                  authState.currentUser?.profileImageUrl,
                              onNotificationTap: () {},
                              onProfileTap: () {},
                            ),
                            const SizedBox(height: 24),
                            BalanceCard(
                              balance:
                                  walletState.wallet?.availableBalance ?? 0,
                              pendingBalance:
                                  walletState.wallet?.totalPendingEscrow ?? 0,
                              isVisible: state.isBalanceVisible,
                              onVisibilityToggle:
                                  controller.toggleBalanceVisibility,
                            ),
                            const SizedBox(height: 24),
                            Row(
                              children: [
                                Expanded(
                                  child: DashboardActionCard(
                                    title: 'Create payment link',
                                    subtitle: 'Secure kipa payment',
                                    icon: CupertinoIcons.link_circle_fill,
                                    onTap: () {
                                      Navigator.pushNamed(
                                        context,
                                        RouteNames.paymentLinkListRoute,
                                      );
                                    },
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: DashboardActionCard(
                                    title: 'Pay via link',
                                    subtitle: 'Enter code to pay',
                                    icon: Icons.wallet,
                                    onTap: () {
                                      Navigator.pushNamed(
                                        context,
                                        RouteNames.payViaLinkRoute,
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                            verticalSpace(24),
                            PromoBanner(
                              onBookRiderTap: () {
                                final activeErrand = errandState.activeErrand;
                                if (activeErrand != null &&
                                    activeErrand.status.isActive &&
                                    activeErrand.status != ErrandStatus.draft) {
                                  if (activeErrand.status ==
                                      ErrandStatus.searching) {
                                    Navigator.pushNamed(
                                      context,
                                      RouteNames.errandSearchingRoute,
                                      arguments: {'errand': activeErrand},
                                    );
                                  } else if (activeErrand.status ==
                                      ErrandStatus.delivered) {
                                    Navigator.pushNamed(
                                      context,
                                      RouteNames.errandCompleteRoute,
                                      arguments: {'errand': activeErrand},
                                    );
                                  } else if (activeErrand.status.hasRider) {
                                    Navigator.pushNamed(
                                      context,
                                      RouteNames.errandTrackingRoute,
                                      arguments: {'errand': activeErrand},
                                    );
                                  }
                                } else {
                                  Navigator.pushNamed(
                                    context,
                                    RouteNames.createErrandRoute,
                                  );
                                }
                              },
                            ),
                            verticalSpace(24),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const BodyText(
                                  'Active Deliveries',
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    controller.setBottomNavIndex(1);
                                    _refreshTabData(1);
                                  },
                                  child: const BodySmall(
                                    'View all',
                                    color: AppColor.lightText,
                                  ),
                                ),
                              ],
                            ),
                            verticalSpace(16),
                            ActiveDeliveriesList(
                              deliveries: activeDeliveries,
                              onViewAllTap: () {},
                              topContent:
                                  errandState.activeErrand != null &&
                                      errandState
                                          .activeErrand!
                                          .status
                                          .isActive &&
                                      errandState.activeErrand!.status !=
                                          ErrandStatus.draft
                                  ? ActiveErrandCard(
                                      errand: errandState.activeErrand!,
                                      onTap: () {
                                        final status =
                                            errandState.activeErrand!.status;
                                        if (status == ErrandStatus.searching) {
                                          Navigator.pushNamed(
                                            context,
                                            RouteNames.errandSearchingRoute,
                                            arguments: {
                                              'errand':
                                                  errandState.activeErrand,
                                            },
                                          );
                                        } else if (status ==
                                            ErrandStatus.delivered) {
                                          Navigator.pushNamed(
                                            context,
                                            RouteNames.errandCompleteRoute,
                                            arguments: {
                                              'errand':
                                                  errandState.activeErrand,
                                            },
                                          );
                                        } else if (status.hasRider) {
                                          Navigator.pushNamed(
                                            context,
                                            RouteNames.errandTrackingRoute,
                                            arguments: {
                                              'errand':
                                                  errandState.activeErrand,
                                            },
                                          );
                                        }
                                      },
                                    )
                                  : null,
                              onDeliveryTap: (index) {
                                final delivery = activeDeliveries[index];
                                if (delivery['deliveryJobId'] != null) {
                                  Navigator.pushNamed(
                                    context,
                                    RouteNames.deliveryDetailsRoute,
                                    arguments: {
                                      'deliveryJobId':
                                          delivery['deliveryJobId'],
                                      'paymentRequestId':
                                          delivery['paymentRequestId'],
                                      'isBuyer': delivery['isBuyer'] ?? true,
                                    },
                                  );
                                }
                              },
                            ),
                            verticalSpace(24),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const DeliveriesListScreen(),
                const TransactionsListScreen(),
                const SupportScreen(),
                const ProfileScreen(),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: DashboardBottomNav(
        currentIndex: state.bottomNavIndex,
        onTap: (index) {
          controller.setBottomNavIndex(index);
          _refreshTabData(index);
        },
      ),
    );
  }
}
