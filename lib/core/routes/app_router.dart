import 'package:flutter/material.dart';
import 'package:kipa/feature/wallet/presentation/pages/wallet_pin_gate_screen.dart';
import '../../feature/splash/presentation/pages/splash_page.dart';
import '../../feature/onboarding/presentation/pages/onboarding_page.dart';
import '../../feature/auth/presentation/pages/register_page.dart';
import '../../feature/auth/presentation/pages/verify_phone_page.dart';
import '../../feature/auth/presentation/pages/verify_code_page.dart';
import '../../feature/dashboard/presentation/pages/dashboard_screen.dart';
import '../../feature/auth/presentation/pages/user_info_page.dart';
import '../shared/widgets/custom_text.dart';
import 'route_names.dart';
import '../../feature/payment/presentation/pages/payment_link_list_screen.dart';
import '../../feature/payment/presentation/pages/create_link_screen.dart';
import 'package:kipa/feature/payment/presentation/pages/fulfillment_form_screen.dart';
import 'package:kipa/feature/payment/presentation/pages/fulfillment_success_screen.dart';
import '../../feature/payment/presentation/pages/link_success_screen.dart';
import '../../feature/payment/presentation/pages/transaction_status_screen.dart';
import '../../feature/payment/presentation/pages/pay_via_link_screen.dart';
import '../../feature/payment/presentation/pages/buyer_payment_details_screen.dart';
import '../../feature/payment/presentation/pages/buyer_payment_success_screen.dart';
import '../../feature/payment/presentation/pages/rider_search_screen.dart';
import '../../feature/delivery/presentation/pages/delivery_tracking_screen.dart';
import '../../feature/delivery/presentation/pages/delivery_details_screen.dart';
import '../../feature/delivery/presentation/pages/chat_screen.dart';
import '../../feature/purchases/presentation/pages/dispute_page.dart';
import '../../feature/sales/presentation/pages/confirm_return_page.dart';

class AppRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteNames.splashRoute:
        return MaterialPageRoute(builder: (_) => const SplashPage());

      case RouteNames.onboardingRoute:
        return MaterialPageRoute(builder: (_) => const OnboardingPage());

      case RouteNames.registerRoute:
        return MaterialPageRoute(builder: (_) => const RegisterPage());

      case RouteNames.verifyPhoneRoute:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) =>
              VerifyPhonePage(phoneNumber: args?['phoneNumber'] ?? ''),
        );

      case RouteNames.verifyCodeRoute:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) => VerifyCodePage(
            phoneNumber: args?['phoneNumber'] ?? '',
            method: args?['method'] ?? 'sms',
            verificationId: args?['verificationId'],
            idempotencyKey: args?['idempotencyKey'],
          ),
        );

      case RouteNames.userInfoRoute:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) => UserInfoPage(phoneNumber: args?['phoneNumber'] ?? ''),
        );

      case RouteNames.loginRoute:
        return MaterialPageRoute(builder: (_) => const RegisterPage());

      case RouteNames.dashboardRoute:
        return MaterialPageRoute(builder: (_) => const DashboardScreen());

      case RouteNames.homeRoute:
        return MaterialPageRoute(builder: (_) => const DashboardScreen());

      case RouteNames.paymentLinkListRoute:
        return MaterialPageRoute(builder: (_) => const PaymentLinkListScreen());

      case RouteNames.createLinkActionRoute:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) => CreateLinkActionScreen(
            isEdit: args?['isEdit'] ?? false,
            paymentRequest: args?['paymentRequest'],
          ),
        );

      case RouteNames.linkCreatedSuccessRoute:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) =>
              LinkCreatedSuccessScreen(isEdit: args?['isEdit'] ?? false),
        );
      case RouteNames.fulfillmentFormRoute:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) => FulfillmentFormScreen(
            paymentRequestId: args?['paymentRequestId'] ?? '',
          ),
        );
      case RouteNames.fulfillmentSuccessRoute:
        return MaterialPageRoute(
          builder: (_) => const FulfillmentSuccessScreen(),
        );

      case RouteNames.transactionStatusRoute:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) => TransactionStatusScreen(
            paymentRequestId: args?['paymentRequestId'] as String? ?? '',
          ),
        );

      case RouteNames.payViaLinkRoute:
        return MaterialPageRoute(builder: (_) => const PayViaLinkScreen());

      case RouteNames.buyerPaymentDetailsRoute:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) => BuyerPaymentDetailsScreen(
            paymentCode: args?['paymentCode'] ?? '',
          ),
        );

      case RouteNames.buyerPaymentSuccessRoute:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) => BuyerPaymentSuccessScreen(
            paymentRequestId: args?['paymentRequestId'] as String?,
          ),
        );

      case RouteNames.riderSearchRoute:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) => RiderSearchScreen(
            paymentRequestId: args?['paymentRequestId'] ?? '',
          ),
        );

      case RouteNames.deliveryTrackingRoute:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) => DeliveryTrackingScreen(
            deliveryJobId: args?['deliveryJobId'] ?? '',
            initialJob: args?['initialJob'],
          ),
        );

      case RouteNames.deliveryDetailsRoute:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) => DeliveryDetailsScreen(
            deliveryJobId: args?['deliveryJobId'] ?? '',
            purchaseId: args?['purchaseId'],
            saleId: args?['saleId'],
            isBuyer: args?['isBuyer'] ?? true,
          ),
        );

      case RouteNames.disputeRoute:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) => DisputePage(
            purchaseId: args?['purchaseId'] ?? '',
            itemName: args?['itemName'],
          ),
        );

      case RouteNames.walletRoute:
        return MaterialPageRoute(builder: (_) => const WalletPinGateScreen());

      case RouteNames.confirmReturnRoute:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) => ConfirmReturnPage(saleId: args?['saleId'] ?? ''),
        );

      case RouteNames.chatRoute:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) => ChatScreen(
            jobId: args?['jobId'] ?? '',
            participantName: args?['participantName'] ?? 'Chat',
            participantPhotoUrl: args?['participantPhotoUrl'],
          ),
        );

      default:
        return MaterialPageRoute(builder: (_) => const NotFoundPage());
    }
  }

  // static String getInitialRoute(BuildContext context) {
  //   final authProvider = context.read<AuthProvider>();
  //   final isAuthenticated = authProvider.isAuthenticated;
  //   final isInitial = authProvider.state.isInitial;

  //   if (isInitial) {
  //     return '/';
  //   }

  //   return isAuthenticated ? RouteNames.dashboardRoute : RouteNames.loginRoute;
  // }

  // static bool canAccess(BuildContext context, String routeName) {
  //   final authProvider = context.read<AuthProvider>();
  //   final protectedRoutes = [
  //     RouteNames.dashboardRoute,
  //     // RouteNames.profileRoute,
  //     // RouteNames.settingsRoute,
  //   ];

  //   if (protectedRoutes.contains(routeName)) {
  //     return authProvider.isAuthenticated;
  //   }

  //   return true;
  // }
}

class NotFoundPage extends StatelessWidget {
  const NotFoundPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: ResponsiveText('Not Found', baseSize: 24)),
    );
  }
}
