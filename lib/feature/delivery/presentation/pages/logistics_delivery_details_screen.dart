import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:kipa/core/shared/widgets/app_webview_page.dart';
import 'package:kipa/core/shared/widgets/buttons/roundedbutton.dart';
import 'package:kipa/core/shared/widgets/custom_snackbar.dart';
import 'package:kipa/core/shared/widgets/custom_text.dart';
import 'package:kipa/core/shared/widgets/textfields/custom_field.dart';
import 'package:kipa/feature/auth/presentation/providers/auth_provider.dart';
import 'package:kipa/feature/delivery/domain/entities/logistics_delivery_entity.dart';
import 'package:kipa/feature/delivery/presentation/providers/delivery_provider.dart';
import 'package:kipa/feature/delivery/presentation/widgets/delivery_list_item.dart';
import 'package:kipa/feature/payment/presentation/widgets/transaction_timeline.dart';
import 'package:kipa/theme/app_colors.dart';
import 'package:kipa/utils/constant.dart';

class LogisticsDeliveryDetailsScreen extends ConsumerStatefulWidget {
  final String logisticsDeliveryId;

  const LogisticsDeliveryDetailsScreen({
    super.key,
    required this.logisticsDeliveryId,
  });

  @override
  ConsumerState<LogisticsDeliveryDetailsScreen> createState() =>
      _LogisticsDeliveryDetailsScreenState();
}

