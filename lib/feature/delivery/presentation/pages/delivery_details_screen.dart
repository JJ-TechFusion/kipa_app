import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:kipa/core/shared/widgets/custom_snackbar.dart';
import 'package:kipa/core/shared/widgets/custom_text.dart';
import 'package:kipa/feature/delivery/domain/enums/delivery_status.dart';
import 'package:kipa/feature/delivery/presentation/providers/delivery_provider.dart';
import 'package:kipa/feature/delivery/presentation/widgets/delivery_status_widgets.dart';
import 'package:kipa/feature/payment/presentation/providers/payment_provider.dart';
import 'package:kipa/feature/payment/presentation/widgets/buyer_info_card.dart';
import 'package:kipa/feature/payment/presentation/widgets/transaction_timeline.dart';
import 'package:kipa/feature/purchases/presentation/providers/purchases_provider.dart';
import 'package:kipa/feature/sales/presentation/providers/sales_provider.dart';
import 'package:kipa/theme/app_colors.dart';
import 'package:kipa/core/shared/widgets/dotted_line_painter.dart';
import 'package:kipa/utils/constant.dart';
import 'package:kipa/core/routes/route_names.dart';

import '../../../../core/shared/widgets/widgets.dart';

class DeliveryDetailsScreen extends ConsumerStatefulWidget {
  final String deliveryJobId;
  final String? purchaseId;
  final String? saleId;
  final bool isBuyer;

  const DeliveryDetailsScreen({
    super.key,
    required this.deliveryJobId,
    this.purchaseId,
    this.saleId,
    this.isBuyer = true,
  });

  @override
  ConsumerState<DeliveryDetailsScreen> createState() =>
      _DeliveryDetailsScreenState();
}

class _DeliveryDetailsScreenState extends ConsumerState<DeliveryDetailsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  void _loadData() {
    ref
        .read(deliveryTrackingProvider.notifier)
        .startTracking(jobId: widget.deliveryJobId);

    // Fetch purchase detail if buyer and we have purchase ID
    if (widget.isBuyer && widget.purchaseId != null) {
      ref
          .read(purchasesNotifierProvider.notifier)
          .fetchPurchaseById(widget.purchaseId!);
    }

