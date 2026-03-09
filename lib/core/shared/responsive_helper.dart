import 'package:flutter/material.dart';

class ResponsiveHelper {
  static const double mobileMaxWidth = 600;
  static const double tabletMaxWidth = 1200;

  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < mobileMaxWidth;
  }

  static bool isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= mobileMaxWidth && width < tabletMaxWidth;
  }

  static bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= tabletMaxWidth;
  }

  static bool isPortrait(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.portrait;
  }

  static bool isLandscape(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.landscape;
  }

  static T getResponsiveValue<T>(
    BuildContext context, {
    required T mobile,
    T? tablet,
    T? desktop,
  }) {
    if (isDesktop(context) && desktop != null) return desktop;
    if (isTablet(context) && tablet != null) return tablet;
    return mobile;
  }

  static T getOrientationValue<T>(
    BuildContext context, {
    required T portrait,
    required T landscape,
  }) {
    return isPortrait(context) ? portrait : landscape;
  }

  static T getFullResponsiveValue<T>(
    BuildContext context, {
    required T mobilePortrait,
    required T mobileLandscape,
    T? tabletPortrait,
    T? tabletLandscape,
    T? desktopPortrait,
    T? desktopLandscape,
  }) {
    final isPort = isPortrait(context);

    if (isDesktop(context)) {
      return isPort
          ? (desktopPortrait ?? mobilePortrait)
          : (desktopLandscape ?? mobileLandscape);
    }

    if (isTablet(context)) {
      return isPort
          ? (tabletPortrait ?? mobilePortrait)
          : (tabletLandscape ?? mobileLandscape);
    }

    return isPort ? mobilePortrait : mobileLandscape;
  }

  static EdgeInsets getResponsivePadding(BuildContext context) {
    return getFullResponsiveValue(
      context,
      mobilePortrait: const EdgeInsets.only(top: 30.0, left: 18.0, right: 18.0),
      mobileLandscape: const EdgeInsets.symmetric(
        horizontal: 24.0,
        vertical: 12.0,
      ),
      tabletPortrait: const EdgeInsets.all(24.0),
      tabletLandscape: const EdgeInsets.symmetric(
        horizontal: 32.0,
        vertical: 16.0,
      ),
      desktopPortrait: const EdgeInsets.all(32.0),
      desktopLandscape: const EdgeInsets.symmetric(
        horizontal: 48.0,
        vertical: 24.0,
      ),
    );
  }

  static double getTextScale(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth < 400) return 0.9;
    if (screenWidth < 600) return 1.0;
    if (screenWidth < 900) return 1.1;
    if (screenWidth < 1200) return 1.15;
    return 1.2;
  }

  static double getResponsiveSize(BuildContext context, double baseSize) {
    return baseSize * getTextScale(context);
  }
}