class _LogisticsDeliveryDetailsScreenState
    extends ConsumerState<LogisticsDeliveryDetailsScreen> {
  final _imagePicker = ImagePicker();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(logisticsNotifierProvider.notifier)
          .fetchLogisticsDeliveryDetails(widget.logisticsDeliveryId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(logisticsNotifierProvider);
    final authState = ref.watch(authNotifierProvider);
    final currentUserId = authState.currentUser?.id ?? '';
    final details = state.currentDetails;

    final isBuyer = details != null && details.buyer.id == currentUserId;
    final isSeller = details != null && details.seller.id == currentUserId;

    return Scaffold(
      backgroundColor: AppColor.scaffoldBackground,
      appBar: AppBar(
        title: const BodyText(
          'Delivery Details',
          fontWeight: FontWeight.w600,
          fontSize: 18,
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: state.isFetchingDetails
          ? const Center(child: CircularProgressIndicator.adaptive())
          : details == null
          ? _buildError(state.errorMessage)
          : RefreshIndicator.adaptive(
              onRefresh: () async {
                await ref
                    .read(logisticsNotifierProvider.notifier)
                    .fetchLogisticsDeliveryDetails(widget.logisticsDeliveryId);
              },
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
                children: [
                  _buildDeliveryStatusCard(details),
                  verticalSpace(16),
                  if (details.delivery.status == 'in_transit')
                    _buildDeliveryBannerCard(details),

                  verticalSpace(16),
                  _buildItemCard(details),
                  verticalSpace(16),
                  _buildRouteCard(details),
                  verticalSpace(16),
                  if (details.delivery.carrier.isNotEmpty) ...[
                    verticalSpace(16),
                    _buildShippingCard(context, details),
                  ],
                  verticalSpace(16),
                  _buildEscrowCard(details),
                  verticalSpace(16),
                  _buildPartiesCard(details),
                  if (details.timeline != null) ...[
                    verticalSpace(16),
                    _buildTimelineCard(details.timeline!),
                  ],
                  if (details.events.isNotEmpty) ...[
                    verticalSpace(16),
                    _buildEventsCard(details.events),
                  ],
                  if (details.dispute != null) ...[
                    verticalSpace(16),
                    _buildDisputeCard(details.dispute!),
                  ],
                  if (isSeller || isBuyer) ...[
                    verticalSpace(24),
                    _buildActions(
                      context,
                      details,
                      isSeller: isSeller,
                      isBuyer: isBuyer,
                    ),
                  ],
                ],
              ),
            ),
    );
  }

  Widget _buildDeliveryStatusCard(LogisticsDeliveryDetailsEntity details) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22.0),
      child: Container(
        padding: const EdgeInsets.all(12),

        decoration: BoxDecoration(
          color: Color(0xFFE0E7FF),
          borderRadius: BorderRadius.circular(20),
        ),
        child: BodyText(
          'Your item has been ${details.delivery.status}',
          fontWeight: FontWeight.w500,
          fontSize: 16,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildDeliveryBannerCard(LogisticsDeliveryDetailsEntity details) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppColor.primary, AppColor.primary.withValues(alpha: 0.8)],
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Overline(
                      details.delivery.status,
                      color: AppColor.primary,
                    ),
                  ),
                  verticalSpace(40),
                  BodyText(
                    'In Transit to ${details.delivery.dropoffState}',
                    fontWeight: FontWeight.w500,
                    textAlign: TextAlign.center,
                    color: Colors.white,
                  ),
                  verticalSpace(5),
                  Caption(
                    'Estimated Delivery: 3-5 Days',
                    fontWeight: FontWeight.w500,
                    textAlign: TextAlign.center,
                    color: Color(0xFFD1D5DB),
                  ),
                ],
              ),
              Image.asset("assets/images/van.png", width: 150, height: 100),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildError(String? message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: AppColor.lightText.withValues(alpha: 0.5),
          ),
          verticalSpace(16),
          BodyText(
            message ?? 'Failed to load delivery details',
            color: AppColor.lightText,
          ),
          verticalSpace(16),
          TextButton(
            onPressed: () {
              ref
                  .read(logisticsNotifierProvider.notifier)
                  .fetchLogisticsDeliveryDetails(widget.logisticsDeliveryId);
            },
            child: const BodySmall('Retry', color: AppColor.primary),
          ),
        ],
      ),
    );
  }

  Widget _buildItemCard(LogisticsDeliveryDetailsEntity details) {
    final pr = details.paymentRequest;
    final delivery = details.delivery;
    final currencyFormatter = NumberFormat.currency(
      symbol: '₦',
      decimalDigits: 2,
    );

    Color statusBgColor;
    Color statusTextColor;
    IconData statusIcon;
    String statusText;

    switch (delivery.status) {
      case 'awaiting_shipment':
        statusText = 'Awaiting Shipment';
        statusBgColor = const Color(0xFFFFF3E0);
        statusTextColor = const Color(0xFFE65100);
        statusIcon = Icons.pending_actions;
        break;
      case 'shipped':
        statusText = 'Shipped';
        statusBgColor = const Color(0xFFE8EAF6);
        statusTextColor = AppColor.primary;
        statusIcon = Icons.local_shipping;
        break;
      case 'delivered':
        statusText = 'Delivered';
        statusBgColor = const Color(0xFFE0F2F1);
        statusTextColor = const Color(0xFF00695C);
        statusIcon = Icons.check_circle;
        break;
      case 'disputed':
        statusText = 'Disputed';
        statusBgColor = const Color(0xFFFFEBEE);
        statusTextColor = const Color(0xFFC62828);
        statusIcon = Icons.gavel;
        break;
      case 'refunded':
        statusText = 'Refunded';
        statusBgColor = const Color(0xFFEDE7F6);
        statusTextColor = Colors.purple;
        statusIcon = Icons.undo;
        break;
      default:
        statusText = delivery.statusDisplay;
        statusBgColor = AppColor.kipaGrey.withValues(alpha: 0.15);
        statusTextColor = AppColor.kipaGrey;
        statusIcon = Icons.info;
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
              _buildBadge(
                text: statusText,
                color: statusBgColor,
                textColor: statusTextColor,
                icon: statusIcon,
              ),
              horizontalSpace(8),
              _buildBadge(
                text: 'Kipa Protected',
                color: const Color(0xFFE0F2F1),
                textColor: const Color(0xFF00695C),
                icon: Icons.verified_user_outlined,
              ),
              if (delivery.isShipDeadlineExceeded) ...[
                horizontalSpace(8),
                _buildBadge(
                  text: 'Deadline Exceeded',
                  color: const Color(0xFFFFEBEE),
                  textColor: const Color(0xFFC62828),
                  icon: Icons.warning,
                ),
              ],
            ],
          ),
          verticalSpace(16),
          BodyText(pr.itemName, fontWeight: FontWeight.w600, fontSize: 16),
          verticalSpace(4),
          if (pr.itemDescription.isNotEmpty) ...[
            BodySmall(
              pr.itemDescription,
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
                currencyFormatter.format(pr.itemPrice),
                fontWeight: FontWeight.w500,
              ),
            ],
          ),
          verticalSpace(8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Caption('Buyer Fee'),
              BodySmall(
                currencyFormatter.format(pr.buyerServiceFee),
                fontWeight: FontWeight.w500,
              ),
            ],
          ),
          verticalSpace(16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Caption('Total Amount', fontWeight: FontWeight.w600),
              BodyText(currencyFormatter.format(pr.estimatedTotal)),
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

  Widget _buildRouteCard(LogisticsDeliveryDetailsEntity details) {
    final delivery = details.delivery;
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const BodySmall('Route', fontWeight: FontWeight.w600),
          verticalSpace(12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                spacing: 8,
                children: [
                  const Icon(Icons.location_on, size: 18, color: Colors.green),
                  Container(
                    width: 2,
                    height: 32,
                    color: AppColor.kipaGrey.withValues(alpha: 0.3),
                  ),
                  const Icon(Icons.location_on, size: 18, color: Colors.red),
                ],
              ),
              horizontalSpace(12),
              Expanded(
                child: Column(
                  spacing: 12,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BodySmall(
                      delivery.pickupState,
                      fontWeight: FontWeight.w600,
                    ),
                    Caption(delivery.pickupAddress, color: AppColor.kipaGrey2),
                    verticalSpace(8),
                    BodySmall(
                      delivery.dropoffState,
                      fontWeight: FontWeight.w600,
                    ),
                    Caption(delivery.dropoffAddress, color: AppColor.kipaGrey2),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPartiesCard(LogisticsDeliveryDetailsEntity details) {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const BodySmall('Parties', fontWeight: FontWeight.w600),
          verticalSpace(12),

          _partyRow(
            icon: Icons.store,
            label: 'Seller',
            name: details.seller.fullName,
            phone: details.seller.phoneNumber,
          ),
          verticalSpace(12),
          const Divider(height: 1),
          verticalSpace(12),
          _partyRow(
            icon: Icons.person,
            label: 'Buyer',
            name: details.buyer.fullName,
            phone: details.buyer.phoneNumber,
          ),
        ],
      ),
    );
  }

  Widget _partyRow({
    required IconData icon,
    required String label,
    required String name,
    required String phone,
  }) {
    return Column(
      spacing: 18,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColor.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(icon, size: 16, color: AppColor.primary),
            ),
            horizontalSpace(12),
            Expanded(
              child: Column(
                spacing: 4,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BodySmall(name, fontWeight: FontWeight.w600),
                  Caption(label, color: AppColor.kipaGrey),
                ],
              ),
            ),
          ],
        ),
        Column(
          spacing: 6,
          children: [
            BodySmall("Phone Number", fontWeight: FontWeight.w600),
            Caption(phone, color: AppColor.kipaGrey2),
          ],
        ),
      ],
    );
  }

  Widget _buildShippingCard(
    BuildContext context,
    LogisticsDeliveryDetailsEntity details,
  ) {
    final delivery = details.delivery;
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const BodySmall('Shipment Details', fontWeight: FontWeight.w600),
              if (delivery.trackingUrl != null &&
                  delivery.trackingUrl!.isNotEmpty) ...[
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            AppWebviewPage(pageUrl: delivery.trackingUrl!),
                      ),
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.open_in_new,
                        size: 16,
                        color: AppColor.primary,
                      ),
                      horizontalSpace(8),
                      const BodySmall(
                        'Track',
                        color: AppColor.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
          verticalSpace(14),
          _infoRow(
            'Carrier',
            delivery.carrier.replaceAll("_", "  ").capitalize(),
          ),
          if (delivery.trackingNumber != null &&
              delivery.trackingNumber!.isNotEmpty) ...[
            verticalSpace(8),
            _infoRow('Tracking #', delivery.trackingNumber!),
          ],
          if (delivery.shippedAt != null) ...[
            verticalSpace(8),
            _infoRow('Shipped On', _formatDate(delivery.shippedAt!)),
          ],
        ],
      ),
    );
  }

  Widget _buildEscrowCard(LogisticsDeliveryDetailsEntity details) {
    final escrow = details.escrow;
    final pr = details.paymentRequest;

    final itemAmount = escrow?.itemAmount ?? pr.itemPrice;
    final buyerFee = escrow?.buyerFee ?? pr.buyerServiceFee;
    final totalLocked = escrow?.totalLocked ?? pr.estimatedTotal;
    final escrowStatus = escrow?.status ?? '';

    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const BodySmall('Escrow', fontWeight: FontWeight.w600),
              const Spacer(),
              if (escrowStatus.isNotEmpty) _escrowStatusBadge(escrowStatus),
            ],
          ),
          verticalSpace(12),
          _amountRow('Item Amount', itemAmount),
          verticalSpace(6),
          _amountRow('Buyer Fee', buyerFee),
          verticalSpace(8),
          const Divider(height: 1),
          verticalSpace(8),
          _amountRow('Total Locked', totalLocked, bold: true),
        ],
      ),
    );
  }

  Widget _amountRow(String label, double amount, {bool bold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Caption(label, color: AppColor.kipaGrey2),
        BodySmall(
          'N${amount.toStringAsFixed(2)}',
          fontWeight: bold ? FontWeight.w700 : FontWeight.w500,
          color: bold ? AppColor.primary : null,
        ),
      ],
    );
  }

  Widget _buildTimelineCard(LogisticsTimeline timeline) {
    final allSteps = [...timeline.steps, ...timeline.disputeSteps];

    final timelineSteps = allSteps.map((step) {
      return TimelineStep(
        title: step.title,
        subtitle: step.timestamp != null
            ? _formatDateTime(step.timestamp!)
            : step.description,
        isCompleted: step.isCompleted,
        isActive: step.isCurrent,
      );
    }).toList();

    return _card(child: TransactionTimeline(steps: timelineSteps));
  }

  Widget _buildEventsCard(List<LogisticsEventEntity> events) {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const BodySmall('Activity Log', fontWeight: FontWeight.w600),
          verticalSpace(12),
          ...events.map((event) => _buildEventItem(event)),
        ],
      ),
    );
  }

  Widget _buildEventItem(LogisticsEventEntity event) {
    final label = event.fromStatus != null
        ? '${_formatStatus(event.fromStatus!)} → ${_formatStatus(event.toStatus)}'
        : _formatStatus(event.toStatus);

    final actorLabel = _capitalize(event.actorType);

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 8,
            height: 8,
            margin: const EdgeInsets.only(top: 4),
            decoration: const BoxDecoration(
              color: AppColor.primary,
              shape: BoxShape.circle,
            ),
          ),
          horizontalSpace(10),
          Expanded(
            child: Column(
              spacing: 4,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BodySmall(label, fontWeight: FontWeight.w500),
                Caption(
                  '$actorLabel · ${_formatDateTime(event.createdAt)}',
                  color: AppColor.kipaGrey,
                ),
                if (event.reason != null && event.reason!.isNotEmpty) ...[
                  verticalSpace(2),
                  Caption(event.reason!, color: AppColor.kipaGrey2),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDisputeCard(LogisticsDisputeEntity dispute) {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.gavel, size: 16, color: Colors.orange),
              horizontalSpace(6),
              const Caption(
                'DISPUTE',
                color: Colors.orange,
                fontWeight: FontWeight.w600,
              ),
              const Spacer(),
              _tag(_capitalize(dispute.status), Colors.orange),
            ],
          ),
          verticalSpace(12),
          _infoRow('Reason', dispute.reason),
          if (dispute.outcome != null && dispute.outcome!.isNotEmpty) ...[
            verticalSpace(8),
            _infoRow('Outcome', _capitalize(dispute.outcome!)),
          ],
          if (dispute.resolutionNotes != null &&
              dispute.resolutionNotes!.isNotEmpty) ...[
            verticalSpace(8),
            Caption(
              'Resolution Notes',
              color: AppColor.kipaGrey,
              fontWeight: FontWeight.w500,
            ),
            verticalSpace(4),
            Caption(dispute.resolutionNotes!, color: AppColor.kipaGrey2),
          ],
          if (dispute.evidence.isNotEmpty) ...[
            verticalSpace(12),
            Caption(
              'Evidence (${dispute.evidence.length})',
              color: AppColor.kipaGrey,
              fontWeight: FontWeight.w500,
            ),
            verticalSpace(6),
            SizedBox(
              height: 80,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: dispute.evidence.length,
                separatorBuilder: (_, _) => horizontalSpace(8),
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              AppWebviewPage(pageUrl: dispute.evidence[index]),
                        ),
                      );
                    },
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: AppColor.kipaGrey.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: AppColor.kipaGrey.withValues(alpha: 0.3),
                        ),
                      ),
                      child: const Icon(
                        Icons.image,
                        color: AppColor.kipaGrey,
                        size: 32,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildActions(
    BuildContext context,
    LogisticsDeliveryDetailsEntity details, {
    required bool isSeller,
    required bool isBuyer,
  }) {
    final currentStatus = details.timeline?.currentStatus ?? '';

    // Seller: show Claim Delivery while current step is 'shipped'
    if (isSeller && currentStatus == 'shipped') {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 36.0),
        child: CustomButton(
          title: 'Claim Delivery',
          onTap: () => _showClaimDeliverySheet(context),
          color: AppColor.primary,
          textColor: Colors.white,
          borderRadius: 30,
        ),
      );
    }

    // Buyer: show Confirm + Dispute while current step is 'delivery_claimed'
    if (isBuyer && currentStatus == 'delivery_claimed') {
      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 36.0),
            child: CustomButton(
              title: 'Confirm Delivery',
              onTap: () => _showConfirmDeliverySheet(context),
              color: AppColor.primary,
              textColor: Colors.white,
              borderRadius: 30,
            ),
          ),
          verticalSpace(12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 36.0),
            child: CustomButton(
              title: 'Open Dispute',
              onTap: () => _showDisputeSheet(context),
              color: AppColor.kipaGrey.withValues(alpha: 0.15),
              textColor: AppColor.primaryText,
              borderRadius: 30,
            ),
          ),
        ],
      );
    }

    // Buyer: dispute resolved in their favour — ship the return back to seller
    if (isBuyer && currentStatus == 'return_required') {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 36.0),
        child: CustomButton(
          title: 'Mark Return Shipped',
          onTap: () => _showReturnShippedSheet(context),
          color: AppColor.primary,
          textColor: Colors.white,
          borderRadius: 30,
        ),
      );
    }

    // Seller: buyer has shipped the return — confirm receipt or dispute
    if (isSeller && currentStatus == 'return_shipped') {
      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 36.0),
            child: CustomButton(
              title: 'Confirm Return',
              onTap: () => _showConfirmReturnSheet(context),
              color: AppColor.primary,
              textColor: Colors.white,
              borderRadius: 30,
            ),
          ),
          verticalSpace(12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 36.0),
            child: CustomButton(
              title: 'Open Dispute',
              onTap: () => _showDisputeSheet(context),
              color: AppColor.kipaGrey.withValues(alpha: 0.15),
              textColor: AppColor.primaryText,
              borderRadius: 30,
            ),
          ),
        ],
      );
    }

    return const SizedBox.shrink();
  }

  Future<void> _showDisputeSheet(BuildContext context) async {
    final result = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _DisputeSheet(
        logisticsDeliveryId: widget.logisticsDeliveryId,
        imagePicker: _imagePicker,
      ),
    );
    if (result == true && context.mounted) {
      CustomSnackBar.show(
        context,
        message: 'Dispute opened. Admin will review shortly.',
        type: SnackBarType.success,
      );
    } else if (result == false && context.mounted) {
      final err = ref.read(logisticsNotifierProvider).errorMessage;
      CustomSnackBar.show(
        context,
        message: err ?? 'Failed to open dispute',
        type: SnackBarType.error,
      );
    }
  }

  Future<void> _showClaimDeliverySheet(BuildContext context) async {
    final result = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _ClaimDeliverySheet(
        logisticsDeliveryId: widget.logisticsDeliveryId,
        imagePicker: _imagePicker,
      ),
    );
    if (result == true && context.mounted) {
      CustomSnackBar.show(
        context,
        message: 'Delivery claimed successfully.',
        type: SnackBarType.success,
      );
    } else if (result == false && context.mounted) {
      final err = ref.read(logisticsNotifierProvider).errorMessage;
      CustomSnackBar.show(
        context,
        message: err ?? 'Failed to claim delivery',
        type: SnackBarType.error,
      );
    }
  }

  Future<void> _showConfirmDeliverySheet(BuildContext context) async {
    final result = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _ConfirmDeliverySheet(
        logisticsDeliveryId: widget.logisticsDeliveryId,
      ),
    );
    if (result == true && context.mounted) {
      CustomSnackBar.show(
        context,
        message: 'Delivery confirmed. Funds released to seller.',
        type: SnackBarType.success,
      );
    } else if (result == false && context.mounted) {
      final err = ref.read(logisticsNotifierProvider).errorMessage;
      CustomSnackBar.show(
        context,
        message: err ?? 'Failed to confirm delivery',
        type: SnackBarType.error,
      );
    }
  }

  Future<void> _showReturnShippedSheet(BuildContext context) async {
    final result = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) =>
          _ReturnShippedSheet(logisticsDeliveryId: widget.logisticsDeliveryId),
    );
    if (result == true && context.mounted) {
      CustomSnackBar.show(
        context,
        message: 'Return shipment marked. Seller has been notified.',
        type: SnackBarType.success,
      );
    } else if (result == false && context.mounted) {
      final err = ref.read(logisticsNotifierProvider).errorMessage;
      CustomSnackBar.show(
        context,
        message: err ?? 'Failed to mark return shipped',
        type: SnackBarType.error,
      );
    }
  }

  Future<void> _showConfirmReturnSheet(BuildContext context) async {
    final result = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) =>
          _ConfirmReturnSheet(logisticsDeliveryId: widget.logisticsDeliveryId),
    );
    if (result == true && context.mounted) {
      CustomSnackBar.show(
        context,
        message: 'Return confirmed. Refund will be processed.',
        type: SnackBarType.success,
      );
    } else if (result == false && context.mounted) {
      final err = ref.read(logisticsNotifierProvider).errorMessage;
      CustomSnackBar.show(
        context,
        message: err ?? 'Failed to confirm return',
        type: SnackBarType.error,
      );
    }
  }

  Widget _card({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColor.cardBackground2,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColor.cardShadow,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _escrowStatusBadge(String status) {
    Color color;
    switch (status) {
      case 'locked':
      case 'funded':
      case 'delivery_in_progress':
        color = Colors.orange;
        break;
      case 'released':
        color = Colors.green;
        break;
      case 'refunded':
        color = Colors.purple;
        break;
      default:
        color = AppColor.kipaGrey;
    }
    return _tag(_capitalize(status), color);
  }

  Widget _tag(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Caption(label, color: color, fontWeight: FontWeight.w600),
    );
  }

  Widget _infoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(width: 100, child: Caption(label, color: AppColor.kipaGrey)),
        Expanded(
          child: Caption(
            value,
            color: AppColor.primaryText,
            fontWeight: FontWeight.w500,
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }

  String _capitalize(String value) {
    if (value.isEmpty) return value;
    return value
        .split('_')
        .map((w) {
          if (w.isEmpty) return w;
          return w[0].toUpperCase() + w.substring(1);
        })
        .join(' ');
  }

  String _formatStatus(String status) => _capitalize(status);

  String _formatDate(DateTime dt) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${dt.day} ${months[dt.month - 1]} ${dt.year}';
  }

  String _formatDateTime(DateTime dt) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    final hour = dt.hour > 12 ? dt.hour - 12 : (dt.hour == 0 ? 12 : dt.hour);
    final period = dt.hour >= 12 ? 'PM' : 'AM';
    return '${dt.day} ${months[dt.month - 1]} at $hour:${dt.minute.toString().padLeft(2, '0')} $period';
  }
}