    // Fetch sale detail if seller and we have sale ID
    if (!widget.isBuyer && widget.saleId != null) {
      ref.read(salesNotifierProvider.notifier).fetchSaleById(widget.saleId!);
    }
  }

  @override
  Widget build(BuildContext context) {
    final trackingState = ref.watch(deliveryTrackingProvider);
    final purchasesState = ref.watch(purchasesNotifierProvider);
    final salesState = ref.watch(salesNotifierProvider);
    final job = trackingState.job;

    // Fetch payment details when job is loaded and we have the ID
    ref.listen(deliveryTrackingProvider.select((s) => s.job), (prev, next) {
      if (next != null &&
          (prev == null || prev.paymentRequestId != next.paymentRequestId)) {
        // First fetch the request details to get the payment code (if needed) or basic info
        ref
            .read(paymentNotifierProvider.notifier)
            .fetchPaymentRequestDetails(next.paymentRequestId);
      }
    });

    // If we have payment request details, try to fetch full details (with seller info) using payment code
    ref.listen(paymentNotifierProvider.select((s) => s.paymentRequestDetails), (
      prev,
      next,
    ) {
      if (next != null &&
          next.paymentCode != null &&
          (prev == null || prev.paymentCode != next.paymentCode)) {
        ref
            .read(paymentNotifierProvider.notifier)
            .getPaymentDetails(paymentCode: next.paymentCode!);
      }
    });

    if (trackingState.isLoading && job == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (job == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Transaction Details')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                trackingState.errorMessage ?? 'Failed to load delivery details',
              ),
              const SizedBox(height: 16),
              ElevatedButton(onPressed: _loadData, child: const Text('Retry')),
            ],
          ),
        ),
      );
    }

    final status = DeliveryStatus.fromString(job.status);
    final isPickupInitiated = status.isAtOrAfter(DeliveryStatus.searching);

    final double amount;
    final DateTime date;
    final double itemPrice;
    final String itemName;
    final String itemDesc;
    final double serviceFee;
    final String feeLabel;
    final double escrowAmount;
    final String escrowText;
    final String? deliveryStatus;
    final String? orderStatus;

    if (widget.isBuyer) {
      // Buyer: Use purchase detail
      final purchase = purchasesState.purchaseDetail;
      amount = purchase?.totalAmount ?? 0.0;
      date = purchase?.paidAt ?? purchase?.createdAt ?? job.createdAt;
      itemPrice = purchase?.itemPrice ?? 0.0;
      itemName = purchase?.itemName ?? 'Item';
      itemDesc = purchase?.itemDescription ?? '';
      serviceFee = purchase?.buyerServiceFee ?? 0.0;
      feeLabel =
          '+${serviceFee > 0 ? '${(serviceFee / itemPrice * 100).toStringAsFixed(0)}%' : ''} Buyer Fee';
      escrowAmount = amount;
      escrowText = purchase?.status.toLowerCase() == 'completed'
          ? 'Funds have been released to the seller'
          : 'Your payment of ₦${amount.toStringAsFixed(2)} is held safely until you confirm delivery';
      deliveryStatus = purchase?.delivery?.status;
      orderStatus = purchase?.status;
    } else {
      // Seller: Use sale detail
      final sale = salesState.saleDetail;
      amount = sale?.totalAmount ?? 0.0;
      date = sale?.paidAt ?? sale?.createdAt ?? job.createdAt;
      itemPrice = sale?.itemPrice ?? 0.0;
      itemName = sale?.itemName ?? 'Item';
      itemDesc = '';
      final escrowLocked = sale?.escrow?.totalLocked ?? 0.0;
      final itemAmount = sale?.escrow?.itemAmount ?? itemPrice;
      serviceFee = escrowLocked - itemAmount;
      feeLabel = serviceFee > 0
          ? '-${(serviceFee / itemPrice * 100).toStringAsFixed(0)}% Seller Fee'
          : 'Seller Fee';
      escrowAmount = sale?.escrow?.totalLocked ?? amount;
      escrowText = sale?.orderStatus.toLowerCase() == 'completed'
          ? 'Funds have been released to you'
          : 'Buyer\'s payment of ₦${escrowAmount.toStringAsFixed(2)} is held safely until buyer confirms delivery';
      deliveryStatus = sale?.delivery?.status;
      orderStatus = sale?.orderStatus;
    }

    final String? displayCode;
    final String codeTitle;
    final String codeSubtitle;

    if (widget.isBuyer) {
      displayCode =
          purchasesState.purchaseDetail?.delivery?.dropoffCode ??
          purchasesState.purchaseDetail?.timeline?.dropoffCode;
      codeTitle = 'Your Drop-off Code';
      codeSubtitle = 'Share this code with your rider';
    } else {
      displayCode =
          salesState.saleDetail?.delivery?.pickupCode ??
          salesState.saleDetail?.timeline?.pickupCode;
      codeTitle = 'Your Pickup Code';
      codeSubtitle = 'Share this code with your rider';
    }

    final riderStatusText = getRiderStatusText(status, isBuyer: widget.isBuyer);

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
          'Transaction Details',
          fontWeight: FontWeight.w600,
          fontSize: 18,
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            if (!isPickupInitiated) ...[
              PaymentStatusCard(amount: amount, date: date),
              verticalSpace(24),
            ] else ...[
              RiderInfoBanner(statusText: riderStatusText),
              verticalSpace(24),

              if (displayCode != null && displayCode.isNotEmpty) ...[
                CodeCard(
                  code: displayCode,
                  title: codeTitle,
                  subtitle: codeSubtitle,
                ),
                verticalSpace(24),
              ],

              // Map Preview
              _buildMapPreview(job),
              verticalSpace(24),
            ],

            // Product Details Card
            _buildProductDetailsCard(
              itemName: itemName,
              itemSpecs: itemDesc,
              itemPrice: itemPrice,
              serviceFee: serviceFee,
              feeLabel: feeLabel,
              totalAmount: amount,
              deliveryStatus: deliveryStatus,
              orderStatus: orderStatus,
            ),
            verticalSpace(24),

            // Processing Status (Only for Screen 1 flow mainly)
            if (!isPickupInitiated) ...[
              const ProcessingStatusCard(daysLeft: 3),
              verticalSpace(24),
            ],

            // Timeline
            _buildTimeline(
              widget.isBuyer
                  ? purchasesState.purchaseDetail?.timeline
                  : salesState.saleDetail?.timeline,
            ),
            verticalSpace(24),

            // Seller/Buyer/Rider Information
            if (widget.isBuyer) ...[
              if (job.rider != null) ...[
                BuyerInfoCard(
                  title: 'Rider Information',
                  roleLabel: 'Rider',
                  name: job.rider!.name,
                  email: '', // Riders don't have email in the entity
                  phone: job.rider!.phone,
                  imageUrl: job.rider!.photoUrl,
                  onCall: () {},
                  onChat: () {},
                  chatIcon: Icons.chat,
                ),
                verticalSpace(24),
              ],
            ] else ...[
              if (job.rider != null) ...[
                BuyerInfoCard(
                  title: 'Rider Information',
                  roleLabel: 'Rider',
                  name: job.rider!.name,
                  imageUrl: job.rider!.photoUrl,
                  email: '',
                  phone: job.rider!.phone,
                  onCall: () {},
                  onChat: () {},
                  chatIcon: Icons.chat,
                ),
                verticalSpace(24),
              ],
            ],

            // Safe Funds Banner
            SafeFundsBanner(amount: escrowAmount, customText: escrowText),
            verticalSpace(24),

            // Delivery Actions (for buyers when delivered and not completed)
            if (widget.isBuyer &&
                job.status.toLowerCase() == 'delivered' &&
                purchasesState.purchaseDetail?.status.toLowerCase() !=
                    'completed') ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 42),
                child: CustomButton(
                  title: 'Open Dispute',
                  onTap: () {},
                  color: AppColor.kipaGrey.withAlpha(50),
                  textColor: AppColor.primaryText,
                  borderRadius: 30,
                ),
              ),
              verticalSpace(16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 42),
                child: CustomButton(
                  title: 'Confirm Delivery',
                  onTap: () async {
                    if (widget.purchaseId == null) return;

                    final confirmed = await ref
                        .read(purchasesNotifierProvider.notifier)
                        .confirmDelivery(widget.purchaseId!);

                    if (confirmed && context.mounted) {
                      CustomSnackBar.show(
                        context,
                        message:
                            'Delivery confirmed. Payment released to seller.',
                        type: SnackBarType.success,
                      );
                      // Refresh purchase detail
                      ref
                          .read(purchasesNotifierProvider.notifier)
                          .fetchPurchaseById(widget.purchaseId!);
                    } else if (context.mounted) {
                      final errorMessage =
                          ref.read(purchasesNotifierProvider).errorMessage ??
                          'Failed to confirm delivery';
                      CustomSnackBar.show(
                        context,
                        message: errorMessage,
                        type: SnackBarType.error,
                      );
                    }
                  },
                  icon: CupertinoIcons.checkmark_circle,
                  borderRadius: 30,
                ),
              ),
              verticalSpace(16),
            ],
            verticalSpace(20),
          ],
        ),
      ),
    );
  }

  Widget _buildProductDetailsCard({
    required String itemName,
    required String itemSpecs,
    required double itemPrice,
    required double serviceFee,
    required String feeLabel,
    required double totalAmount,
    String? deliveryStatus,
    String? orderStatus,
  }) {
    final currencyFormatter = NumberFormat.currency(
      symbol: '₦',
      decimalDigits: 2,
    );

    // Determine status badge based on actual delivery status
    String? statusText;
    Color? statusBgColor;
    Color? statusTextColor;
    IconData? statusIcon;

    if (deliveryStatus != null) {
      final normalizedStatus = deliveryStatus.toLowerCase();

      if (normalizedStatus == 'delivered') {
        statusText = 'Delivered';
        statusBgColor = const Color(0xFFE0F2F1);
        statusTextColor = const Color(0xFF00695C);
        statusIcon = Icons.check_circle;
      } else if (normalizedStatus == 'in_transit' ||
          normalizedStatus == 'intransit') {
        statusText = 'In Transit';
        statusBgColor = const Color(0xFFE8EAF6);
        statusTextColor = AppColor.primary;
        statusIcon = Icons.local_shipping;
      } else if (normalizedStatus == 'picked_up' ||
          normalizedStatus == 'pickedup') {
        statusText = 'Picked Up';
        statusBgColor = const Color(0xFFE8EAF6);
        statusTextColor = AppColor.primary;
        statusIcon = Icons.shopping_bag;
      } else if (normalizedStatus == 'accepted') {
        statusText = 'Rider Assigned';
        statusBgColor = const Color(0xFFE8EAF6);
        statusTextColor = AppColor.primary;
        statusIcon = Icons.two_wheeler;
      } else if (normalizedStatus == 'searching' ||
          normalizedStatus == 'searching_rider') {
        statusText = 'Searching Rider';
        statusBgColor = const Color(0xFFFFF3E0);
        statusTextColor = const Color(0xFFE65100);
        statusIcon = Icons.search;
      }
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColor.cardBackground2,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (statusText != null)
                _buildBadge(
                  text: statusText,
                  color: statusBgColor!,
                  textColor: statusTextColor!,
                  icon: statusIcon,
                ),
              if (statusText != null) horizontalSpace(8),
              _buildBadge(
                text: 'Kipa Protected',
                color: const Color(0xFFE0F2F1),
                textColor: const Color(0xFF00695C),
                icon: Icons.verified_user_outlined,
              ),
            ],
          ),
          verticalSpace(16),

          BodyText(itemName, fontWeight: FontWeight.w600, fontSize: 16),
          verticalSpace(4),
          if (itemSpecs.isNotEmpty) ...[
            BodySmall(
              itemSpecs,
              color: AppColor.lightText,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            verticalSpace(16),
          ] else
            verticalSpace(16),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Caption('Item Price'),
              BodySmall(
                currencyFormatter.format(itemPrice),
                fontWeight: FontWeight.w500,
              ),
            ],
          ),
          verticalSpace(8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Caption(feeLabel),
              BodySmall(
                currencyFormatter.format(serviceFee),
                fontWeight: FontWeight.w500,
              ),
            ],
          ),
          verticalSpace(16),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Caption('Total Amount', fontWeight: FontWeight.w600),
              BodyText(currencyFormatter.format(totalAmount)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBadge({
    required String text,
    required Color color,
    required Color textColor,
    IconData? icon,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 12, color: textColor),
            horizontalSpace(4),
          ],
          Text(
            text,
            style: TextStyle(
              color: textColor,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMapPreview(dynamic job) {
    // Determine lat/lng from job
    final lat = job.pickupLat ?? 6.5244;
    final lng = job.pickupLng ?? 3.3792;

    return GestureDetector(
      onTap: () {
        // Navigate to delivery tracking screen
        Navigator.pushNamed(
          context,
          RouteNames.deliveryTrackingRoute,
          arguments: {'deliveryJobId': job.id, 'initialJob': job},
        );
      },
      child: SizedBox(
        height: 200,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Column(
            children: [
              Expanded(
                child: Stack(
                  children: [
                    GoogleMap(
                      initialCameraPosition: CameraPosition(
                        target: LatLng(lat, lng),
                        zoom: 14,
                      ),
                      zoomControlsEnabled: false,
                      myLocationButtonEnabled: false,
                      mapToolbarEnabled: false,
                      liteModeEnabled: true,
                    ),
                    // Overlay to indicate it's clickable
                    Positioned(
                      top: 12,
                      right: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: AppColor.primary,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withAlpha(30),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.my_location,
                              size: 14,
                              color: Colors.white,
                            ),
                            SizedBox(width: 4),
                            Text(
                              'Track Delivery',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: const BoxDecoration(
                  color: AppColor.cardBackground2,
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(16),
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        const Icon(
                          Icons.my_location,
                          size: 14,
                          color: AppColor.primary,
                        ),
                        Container(
                          height: 25,
                          width: 1,
                          margin: const EdgeInsets.symmetric(vertical: 2),
                          child: CustomPaint(
                            painter: DottedLinePainter(
                              color: Colors.grey.withAlpha(100),
                            ),
                          ),
                        ),
                        const Icon(
                          Icons.location_on,
                          size: 14,
                          color: AppColor.green,
                        ),
                      ],
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            job.pickupAddress.isNotEmpty
                                ? job.pickupAddress
                                : 'Pickup Point',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 29),
                          Text(
                            job.dropoffAddress.isNotEmpty
                                ? job.dropoffAddress
                                : 'Destination',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTimeline(dynamic timeline) {
    final dateFormat = DateFormat('MMM d, h:mma');

    if (timeline == null) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: CircularProgressIndicator(),
        ),
      );
    }

    final steps = timeline.steps ?? [];
    final currentStep = timeline.currentStep ?? '';

    return TransactionTimeline(
      steps: steps.map<TimelineStep>((step) {
        final isCompleted = step.status == 'completed';
        final isCurrent = step.step == currentStep;
        final timestamp = step.timestamp;

        Widget? extraWidget;
        if (step.step == 'payment_received') {
          extraWidget = Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: const Color(0xFFE0F2F1),
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Text(
              'Funds in Kipa Protect',
              style: TextStyle(fontSize: 10, color: Color(0xFF00695C)),
            ),
          );
        }

        return TimelineStep(
          title: step.title,
          subtitle: timestamp != null
              ? dateFormat.format(timestamp)
              : step.description,
          isCompleted: isCompleted,
          isActive: isCurrent,
          extraWidget: extraWidget,
        );
      }).toList(),
    );
  }
}
