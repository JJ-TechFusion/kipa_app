import 'package:flutter/material.dart';
import 'package:kipa/theme/app_colors.dart';

class SmartImage extends StatelessWidget {
  final String imageUrl;
  final BoxFit fit;
  final double? width;
  final double? height;
  final Widget? placeholder;
  final Widget? errorWidget;
  final double? progressStrokeWidth;
  final Color? progressColor;
  final IconData? fallbackIcon;
  final double? fallbackIconSize;
  final Color? backgroundColor;
  final String? name;
  final bool showInitials;

  const SmartImage({
    super.key,
    required this.imageUrl,
    this.fit = BoxFit.cover,
    this.width,
    this.height,
    this.placeholder,
    this.errorWidget,
    this.progressStrokeWidth = 2.0,
    this.progressColor,
    this.fallbackIcon = Icons.home,
    this.fallbackIconSize = 60,
    this.backgroundColor,
    this.name,
    this.showInitials = true,
  });

  String _getInitials() {
    if (name == null || name!.isEmpty) return '?';
    final nameParts = name!
        .trim()
        .split(' ')
        .where((w) => w.isNotEmpty)
        .toList();
    if (nameParts.isEmpty) return '?';
    if (nameParts.length == 1) return nameParts[0][0].toUpperCase();
    return '${nameParts[0][0]}${nameParts[nameParts.length - 1][0]}'
        .toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    if (imageUrl.isEmpty ||
        imageUrl.contains('placeholder') ||
        imageUrl.contains('user_placeholder.png')) {
      return _buildErrorWidget();
    }

    final isNetworkImage = imageUrl.startsWith('http');

    if (isNetworkImage) {
      return Image.network(
        imageUrl,
        fit: fit,
        width: width,
        height: height,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;

          return placeholder ?? _buildLoadingPlaceholder(loadingProgress);
        },
        errorBuilder: (context, error, stackTrace) {
          return errorWidget ?? _buildErrorWidget();
        },
      );
    } else {
      final assetPath = imageUrl.contains('assets/')
          ? imageUrl
          : 'assets/images/$imageUrl${imageUrl.contains('.') ? '' : '.png'}';

      return Image.asset(
        assetPath,
        fit: fit,
        width: width,
        height: height,
        errorBuilder: (context, error, stackTrace) {
          return errorWidget ?? _buildErrorWidget();
        },
      );
    }
  }

  Widget _buildLoadingPlaceholder(ImageChunkEvent loadingProgress) {
    return Container(
      width: width,
      height: height,
      color: backgroundColor ?? Colors.grey[100],
      child: Center(
        child: CircularProgressIndicator(
          value: loadingProgress.expectedTotalBytes != null
              ? loadingProgress.cumulativeBytesLoaded /
                    loadingProgress.expectedTotalBytes!
              : null,
          strokeWidth: progressStrokeWidth!,
          color: progressColor ?? AppColor.primary,
        ),
      ),
    );
  }

  Widget _buildErrorWidget() {
    if (errorWidget != null) return errorWidget!;

    if (showInitials && name != null && name!.isNotEmpty) {
      final radius = width != null ? width! / 2 : 20.0;
      return CircleAvatar(
        radius: radius,
        backgroundColor: AppColor.primary,
        child: Text(
          _getInitials(),
          style: TextStyle(
            color: Colors.white,
            fontSize: radius * 0.8,
            fontWeight: FontWeight.w600,
          ),
        ),
      );
    }

    return Container(
      width: width,
      height: height,
      color: backgroundColor ?? Colors.transparent,
    );
  }
}