class _DisputeSheet extends ConsumerStatefulWidget {
  final String logisticsDeliveryId;
  final ImagePicker imagePicker;

  const _DisputeSheet({
    required this.logisticsDeliveryId,
    required this.imagePicker,
  });

  @override
  ConsumerState<_DisputeSheet> createState() => _DisputeSheetState();
}

class _DisputeSheetState extends ConsumerState<_DisputeSheet> {
  final _reasonController = TextEditingController();
  final List<File> _evidenceImages = [];
  bool _isSubmitting = false;

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      builder: (_) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const BodySmall('Choose from Gallery'),
              onTap: () => Navigator.pop(context, ImageSource.gallery),
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const BodySmall('Take a Photo'),
              onTap: () => Navigator.pop(context, ImageSource.camera),
            ),
          ],
        ),
      ),
    );
    if (source == null || !mounted) return;
    final picked = await widget.imagePicker.pickImage(
      source: source,
      maxWidth: 1024,
      maxHeight: 1024,
      imageQuality: 85,
    );
    if (picked != null && mounted) {
      setState(() => _evidenceImages.add(File(picked.path)));
    }
  }

  Future<void> _submit() async {
    setState(() => _isSubmitting = true);
    final notifier = ref.read(logisticsNotifierProvider.notifier);

    final List<String> evidenceUrls = [];
    for (final img in _evidenceImages) {
      final bytes = await img.readAsBytes();
      final name = img.path.split('/').last;
      final url = await notifier.uploadDisputeEvidence(
        fileName: name,
        fileBytes: bytes,
      );
      if (url != null) evidenceUrls.add(url);
    }

    final success = await notifier.openLogisticsDispute(
      logisticsDeliveryId: widget.logisticsDeliveryId,
      reason: _reasonController.text.trim(),
      evidenceUrls: evidenceUrls,
    );

    if (mounted) Navigator.pop(context, success);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColor.kipaGrey.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              verticalSpace(20),
              const BodyText('Open Dispute', fontWeight: FontWeight.w600),
              verticalSpace(4),
              const Caption(
                'Describe the issue and upload supporting evidence.',
                color: AppColor.kipaGrey2,
              ),
              verticalSpace(20),
              TextInputField(
                label: 'Reason',
                controller: _reasonController,
                inputType: TextInputType.multiline,
                maxLines: 4,
                hintText: 'Describe the issue with this delivery...',
                onChanged: (_) => setState(() {}),
              ),
              verticalSpace(16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Caption(
                    'Evidence Photos',
                    color: AppColor.kipaGrey,
                    fontWeight: FontWeight.w500,
                  ),
                  GestureDetector(
                    onTap: _evidenceImages.length >= 5 ? null : _pickImage,
                    child: Caption(
                      _evidenceImages.length >= 5
                          ? 'Max 5 photos'
                          : '+ Add Photo',
                      color: _evidenceImages.length >= 5
                          ? AppColor.kipaGrey
                          : AppColor.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              verticalSpace(8),
              if (_evidenceImages.isNotEmpty) ...[
                SizedBox(
                  height: 80,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: _evidenceImages.length,
                    separatorBuilder: (_, _) => horizontalSpace(8),
                    itemBuilder: (_, i) => Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.file(
                            _evidenceImages[i],
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                          top: 2,
                          right: 2,
                          child: GestureDetector(
                            onTap: () =>
                                setState(() => _evidenceImages.removeAt(i)),
                            child: Container(
                              decoration: const BoxDecoration(
                                color: Colors.black54,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.close,
                                size: 14,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                verticalSpace(16),
              ] else ...[
                Container(
                  height: 72,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColor.kipaGrey.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColor.kipaGrey.withValues(alpha: 0.3),
                    ),
                  ),
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.add_photo_alternate_outlined,
                        size: 28,
                        color: AppColor.kipaGrey,
                      ),
                      SizedBox(height: 4),
                      Caption(
                        'Tap "+ Add Photo" to attach evidence',
                        color: AppColor.kipaGrey,
                      ),
                    ],
                  ),
                ),
                verticalSpace(16),
              ],
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 36.0),
                child: CustomButton(
                  title: 'Submit Dispute',
                  isLoading: _isSubmitting,
                  onTap: _reasonController.text.trim().isEmpty ? null : _submit,
                  color: Colors.red.shade600,
                  textColor: Colors.white,
                  borderRadius: 30,
                ),
              ),
              verticalSpace(8),
            ],
          ),
        ),
      ),
    );
  }
}

