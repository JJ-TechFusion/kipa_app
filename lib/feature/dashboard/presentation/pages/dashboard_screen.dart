import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kipa/feature/dashboard/presentation/provider/dashboard_provider.dart';
import 'package:kipa/feature/dashboard/presentation/widgets/active_deliveries_list.dart';
import 'package:kipa/feature/dashboard/presentation/widgets/balance_card.dart';
import 'package:kipa/feature/dashboard/presentation/widgets/dashboard_action_card.dart';
import 'package:kipa/feature/dashboard/presentation/widgets/dashboard_bottom_nav.dart';
import 'package:kipa/feature/dashboard/presentation/widgets/dashboard_header.dart';
import 'package:kipa/feature/dashboard/presentation/widgets/promo_banner.dart';
import 'package:kipa/feature/wallet/presentation/providers/wallet_provider.dart';
import 'package:kipa/core/routes/route_names.dart';
import 'package:kipa/utils/constant.dart';

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
      ref.read(walletNotifierProvider.notifier).getWallet();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(dashboardProvider);
    final controller = ref.read(dashboardProvider.notifier);
    final walletState = ref.watch(walletNotifierProvider);

    // Mock active deliveries data
    final activeDeliveries = [
      {
        'buyerName': 'Grace Ikpang',
        'buyerImage': 'user_grace.png', // Assuming assets
        'itemName': 'iPhone 17 Pro Max',
        'itemSpecs': 'Brand new 512GB/8GB RAM',
        'price': 3500000.00,
        'status': 'In Transit',
      },
      // Add more if needed for horizontal scroll check
    ];

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Expanded(
              child: IndexedStack(
                index: state.bottomNavIndex,
                children: [
                  SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        DashboardHeader(
                          userName: 'Grace',
                          onNotificationTap: () {},
                          onProfileTap: () {},
                        ),
                        const SizedBox(height: 24),
                        BalanceCard(
                          balance: walletState.wallet?.availableBalance ?? 0,
                          pendingBalance:
                              walletState.wallet?.lockedBalance ?? 0,
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
                                icon: Icons.link,
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
                                icon: Icons.payment,
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
                        PromoBanner(onBookRiderTap: () {}),
                        verticalSpace(24),
                        ActiveDeliveriesList(
                          deliveries: activeDeliveries,
                          onViewAllTap: () {},
                          onDeliveryTap: (index) {},
                        ),
                      ],
                    ),
                  ),
                  const Center(child: Text('Deliveries Screen')),
                  const Center(child: Text('Wallet Screen')),
                  const Center(child: Text('Support Screen')),
                  const Center(child: Text('Profile Screen')),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: DashboardBottomNav(
        currentIndex: state.bottomNavIndex,
        onTap: controller.setBottomNavIndex,
      ),
    );
  }
}
