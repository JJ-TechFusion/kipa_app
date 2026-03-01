import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:kipa/utils/constant.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:kipa/core/shared/widgets/custom_text.dart';
import 'package:kipa/theme/app_colors.dart';
import 'package:kipa/feature/support/presentation/pages/faq_screen.dart';
import 'package:kipa/feature/disputes/domain/entities/dispute_entity.dart';
import 'package:kipa/feature/disputes/presentation/providers/disputes_provider.dart';
import 'package:kipa/feature/auth/presentation/providers/auth_provider.dart';
import 'package:kipa/feature/disputes/presentation/pages/disputes_list_screen.dart';

class SupportScreen extends ConsumerStatefulWidget {
  const SupportScreen({super.key});

  @override
  ConsumerState<SupportScreen> createState() => _SupportScreenState();
}

class _SupportScreenState extends ConsumerState<SupportScreen> {
  static const _supportEmail = 'support@getkipa.com';
  static const _supportPhone = '+2349000000000';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      ref.read(disputesNotifierProvider.notifier).fetchDisputes();
    });
  }

  Future<void> _launchEmail() async {
    final uri = Uri(
      scheme: 'mailto',
      path: _supportEmail,
      queryParameters: {'subject': 'Kipa Support Request'},
    );
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  Future<void> _launchPhone() async {
    final uri = Uri(scheme: 'tel', path: _supportPhone);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  @override
  Widget build(BuildContext context) {
    final disputesState = ref.watch(disputesNotifierProvider);
    final authState = ref.watch(authNotifierProvider);
    final currentUserId = authState.currentUser?.id;
    final userName = authState.currentUser?.firstName ?? "User";
    final topPadding = MediaQuery.of(context).padding.top;

    return Container(
      color: AppColor.scaffoldBackground,
      child: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: false,
            primary: false,
            backgroundColor: AppColor.primary,
            automaticallyImplyLeading: false,
            flexibleSpace: FlexibleSpaceBar(
              background: Padding(
                padding: EdgeInsets.only(top: topPadding, left: 20, right: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    verticalSpace(80),
                    CircleAvatar(
                      radius: 35,
                      backgroundColor: Colors.white,
                      child: Image.asset("assets/images/kipa.png", width: 50),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "Hi $userName!",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const BodySmall(
                      "How can we help you today?",
                      color: Colors.white70,
                    ),
                  ],
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _buildContactCard(
                          icon: Icons.email_outlined,
                          color: const Color(0xFFE0E7FF),
                          iconColor: AppColor.primary,
                          title: "Email Us",
                          subtitle: "Send us an email",
                          onTap: _launchEmail,
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
                          onTap: _launchPhone,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),

                  /// Active Disputes
                  const BodyText(
                    "Active Disputes",
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                  const SizedBox(height: 10),

                  if (disputesState.isFetchingDisputes)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: CircularProgressIndicator(),
                    )
                  else if (disputesState.disputes == null ||
                      disputesState.disputes!.isEmpty)
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Center(child: Caption("No active disputes")),
                    )
                  else ...[
                    _buildDisputeCard(
                      disputesState.disputes!.first,
                      currentUserId,
                    ),
                    if (disputesState.disputes!.length > 1) ...[
                      const SizedBox(height: 10),
                      _buildNavRow(
                        context,
                        icon: Icons.gavel_outlined,
                        title:
                            'View All Disputes (${disputesState.disputes!.length})',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const DisputesListScreen(),
                            ),
                          );
                        },
                      ),
                    ],
                  ],
                  const SizedBox(height: 30),

                  _buildNavRow(
                    context,
                    icon: Icons.help_outline,
                    title: 'Frequently Asked Questions',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const FaqScreen()),
                      );
                    },
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ================= Helpers =================

  Widget _buildContactCard({
    required IconData icon,
    required Color color,
    required Color iconColor,
    required String title,
    required String subtitle,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
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
      ),
    );
  }

  Widget _buildNavRow(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Icon(icon, size: 20, color: AppColor.primary),
            const SizedBox(width: 12),
            Expanded(child: BodySmall(title, fontWeight: FontWeight.w500)),
            const Icon(
              Icons.arrow_forward_ios,
              size: 14,
              color: AppColor.lightText,
            ),
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

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: BodySmall(
        currencyFormatter.format(dispute.paymentRequest.itemPrice),
      ),
    );
  }
}
