import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kipa/theme/app_colors.dart';

final ThemeData lightTheme = ThemeData(
  primaryColor: AppColor.primary,
  secondaryHeaderColor: AppColor.secondary,
  scaffoldBackgroundColor: const Color(0xFFF8F9FA),
  hintColor: AppColor.secondary,
  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: AppColor.primaryText),
    bodyMedium: TextStyle(color: AppColor.primaryText),
    displayLarge: TextStyle(color: AppColor.primaryText),
    titleLarge: TextStyle(color: AppColor.primaryText),
    titleMedium: TextStyle(color: AppColor.primaryText),
  ),
  appBarTheme: const AppBarTheme(
    centerTitle: true,
    backgroundColor: Colors.transparent,
    systemOverlayStyle: SystemUiOverlayStyle(
      statusBarColor: Colors.black,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.light,
    ),
    iconTheme: IconThemeData(color: AppColor.darkPrimary),
    titleTextStyle: TextStyle(
      color: Colors.black,
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
    elevation: 0,
    toolbarHeight: 60,
  ),
  buttonTheme: const ButtonThemeData(
    buttonColor: AppColor.primary,
    textTheme: ButtonTextTheme.primary,
  ),
  cardTheme: const CardThemeData(
    color: Colors.white,
    elevation: 0,
    shadowColor: Color(0xFF000000),
  ),
  iconTheme: const IconThemeData(color: Color(0xFF28A745)),
  colorScheme: const ColorScheme(
    primary: Color(0xFF007BFF),
    secondary: Color(0xFF28A745),
    surface: Colors.white,
    error: Colors.red,
    onPrimary: Colors.white,
    onSecondary: Colors.white,
    onSurface: Colors.black,
    onError: Colors.white,
    brightness: Brightness.light,
  ),
  progressIndicatorTheme: ProgressIndicatorThemeData(
    circularTrackColor: AppColor.primary,
    color: AppColor.primary,
  ),
  useMaterial3: false,
);
