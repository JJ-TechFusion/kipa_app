import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/routes/route_names.dart';
import '../../../../core/services/notification/notification_service.dart';
import '../../../../core/services/notification/notification_remote_datasource.dart';
import '../../../../core/services/storage/secure_storage.dart';
import '../../../../theme/app_colors.dart';
import '../../../../utils/constant.dart';
import '../../../../utils/session_utils.dart';
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

    // Check if token expired (401 triggered logout) and clear session data
    final secureStorage = getIt<SecureStorageService>();
    final tokenExpired = await secureStorage.readData('tokenExpired');
    if (tokenExpired == 'true') {
      clearUserSession(ref);
      await secureStorage.deleteData('tokenExpired');
    }

    final appState = await ref.read(appStateProvider.future);

    if (!mounted) return;

    if (appState.isFirstTime) {
      Navigator.of(context).pushReplacementNamed(RouteNames.onboardingRoute);
    } else if (appState.needsProfileCompletion) {
      Navigator.of(context).pushReplacementNamed(RouteNames.userInfoRoute);
    } else if (appState.isAuthenticated) {
      debugPrint('[FCM] User is authenticated, initializing notifications...');
      _initializeNotifications();
      Navigator.of(context).pushReplacementNamed(RouteNames.homeRoute);
    } else {
      Navigator.of(context).pushReplacementNamed(RouteNames.loginRoute);
    }
  }

  Future<void> _initializeNotifications() async {
    try {
      debugPrint('[FCM] Starting notification setup...');

      final notificationService = getIt<NotificationService>();
      final notificationDatasource = getIt<NotificationRemoteDatasource>();

      final authorized = await notificationService.requestPermissions();
      debugPrint('[FCM] Notification permissions authorized: $authorized');

      if (!authorized) {
        debugPrint(
          '[FCM] Notifications not authorized, skipping token registration',
        );
        return;
      }

      final token = await notificationService.getToken();
      debugPrint('[FCM] FCM Token: $token');

      if (token != null) {
        final registered = await notificationDatasource.registerDeviceToken(
          token: token,
          platform: notificationService.platform,
        );
        debugPrint('[FCM] Token registered with backend: $registered');
      } else {
        debugPrint('[FCM] No FCM token available');
      }

      notificationService.onTokenRefresh((newToken) {
        debugPrint('[FCM] Token refreshed: $newToken');
        notificationDatasource.registerDeviceToken(
          token: newToken,
          platform: notificationService.platform,
        );
      });
    } catch (e, stack) {
      debugPrint('[FCM] Error initializing notifications: $e');
      debugPrint('[FCM] Stack trace: $stack');
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
