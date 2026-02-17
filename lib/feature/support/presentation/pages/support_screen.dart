import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:kipa/core/shared/widgets/buttons/roundedbutton.dart';
import 'package:kipa/core/shared/widgets/custom_text.dart';
import 'package:kipa/theme/app_colors.dart';
import 'package:kipa/feature/support/data/faq_data.dart';
import 'package:kipa/utils/constant.dart';
import 'package:kipa/feature/disputes/domain/entities/dispute_entity.dart';
import 'package:kipa/feature/disputes/presentation/providers/disputes_provider.dart';
import 'package:kipa/feature/auth/presentation/providers/auth_provider.dart';
import 'package:kipa/core/routes/route_names.dart';

class SupportScreen extends ConsumerStatefulWidget {
  const SupportScreen({super.key});

  @override
  ConsumerState<SupportScreen> createState() => _SupportScreenState();
}

class _SupportScreenState extends ConsumerState<SupportScreen> {
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
      body: SafeArea(
        child: ListView(
          children: [
            const H4("Support"),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: _buildContactCard(
                    icon: Icons.chat_bubble,
                    color: const Color(0xFFE0E7FF),
                    iconColor: AppColor.primary,
                    title: "Live Chat",
                    subtitle: "Chat with support",
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: _buildContactCard(
                    icon: Icons.call,
                    color: const Color(0xFFE0E7FF),
                    iconColor: AppColor.primary,
                    title: "Call Us",
                    subtitle: "Give us a call",
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),

            const BodyText(
              "Active Disputes",
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
            const SizedBox(height: 10),
            if (disputesState.isFetchingDisputes)
              const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: CircularProgressIndicator(),
                ),
              )
            else if (disputesState.disputes == null ||
                disputesState.disputes!.isEmpty)
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Center(
                  child: Caption("No active disputes"),
                ),
              )
            else
              ...disputesState.disputes!.map(
                (dispute) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _buildDisputeCard(dispute, currentUserId),
                ),
              ),
            const SizedBox(height: 30),

            const BodyText(
              "Frequently Asked Questions",
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
            const SizedBox(height: 10),
            ...kFaqData.map((categoryData) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: BodySmall(
                      categoryData['category'],
                      fontWeight: FontWeight.w600,
                      color: AppColor.kipaGrey,
                    ),
                  ),
                  ...(categoryData['questions'] as List<dynamic>).map((q) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: _buildFAQItem(
                        title: q['question'],
                        content: q['answer'],
                      ),
                    );
                  }),
                  const SizedBox(height: 10),
                ],
              );
            }),
            const SizedBox(height: 10),

            const BodyText(
              "Support Resources",
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: const BoxDecoration(
                      color: Color(0xFFE8EAF6),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.email_outlined,
                      color: AppColor.primary,
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 15),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        BodySmall("Email Support", fontWeight: FontWeight.w600),
                        Caption("support@kipa.com"),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildDisputeCard(DisputeEntity dispute, String? currentUserId) {
    final currencyFormatter = NumberFormat.currency(
      symbol: '\u20A6',
      decimalDigits: 2,
    );
    final dateFormatter = DateFormat('MMM d, h:mma');

    // role = logged-in user's role; counterparty is the opposite
    final counterpartyRole =
        dispute.role == 'buyer' ? 'Seller' : 'Buyer';

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
            "Dispute Description",
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
              title: "View Dispute",
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

  Widget _buildContactCard({
    required IconData icon,
    required Color color,
    required Color iconColor,
    required String title,
    required String subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      height: 180,
      decoration: BoxDecoration(
        color: AppColor.cardBackground,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            child: Icon(icon, color: iconColor, size: 18),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BodyText(title, fontWeight: FontWeight.w500),
              const SizedBox(height: 5),
              Caption(subtitle),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFAQItem({
    required String title,
    String? subtitle,
    String? content,
    bool isExpanded = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Theme(
        data: ThemeData(dividerColor: Colors.transparent),
        child: ExpansionTile(
          initiallyExpanded: isExpanded,
          title: BodySmall(title, fontWeight: FontWeight.w600),
          subtitle: subtitle != null ? Caption(subtitle) : null,
          childrenPadding: const EdgeInsets.only(
            left: 16,
            right: 16,
            bottom: 16,
          ),
          children: [
            if (content != null)
              BodySmall(content, color: AppColor.kipaGrey2, lineHeight: 1.5),
          ],
        ),
      ),
    );
  }
}
