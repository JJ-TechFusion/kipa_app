import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:kipa/core/shared/widgets/custom_snackbar.dart';
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
  bool _deliveryConfirmed = false;
  bool _disputeOpened = false;
  bool _returnConfirmed = false;

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

    if (widget.isBuyer && widget.purchaseId != null) {
      ref
          .read(purchasesNotifierProvider.notifier)
          .fetchPurchaseById(widget.purchaseId!);
    }

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
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
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

    // Check if this is a return flow based on timeline.phase
    final isReturnFlow = widget.isBuyer
        ? purchasesState.purchaseDetail?.timeline?.phase?.toLowerCase() ==
              'return'
        : salesState.saleDetail?.timeline?.phase?.toLowerCase() == 'return';

    if (widget.isBuyer) {
      if (isReturnFlow) {
        // During return: buyer has pickup code from timeline (they're sending item back)
        displayCode = purchasesState.purchaseDetail?.timeline?.pickupCode;
        codeTitle = 'Your Pickup Code';
        codeSubtitle = 'Share this code with the rider picking up';
      } else {
        // Normal delivery: buyer has dropoff code
        displayCode =
            purchasesState.purchaseDetail?.delivery?.dropoffCode ??
            purchasesState.purchaseDetail?.timeline?.dropoffCode;
        codeTitle = 'Your Drop-off Code';
        codeSubtitle = 'Share this code with your rider';
      }
    } else {
      final isForcedReturn =
          salesState.saleDetail?.delivery?.status.toLowerCase() ==
          'forced_return';
      if (isReturnFlow || isForcedReturn) {
        // During return or forced return: seller has dropoff code (they're receiving item back)
        displayCode =
            salesState.saleDetail?.timeline?.dropoffCode ??
            salesState.saleDetail?.delivery?.dropoffCode;
        codeTitle = 'Your Drop-off Code';
        codeSubtitle = 'Share this code with the rider returning the item';
      } else {
        // Normal delivery: seller has pickup code
        displayCode =
            salesState.saleDetail?.delivery?.pickupCode ??
            salesState.saleDetail?.timeline?.pickupCode;
        codeTitle = 'Your Pickup Code';
        codeSubtitle = 'Share this code with your rider';
      }
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

              Builder(
                builder: (ctx) {
                  bool isReturnConfirmed = false;
                  if (widget.isBuyer) {
                    isReturnConfirmed =
                        purchasesState.purchaseDetail?.timeline?.steps.any(
                          (s) =>
                              (s.step == 'return_confirmed' ||
                                  s.title.toLowerCase().contains(
                                    'return confirmed',
                                  )) &&
                              (s.status == 'completed' || s.status == 'done'),
                        ) ==
                        true;
                  } else {
                    isReturnConfirmed =
                        salesState.saleDetail?.timeline?.steps.any(
                          (s) =>
                              (s.step == 'return_confirmed' ||
                                  s.title.toLowerCase().contains(
                                    'return confirmed',
                                  )) &&
                              (s.status == 'completed' || s.status == 'done'),
                        ) ==
                        true;
                  }

                  final isMapDisabled =
                      orderStatus?.toLowerCase() == 'completed' ||
                      isReturnConfirmed;

                  return _buildMapPreview(
                    job,
                    isReturnFlow: isReturnFlow,
                    trackingJobId: isReturnFlow
                        ? (widget.isBuyer
                              ? purchasesState
                                    .purchaseDetail
                                    ?.delivery
                                    ?.returnJobId
                              : salesState.saleDetail?.delivery?.returnJobId)
                        : null,
                    disabled: isMapDisabled,
                  );
                },
              ),
              verticalSpace(24),
            ],

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

            if (!isPickupInitiated) ...[
              const ProcessingStatusCard(daysLeft: 3),
              verticalSpace(24),
            ],

            _buildTimeline(
              widget.isBuyer
                  ? purchasesState.purchaseDetail?.timeline
                  : salesState.saleDetail?.timeline,
            ),
            verticalSpace(24),

            if (widget.isBuyer) ...[
              if (job.rider != null) ...[
                BuyerInfoCard(
                  title: 'Rider Information',
                  roleLabel: 'Rider',
                  name: job.rider!.name,
                  email: '',
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

            SafeFundsBanner(amount: escrowAmount, customText: escrowText),
            verticalSpace(24),

            if (widget.isBuyer &&
                !_deliveryConfirmed &&
                !_disputeOpened &&
                job.status.toLowerCase() == 'delivered' &&
                purchasesState.purchaseDetail?.status.toLowerCase() !=
                    'completed' &&
                purchasesState.purchaseDetail?.status.toLowerCase() !=
                    'disputed') ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 42),
                child: CustomButton(
                  title: 'Open Dispute',
                  onTap: () async {
                    await Navigator.pushNamed(
                      context,
                      RouteNames.disputeRoute,
                      arguments: {
                        'purchaseId': widget.purchaseId,
                        'itemName': purchasesState.purchaseDetail?.itemName,
                      },
                    );
                    if (mounted && widget.purchaseId != null) {
                      setState(() => _disputeOpened = true);
                      ref
                          .read(purchasesNotifierProvider.notifier)
                          .fetchPurchaseById(widget.purchaseId!);
                    }
                  },
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
                      setState(() => _deliveryConfirmed = true);
                      CustomSnackBar.show(
                        context,
                        message:
                            'Delivery confirmed. Payment released to seller.',
                        type: SnackBarType.success,
                      );
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

            if (widget.isBuyer &&
                !_returnConfirmed &&
                purchasesState.purchaseDetail?.prStatus?.toLowerCase() ==
                    'return_required') ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 42),
                child: CustomButton(
                  title: 'Confirm Return',
                  isLoading: purchasesState.isInitiatingReturn,
                  onTap: () async {
                    if (widget.purchaseId == null) return;

                    final response = await ref
                        .read(purchasesNotifierProvider.notifier)
                        .readyForReturn(widget.purchaseId!);

                    if (response != null && context.mounted) {
                      setState(() => _returnConfirmed = true);
                      Navigator.pushNamed(
                        context,
                        RouteNames.deliveryTrackingRoute,
                        arguments: {
                          'deliveryJobId': response.returnJobId,
                          'isReturnFlow': true,
                        },
                      );
                    } else if (context.mounted) {
                      final errorMessage =
                          ref.read(purchasesNotifierProvider).errorMessage ??
                          'Failed to initiate return';
                      CustomSnackBar.show(
                        context,
                        message: errorMessage,
                        type: SnackBarType.error,
                      );
                    }
                  },
                  icon: Icons.assignment_return,
                  borderRadius: 30,
                ),
              ),
              verticalSpace(16),
            ],

            // Buyer: Rebook rider when buyer was unavailable
            if (widget.isBuyer &&
                purchasesState.purchaseDetail?.prStatus?.toLowerCase() ==
                    'pending_rebook' &&
                purchasesState.purchaseDetail?.delivery?.status.toLowerCase() ==
                    'buyer_unavailable') ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 42),
                child: CustomButton(
                  title: 'Rebook Rider',
                  isLoading: purchasesState.isRebooking,
                  onTap: () async {
                    if (widget.purchaseId == null) return;

                    final success = await ref
                        .read(purchasesNotifierProvider.notifier)
                        .rebookDelivery(widget.purchaseId!);

                    if (success && context.mounted) {
                      CustomSnackBar.show(
                        context,
                        message:
                            'Delivery rebooked! Rider will continue to your location.',
                        type: SnackBarType.success,
                      );
                      ref
                          .read(purchasesNotifierProvider.notifier)
                          .fetchPurchaseById(widget.purchaseId!);
                    } else if (context.mounted) {
                      final errorMessage =
                          ref.read(purchasesNotifierProvider).errorMessage ??
                          'Failed to rebook delivery';
                      CustomSnackBar.show(
                        context,
                        message: errorMessage,
                        type: SnackBarType.error,
                      );
                    }
                  },
                  icon: Icons.refresh,
                  borderRadius: 30,
                ),
              ),
              verticalSpace(16),
            ],

            // Seller: Confirm return when return_delivered step is completed
            if (!widget.isBuyer && widget.saleId != null) ...[
              Builder(
                builder: (context) {
                  final timeline = salesState.saleDetail?.timeline;
                  final currentStep = timeline?.currentStep ?? '';

                  final isReturnDelivered =
                      currentStep == 'return_delivered' ||
                      currentStep == 'return_confirmed';

                  final isReturnAlreadyConfirmed = (timeline?.steps ?? []).any(
                    (s) =>
                        (s.step == 'return_confirmed' ||
                            s.title.toLowerCase().contains(
                              'return confirmed',
                            )) &&
                        (s.status == 'completed' || s.status == 'done'),
                  );

                  if (isReturnDelivered && !isReturnAlreadyConfirmed) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 42),
                      child: CustomButton(
                        title: 'Confirm Return',
                        isLoading: salesState.isConfirmingReturn,
                        onTap: () => Navigator.pushNamed(
                          context,
                          RouteNames.confirmReturnRoute,
                          arguments: {'saleId': widget.saleId},
                        ),
                        icon: Icons.check_circle,
                        borderRadius: 30,
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
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
      } else if (normalizedStatus == 'buyer_unavailable') {
        statusText = 'Buyer Unavailable';
        statusBgColor = const Color(0xFFFFF3E0);
        statusTextColor = const Color(0xFFE65100);
        statusIcon = Icons.person_off;
      } else if (normalizedStatus == 'forced_return') {
        statusText = 'Returning to Seller';
        statusBgColor = const Color(0xFFFFEBEE);
        statusTextColor = const Color(0xFFC62828);
        statusIcon = Icons.assignment_return;
      } else if (normalizedStatus == 'forced_return_done') {
        statusText = 'Returned - Refund Processing';
        statusBgColor = const Color(0xFFE8F5E9);
        statusTextColor = const Color(0xFF2E7D32);
        statusIcon = Icons.payments;
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

  Widget _buildMapPreview(
    dynamic job, {
    String? trackingJobId,
    bool isReturnFlow = false,
    bool disabled = false,
  }) {
    // Determine lat/lng from job
    final lat = job.pickupLat ?? 6.5244;
    final lng = job.pickupLng ?? 3.3792;
    final jobIdToTrack = trackingJobId ?? job.id;

    // During return the item travels back: dropoff becomes origin, pickup becomes destination
    final topAddress = isReturnFlow
        ? (job.dropoffAddress.isNotEmpty ? job.dropoffAddress : 'Pickup Point')
        : (job.pickupAddress.isNotEmpty ? job.pickupAddress : 'Pickup Point');
    final bottomAddress = isReturnFlow
        ? (job.pickupAddress.isNotEmpty ? job.pickupAddress : 'Destination')
        : (job.dropoffAddress.isNotEmpty ? job.dropoffAddress : 'Destination');

    return GestureDetector(
      onTap: disabled
          ? null
          : () {
              Navigator.pushNamed(
                context,
                RouteNames.deliveryTrackingRoute,
                arguments: {
                  'deliveryJobId': jobIdToTrack,
                  if (trackingJobId != null) 'initialJob': null,
                },
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
                    if (!disabled)
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
                            topAddress,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 29),
                          Text(
                            bottomAddress,
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
