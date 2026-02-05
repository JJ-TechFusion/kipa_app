import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kipa/core/shared/widgets/buttons/roundedbutton.dart';
import 'package:kipa/core/shared/widgets/custom_text.dart';
import 'package:kipa/feature/payment/presentation/widgets/buyer_info_card.dart';
import 'package:kipa/feature/payment/presentation/widgets/transaction_details_card.dart';
import 'package:kipa/feature/payment/presentation/widgets/transaction_timeline.dart';
import 'package:kipa/theme/app_colors.dart';
import 'package:kipa/utils/constant.dart';

class TransactionStatusScreen extends StatefulWidget {
  final bool initialStatusReceived;

  const TransactionStatusScreen({
    super.key,
    this.initialStatusReceived = false,
  });

  @override
  State<TransactionStatusScreen> createState() =>
      _TransactionStatusScreenState();
}

class _TransactionStatusScreenState extends State<TransactionStatusScreen> {
  late bool isReceived;

  @override
  void initState() {
    super.initState();
    isReceived = widget.initialStatusReceived;
  }

  @override
  Widget build(BuildContext context) {
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
        title: BodyText(
          isReceived ? 'Transaction Status' : 'Transaction Status',
          fontWeight: FontWeight.w600,
          fontSize: 18,
        ),
        actions: [
          // Toggle for demo
          CupertinoSwitch(
            value: isReceived,
            onChanged: (val) {
              setState(() => isReceived = val);
            },
          ),
          horizontalSpace(16),
        ],
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 22),
        child: Column(
          children: [
            (isReceived) ? _buildReceivedHeader() : _buildPendingHeader(),
            verticalSpace(24),

            if (isReceived) ...[_buildProcessingBanner(), verticalSpace(24)],

            TransactionDetailsCard(
              itemName: 'iPhone 16 Pro Max',
              itemSpecs: 'BRE-B640 • Silver 256GB/4GB RAM',
              itemPrice: '₦2,250,000.00',
              buyerFee: '₦25,500.00',
              buyerTotal: '₦2,275,500.00',
              youReceive: '₦2,250,000.00',
              isReceived: isReceived,
            ),
            verticalSpace(32),

            Align(
              alignment: Alignment.centerLeft,
              child: TransactionTimeline(steps: _getTimelineSteps()),
            ),
            verticalSpace(32),

            if (isReceived) ...[
              _buildBuyerInfo(),
              verticalSpace(32),
              _buildFundsSecuredBanner(),
              verticalSpace(32),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 42),
                child: CustomButton(
                  title: 'Start Delivery',
                  onTap: () {},
                  icon: CupertinoIcons.cube_box,
                  borderRadius: 30,
                ),
              ),
              verticalSpace(16),
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

  Widget _buildReceivedHeader() {
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
        const H4('₦2,250,000.00'),
        verticalSpace(8),
        const Caption('Dec 30, 14:54PM', color: AppColor.lightText),
      ],
    );
  }

  Widget _buildProcessingBanner() {
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
              const Text(
                '3 days left',
                style: TextStyle(
                  color: Color(0xFFE65100),
                  fontWeight: FontWeight.w500,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          verticalSpace(8),
          const Caption(
            'Your have a maximum of 3 days to send your package for delivery or the money will be automatically refunded to the buyer',
            fontSize: 11,
            color: AppColor.kipaGrey2,
          ),
        ],
      ),
    );
  }

  Widget _buildBuyerInfo() {
    return BuyerInfoCard(
      name: 'Grace Ikpang',
      email: 'grace.ikpang@gmail.com',
      phone: '+234 8123457890',
      onCall: () {},
    );
  }

  Widget _buildFundsSecuredBanner() {
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
              ), // Assuming font
              children: [
                const TextSpan(text: 'Your payment of '),
                const TextSpan(
                  text: '₦2,250,000.00',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const TextSpan(
                  text:
                      ' is held safely until delivery is confirmed by the buyer',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<TimelineStep> _getTimelineSteps() {
    if (isReceived) {
      return [
        TimelineStep(
          title: 'Link Created',
          subtitle: 'Dec 30, 14:33PM',
          isCompleted: true,
        ),
        TimelineStep(
          title: 'Payment Received',
          subtitle: 'Dec 30, 14:54PM',
          isCompleted: true,
          extraWidget: Container(
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
          ),
        ),
        TimelineStep(title: 'Awaiting Processing Time', isActive: true),
      ];
    } else {
      return [
        TimelineStep(
          title: 'Link Created',
          subtitle: 'Dec 30, 14:33PM',
          isCompleted: true,
        ),
        TimelineStep(title: 'Payment Pending', isActive: true),
      ];
    }
  }
}