class _ClaimDeliverySheet extends ConsumerStatefulWidget {
  final String logisticsDeliveryId;
  final ImagePicker imagePicker;

  const _ClaimDeliverySheet({
    required this.logisticsDeliveryId,
    required this.imagePicker,
  });

  @override
  ConsumerState<_ClaimDeliverySheet> createState() =>
      _ClaimDeliverySheetState();
}

class _ClaimDeliverySheetState extends ConsumerState<_ClaimDeliverySheet> {
  final _notesController = TextEditingController();
  File? _proofImage;
  bool _isUploading = false;

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      builder: (_) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const BodySmall('Choose from Gallery'),
              onTap: () => Navigator.pop(context, ImageSource.gallery),
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const BodySmall('Take a Photo'),
              onTap: () => Navigator.pop(context, ImageSource.camera),
            ),
          ],
        ),
      ),
    );
    if (source == null || !mounted) return;
    final picked = await widget.imagePicker.pickImage(
      source: source,
      maxWidth: 1024,
      maxHeight: 1024,
      imageQuality: 85,
    );
    if (picked != null && mounted) {
      setState(() => _proofImage = File(picked.path));
    }
  }

  Future<void> _submit() async {
    if (_proofImage == null) return;
    setState(() => _isUploading = true);

    final notifier = ref.read(logisticsNotifierProvider.notifier);
    final bytes = await _proofImage!.readAsBytes();
    final fileName = _proofImage!.path.split('/').last;

    final proofUrl = await notifier.uploadDeliveryProof(
      fileName: fileName,
      fileBytes: bytes,
    );

    if (proofUrl == null) {
      if (mounted) {
        setState(() => _isUploading = false);
        CustomSnackBar.show(
          context,
          message: 'Failed to upload proof photo',
          type: SnackBarType.error,
        );
      }
      return;
    }

    final success = await notifier.claimDelivery(
      logisticsDeliveryId: widget.logisticsDeliveryId,
      deliveryProofUrl: proofUrl,
      notes: _notesController.text.trim(),
    );

    if (mounted) Navigator.pop(context, success);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColor.kipaGrey.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              verticalSpace(20),
              const BodyText('Claim Delivery', fontWeight: FontWeight.w600),
              verticalSpace(4),
              const Caption(
                'Upload a photo as proof that the item was delivered.',
                color: AppColor.kipaGrey2,
              ),
              verticalSpace(20),
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  height: 120,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColor.kipaGrey.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColor.kipaGrey.withValues(alpha: 0.3),
                    ),
                  ),
                  child: _proofImage != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.file(_proofImage!, fit: BoxFit.cover),
                        )
                      : const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.add_a_photo,
                              size: 32,
                              color: AppColor.kipaGrey,
                            ),
                            SizedBox(height: 8),
                            Caption(
                              'Tap to upload delivery proof',
                              color: AppColor.kipaGrey,
                            ),
                          ],
                        ),
                ),
              ),
              verticalSpace(16),
              TextInputField(
                label: 'Notes (optional)',
                controller: _notesController,
                inputType: TextInputType.multiline,
                maxLines: 3,
                hintText: '',
              ),
              verticalSpace(20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 36.0),
                child: CustomButton(
                  title: 'Submit Claim',
                  isLoading: _isUploading,
                  onTap: _proofImage == null ? null : _submit,
                  color: AppColor.primary,
                  textColor: Colors.white,
                  borderRadius: 30,
                ),
              ),
              verticalSpace(8),
            ],
          ),
        ),
      ),
    );
  }
}

