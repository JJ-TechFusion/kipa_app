import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:kipa/core/routes/route_names.dart';
import 'package:kipa/core/shared/widgets/buttons/roundedbutton.dart';
import 'package:kipa/core/shared/widgets/custom_text.dart';
import 'package:kipa/feature/payment/domain/entities/transaction_status_entities.dart';
import 'package:kipa/feature/payment/presentation/providers/payment_provider.dart';
import 'package:kipa/feature/payment/presentation/widgets/buyer_info_card.dart';
import 'package:kipa/feature/payment/presentation/widgets/transaction_details_card.dart';
import 'package:kipa/feature/payment/presentation/widgets/transaction_timeline.dart';
import 'package:kipa/theme/app_colors.dart';
import 'package:kipa/utils/constant.dart';

class TransactionStatusScreen extends ConsumerStatefulWidget {
  final String paymentRequestId;

  const TransactionStatusScreen({super.key, required this.paymentRequestId});

  @override
  ConsumerState<TransactionStatusScreen> createState() =>
      _TransactionStatusScreenState();
}

class _TransactionStatusScreenState
    extends ConsumerState<TransactionStatusScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(transactionStatusNotifierProvider.notifier)
          .fetchTransactionStatus(widget.paymentRequestId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(transactionStatusNotifierProvider);
    final transaction = state.transactionStatus;

    if (state.isLoading && transaction == null) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: AppColor.primary,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.arrow_back,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
          title: const BodyText(
            'Transaction Status',
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (transaction == null) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: AppColor.primary,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.arrow_back,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
          title: const BodyText(
            'Transaction Status',
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        body: const Center(child: Text('No transaction data')),
      );
    }

    final isBuyer = transaction.isBuyer;
    final isPaid = transaction.payment.isPaid;
    final currencyFormat = NumberFormat.currency(symbol: '₦', decimalDigits: 2);

    return Scaffold(
      backgroundColor: Colors.white,
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
          'Transaction Status',
          fontWeight: FontWeight.w600,
          fontSize: 18,
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 22),
        child: Column(
          children: [
            isPaid ? _buildReceivedHeader(transaction) : _buildPendingHeader(),
            verticalSpace(24),

            if (isPaid && transaction.isSeller) ...[
              _buildProcessingBanner(transaction),
              verticalSpace(24),
            ],

            _buildTransactionDetailsCard(transaction, isBuyer, currencyFormat),
            verticalSpace(32),

            Align(
              alignment: Alignment.centerLeft,
              child: TransactionTimeline(
                steps: _getTimelineSteps(transaction.timeline),
              ),
            ),
            verticalSpace(32),

            // Show other party's info
            if (isPaid) ...[
              _buildUserInfo(transaction, isBuyer),
              verticalSpace(32),
              _buildFundsSecuredBanner(transaction, isBuyer, currencyFormat),
              verticalSpace(32),
              if (transaction.isSeller &&
                  transaction.status == 'paid_awaiting_fulfillment') ...[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 42),
                  child: CustomButton(
                    title: 'View Payment List',
                    onTap: () {
                      Navigator.pushReplacementNamed(
                        context,
                        RouteNames.paymentLinkListRoute,
                      );
                    },
                    icon: CupertinoIcons.cube_box,
                    borderRadius: 30,
                  ),
                ),
                verticalSpace(16),
              ],
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 42),
                child: CustomButton(
                  title: 'Report an Issue',
                  onTap: () {},
                  color: AppColor.kipaGrey.withAlpha(50),
                  textColor: AppColor.primaryText,
                  borderRadius: 30,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildPendingHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColor.scaffoldBackground,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.info_outline, size: 20, color: AppColor.primaryText),
          horizontalSpace(12),
          const Expanded(
            child: Caption(
              'You will be notified as soon as payment has been received from buyer',
              color: AppColor.primaryText,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReceivedHeader(TransactionStatusEntity transaction) {
    final currencyFormat = NumberFormat.currency(symbol: '₦', decimalDigits: 2);
    final dateFormat = DateFormat('MMM dd, hh:mma');

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: const BoxDecoration(
            color: AppColor.successCheckIcon,
            shape: BoxShape.circle,
          ),
          child: const Icon(
            CupertinoIcons.checkmark_seal_fill,
            color: Colors.white,
            size: 24,
          ),
        ),
        verticalSpace(16),
        const BodySmall('Payment Received', fontWeight: FontWeight.w500),
        verticalSpace(8),
        H4(currencyFormat.format(transaction.payment.amount)),
        verticalSpace(8),
        Caption(
          transaction.payment.paidAt != null
              ? dateFormat.format(transaction.payment.paidAt!)
              : 'Payment date unavailable',
          color: AppColor.lightText,
        ),
      ],
    );
  }

  Widget _buildProcessingBanner(TransactionStatusEntity transaction) {
    final now = DateTime.now();
    final processingDeadline = transaction.payment.paidAt?.add(
      Duration(hours: transaction.processingTimeHours),
    );

    String timeLeft = 'Processing';
    if (processingDeadline != null) {
      final difference = processingDeadline.difference(now);
      if (difference.inHours > 24) {
        final days = (difference.inHours / 24).ceil();
        timeLeft = '$days ${days == 1 ? 'day' : 'days'} left';
      } else if (difference.inHours > 0) {
        timeLeft =
            '${difference.inHours} ${difference.inHours == 1 ? 'hour' : 'hours'} left';
      } else if (difference.inMinutes > 0) {
        timeLeft = '${difference.inMinutes} minutes left';
      } else {
        timeLeft = 'Expired';
      }
    }

    final maxDays = (transaction.processingTimeHours / 24).ceil();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColor.processingWindowBackground,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.access_time,
                    size: 16,
                    color: AppColor.primaryText,
                  ),
                  horizontalSpace(8),
                  const BodyText(
                    'Processing Window Active',
                    fontWeight: FontWeight.w500,
                    fontSize: 13,
                  ),
                ],
              ),
              Text(
                timeLeft,
                style: const TextStyle(
                  color: Color(0xFFE65100),
                  fontWeight: FontWeight.w500,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          verticalSpace(8),
          Caption(
            'You have a maximum of $maxDays ${maxDays == 1 ? 'day' : 'days'} to send your package for delivery or the money will be automatically refunded to the buyer',
            fontSize: 11,
            color: AppColor.kipaGrey2,
          ),
        ],
      ),
    );
  }

  Widget _buildUserInfo(TransactionStatusEntity transaction, bool isBuyer) {
    final user = isBuyer ? transaction.seller : transaction.buyer;
    final title = isBuyer ? 'Seller Information' : 'Buyer Information';
    final roleLabel = isBuyer ? 'Seller' : 'Buyer';

    return BuyerInfoCard(
      name: user.name,
      email: '',
      phone: user.phoneNumber,
      onCall: () {},
      title: title,
      roleLabel: roleLabel,
    );
  }

  Widget _buildFundsSecuredBanner(
    TransactionStatusEntity transaction,
    bool isBuyer,
    NumberFormat currencyFormat,
  ) {
    final amount = currencyFormat.format(transaction.payment.amount);
    final confirmationText = isBuyer
        ? 'is held safely until you confirm delivery'
        : 'is held safely until delivery is confirmed by the buyer';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColor.successCircleBackground,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.shield_outlined,
                size: 16,
                color: AppColor.successCheckIcon,
              ),
              horizontalSpace(8),
              const BodyText(
                'Funds secured in Kipa Protect',
                fontWeight: FontWeight.w500,
                fontSize: 13,
                color: AppColor.successCheckIcon,
              ),
            ],
          ),
          verticalSpace(8),
          RichText(
            text: TextSpan(
              style: const TextStyle(
                fontSize: 11,
                color: AppColor.successCheckIcon,
                fontFamily: 'Plus Jakarta Sans',
              ),
              children: [
                TextSpan(
                  text: isBuyer ? 'Your payment of ' : 'The payment of ',
                ),
                TextSpan(
                  text: amount,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(text: ' $confirmationText'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionDetailsCard(
    TransactionStatusEntity transaction,
    bool isBuyer,
    NumberFormat currencyFormat,
  ) {
    return TransactionDetailsCard(
      itemName: transaction.itemName,
      itemSpecs: transaction.itemDescription,
      itemPrice: currencyFormat.format(transaction.itemPrice),
      buyerFee: currencyFormat.format(
        isBuyer
            ? (transaction.feeInfo.serviceFee ?? 0.0)
            : (transaction.feeInfo.platformFee ?? 0.0),
      ),
      buyerTotal: currencyFormat.format(transaction.feeInfo.buyerPaysTotal),
      isReceived: transaction.payment.isPaid,
      youReceive: isBuyer
          ? null
          : currencyFormat.format(transaction.feeInfo.youReceive ?? 0.0),
      totalLabel: isBuyer ? 'Buyer Pays Total' : null,
      deliveryFee: transaction.deliveryType.toLowerCase() == 'kipa_delivery'
          ? currencyFormat.format(transaction.feeInfo.estimatedDeliveryFee)
          : null,
    );
  }

  List<TimelineStep> _getTimelineSteps(TransactionTimelineEntity timeline) {
    final dateFormat = DateFormat('MMM dd, hh:mma');

    return timeline.steps.map((step) {
      return TimelineStep(
        title: step.title,
        subtitle: step.timestamp != null
            ? dateFormat.format(step.timestamp!)
            : null,
        isCompleted: step.isCompleted,
        isActive: step.isCurrent,
        extraWidget:
            step.title.toLowerCase().contains('payment') && step.isCompleted
            ? Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColor.successCircleBackground,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'Funds in Kipa Protect',
                  style: TextStyle(
                    fontSize: 10,
                    color: AppColor.successCheckIcon,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              )
            : null,
      );
    }).toList();
  }
}
