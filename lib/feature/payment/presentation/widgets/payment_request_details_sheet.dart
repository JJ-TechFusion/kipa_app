import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kipa/core/shared/widgets/buttons/roundedbutton.dart';
import 'package:kipa/core/shared/widgets/custom_text.dart';
import 'package:kipa/core/shared/widgets/custom_snackbar.dart';
import 'package:kipa/feature/payment/domain/enums/payment_request_status.dart';
import 'package:kipa/theme/app_colors.dart';
import 'package:kipa/utils/constant.dart';
import 'package:kipa/core/routes/route_names.dart';
import '../providers/payment_provider.dart';

class PaymentRequestDetailsSheet extends ConsumerStatefulWidget {
  final String paymentRequestId;

  const PaymentRequestDetailsSheet({super.key, required this.paymentRequestId});

  @override
  ConsumerState<PaymentRequestDetailsSheet> createState() =>
      _PaymentRequestDetailsSheetState();
}

class _PaymentRequestDetailsSheetState
    extends ConsumerState<PaymentRequestDetailsSheet> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(paymentNotifierProvider.notifier)
          .fetchPaymentRequestDetails(widget.paymentRequestId);
    });
  }

  String _formatAmount(double amount) {
    return '₦${amount.toStringAsFixed(2).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')}';
  }

  String _formatDate(DateTime date) {
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
    return '${date.day} ${months[date.month - 1]}, ${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(paymentNotifierProvider);
    final details = state.paymentRequestDetails;

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: state.isFetchingPaymentRequestDetails || details == null
          ? const SizedBox(
              height: 400,
              child: Center(child: CircularProgressIndicator()),
            )
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Handle
                  Center(
                    child: Container(
                      margin: const EdgeInsets.only(top: 12),
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  verticalSpace(24),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header with status
                        Row(
                          children: [
                            const Expanded(
                              child: BodyText(
                                'Payment Request Details',
                                fontWeight: FontWeight.w600,
                                fontSize: 18,
                              ),
                            ),
                            _buildStatusBadge(details.status),
                          ],
                        ),
                        verticalSpace(24),

                        // Item details
                        _buildSectionHeader('Item Details'),
                        verticalSpace(12),
                        _buildInfoCard(
                          children: [
                            _buildInfoRow('Item Name', details.itemName),
                            if (details.itemDescription.isNotEmpty) ...[
                              verticalSpace(12),
                              _buildInfoRow(
                                'Description',
                                details.itemDescription,
                              ),
                            ],
                            verticalSpace(12),
                            _buildInfoRow(
                              'Item Price',
                              _formatAmount(details.itemPrice),
                              isBold: true,
                            ),
                          ],
                        ),
                        verticalSpace(24),

                        // Pricing breakdown
                        _buildSectionHeader('Pricing'),
                        verticalSpace(12),
                        _buildInfoCard(
                          children: [
                            _buildInfoRow(
                              'Item Price',
                              _formatAmount(details.itemPrice),
                            ),
                            verticalSpace(8),
                            _buildInfoRow(
                              'Service Fee (1%)',
                              _formatAmount(details.buyerServiceFee ?? 0),
                            ),
                            if (details.estimatedDeliveryFee != null) ...[
                              verticalSpace(8),
                              _buildInfoRow(
                                'Delivery Fee',
                                _formatAmount(details.estimatedDeliveryFee!),
                              ),
                              verticalSpace(4),
                              const Caption(
                                'Paid separately to rider',
                                fontSize: 10,
                                color: AppColor.kipaGrey2,
                              ),
                            ],
                            verticalSpace(12),
                            Container(
                              height: 1,
                              color: AppColor.kipaGrey.withAlpha(30),
                            ),
                            verticalSpace(12),
                            _buildInfoRow(
                              'Total (in app)',
                              _formatAmount(
                                (details.itemPrice) +
                                    (details.buyerServiceFee ?? 0),
                              ),
                              isBold: true,
                              valueColor: AppColor.primary,
                            ),
                          ],
                        ),
                        verticalSpace(24),

                        // Delivery details
                        if (details.pickupAddress != null ||
                            details.dropoffAddress != null) ...[
                          _buildSectionHeader('Delivery Details'),
                          verticalSpace(12),
                          _buildInfoCard(
                            children: [
                              if (details.pickupAddress != null) ...[
                                _buildAddressRow(
                                  'Pickup Address',
                                  details.pickupAddress!,
                                  Icons.gps_fixed,
                                  AppColor.primary,
                                ),
                              ],
                              if (details.pickupAddress != null &&
                                  details.dropoffAddress != null)
                                verticalSpace(16),
                              if (details.dropoffAddress != null) ...[
                                _buildAddressRow(
                                  'Dropoff Address',
                                  details.dropoffAddress!,
                                  Icons.location_on,
                                  AppColor.green,
                                ),
                              ],
                            ],
                          ),
                          verticalSpace(24),
                        ],

                        // Payment info
                        _buildSectionHeader('Payment Information'),
                        verticalSpace(12),
                        _buildInfoCard(
                          children: [
                            if (details.paymentCode != null) ...[
                              _buildInfoRowWithCopy(
                                'Payment Code',
                                details.paymentCode!,
                              ),
                              verticalSpace(12),
                            ],
                            _buildInfoRow(
                              'Created',
                              _formatDate(details.createdAt),
                            ),
                            if (details.isReusable == true) ...[
                              verticalSpace(12),
                              _buildInfoRow(
                                'Reusable',
                                'Yes (${details.currentUses} uses)',
                              ),
                            ],
                          ],
                        ),
                        verticalSpace(32),

                        // Action button - only show if not completed or if reusable
                        if (!(details.status == 'completed' &&
                            details.isReusable == false))
                          SizedBox(
                            width: double.infinity,
                            child: CustomButton(
                              title: 'Generate Payment Link',
                              onTap: () {
                                Navigator.pop(context);
                                Navigator.pushNamed(
                                  context,
                                  RouteNames.fulfillmentFormRoute,
                                  arguments: {
                                    'paymentRequestId': widget.paymentRequestId,
                                  },
                                );
                              },
                              borderRadius: 30,
                            ),
                          ),
                        if (!(details.status == 'completed' &&
                            details.isReusable == false))
                          verticalSpace(24),
                        if (details.status == 'completed' &&
                            details.isReusable == false)
                          verticalSpace(12),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return BodyText(title, fontWeight: FontWeight.w600, fontSize: 16);
  }

  Widget _buildInfoCard({required List<Widget> children}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColor.scaffoldBackground,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }

  Widget _buildInfoRow(
    String label,
    String value, {
    bool isBold = false,
    Color? valueColor,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: Caption(label, color: AppColor.lightText)),
        horizontalSpace(16),
        Expanded(
          child: BodySmall(
            value,
            fontWeight: isBold ? FontWeight.w600 : FontWeight.w500,
            color: valueColor,
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRowWithCopy(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Caption(label, color: AppColor.lightText),
        horizontalSpace(16),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Flexible(
                child: BodySmall(
                  value,
                  fontWeight: FontWeight.w600,
                  textAlign: TextAlign.right,
                ),
              ),
              horizontalSpace(8),
              GestureDetector(
                onTap: () {
                  Clipboard.setData(ClipboardData(text: value));
                  CustomSnackBar.show(
                    context,
                    message: 'Copied to clipboard',
                    type: SnackBarType.success,
                  );
                },
                child: const Icon(
                  Icons.copy,
                  size: 16,
                  color: AppColor.primary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAddressRow(
    String label,
    String address,
    IconData icon,
    Color iconColor,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: iconColor.withAlpha(30),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 14, color: iconColor),
        ),
        horizontalSpace(12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Caption(label, color: AppColor.lightText),
              verticalSpace(4),
              BodySmall(address),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatusBadge(String statusString) {
    final status = PaymentRequestStatus.fromString(statusString);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: status.color.withAlpha(30),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(status.icon, size: 12, color: status.color),
          horizontalSpace(6),
          Caption(
            status.shortLabel,
            color: status.color,
            fontWeight: FontWeight.w600,
            fontSize: 11,
          ),
        ],
      ),
    );
  }
}
