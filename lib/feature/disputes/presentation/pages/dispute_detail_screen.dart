import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:kipa/core/shared/widgets/custom_snackbar.dart';
import 'package:kipa/core/shared/widgets/widgets.dart';
import 'package:kipa/feature/support/domain/entities/support_conversation_entity.dart';
import 'package:kipa/feature/support/presentation/pages/support_chat_screen.dart';
import 'package:kipa/feature/support/presentation/providers/support_provider.dart';
import 'package:kipa/theme/app_colors.dart';
import 'package:kipa/utils/constant.dart';
import 'package:kipa/feature/disputes/presentation/providers/disputes_provider.dart';

class DisputeDetailScreen extends ConsumerStatefulWidget {
  final String disputeId;

  const DisputeDetailScreen({super.key, required this.disputeId});

  @override
  ConsumerState<DisputeDetailScreen> createState() =>
      _DisputeDetailScreenState();
}

class _DisputeDetailScreenState extends ConsumerState<DisputeDetailScreen> {
  bool _isOpeningSupportChat = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      ref
          .read(disputesNotifierProvider.notifier)
          .fetchDisputeById(widget.disputeId);
    });
  }

  Future<void> _openSupportChat() async {
    if (_isOpeningSupportChat) return;

    setState(() {
      _isOpeningSupportChat = true;
    });

    final response = await ref
        .read(getOrCreateSupportConversationUseCaseProvider)
        .call();

    if (!mounted) return;

    setState(() {
      _isOpeningSupportChat = false;
    });

    if (!response.success ||
        response.data is! SupportConversationResponseEntity) {
      CustomSnackBar.show(
        context,
        message: response.message.isEmpty
            ? 'Failed to open support chat'
            : response.message,
        type: SnackBarType.error,
      );
      return;
    }

    final supportData = response.data as SupportConversationResponseEntity;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SupportChatScreen(
          conversation: supportData.conversation,
          activeDisputes: supportData.activeDisputes,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(disputesNotifierProvider);
    final dispute = state.disputeDetail;

    final currencyFormatter = NumberFormat.currency(
      symbol: '\u20A6',
      decimalDigits: 2,
    );
    final dateFormatter = DateFormat('MMM d, yyyy • h:mm a');

    if (state.isFetchingDisputeDetail && dispute == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (dispute == null) {
      return Scaffold(
        appBar: _buildAppBar(context, 'Dispute Details'),
        body: const Center(child: Caption('Unable to load dispute')),
      );
    }

    final counterpartyRole = dispute.role == 'buyer' ? 'Seller' : 'Buyer';
    final initials = dispute.counterPartyName
        .trim()
        .split(' ')
        .where((w) => w.isNotEmpty)
        .take(2)
        .map((w) => w[0].toUpperCase())
        .join();

    return Scaffold(
      backgroundColor: AppColor.scaffoldBackground,
      appBar: _buildAppBar(context, 'Dispute Details'),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildCard(
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: _statusColor(
                          dispute.status,
                        ).withValues(alpha: 0.12),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.history_toggle_off,
                        color: _statusColor(dispute.status),
                        size: 20,
                      ),
                    ),
                    horizontalSpace(12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          BodyText(
                            _statusLabel(dispute.status),
                            fontWeight: FontWeight.w600,
                          ),
                          Caption(dateFormatter.format(dispute.createdAt)),
                        ],
                      ),
                    ),
                    _buildOutcomeBadge(dispute.outcome),
                  ],
                ),
              ),
              verticalSpace(16),
              _buildCard(
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: AppColor.primary,
                      radius: 24,
                      child: Text(
                        initials,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    horizontalSpace(12),
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
              ),
              verticalSpace(16),
              _buildCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Caption(
                      'Transaction',
                      fontWeight: FontWeight.w600,
                      color: AppColor.kipaGrey,
                    ),
                    verticalSpace(12),
                    _buildRow('Item', dispute.paymentRequest.itemName),
                    if (dispute.paymentRequest.itemDescription != null) ...[
                      verticalSpace(8),
                      _buildRow(
                        'Description',
                        dispute.paymentRequest.itemDescription!,
                      ),
                    ],
                    verticalSpace(8),
                    _buildRow(
                      'Item Price',
                      currencyFormatter.format(
                        dispute.paymentRequest.itemPrice,
                      ),
                      valueWeight: FontWeight.w600,
                    ),
                    verticalSpace(8),
                    _buildRow(
                      'Delivery Fee',
                      currencyFormatter.format(
                        dispute.paymentRequest.estimatedDeliveryFee,
                      ),
                    ),
                    verticalSpace(8),
                    _buildRow(
                      'Total',
                      currencyFormatter.format(
                        dispute.paymentRequest.estimatedTotal,
                      ),
                      valueWeight: FontWeight.w600,
                    ),
                    verticalSpace(8),
                    _buildRow(
                      'Payment Code',
                      dispute.paymentRequest.paymentCode,
                    ),
                  ],
                ),
              ),
              verticalSpace(16),
              _buildCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Caption(
                      'Dispute Reason',
                      fontWeight: FontWeight.w600,
                      color: AppColor.kipaGrey,
                    ),
                    verticalSpace(10),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColor.scaffoldBackground,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: BodySmall(
                        dispute.reason,
                        color: AppColor.primaryText,
                        lineHeight: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
              verticalSpace(16),
              if (dispute.evidence.isNotEmpty) ...[
                _buildCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Caption(
                        'Evidence',
                        fontWeight: FontWeight.w600,
                        color: AppColor.kipaGrey,
                      ),
                      verticalSpace(12),
                      SizedBox(
                        height: 100,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: dispute.evidence.length,
                          separatorBuilder: (context, index) =>
                              horizontalSpace(8),
                          itemBuilder: (context, index) {
                            return ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                dispute.evidence[index],
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stack) =>
                                    Container(
                                      width: 100,
                                      height: 100,
                                      color: AppColor.scaffoldBackground,
                                      child: const Icon(
                                        Icons.broken_image_outlined,
                                        color: AppColor.kipaGrey,
                                      ),
                                    ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                verticalSpace(16),
              ],
              if (dispute.outcome != 'pending') ...[
                _buildCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Caption(
                        'Resolution',
                        fontWeight: FontWeight.w600,
                        color: AppColor.kipaGrey,
                      ),
                      verticalSpace(12),
                      _buildRow('Outcome', _outcomeLabel(dispute.outcome)),
                      if (dispute.resolvedAt != null) ...[
                        verticalSpace(8),
                        _buildRow(
                          'Resolved At',
                          dateFormatter.format(dispute.resolvedAt!),
                        ),
                      ],
                      if (dispute.resolutionNotes != null &&
                          dispute.resolutionNotes!.isNotEmpty) ...[
                        verticalSpace(10),
                        const Caption(
                          'Notes',
                          fontWeight: FontWeight.w500,
                          color: AppColor.kipaGrey,
                        ),
                        verticalSpace(6),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColor.scaffoldBackground,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: BodySmall(
                            dispute.resolutionNotes!,
                            color: AppColor.primaryText,
                            lineHeight: 1.5,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                verticalSpace(16),
              ],
              _buildCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Caption(
                      'Escrow Breakdown',
                      fontWeight: FontWeight.w600,
                      color: AppColor.kipaGrey,
                    ),
                    verticalSpace(12),
                    _buildRow(
                      'Item Amount',
                      currencyFormatter.format(dispute.escrow.itemAmount),
                    ),
                    verticalSpace(8),
                    _buildRow(
                      'Delivery Fee',
                      currencyFormatter.format(
                        dispute.escrow.actualDeliveryFee,
                      ),
                    ),
                    verticalSpace(8),
                    _buildRow(
                      'Buyer Fee',
                      currencyFormatter.format(dispute.escrow.buyerFee),
                    ),
                    const Divider(height: 20),
                    _buildRow(
                      'Total Locked',
                      currencyFormatter.format(dispute.escrow.totalLocked),
                      valueWeight: FontWeight.w700,
                    ),
                    verticalSpace(8),
                    _buildRow(
                      'Seller Payout',
                      currencyFormatter.format(dispute.escrow.sellerPayout),
                      valueWeight: FontWeight.w600,
                    ),
                  ],
                ),
              ),
              verticalSpace(16),
              SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 42),
                  child: CustomButton(
                    title: _isOpeningSupportChat
                        ? 'Opening Support Chat...'
                        : 'Chat with Support',
                    onTap: _isOpeningSupportChat ? null : _openSupportChat,
                    icon: Icons.support_agent,
                    isLoading: _isOpeningSupportChat,
                    color: AppColor.primary,
                    textColor: Colors.white,
                    borderRadius: 22,
                  ),
                ),
              ),
              verticalSpace(30),
            ],
          ),
        ),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context, String title) {
    return AppBar(
      automaticallyImplyLeading: false,
      title: BodyText(title, fontWeight: FontWeight.w600, fontSize: 18),
      centerTitle: true,
      elevation: 0,
      backgroundColor: Colors.transparent,
    );
  }

  Widget _buildCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: child,
    );
  }

  Widget _buildRow(String label, String value, {FontWeight? valueWeight}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Caption(label, color: AppColor.kipaGrey),
        const SizedBox(width: 16),
        Flexible(
          child: Caption(
            value,
            fontWeight: valueWeight ?? FontWeight.w500,
            color: AppColor.primaryText,
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }

  Widget _buildOutcomeBadge(String outcome) {
    if (outcome == 'pending') return const SizedBox.shrink();

    final color = switch (outcome) {
      'buyer_favor' => const Color(0xFF10B981),
      'seller_favor' => const Color(0xFF3B82F6),
      'partial_refund' => const Color(0xFFF59E0B),
      'mutual' => AppColor.primary,
      _ => AppColor.kipaGrey,
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Caption(_outcomeLabel(outcome), color: color),
    );
  }

  String _statusLabel(String status) {
    return switch (status) {
      'open' => 'Dispute Opened',
      'under_review' => 'Under Review',
      'resolved' => 'Resolved',
      'closed' => 'Closed',
      _ => 'In Progress',
    };
  }

  Color _statusColor(String status) {
    return switch (status) {
      'open' => AppColor.primary,
      'under_review' => const Color(0xFFF59E0B),
      'resolved' => const Color(0xFF10B981),
      'closed' => AppColor.kipaGrey,
      _ => AppColor.primary,
    };
  }

  String _outcomeLabel(String outcome) {
    return switch (outcome) {
      'pending' => 'Pending',
      'buyer_favor' => 'Buyer Favor',
      'seller_favor' => 'Seller Favor',
      'partial_refund' => 'Partial Refund',
      'mutual' => 'Mutual',
      _ => outcome,
    };
  }
}