class _ConfirmDeliverySheet extends ConsumerStatefulWidget {
  final String logisticsDeliveryId;

  const _ConfirmDeliverySheet({required this.logisticsDeliveryId});

  @override
  ConsumerState<_ConfirmDeliverySheet> createState() =>
      _ConfirmDeliverySheetState();
}

class _ConfirmDeliverySheetState extends ConsumerState<_ConfirmDeliverySheet> {
  final _notesController = TextEditingController();
  int _selectedRating = 5;
  bool _isLoading = false;

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() => _isLoading = true);
    final success = await ref
        .read(logisticsNotifierProvider.notifier)
        .confirmLogisticsDelivery(
          logisticsDeliveryId: widget.logisticsDeliveryId,
          rating: _selectedRating,
          notes: _notesController.text.trim(),
        );
    if (mounted) Navigator.pop(context, success);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColor.kipaGrey.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              verticalSpace(20),
              const BodyText('Confirm Delivery', fontWeight: FontWeight.w600),
              verticalSpace(4),
              const Caption(
                'Rate your experience and confirm you received the item.',
                color: AppColor.kipaGrey2,
              ),
              verticalSpace(20),
              const Caption(
                'Rate this delivery',
                color: AppColor.kipaGrey,
                fontWeight: FontWeight.w500,
              ),
              verticalSpace(8),
              Row(
                children: List.generate(5, (index) {
                  final star = index + 1;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedRating = star),
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: Icon(
                        star <= _selectedRating
                            ? Icons.star
                            : Icons.star_border,
                        color: Colors.amber,
                        size: 36,
                      ),
                    ),
                  );
                }),
              ),
              verticalSpace(16),
              TextInputField(
                label: 'Notes (optional)',
                controller: _notesController,
                inputType: TextInputType.multiline,
                maxLines: 3,
                hintText: '',
              ),
              verticalSpace(20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 36.0),
                child: CustomButton(
                  title: 'Confirm Delivery',
                  isLoading: _isLoading,
                  onTap: _submit,
                  color: AppColor.primary,
                  textColor: Colors.white,
                  borderRadius: 30,
                ),
              ),
              verticalSpace(8),
            ],
          ),
        ),
      ),
    );
  }
}

