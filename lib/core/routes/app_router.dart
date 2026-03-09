import 'package:flutter/material.dart';
import 'package:kipa/feature/wallet/presentation/pages/wallet_pin_gate_screen.dart';
import 'package:kipa/feature/wallet/presentation/pages/bank_accounts_list_screen.dart';
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
import '../../feature/payment/presentation/pages/ship_logistics_form_screen.dart';
import '../../feature/delivery/presentation/pages/deliveries_list_screen.dart';
import '../../feature/delivery/presentation/pages/delivery_tracking_screen.dart';
import '../../feature/delivery/presentation/pages/delivery_details_screen.dart';
import '../../feature/delivery/presentation/pages/chat_screen.dart';
import '../../feature/purchases/presentation/pages/dispute_page.dart';
import '../../feature/sales/presentation/pages/confirm_return_page.dart';
import '../../feature/profile/presentation/pages/personal_details_screen.dart';
import '../../feature/errand/presentation/pages/create_errand_screen.dart';
import '../../feature/errand/presentation/pages/errand_summary_screen.dart';
import '../../feature/errand/presentation/pages/errand_searching_screen.dart';
import '../../feature/errand/presentation/pages/errand_tracking_screen.dart';
import '../../feature/errand/presentation/pages/errand_complete_screen.dart';
import '../../feature/errand/presentation/pages/errand_details_screen.dart';
import '../../feature/errand/domain/entities/errand_entity.dart';
import '../../feature/disputes/presentation/pages/dispute_detail_screen.dart';
import '../../feature/delivery/presentation/pages/logistics_delivery_details_screen.dart';

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
            pickupAddress: args?['pickupAddress'],
            dropoffAddress: args?['dropoffAddress'],
            pickupLat: args?['pickupLat'],
            pickupLng: args?['pickupLng'],
            dropoffLat: args?['dropoffLat'],
            dropoffLng: args?['dropoffLng'],
          ),
        );

      case RouteNames.shipLogisticsFormRoute:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) => ShipLogisticsFormScreen(
            logisticsDeliveryId: args?['logisticsDeliveryId'] ?? '',
            paymentRequestId: args?['paymentRequestId'] ?? '',
          ),
        );

      case RouteNames.deliveriesListRoute:
        return MaterialPageRoute(
          builder: (_) => const DeliveriesListScreen(),
          settings: settings,
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

      case RouteNames.bankAccountsRoute:
        return MaterialPageRoute(
          builder: (_) => const BankAccountsListScreen(),
        );

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
            showSenderNames: args?['showSenderNames'] ?? true,
          ),
        );

      case RouteNames.personalDetailsRoute:
        return MaterialPageRoute(builder: (_) => const PersonalDetailsScreen());

      case RouteNames.createErrandRoute:
        return MaterialPageRoute(builder: (_) => const CreateErrandScreen());

      case RouteNames.errandSummaryRoute:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) =>
              ErrandSummaryScreen(errand: args?['errand'] as ErrandEntity),
        );

      case RouteNames.errandSearchingRoute:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) =>
              ErrandSearchingScreen(errand: args?['errand'] as ErrandEntity),
        );

      case RouteNames.errandTrackingRoute:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) =>
              ErrandTrackingScreen(errand: args?['errand'] as ErrandEntity),
        );

      case RouteNames.errandCompleteRoute:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) =>
              ErrandCompleteScreen(errand: args?['errand'] as ErrandEntity),
        );

      case RouteNames.disputeDetailRoute:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) => DisputeDetailScreen(
            disputeId: args?['disputeId'] as String? ?? '',
          ),
        );

      case RouteNames.errandDetailsRoute:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) =>
              ErrandDetailsScreen(errandId: args?['errandId'] as String? ?? ''),
        );

      case RouteNames.logisticsDeliveryDetailsRoute:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) => LogisticsDeliveryDetailsScreen(
            logisticsDeliveryId: args?['logisticsDeliveryId'] as String? ?? '',
          ),
        );

      default:
        return MaterialPageRoute(builder: (_) => const NotFoundPage());
    }
  }
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
