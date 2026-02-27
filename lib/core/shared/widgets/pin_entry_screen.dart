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
  final bool isLoading;
  final String? errorMessage;
  final VoidCallback? onErrorDismissed;
  final bool showBackButton;

  const PinEntryScreen({
    super.key,
    required this.onSubmit,
    this.title = 'Confirm Your PIN',
    this.subtitle,
    this.pinLength = 4,
    this.obscurePin = true,
    this.isLoading = false,
    this.errorMessage,
    this.onErrorDismissed,
    this.showBackButton = false,
  });

  @override
  State<PinEntryScreen> createState() => PinEntryScreenState();
}

class PinEntryScreenState extends State<PinEntryScreen> {
  String _pin = '';

  void resetPin() {
    setState(() {
      _pin = '';
    });
  }

  void _onNumberSelected(String value) {
    if (widget.isLoading) return;

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
    if (widget.isLoading) return;

    if (_pin.isNotEmpty) {
      setState(() {
        _pin = _pin.substring(0, _pin.length - 1);
      });
    }
  }

  void _onClear() {
    if (widget.isLoading) return;

    setState(() {
      _pin = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        // automaticallyImplyLeading: widget.showBackButton,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  H4(widget.title, textAlign: TextAlign.center),
                  if (widget.subtitle != null) ...[
                    verticalSpace(8),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: BodyText(
                        widget.subtitle!,
                        textAlign: TextAlign.center,
                        color: AppColor.lightText,
                      ),
                    ),
                  ],
                  verticalSpace(40),
                  if (widget.isLoading)
                    const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  else
                    _buildPinDots(),
                  if (widget.errorMessage != null) ...[
                    verticalSpace(16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: GestureDetector(
                        onTap: widget.onErrorDismissed,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.red.shade50,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.error_outline,
                                color: Colors.red.shade700,
                                size: 16,
                              ),
                              horizontalSpace(8),
                              Flexible(
                                child: Caption(
                                  widget.errorMessage!,
                                  color: Colors.red.shade700,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
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
                textColor: widget.isLoading ? Colors.grey : Colors.black,
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
