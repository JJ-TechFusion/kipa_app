import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:kipa/core/shared/widgets/buttons/roundedbutton.dart';
import 'package:kipa/core/shared/widgets/custom_text.dart';
import 'package:kipa/core/routes/route_names.dart';
import 'package:kipa/theme/app_colors.dart';
import 'package:kipa/utils/constant.dart';
import 'package:kipa/feature/auth/presentation/providers/auth_provider.dart';
import '../providers/disputes_provider.dart';
import '../../domain/entities/dispute_entity.dart';

class DisputesListScreen extends ConsumerStatefulWidget {
  const DisputesListScreen({super.key});

  @override
  ConsumerState<DisputesListScreen> createState() => _DisputesListScreenState();
}

class _DisputesListScreenState extends ConsumerState<DisputesListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      ref.read(disputesNotifierProvider.notifier).fetchDisputes();
    });
  }

  @override
  Widget build(BuildContext context) {
    final disputesState = ref.watch(disputesNotifierProvider);
    final authState = ref.watch(authNotifierProvider);
    final currentUserId = authState.currentUser?.id;

    return Scaffold(
      backgroundColor: AppColor.scaffoldBackground,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: AppColor.primary,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.arrow_back, color: Colors.white, size: 18),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const BodyText(
          'Active Disputes',
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: () async =>
            ref.read(disputesNotifierProvider.notifier).fetchDisputes(),
        child: disputesState.isFetchingDisputes
            ? const Center(child: CircularProgressIndicator())
            : disputesState.disputes == null || disputesState.disputes!.isEmpty
            ? ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Center(child: Caption('No active disputes')),
                  ),
                ],
              )
            : ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: disputesState.disputes!.length,
                separatorBuilder: (_, _) => verticalSpace(12),
                itemBuilder: (context, index) {
                  final dispute = disputesState.disputes![index];
                  return _buildDisputeCard(context, dispute, currentUserId);
                },
              ),
      ),
    );
  }

  Widget _buildDisputeCard(
    BuildContext context,
    DisputeEntity dispute,
    String? currentUserId,
  ) {
    final currencyFormatter = NumberFormat.currency(
      symbol: '\u20A6',
      decimalDigits: 2,
    );
    final dateFormatter = DateFormat('MMM d, h:mma');
    final counterpartyRole = dispute.role == 'buyer' ? 'Seller' : 'Buyer';
    final initials = dispute.counterPartyName
        .trim()
        .split(' ')
        .where((w) => w.isNotEmpty)
        .take(2)
        .map((w) => w[0].toUpperCase())
        .join();
    final statusLabel = _statusLabel(dispute.status);
    final statusColor = _statusColor(dispute.status);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.history_toggle_off,
                      size: 14,
                      color: statusColor,
                    ),
                    const SizedBox(width: 5),
                    Caption(statusLabel, color: statusColor),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                backgroundColor: AppColor.primary,
                child: Text(
                  initials,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Caption(
                    dispute.counterPartyName,
                    fontWeight: FontWeight.w600,
                    color: AppColor.primaryText,
                  ),
                  Overline(counterpartyRole),
                ],
              ),
            ],
          ),
          verticalSpace(15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Caption(
                      dispute.paymentRequest.itemName,
                      fontWeight: FontWeight.w500,
                      color: AppColor.primaryText,
                    ),
                    if (dispute.paymentRequest.itemDescription != null)
                      Overline(dispute.paymentRequest.itemDescription!),
                    Overline(dateFormatter.format(dispute.createdAt)),
                  ],
                ),
              ),
              BodySmall(
                currencyFormatter.format(dispute.paymentRequest.itemPrice),
                fontWeight: FontWeight.w600,
              ),
            ],
          ),
          const SizedBox(height: 15),
          const Caption(
            'Dispute Description',
            fontWeight: FontWeight.w500,
            color: AppColor.primaryText,
          ),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColor.scaffoldBackground,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Overline(dispute.reason),
          ),
          verticalSpace(15),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 56.0),
            child: CustomButton(
              title: 'View Dispute',
              color: const Color(0xFFE0E7FF),
              textColor: AppColor.primary,
              borderRadius: 30,
              size: 14,
              onTap: () {
                Navigator.pushNamed(
                  context,
                  RouteNames.disputeDetailRoute,
                  arguments: {'disputeId': dispute.id},
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  String _statusLabel(String status) {
    switch (status) {
      case 'open':
        return 'Dispute Opened';
      case 'under_review':
        return 'Under Review';
      case 'resolved':
        return 'Resolved';
      case 'closed':
        return 'Closed';
      default:
        return 'Dispute in Progress';
    }
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'open':
        return AppColor.primary;
      case 'under_review':
        return const Color(0xFFF59E0B);
      case 'resolved':
        return const Color(0xFF10B981);
      case 'closed':
        return AppColor.kipaGrey;
      default:
        return AppColor.primary;
    }
  }
}