class _ReturnShippedSheet extends ConsumerStatefulWidget {
  final String logisticsDeliveryId;

  const _ReturnShippedSheet({required this.logisticsDeliveryId});

  @override
  ConsumerState<_ReturnShippedSheet> createState() =>
      _ReturnShippedSheetState();
}

class _ReturnShippedSheetState extends ConsumerState<_ReturnShippedSheet> {
  final _carrierController = TextEditingController();
  final _trackingController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _carrierController.dispose();
    _trackingController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() => _isLoading = true);
    final success = await ref
        .read(logisticsNotifierProvider.notifier)
        .markReturnShipped(
          logisticsDeliveryId: widget.logisticsDeliveryId,
          returnCarrier: _carrierController.text.trim(),
          returnTrackingNumber: _trackingController.text.trim(),
        );
    if (mounted) Navigator.pop(context, success);
  }

  bool get _canSubmit =>
      _carrierController.text.trim().isNotEmpty &&
      _trackingController.text.trim().isNotEmpty;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColor.kipaGrey.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              verticalSpace(20),
              const BodyText(
                'Mark Return Shipped',
                fontWeight: FontWeight.w600,
              ),
              verticalSpace(4),
              const Caption(
                'Enter the carrier and tracking number for your return shipment.',
                color: AppColor.kipaGrey2,
              ),
              verticalSpace(20),
              TextInputField(
                label: 'Carrier',
                controller: _carrierController,
                hintText: 'e.g. DHL, UPS, FedEx',
                onChanged: (_) => setState(() {}),
              ),
              verticalSpace(16),
              TextInputField(
                label: 'Tracking Number',
                controller: _trackingController,
                hintText: 'e.g. DHL-RET-789012',
                onChanged: (_) => setState(() {}),
              ),
              verticalSpace(20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 36.0),
                child: CustomButton(
                  title: 'Mark as Shipped',
                  isLoading: _isLoading,
                  onTap: _canSubmit ? _submit : null,
                  color: AppColor.primary,
                  textColor: Colors.white,
                  borderRadius: 30,
                ),
              ),
              verticalSpace(8),
            ],
          ),
        ),
      ),
    );
  }
}

