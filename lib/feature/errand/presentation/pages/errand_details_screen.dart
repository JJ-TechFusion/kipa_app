import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:kipa/core/shared/widgets/custom_text.dart';
import 'package:kipa/core/utils/map_marker_generator.dart';
import 'package:kipa/feature/payment/presentation/widgets/transaction_timeline.dart';
import 'package:kipa/theme/app_colors.dart';
import 'package:kipa/utils/constant.dart';
import '../../domain/entities/errand_entity.dart';
import '../../domain/enums/errand_status.dart';
import '../providers/errand_provider.dart';

class ErrandDetailsScreen extends ConsumerStatefulWidget {
  final String errandId;

  const ErrandDetailsScreen({super.key, required this.errandId});

  @override
  ConsumerState<ErrandDetailsScreen> createState() =>
      _ErrandDetailsScreenState();
}

class _ErrandDetailsScreenState extends ConsumerState<ErrandDetailsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  void _loadData() {
    ref.read(errandNotifierProvider.notifier).fetchErrand(widget.errandId);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(errandNotifierProvider);
    final errand = state.currentErrand;

    final currencyFormatter = NumberFormat.currency(
      symbol: '\u20A6',
      decimalDigits: 2,
    );
    final dateFormatter = DateFormat('MMM d, yyyy');
    final timeFormatter = DateFormat('h:mm a');

