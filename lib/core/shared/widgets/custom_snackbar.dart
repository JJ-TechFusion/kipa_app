import 'package:flutter/material.dart';
import 'package:kipa/theme/app_colors.dart';
import 'package:kipa/core/shared/widgets/custom_text.dart';

enum SnackBarType { success, error, warning, info }

class CustomSnackBar {
  static void show(
    BuildContext context, {
    required String message,
    SnackBarType type = SnackBarType.info,
    Duration duration = const Duration(seconds: 3),
  }) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            _getIcon(type),
            const SizedBox(width: 12),
            Expanded(
              child: BodyText(
                message,
                color: Colors.white,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        backgroundColor: _getBackgroundColor(type),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: duration,
        elevation: 4,
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }

  static Color _getBackgroundColor(SnackBarType type) {
    switch (type) {
      case SnackBarType.success:
        return AppColor.green;
      case SnackBarType.error:
        return AppColor.errorColor;
      case SnackBarType.warning:
        return AppColor.warning;
      case SnackBarType.info:
        return AppColor.primary;
    }
  }

  static Widget _getIcon(SnackBarType type) {
    IconData iconData;
    switch (type) {
      case SnackBarType.success:
        iconData = Icons.check_circle_outline;
        break;
      case SnackBarType.error:
        iconData = Icons.error_outline;
        break;
      case SnackBarType.warning:
        iconData = Icons.warning_amber_rounded;
        break;
      case SnackBarType.info:
        iconData = Icons.info_outline;
        break;
    }
    return Icon(iconData, color: Colors.white, size: 24);
  }
}
