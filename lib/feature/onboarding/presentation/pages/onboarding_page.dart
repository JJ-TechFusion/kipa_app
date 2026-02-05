import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/routes/route_names.dart';
import '../../../../core/shared/widgets/custom_text.dart';
import '../../../../theme/app_colors.dart';
import '../../../../utils/constant.dart';
import '../../../../utils/no_params.dart';
import '../providers/onboarding_provider.dart';
import '../widgets/onboarding_page_widget.dart';

class OnboardingPage extends ConsumerStatefulWidget {
  const OnboardingPage({super.key});

  @override
  ConsumerState<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends ConsumerState<OnboardingPage> {
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    ref.read(currentPageIndexProvider.notifier).setIndex(index);
  }

  Future<void> _completeOnboarding() async {
    try {
      await ref.read(completeOnboardingUseCaseProvider).call(NoParams());
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  void _onCreateAccount() {
    _completeOnboarding();
    Navigator.of(context).pushReplacementNamed(RouteNames.registerRoute);
  }

  void _onLogin() {
    _completeOnboarding();
    Navigator.of(context).pushReplacementNamed(RouteNames.loginRoute);
  }

  @override
  Widget build(BuildContext context) {
    final pagesAsync = ref.watch(onboardingPagesProvider);
    final currentPageIndex = ref.watch(currentPageIndexProvider);

    return pagesAsync.when(
      data: (pages) {
        final currentPage = pages[currentPageIndex];

        return Scaffold(
          backgroundColor: currentPage.backgroundColor,
          body: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    onPageChanged: _onPageChanged,
                    itemCount: pages.length,
                    itemBuilder: (context, index) {
                      return OnboardingPageWidget(page: pages[index]);
                    },
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      pages.length,
                      (index) => AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: currentPageIndex == index ? 32 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: currentPageIndex == index
                              ? AppColor.onboardingPrimary
                              : AppColor.onboardingIndicatorInactive,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),
                ),
                verticalSpace(24),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: _onCreateAccount,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.onboardingPrimary,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(28),
                        ),
                      ),
                      child: const BodyText(
                        'Create Account',
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                verticalSpace(16),

                TextButton(
                  onPressed: _onLogin,
                  child: const BodyText(
                    'Log in',
                    fontWeight: FontWeight.w500,
                    color: AppColor.onboardingPrimary,
                  ),
                ),
                verticalSpace(24),
              ],
            ),
          ),
        );
      },
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (error, stack) => Scaffold(
        body: Center(child: Text('Error loading onboarding: $error')),
      ),
    );
  }
}
