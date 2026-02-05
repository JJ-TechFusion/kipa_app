import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/routes/route_names.dart';
import '../../../../theme/app_colors.dart';
import '../providers/splash_provider.dart';

class SplashPage extends ConsumerStatefulWidget {
  const SplashPage({super.key});

  @override
  ConsumerState<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends ConsumerState<SplashPage> {
  @override
  void initState() {
    super.initState();
    _navigateToNextScreen();
  }

  Future<void> _navigateToNextScreen() async {
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    final appState = await ref.read(appStateProvider.future);

    if (!mounted) return;

    if (appState.isFirstTime) {
      Navigator.of(context).pushReplacementNamed(RouteNames.onboardingRoute);
    } else if (appState.needsProfileCompletion) {
      Navigator.of(context).pushReplacementNamed(RouteNames.userInfoRoute);
    } else if (appState.isAuthenticated) {
      Navigator.of(context).pushReplacementNamed(RouteNames.homeRoute);
    } else {
      Navigator.of(context).pushReplacementNamed(RouteNames.loginRoute);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.primary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/logo/logo.png',
              width: 120,
              height: 120,
              errorBuilder: (context, error, stackTrace) {
                return Icon(
                  Icons.account_balance_wallet,
                  size: 100,
                  color: Theme.of(context).primaryColor,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