    if (state.isLoading && errand == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (errand == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

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
          'Errand Details',
          fontWeight: FontWeight.w600,
          fontSize: 18,
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  _buildStatusIcon(errand.status),
                  horizontalSpace(12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        BodyText(
                          errand.status.displayName,
                          fontWeight: FontWeight.w600,
                        ),
                        Caption(
                          '${dateFormatter.format(errand.createdAt)} at ${timeFormatter.format(errand.createdAt)}',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            verticalSpace(20),

            // Timeline
            if (errand.timeline != null && errand.timeline!.steps.isNotEmpty) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: _buildErrandTimeline(errand.timeline!),
              ),
              verticalSpace(20),
            ],

            // Package info
            _buildSectionTitle('Package Details'),
            verticalSpace(12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Caption('Description'),
                      Flexible(
                        child: BodySmall(
                          errand.packageDescription,
                          fontWeight: FontWeight.w500,
                          textAlign: TextAlign.end,
                        ),
                      ),
                    ],
                  ),
                  verticalSpace(12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Caption('Package Size'),
                      BodySmall(
                        errand.packageSize.displayName,
                        fontWeight: FontWeight.w500,
                      ),
                    ],
                  ),
                  if (errand.notes != null && errand.notes!.isNotEmpty) ...[
                    verticalSpace(12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Caption('Notes'),
                        Expanded(
                          child: BodySmall(
                            errand.notes!,
                            fontWeight: FontWeight.w500,
                            textAlign: TextAlign.end,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            verticalSpace(20),

            // Route info
            _buildSectionTitle('Route'),
            verticalSpace(12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: _buildTimeline(
                pickup: errand.pickupAddress,
                dropoff: errand.dropoffAddress,
              ),
            ),
            verticalSpace(20),

            // Fee breakdown
            _buildSectionTitle('Fee Breakdown'),
            verticalSpace(12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Caption('Distance'),
                      BodySmall(
                        '${errand.estimatedDistanceKm?.toStringAsFixed(1) ?? '0'} km',
                        fontWeight: FontWeight.w500,
                      ),
                    ],
                  ),
                  verticalSpace(12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Caption('Delivery Fee'),
                      BodySmall(
                        currencyFormatter.format(errand.estimatedPrice ?? 0),
                        fontWeight: FontWeight.w500,
                      ),
                    ],
                  ),
                  verticalSpace(12),
                  const Divider(),
                  verticalSpace(12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const BodySmall('Total', fontWeight: FontWeight.w600),
                      BodyText(
                        currencyFormatter.format(errand.estimatedPrice ?? 0),
                        fontWeight: FontWeight.w600,
                        color: AppColor.primary,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            verticalSpace(20),

            // Contact info
            _buildSectionTitle('Contacts'),
            verticalSpace(12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  _buildContactRow(
                    'Pickup Contact',
                    errand.pickupContactName,
                    errand.pickupContactPhone,
                  ),
                  verticalSpace(16),
                  _buildContactRow(
                    'Dropoff Contact',
                    errand.dropoffContactName,
                    errand.dropoffContactPhone,
                  ),
                ],
              ),
            ),

            // Rider info (if available)
            if (errand.deliveryJob?.rider != null) ...[
              verticalSpace(20),
              _buildSectionTitle('Rider'),
              verticalSpace(12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 24,
                      backgroundColor: AppColor.primary.withAlpha(30),
                      backgroundImage:
                          errand.deliveryJob!.rider!.photoUrl != null
                          ? NetworkImage(errand.deliveryJob!.rider!.photoUrl!)
                          : null,
                      child: errand.deliveryJob!.rider!.photoUrl == null
                          ? const Icon(Icons.person, color: AppColor.primary)
                          : null,
                    ),
                    horizontalSpace(12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          BodyText(
                            errand.deliveryJob!.rider!.name,
                            fontWeight: FontWeight.w500,
                          ),
                          Row(
                            children: [
                              const Icon(
                                Icons.star,
                                color: Colors.amber,
                                size: 14,
                              ),
                              horizontalSpace(4),
                              Caption('${errand.deliveryJob!.rider!.rating}'),
                              horizontalSpace(8),
                              Caption(errand.deliveryJob!.rider!.vehicleType),
                            ],
                          ),
                        ],
                      ),
                    ),
                    if (errand.deliveryJob!.rider!.vehiclePlate != null)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE0E7FF),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Caption(
                          errand.deliveryJob!.rider!.vehiclePlate!,
                          color: AppColor.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                  ],
                ),
              ),
            ],

            verticalSpace(40),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusIcon(ErrandStatus status) {
    IconData icon;
    Color color;

    switch (status) {
      case ErrandStatus.completed:
      case ErrandStatus.delivered:
        icon = Icons.check_circle;
        color = AppColor.green;
        break;
      case ErrandStatus.cancelled:
        icon = Icons.cancel;
        color = Colors.red;
        break;
      default:
        icon = Icons.pending;
        color = AppColor.primary;
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withAlpha(25),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: color, size: 24),
    );
  }

  Widget _buildSectionTitle(String title) {
    return BodySmall(
      title,
      fontWeight: FontWeight.w600,
      color: AppColor.lightText,
    );
  }

  Widget _buildTimeline({required String pickup, required String dropoff}) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Column(
            children: [
              _buildTimelineIcon(
                Icons.my_location,
                MapMarkerGenerator.pickupColor,
              ),
              Expanded(
                child: Container(
                  width: 2,
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  color: AppColor.lightText.withAlpha(50),
                ),
              ),
              _buildTimelineIcon(
                Icons.location_on_outlined,
                MapMarkerGenerator.dropoffColor,
              ),
            ],
          ),
          horizontalSpace(12),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildLocationText(pickup, 'Pickup'),
                verticalSpace(32),
                _buildLocationText(dropoff, 'Dropoff'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineIcon(IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: color.withAlpha(25),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: color, size: 14),
    );
  }

  Widget _buildLocationText(String address, String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Caption(label),
        verticalSpace(4),
        BodySmall(
          address,
          fontWeight: FontWeight.w500,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildContactRow(String label, String name, String phone) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColor.primary.withAlpha(25),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.person, color: AppColor.primary, size: 16),
        ),
        horizontalSpace(12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Caption(label),
              BodySmall(name, fontWeight: FontWeight.w500),
            ],
          ),
        ),
        Caption(phone),
      ],
    );
  }

  Widget _buildErrandTimeline(ErrandTimelineEntity timeline) {
    final dateFormat = DateFormat('MMM dd, hh:mma');

    final steps = timeline.steps.map((step) {
      final isCompleted = step.status == 'completed';
      final isCurrent = step.step == timeline.currentStep;

      return TimelineStep(
        title: step.title,
        subtitle: step.timestamp != null
            ? dateFormat.format(step.timestamp!)
            : step.description,
        isCompleted: isCompleted,
        isActive: isCurrent,
      );
    }).toList();

    return TransactionTimeline(steps: steps);
  }
}
