import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:kipa/core/routes/route_names.dart';
import 'package:kipa/core/shared/widgets/buttons/roundedbutton.dart';
import 'package:kipa/core/shared/widgets/custom_snackbar.dart'
    show CustomSnackBar, SnackBarType;
import 'package:kipa/core/shared/widgets/custom_text.dart';
import 'package:kipa/theme/app_colors.dart';
import 'package:kipa/utils/constant.dart';
import '../../domain/entities/errand_entity.dart';
import '../providers/errand_provider.dart';

class ErrandSummaryScreen extends ConsumerWidget {
  final ErrandEntity errand;

  const ErrandSummaryScreen({super.key, required this.errand});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(errandNotifierProvider);
    final currencyFormat = NumberFormat.currency(
      symbol: '\u20A6',
      decimalDigits: 0,
    );

    ref.listen(errandNotifierProvider, (prev, next) {
      if (next.errorMessage != null &&
          prev?.errorMessage != next.errorMessage) {
        CustomSnackBar.show(
          context,
          message: next.errorMessage!,
          type: SnackBarType.error,
        );
        Future.microtask(() {
          ref.read(errandNotifierProvider.notifier).clearMessages();
        });
      }
    });

    return Scaffold(
      backgroundColor: AppColor.scaffoldBackground,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColor.darkPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: const BodyText(
          'Review Errand',
          fontWeight: FontWeight.w600,
          color: AppColor.darkPrimary,
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [AppColor.primary, Color(0xFF6366F1)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: [
                        const BodyText(
                          'Estimated Price',
                          color: Colors.white70,
                        ),
                        verticalSpace(8),
                        H2(
                          currencyFormat.format(errand.estimatedPrice ?? 0),
                          color: Colors.white,
                        ),
                        verticalSpace(16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildEstimateItem(
                              Icons.route,
                              '${errand.estimatedDistanceKm?.toStringAsFixed(1) ?? '0'} km',
                              'Distance',
                            ),
                            Container(
                              height: 40,
                              width: 1,
                              color: Colors.white30,
                            ),
                            _buildEstimateItem(
                              Icons.access_time,
                              '${errand.estimatedDurationMins ?? 0} mins',
                              'Duration',
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  verticalSpace(24),
                  const BodyText(
                    'Route Details',
                    fontWeight: FontWeight.w600,
                    color: AppColor.darkPrimary,
                  ),
                  verticalSpace(12),
                  _buildRouteCard(),
                  verticalSpace(24),
                  const BodyText(
                    'Package Details',
                    fontWeight: FontWeight.w600,
                    color: AppColor.darkPrimary,
                  ),
                  verticalSpace(12),
                  _buildPackageCard(),
                  verticalSpace(24),
                  const BodyText(
                    'Contact Details',
                    fontWeight: FontWeight.w600,
                    color: AppColor.darkPrimary,
                  ),
                  verticalSpace(12),
                  _buildContactsCard(),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(10),
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: SafeArea(
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: state.isCancelling
                              ? null
                              : () async {
                                  final result = await ref
                                      .read(errandNotifierProvider.notifier)
                                      .cancelErrand(errand.id);
                                  if (result != null && context.mounted) {
                                    Navigator.popUntil(
                                      context,
                                      (route) => route.isFirst,
                                    );
                                  }
                                },
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            side: const BorderSide(color: AppColor.errorColor),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: state.isCancelling
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: AppColor.errorColor,
                                  ),
                                )
                              : const BodyText(
                                  'Cancel',
                                  color: AppColor.errorColor,
                                  fontWeight: FontWeight.w600,
                                ),
                        ),
                      ),
                      horizontalSpace(16),
                      Expanded(
                        flex: 2,
                        child: CustomButton(
                          title: 'Confirm Errand',
                          isLoading: state.isConfirming,
                          onTap: state.isConfirming
                              ? null
                              : () async {
                                  final confirmed = await ref
                                      .read(errandNotifierProvider.notifier)
                                      .confirmErrand(errand.id);
                                  if (confirmed != null && context.mounted) {
                                    Navigator.pushReplacementNamed(
                                      context,
                                      RouteNames.errandSearchingRoute,
                                      arguments: {'errand': confirmed},
                                    );
                                  }
                                },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEstimateItem(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 20),
        verticalSpace(4),
        BodyText(value, color: Colors.white, fontWeight: FontWeight.w600),
        Caption(label, color: Colors.white70),
      ],
    );
  }

  Widget _buildRouteCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColor.kipaGrey.withAlpha(30)),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: const BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                    ),
                  ),
                  Container(
                    width: 2,
                    height: 40,
                    color: AppColor.kipaGrey.withAlpha(50),
                  ),
                  Container(
                    width: 12,
                    height: 12,
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ),
              horizontalSpace(16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Caption('PICKUP', color: AppColor.lightText),
                    verticalSpace(4),
                    BodySmall(
                      errand.pickupAddress,
                      color: AppColor.darkPrimary,
                      fontWeight: FontWeight.w500,
                    ),
                    verticalSpace(24),
                    const Caption('DROPOFF', color: AppColor.lightText),
                    verticalSpace(4),
                    BodySmall(
                      errand.dropoffAddress,
                      color: AppColor.darkPrimary,
                      fontWeight: FontWeight.w500,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPackageCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColor.kipaGrey.withAlpha(30)),
      ),
      child: Column(
        children: [
          if (errand.packageDescription != null &&
              errand.packageDescription!.isNotEmpty) ...[
            _buildDetailRow('Description', errand.packageDescription!),
            if (errand.notes != null && errand.notes!.isNotEmpty)
              const Divider(height: 24),
          ],
          if (errand.notes != null && errand.notes!.isNotEmpty)
            _buildDetailRow('Pickup Instructions', errand.notes!),
          if (errand.packageDescription == null &&
              (errand.notes == null || errand.notes!.isEmpty))
            const BodySmall(
              'No package details provided',
              color: AppColor.lightText,
            ),
        ],
      ),
    );
  }

  Widget _buildContactsCard() {
    final hasPickupContact =
        errand.pickupContactName != null || errand.pickupContactPhone != null;
    final hasDropoffContact =
        errand.dropoffContactName != null || errand.dropoffContactPhone != null;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColor.kipaGrey.withAlpha(30)),
      ),
      child: Column(
        children: [
          if (hasPickupContact) ...[
            _buildContactRow(
              'Pickup Contact',
              errand.pickupContactName ?? 'Not provided',
              errand.pickupContactPhone ?? 'Not provided',
              Colors.green,
            ),
          ],
          if (hasPickupContact && hasDropoffContact) const Divider(height: 24),
          if (hasDropoffContact) ...[
            _buildContactRow(
              'Dropoff Contact',
              errand.dropoffContactName ?? 'Not provided',
              errand.dropoffContactPhone ?? 'Not provided',
              Colors.red,
            ),
          ],
          if (!hasPickupContact && !hasDropoffContact)
            const BodySmall(
              'No contact details provided',
              color: AppColor.lightText,
            ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(flex: 2, child: Caption(label, color: AppColor.lightText)),
        Expanded(
          flex: 3,
          child: BodySmall(
            value,
            color: AppColor.darkPrimary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildContactRow(
    String title,
    String name,
    String phone,
    Color dotColor,
  ) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle),
        ),
        horizontalSpace(12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Caption(title, color: AppColor.lightText),
              verticalSpace(4),
              BodySmall(
                name,
                color: AppColor.darkPrimary,
                fontWeight: FontWeight.w500,
              ),
              Caption(phone, color: AppColor.lightText),
            ],
          ),
        ),
      ],
    );
  }
}
