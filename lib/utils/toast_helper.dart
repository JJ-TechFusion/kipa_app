import 'package:flutter/material.dart';
import 'package:kipa/main.dart';
import 'package:kipa/theme/app_colors.dart';

class ToastMessage {
  static void showErrorToast({required String message, VoidCallback? onTap}) {
    _toast(message: message, type: _ToastType.error);
  }

  static void showWarningToast({required String message, VoidCallback? onTap}) {
    _toast(message: message, type: _ToastType.warning);
  }

  static void showSuccessToast({required String message, VoidCallback? onTap}) {
    _toast(message: message, type: _ToastType.success, onTap: onTap);
  }

  static void showInfoToast({required String message, VoidCallback? onTap}) {
    _toast(message: message, type: _ToastType.info, onTap: onTap);
  }

  static void _toast({
    required String message,
    required _ToastType type,
    VoidCallback? onTap,
  }) {
    try {
      if (navigatorKey.currentState == null ||
          navigatorKey.currentContext == null) {
        debugPrint(
          'Toast error: Navigator state or context is null for message: $message',
        );
        return;
      }

      ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: switch (type) {
            _ToastType.error => AppColor.errorColor,
            _ToastType.warning => Colors.yellow,
            _ToastType.success => AppColor.green,
            _ToastType.info => AppColor.primary,
          },
          duration: const Duration(seconds: 3),
          action:
              onTap != null
                  ? SnackBarAction(
                    label: 'Dismiss',
                    onPressed: () {
                      ScaffoldMessenger.of(
                        navigatorKey.currentContext!,
                      ).hideCurrentSnackBar();
                      onTap.call();
                    },
                  )
                  : null,
        ),
      );
    } catch (e) {
      debugPrint('Failed to show toast: $e');
    }
  }
}

enum _ToastType { error, warning, success, info }
