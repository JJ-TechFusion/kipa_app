import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kipa/feature/auth/presentation/providers/auth_provider.dart';
import 'package:kipa/feature/wallet/presentation/providers/wallet_provider.dart';
import 'package:kipa/feature/wallet/presentation/providers/bank_accounts_provider.dart';
import 'package:kipa/feature/payment/presentation/providers/payment_provider.dart';
import 'package:kipa/feature/sales/presentation/providers/sales_provider.dart';
import 'package:kipa/feature/purchases/presentation/providers/purchases_provider.dart';
import 'package:kipa/feature/disputes/presentation/providers/disputes_provider.dart';
import 'package:kipa/feature/errand/presentation/providers/errand_provider.dart';
import 'package:kipa/feature/dashboard/presentation/provider/dashboard_provider.dart';
import 'package:kipa/feature/delivery/presentation/providers/delivery_provider.dart';
import 'package:kipa/feature/splash/presentation/providers/splash_provider.dart';

/// Clears all user-specific cached data from Riverpod providers.
/// Must be called during logout/account deletion before navigation.
void clearUserSession(WidgetRef ref) {
  // Invalidate all user-specific NotifierProviders
  ref.invalidate(walletNotifierProvider);
  ref.invalidate(bankAccountsNotifierProvider);
  ref.invalidate(paymentNotifierProvider);
  ref.invalidate(transactionStatusNotifierProvider);
  ref.invalidate(transactionsListNotifierProvider);
  ref.invalidate(salesNotifierProvider);
  ref.invalidate(purchasesNotifierProvider);
  ref.invalidate(disputesNotifierProvider);
  ref.invalidate(errandNotifierProvider);
  ref.invalidate(dashboardProvider);
  ref.invalidate(deliveryTrackingProvider);
  ref.invalidate(logisticsNotifierProvider);

  // Invalidate FutureProviders that cache user data
  ref.invalidate(appStateProvider);

  // Auth provider is handled separately in logout()
  // but invalidate it here too for completeness
  ref.invalidate(authNotifierProvider);
}
