import 'package:flutter/material.dart';
import 'package:kipa/core/shared/widgets/custom_text.dart';
import 'package:kipa/core/shared/widgets/number_pad.dart';
import 'package:kipa/theme/app_colors.dart';
import 'package:kipa/utils/constant.dart';

class PinEntryScreen extends StatefulWidget {
  final String title;
  final String? subtitle;
  final int pinLength;
  final Function(String) onSubmit;
  final bool obscurePin;

  const PinEntryScreen({
    super.key,
    required this.onSubmit,
    this.title = 'Confirm Your PIN',
    this.subtitle,
    this.pinLength = 4,
    this.obscurePin = true,
  });

  @override
  State<PinEntryScreen> createState() => _PinEntryScreenState();
}

class _PinEntryScreenState extends State<PinEntryScreen> {
  String _pin = '';

  void _onNumberSelected(String value) {
    if (_pin.length < widget.pinLength) {
      setState(() {
        _pin += value;
      });

      if (_pin.length == widget.pinLength) {
        widget.onSubmit(_pin);
      }
    }
  }

  void _onBackspace() {
    if (_pin.isNotEmpty) {
      setState(() {
        _pin = _pin.substring(0, _pin.length - 1);
      });
    }
  }

  void _onClear() {
    setState(() {
      _pin = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  H4(widget.title, textAlign: TextAlign.center),
                  if (widget.subtitle != null) ...[
                    verticalSpace(8),
                    BodyText(
                      widget.subtitle!,
                      textAlign: TextAlign.center,
                      color: AppColor.lightText,
                    ),
                  ],
                  verticalSpace(40),
                  _buildPinDots(),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
              child: NumberPad(
                onNumberSelected: _onNumberSelected,
                onBackspace: _onBackspace,
                onClear: _onClear,
                backspaceIcon: Icons.arrow_back_ios_new_rounded,
                textColor: Colors.black, // Match the design numbers
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPinDots() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(widget.pinLength, (index) {
        final isFilled = index < _pin.length;
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 8),
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isFilled ? const Color(0xFFE0E7FF) : const Color(0xFFF3F4F6),
          ),
          child: isFilled && widget.obscurePin
              ? Center(
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColor.primary,
                    ),
                  ),
                )
              : null,
        );
      }),
    );
  }
}
