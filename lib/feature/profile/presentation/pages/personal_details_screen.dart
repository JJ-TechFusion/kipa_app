import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kipa/core/shared/widgets/custom_text.dart';
import 'package:kipa/feature/auth/presentation/providers/auth_provider.dart';
import 'package:kipa/theme/app_colors.dart';
import 'package:kipa/utils/constant.dart';

class PersonalDetailsScreen extends ConsumerWidget {
  const PersonalDetailsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authNotifierProvider);
    final user = authState.currentUser;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Icon(Icons.arrow_back, color: AppColor.primaryText),
        ),
        title: const BodyLarge("Personal Details", fontWeight: FontWeight.bold),
        centerTitle: true,
      ),
      body: user == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _DetailItem(
                    label: "Account Name",
                    value: user.fullName,
                    onEdit: () {
                      // Navigate to edit name
                    },
                  ),
                  verticalSpace(16),
                  _DetailItem(
                    label: "Phone Number",
                    value: user.phoneNumber,
                    onEdit: () {
                      // Navigate to edit phone
                    },
                  ),
                  verticalSpace(16),
                  _DetailItem(
                    label: "Email",
                    value: user.email,
                    onEdit: () {
                      // Navigate to edit email
                    },
                  ),
                ],
              ),
            ),
    );
  }
}

class _DetailItem extends StatelessWidget {
  final String label;
  final String value;
  final VoidCallback onEdit;

  const _DetailItem({
    required this.label,
    required this.value,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              spacing: 8,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BodySmall(label, fontWeight: FontWeight.bold),
                Caption(value, color: AppColor.lightText),
              ],
            ),
          ),
          InkWell(
            onTap: onEdit,
            child: const Icon(
              Icons.edit_outlined,
              color: AppColor.lightText,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }
}
