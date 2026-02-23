import 'package:flutter/material.dart';
import '../../../../core/shared/widgets/custom_text.dart';
import '../../../../theme/app_colors.dart';
import '../../../../utils/constant.dart';
import '../widgets/change_pin_sheet.dart';
import '../widgets/reset_pin_sheet.dart';

class SecurityScreen extends StatelessWidget {
  const SecurityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const BodyLarge("Security", fontWeight: FontWeight.bold),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            verticalSpace(16),
            _SecurityOptionCard(
              title: "Change Wallet PIN",
              onTap: () {
                _showChangePinBottomSheet(context);
              },
            ),
            verticalSpace(16),
            _SecurityOptionCard(
              title: "Reset Wallet PIN",
              onTap: () {
                _showResetPinBottomSheet(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showChangePinBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => const ChangePinSheet(),
    );
  }

  void _showResetPinBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => const ResetPinSheet(),
    );
  }
}

class _SecurityOptionCard extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const _SecurityOptionCard({required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        decoration: BoxDecoration(
          color: const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.account_balance_wallet_outlined,
              color: AppColor.primaryText,
              size: 20,
            ),
            horizontalSpace(16),
            Expanded(child: BodySmall(title, fontWeight: FontWeight.w500)),
            const Icon(
              Icons.arrow_forward_ios,
              color: AppColor.kipaGrey,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}
