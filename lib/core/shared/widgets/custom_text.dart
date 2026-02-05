import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kipa/core/shared/responsive_helper.dart';
import 'package:kipa/theme/app_colors.dart';

class TextSizes {
  static const double heading1 = 32.0;
  static const double heading2 = 28.0;
  static const double heading3 = 24.0;
  static const double heading4 = 20.0;
  static const double bodyLarge = 18.0;
  static const double bodyMedium = 16.0;
  static const double bodySmall = 14.0;
  static const double caption = 12.0;
  static const double overline = 10.0;
}

// Streamlined ResponsiveText widget
class ResponsiveText extends StatelessWidget {
  final String text;
  final double baseSize;
  final FontWeight? fontWeight;
  final Color? color;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final TextStyle? style;
  final double? lineHeight;

  const ResponsiveText(
    this.text, {
    super.key,
    this.baseSize = TextSizes.bodyMedium,
    this.fontWeight,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.style,
    this.lineHeight,
  });

  @override
  Widget build(BuildContext context) {
    final responsiveSize = ResponsiveHelper.getResponsiveSize(
      context,
      baseSize,
    );

    final textStyle = GoogleFonts.dmSans(
      fontSize: responsiveSize,
      fontWeight: fontWeight,
      color: color,
      height: lineHeight ?? 1,
    ).merge(style);

    return Text(
      text,
      style: textStyle,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}

// Semantic text widgets for common use cases
class H1 extends StatelessWidget {
  final String text;
  final Color? color;
  final TextAlign? textAlign;
  final int? maxLines;
  final double? fontSize;

  const H1(
    this.text, {
    super.key,
    this.color,
    this.textAlign,
    this.maxLines,
    this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    return ResponsiveText(
      text,
      baseSize: fontSize ?? TextSizes.heading1,
      fontWeight: FontWeight.bold,
      color: color,
      textAlign: textAlign,
      maxLines: maxLines,
    );
  }
}

class H2 extends StatelessWidget {
  final String text;
  final Color? color;
  final TextAlign? textAlign;
  final int? maxLines;
  final double? fontSize;

  const H2(
    this.text, {
    super.key,
    this.color,
    this.textAlign,
    this.maxLines,
    this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    return ResponsiveText(
      text,
      baseSize: fontSize ?? TextSizes.heading2,
      fontWeight: FontWeight.w600,
      color: color ?? AppColor.primaryText,
      textAlign: textAlign,
      maxLines: maxLines,
    );
  }
}

class H3 extends StatelessWidget {
  final String text;
  final Color? color;
  final TextAlign? textAlign;
  final int? maxLines;

  const H3(this.text, {super.key, this.color, this.textAlign, this.maxLines});

  @override
  Widget build(BuildContext context) {
    return ResponsiveText(
      text,
      baseSize: TextSizes.heading3,
      fontWeight: FontWeight.w600,
      color: color ?? AppColor.primaryText,
      textAlign: textAlign,
      maxLines: maxLines,
    );
  }
}

class H4 extends StatelessWidget {
  final String text;
  final Color? color;
  final TextAlign? textAlign;
  final int? maxLines;

  const H4(this.text, {super.key, this.color, this.textAlign, this.maxLines});

  @override
  Widget build(BuildContext context) {
    return ResponsiveText(
      text,
      baseSize: TextSizes.heading4,
      fontWeight: FontWeight.w600,
      color: color ?? AppColor.primaryText,
      textAlign: textAlign,
      maxLines: maxLines,
    );
  }
}

class BodyText extends StatelessWidget {
  final String text;
  final Color? color;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final FontWeight? fontWeight;
  final double? fontSize;

  const BodyText(
    this.text, {
    super.key,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.fontWeight,
    this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    return ResponsiveText(
      text,
      baseSize: fontSize ?? TextSizes.bodyMedium,
      color: color ?? AppColor.primaryText,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      fontWeight: fontWeight,
    );
  }
}

class BodyLarge extends StatelessWidget {
  final String text;
  final Color? color;
  final TextAlign? textAlign;
  final int? maxLines;
  final FontWeight? fontWeight;

  const BodyLarge(
    this.text, {
    super.key,
    this.color,
    this.textAlign,
    this.maxLines,
    this.fontWeight,
  });

  @override
  Widget build(BuildContext context) {
    return ResponsiveText(
      text,
      baseSize: TextSizes.bodyLarge,
      color: color ?? AppColor.primaryText,
      textAlign: textAlign,
      maxLines: maxLines,
      fontWeight: fontWeight,
    );
  }
}

class BodySmall extends StatelessWidget {
  final String text;
  final Color? color;
  final TextAlign? textAlign;
  final int? maxLines;
  final FontWeight? fontWeight;
  final TextOverflow? overflow;
  final Decoration? decoration;
  final double? lineHeight;

  const BodySmall(
    this.text, {
    super.key,
    this.color,
    this.textAlign,
    this.maxLines,
    this.fontWeight,
    this.overflow,
    this.decoration,
    this.lineHeight,
  });

  @override
  Widget build(BuildContext context) {
    return ResponsiveText(
      text,
      baseSize: TextSizes.bodySmall,
      color: color ?? AppColor.primaryText,
      textAlign: textAlign,
      maxLines: maxLines,
      fontWeight: fontWeight,
      overflow: overflow,
      lineHeight: lineHeight,
    );
  }
}

class Caption extends StatelessWidget {
  final String text;
  final Color? color;
  final TextAlign? textAlign;
  final FontWeight? fontWeight;
  final double? fontSize;

  const Caption(
    this.text, {
    super.key,
    this.color,
    this.textAlign,
    this.fontWeight,
    this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    return ResponsiveText(
      text,
      baseSize: fontSize ?? TextSizes.caption,
      color: color ?? AppColor.kipaGrey,
      textAlign: textAlign,
      fontWeight: fontWeight,
    );
  }
}

class Overline extends StatelessWidget {
  final String text;
  final Color? color;
  final TextAlign? textAlign;
  final FontWeight? fontWeight;
  final double? fontSize;

  const Overline(
    this.text, {
    super.key,
    this.color,
    this.textAlign,
    this.fontWeight,
    this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    return ResponsiveText(
      text,
      baseSize: fontSize ?? TextSizes.overline,
      color: color ?? AppColor.kipaGrey,
      textAlign: textAlign,
      fontWeight: fontWeight,
    );
  }
}
