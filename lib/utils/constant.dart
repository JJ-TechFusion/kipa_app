import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';

import '../core/services/network/api_services.dart';
import '../core/services/network/app_dio.dart';
import '../core/services/network/auth_token_service.dart';
import '../core/services/notification/notification_service.dart';
import '../core/services/notification/notification_remote_datasource.dart';
import '../core/services/storage/secure_storage.dart';

final getIt = GetIt.instance;

SizedBox verticalSpace(double height) {
  return SizedBox(height: height);
}

SizedBox horizontalSpace(double width) {
  return SizedBox(width: width);
}

String formatCurrency(String amount) {
  return "₦${amount.replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match match) => '${match[1]},')}";
}

Future<void> initDependencies() async {
  getIt.registerLazySingleton<FlutterSecureStorage>(
    () => const FlutterSecureStorage(),
  );

  getIt.registerLazySingleton<SecureStorageService>(
    () => SecureStorageService(getIt<FlutterSecureStorage>()),
  );

  getIt.registerLazySingleton<AuthTokenService>(
    () => AuthTokenService(secureStorage: getIt<SecureStorageService>()),
  );

  getIt.registerLazySingleton<AppDio>(AppDio.fromConfig);

  getIt.registerLazySingleton<ApiService>(() => ApiService(getIt<AppDio>()));
  getIt.registerLazySingleton<NotificationService>(() => NotificationService());

  getIt.registerLazySingleton<NotificationRemoteDatasource>(
    () => NotificationRemoteDatasource(getIt<ApiService>()),
  );

  await GoogleFonts.pendingFonts([
    GoogleFonts.dmSans(),
    GoogleFonts.dmSans(),
  ]).timeout(const Duration(seconds: 10), onTimeout: () => []);
}

void setupLocator(GlobalKey<NavigatorState> navigatorKey) {}

void logMessage(
  String messageSource,
  String message, {
  StackTrace? stackTrace,
}) {
  log(
    "=========> Message from $messageSource ====================> \n \n =========> Message: $message",
  );
  if (stackTrace != null) {
    debugPrintStack(stackTrace: stackTrace);
  }
}
