import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kipa/core/shared/widgets/custom_text.dart';
import 'package:kipa/core/shared/widgets/smart_image.dart';
import 'package:kipa/feature/auth/presentation/providers/auth_provider.dart';
import 'package:kipa/theme/app_colors.dart';
import 'package:kipa/core/routes/route_names.dart';
import 'package:kipa/utils/constant.dart';
import 'package:kipa/feature/profile/presentation/pages/security_screen.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  Future<void> _handleLogout(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog.adaptive(
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      await ref.read(authNotifierProvider.notifier).logout();
      if (context.mounted) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          RouteNames.loginRoute,
          (route) => false,
        );
      }
    }
  }

  Future<void> _handleDeleteAccount(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog.adaptive(
        title: const Text('Delete Account'),
        content: const Text(
          'Are you sure you want to delete your account? This action cannot be undone and all your data will be permanently deleted.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete Account'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      final success = await ref.read(authNotifierProvider.notifier).deleteAccount();
      if (success && context.mounted) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          RouteNames.loginRoute,
          (route) => false,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authNotifierProvider);
    final user = authState.currentUser;
    final isLoggingOut = authState.isLoggingOut;
    final isDeletingAccount = authState.isDeletingAccount;

    if (user == null) {
      return const Center(child: CircularProgressIndicator());
    }

    if (isLoggingOut) {
      return const Scaffold(
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Signing out...'),
            ],
          ),
        ),
      );
    }

    if (isDeletingAccount) {
      return const Scaffold(
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Deleting account...'),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: 0,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await ref.read(authNotifierProvider.notifier).fetchCurrentUser();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              verticalSpace(20),
              Center(
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColor.primary.withValues(alpha: 0.1),
                          width: 2,
                        ),
                      ),
                      child: ClipOval(
                        child: SmartImage(
                          imageUrl:
                              (user.profileImageUrl == null ||
                                  user.profileImageUrl!.isEmpty)
                              ? 'assets/images/user_placeholder.png'
                              : user.profileImageUrl!,
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    verticalSpace(12),
                    H4(user.fullName),
                    verticalSpace(4),
                    BodySmall(user.email, color: AppColor.lightText),
                  ],
                ),
              ),
              verticalSpace(32),

              const BodyText("Account", fontWeight: FontWeight.bold),
              verticalSpace(16),
              _buildMenuItem(
                context,
                icon: Icons.person_outline,
                title: "Personal Details",
                onTap: () {
                  Navigator.pushNamed(context, RouteNames.personalDetailsRoute);
                },
              ),
              _buildMenuItem(
                context,
                icon: Icons.shield_outlined,
                title: "Security & Privacy",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SecurityScreen(),
                    ),
                  );
                },
              ),
              _buildMenuItem(
                context,
                icon: Icons.link,
                title: "Payment Links",
                onTap: () {
                  Navigator.pushNamed(context, RouteNames.paymentLinkListRoute);
                },
              ),
              verticalSpace(24),

              const BodyText("Support", fontWeight: FontWeight.bold),
              verticalSpace(16),
              _buildMenuItem(
                context,
                icon: Icons.info_outline,
                title: "Help Centre",
                onTap: () {},
              ),
              verticalSpace(24),

              const BodyText("Actions", fontWeight: FontWeight.bold),
              verticalSpace(16),
              _buildMenuItem(
                context,
                icon: Icons.logout,
                title: "Sign Out",
                onTap: () => _handleLogout(context, ref),
                isLast: false,
              ),
              _buildMenuItem(
                context,
                icon: Icons.delete_outline,
                title: "Delete Account",
                onTap: () => _handleDeleteAccount(context, ref),
                isLast: true,
              ),
              verticalSpace(40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isLast = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: Row(
              children: [
                Icon(icon, size: 18, color: AppColor.primaryText),
                horizontalSpace(16),
                Expanded(child: BodySmall(title)),
                const Icon(
                  Icons.arrow_forward_ios,
                  size: 14,
                  color: AppColor.lightText,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
