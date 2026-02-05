import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kipa/core/shared/widgets/custom_text.dart';
import 'package:kipa/theme/app_colors.dart';
import 'package:kipa/core/routes/route_names.dart';
import 'package:kipa/utils/constant.dart';
import 'package:kipa/core/shared/widgets/buttons/roundedbutton.dart';
import 'package:flutter/cupertino.dart';
import 'package:kipa/feature/delivery/domain/entities/delivery_entities.dart';
import '../../domain/enums/payment_request_status.dart';
import '../providers/payment_provider.dart';
import 'payment_request_details_sheet.dart';

class PaymentLinkCard extends ConsumerWidget {
  final Map<String, dynamic> data;
  final VoidCallback onReuse;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const PaymentLinkCard({
    super.key,
    required this.data,
    required this.onReuse,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statusString = (data['status'] ?? '').toString();
    final status = PaymentRequestStatus.fromString(statusString);

    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (context) => PaymentRequestDetailsSheet(
            paymentRequestId: data['id']?.toString() ?? '',
          ),
        );
      },
      child: Container(
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _buildStatusTag(data['status'] ?? 'Link Active'),
                horizontalSpace(8),
                _buildDateTag(data['date'] ?? 'Created 31 Jan, 2025'),
              ],
            ),
            verticalSpace(16),
            BodySmall(
              data['itemName'] ?? 'iPhone 17 Pro Max',
              fontWeight: FontWeight.w600,
            ),
            verticalSpace(4),
            Caption(
              data['specs'] ?? 'Silver 256GB/4GB RAM',
              color: AppColor.lightText,
            ),
            verticalSpace(16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const BodySmall(
                  'You Receive',
                  color: AppColor.kipaGrey2,
                  fontWeight: FontWeight.w500,
                ),
                BodySmall(
                  '₦${data['amount'] ?? '2,250,000.00'}',
                  fontWeight: FontWeight.w600,
                ),
              ],
            ),
            verticalSpace(16),

            // Action buttons based on status
            if (status.canMarkReady)
              _buildReadyForPickupButton(context, ref)
            else if (status == PaymentRequestStatus.searchingRider)
              _buildSearchingIndicator()
            else if (status.shouldShowTracking)
              _buildTrackDeliveryButton(context, status)
            else
              _buildDefaultActions(),
          ],
        ),
      ),
    );
  }

  Widget _buildReadyForPickupButton(BuildContext context, WidgetRef ref) {
    return SizedBox(
      width: double.infinity,
      child: CustomButton(
        title: 'Ready for Pickup',
        onTap: () async {
          final paymentRequestId = data['id'] as String;

          Navigator.pushNamed(
            context,
            RouteNames.riderSearchRoute,
            arguments: {'paymentRequestId': paymentRequestId},
          );

          ref
              .read(paymentNotifierProvider.notifier)
              .markReadyForPickup(paymentRequestId: paymentRequestId);
        },
        color: AppColor.primary,
        textColor: Colors.white,
        borderRadius: 15,
        size: 14,
      ),
    );
  }

  Widget _buildSearchingIndicator() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: AppColor.primary.withAlpha(20),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: AppColor.primary.withAlpha(60)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(AppColor.primary),
            ),
          ),
          horizontalSpace(8),
          const BodySmall(
            'Searching for rider...',
            fontWeight: FontWeight.w600,
            color: AppColor.primary,
          ),
        ],
      ),
    );
  }

  Widget _buildTrackDeliveryButton(
    BuildContext context,
    PaymentRequestStatus status,
  ) {
    final deliveryJobId =
        data['delivery_job_id']?.toString() ?? data['id']?.toString() ?? '';

    return SizedBox(
      width: double.infinity,
      child: CustomButton(
        title: status == PaymentRequestStatus.inDelivery
            ? 'Track Delivery'
            : 'View Rider',
        onTap: () {
          // Use a reasonable default status based on payment request state
          // fetchJobDetails will update with actual status after connecting
          String initialStatus = 'searching';
          if (status == PaymentRequestStatus.riderAssigned ||
              status == PaymentRequestStatus.inDelivery) {
            initialStatus = 'accepted'; // Better default when rider is assigned
          }

          final initialJob = DeliveryJobEntity(
            id: deliveryJobId,
            paymentRequestId: data['id']?.toString() ?? '',
            status: initialStatus,
            rider: null,
            pickupAddress:
                data['pickupAddress']?.toString() ??
                data['pickup_address']?.toString() ??
                '',
            dropoffAddress:
                data['dropoffAddress']?.toString() ??
                data['dropoff_address']?.toString() ??
                '',
            pickupLat: _parseDouble(data['pickup_lat']),
            pickupLng: _parseDouble(data['pickup_lng']),
            dropoffLat: _parseDouble(data['dropoff_lat']),
            dropoffLng: _parseDouble(data['dropoff_lng']),
            estimatedArrival: null,
            createdAt: DateTime.now(),
          );

          Navigator.pushNamed(
            context,
            RouteNames.deliveryTrackingRoute,
            arguments: {
              'deliveryJobId': deliveryJobId,
              'initialJob': initialJob,
            },
          );
        },
        color: Colors.green,
        textColor: Colors.white,
        borderRadius: 15,
        size: 14,
      ),
    );
  }

  Widget _buildDefaultActions() {
    final statusString = (data['status'] ?? '').toString();
    final status = PaymentRequestStatus.fromString(statusString);
    final showReuseButton =
        data['isReusable'] == true && status == PaymentRequestStatus.completed;

    return Row(
      children: [
        if (showReuseButton)
          Expanded(
            child: CustomButton(
              title: 'Reuse this link',
              onTap: onReuse,
              color: AppColor.primary.withAlpha(20),
              textColor: AppColor.primary,
              borderColor: AppColor.primary,
              borderRadius: 15,
              size: 14,
            ),
          ),
        if (showReuseButton) horizontalSpace(12),
        if (!showReuseButton) const Spacer(),
        _buildIconButton(CupertinoIcons.pencil, onEdit),
        horizontalSpace(8),
        _buildIconButton(CupertinoIcons.delete, onDelete),
      ],
    );
  }

  Widget _buildStatusTag(String statusString) {
    final status = PaymentRequestStatus.fromString(statusString);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: status.color.withAlpha(30),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(status.icon, size: 12, color: status.color),
          horizontalSpace(4),
          Caption(
            status.shortLabel,
            color: status.color,
            fontWeight: FontWeight.w600,
          ),
        ],
      ),
    );
  }

  Widget _buildDateTag(String date) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColor.tagBackground,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.calendar_today, size: 10, color: AppColor.kipaGrey),
          horizontalSpace(4),
          Caption(date, color: AppColor.kipaGrey, fontWeight: FontWeight.w600),
        ],
      ),
    );
  }

  Widget _buildIconButton(IconData icon, VoidCallback onPressed) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppColor.tagBackground,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, size: 16, color: AppColor.primaryText),
      ),
    );
  }

  static double? _parseDouble(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }
}
