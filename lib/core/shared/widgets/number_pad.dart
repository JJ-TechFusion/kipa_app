import 'package:flutter/material.dart';
import 'package:kipa/theme/app_colors.dart';

class NumberPad extends StatelessWidget {
  final Function(String) onNumberSelected;
  final VoidCallback onBackspace;
  final VoidCallback? onClear;
  final bool showDecimal;
  final Color? textColor;
  final Color? backgroundColor;

  final IconData? backspaceIcon;

  const NumberPad({
    super.key,
    required this.onNumberSelected,
    required this.onBackspace,
    this.onClear,
    this.showDecimal = false,
    this.textColor,
    this.backgroundColor,
    this.backspaceIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor ?? Colors.transparent,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              _buildNumberKey('1'),
              _buildNumberKey('2'),
              _buildNumberKey('3'),
            ],
          ),
          Row(
            children: [
              _buildNumberKey('4'),
              _buildNumberKey('5'),
              _buildNumberKey('6'),
            ],
          ),
          Row(
            children: [
              _buildNumberKey('7'),
              _buildNumberKey('8'),
              _buildNumberKey('9'),
            ],
          ),
          Row(
            children: [
              showDecimal
                  ? _buildNumberKey('.')
                  : Expanded(child: SizedBox.shrink()),
              _buildNumberKey('0'),
              _buildBackspaceKey(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNumberKey(String value) {
    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => onNumberSelected(value),
          borderRadius: BorderRadius.circular(40),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: Center(
              child: Text(
                value,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: textColor ?? AppColor.primaryText,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBackspaceKey() {
    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onBackspace,
          onLongPress: onClear,
          borderRadius: BorderRadius.circular(40),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: Center(
              child: Icon(
                backspaceIcon ?? Icons.backspace_outlined,
                color: textColor ?? AppColor.primaryText,
                size: 24,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
