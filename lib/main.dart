import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_portal/flutter_portal.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kipa/core/routes/app_router.dart';
import 'package:kipa/core/routes/route_names.dart';
import 'package:kipa/utils/constant.dart';

import 'core/shared/responsive_helper.dart';
import 'core/shared/responsive_widget_wrapper.dart';
import 'theme/theme.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDependencies();
  runApp(const ProviderScope(child: KipaApp()));
}

class KipaApp extends StatefulWidget {
  const KipaApp({super.key});

  @override
  State<KipaApp> createState() => _KipaAppState();
}

class _KipaAppState extends State<KipaApp> {
  @override
  Widget build(BuildContext context) {
    return ResponsiveWrapper(
      child: Portal(
        child: MaterialApp(
          title: 'Kipa',
          debugShowCheckedModeBanner: false,
          scrollBehavior: const ScrollBehavior().copyWith(
            dragDevices: {PointerDeviceKind.touch, PointerDeviceKind.mouse},
            physics: const BouncingScrollPhysics(),
          ),
          theme: lightTheme,
          builder: (context, child) {
            final isLandscape =
                MediaQuery.of(context).orientation == Orientation.landscape;

            if (isLandscape) {
              return child ?? const SizedBox.shrink();
            }
            if (ResponsiveHelper.isDesktop(context)) {
              return Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: ResponsiveHelper.tabletMaxWidth,
                  ),
                  child: child ?? const SizedBox.shrink(),
                ),
              );
            }
            return child ?? const SizedBox.shrink();
          },
          onGenerateRoute: AppRouter.onGenerateRoute,
          initialRoute: RouteNames.splashRoute,
          navigatorKey: navigatorKey,
        ),
      ),
    );
  }
}