class _ConfirmReturnSheet extends ConsumerStatefulWidget {
  final String logisticsDeliveryId;

  const _ConfirmReturnSheet({required this.logisticsDeliveryId});

  @override
  ConsumerState<_ConfirmReturnSheet> createState() =>
      _ConfirmReturnSheetState();
}

class _ConfirmReturnSheetState extends ConsumerState<_ConfirmReturnSheet> {
  final _notesController = TextEditingController();
  String _selectedCondition = 'good';
  bool _isLoading = false;

  static const _conditions = ['good', 'fair', 'poor'];

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() => _isLoading = true);
    final success = await ref
        .read(logisticsNotifierProvider.notifier)
        .confirmLogisticsReturn(
          logisticsDeliveryId: widget.logisticsDeliveryId,
          condition: _selectedCondition,
          notes: _notesController.text.trim(),
        );
    if (mounted) Navigator.pop(context, success);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColor.kipaGrey.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              verticalSpace(20),
              const BodyText('Confirm Return', fontWeight: FontWeight.w600),
              verticalSpace(4),
              const Caption(
                'Confirm you received the returned item and rate its condition. If the item is damaged, please select use the open dispute button instead.',
                color: AppColor.kipaGrey2,
              ),
              verticalSpace(20),
              const Caption(
                'Item Condition',
                color: AppColor.kipaGrey,
                fontWeight: FontWeight.w500,
              ),
              verticalSpace(10),
              Row(
                children: _conditions.map((condition) {
                  final isSelected = _selectedCondition == condition;
                  Color chipColor;
                  switch (condition) {
                    case 'good':
                      chipColor = Colors.green;
                      break;
                    case 'fair':
                      chipColor = Colors.orange;
                      break;
                    default:
                      chipColor = Colors.red;
                  }
                  return Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: GestureDetector(
                      onTap: () =>
                          setState(() => _selectedCondition = condition),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? chipColor.withValues(alpha: 0.15)
                              : AppColor.kipaGrey.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isSelected
                                ? chipColor
                                : AppColor.kipaGrey.withValues(alpha: 0.3),
                            width: isSelected ? 1.5 : 1,
                          ),
                        ),
                        child: Caption(
                          condition[0].toUpperCase() + condition.substring(1),
                          color: isSelected ? chipColor : AppColor.kipaGrey,
                          fontWeight: isSelected
                              ? FontWeight.w700
                              : FontWeight.w500,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              verticalSpace(16),
              TextInputField(
                label: 'Notes (optional)',
                controller: _notesController,
                inputType: TextInputType.multiline,
                maxLines: 3,
                hintText: 'Any additional comments about the return...',
              ),
              verticalSpace(20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 36.0),
                child: CustomButton(
                  title: 'Confirm Return',
                  isLoading: _isLoading,
                  onTap: _submit,
                  color: AppColor.primary,
                  textColor: Colors.white,
                  borderRadius: 30,
                ),
              ),
              verticalSpace(8),
            ],
          ),
        ),
      ),
    );
  }
}
