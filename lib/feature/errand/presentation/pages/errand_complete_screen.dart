import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kipa/core/shared/widgets/buttons/animated_button.dart';
import 'package:kipa/core/shared/widgets/custom_snackbar.dart'
    show CustomSnackBar, SnackBarType;
import 'package:kipa/core/shared/widgets/number_pad.dart';
import 'package:kipa/theme/app_colors.dart';
import 'package:kipa/utils/constant.dart';
import '../../../../core/shared/widgets/widgets.dart';
import '../../domain/entities/errand_entity.dart';
import '../providers/errand_provider.dart';

class ErrandCompleteScreen extends ConsumerStatefulWidget {
  final ErrandEntity errand;

  const ErrandCompleteScreen({super.key, required this.errand});

  @override
  ConsumerState<ErrandCompleteScreen> createState() =>
      _ErrandCompleteScreenState();
}

class _ErrandCompleteScreenState extends ConsumerState<ErrandCompleteScreen> {
  String _code = '';
  bool _showSuccess = false;

  void _onNumberSelected(String value) {
    final state = ref.read(errandNotifierProvider);
    if (state.isCompleting) return;

    if (_code.length < 6) {
      setState(() {
        _code += value;
      });

      if (_code.length == 6) {
        _submitCode();
      }
    }
  }

  void _onBackspace() {
    if (_code.isNotEmpty) {
      setState(() {
        _code = _code.substring(0, _code.length - 1);
      });
    }
  }

  void _onClear() {
    setState(() {
      _code = '';
    });
  }

  Future<void> _submitCode() async {
    final success = await ref
        .read(errandNotifierProvider.notifier)
        .completeErrand(widget.errand.id, _code);

    if (success && mounted) {
      setState(() {
        _showSuccess = true;
      });
    } else {
      setState(() {
        _code = '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(errandNotifierProvider);

    ref.listen(errandNotifierProvider, (prev, next) {
      if (!mounted) return;
      if (next.errorMessage != null &&
          prev?.errorMessage != next.errorMessage) {
        CustomSnackBar.show(
          context,
          message: next.errorMessage!,
          type: SnackBarType.error,
        );
        Future.microtask(() {
          if (mounted) {
            ref.read(errandNotifierProvider.notifier).clearMessages();
          }
        });
      }
    });

    if (_showSuccess) {
      return _buildSuccessScreen();
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColor.darkPrimary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  verticalSpace(20),
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: AppColor.primary.withAlpha(25),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.inventory_2,
                      size: 40,
                      color: AppColor.primary,
                    ),
                  ),
                  verticalSpace(24),
                  const H4(
                    'Confirm Delivery',
                    color: AppColor.darkPrimary,
                    textAlign: TextAlign.center,
                  ),
                  verticalSpace(8),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 32),
                    child: BodyText(
                      'Enter the code below to confirm delivery',
                      textAlign: TextAlign.center,
                      color: AppColor.lightText,
                    ),
                  ),
                  verticalSpace(24),
                  if (widget.errand.dropoffCode != null) ...[
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 16,
                      ),
                      decoration: BoxDecoration(
                        color: AppColor.primary.withAlpha(15),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppColor.primary.withAlpha(50),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.lock_outline,
                            color: AppColor.primary,
                            size: 20,
                          ),
                          horizontalSpace(12),
                          H3(
                            widget.errand.dropoffCode!,
                            color: AppColor.primary,
                          ),
                        ],
                      ),
                    ),
                  ],
                  verticalSpace(32),
                  if (state.isCompleting)
                    const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  else
                    _buildPinDots(),
                  if (state.errorMessage != null) ...[
                    verticalSpace(16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
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
                                'Invalid code. Please try again.',
                                color: Colors.red.shade700,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
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
                textColor: state.isCompleting ? Colors.grey : Colors.black,
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
      children: List.generate(6, (index) {
        final isFilled = index < _code.length;
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: 44,
          height: 52,
          decoration: BoxDecoration(
            color: isFilled ? const Color(0xFFE0E7FF) : const Color(0xFFF3F4F6),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isFilled ? AppColor.primary : Colors.transparent,
              width: 2,
            ),
          ),
          child: isFilled
              ? Center(
                  child: BodyText(
                    _code[index],
                    color: AppColor.primary,
                    fontWeight: FontWeight.w600,
                    fontSize: 20,
                  ),
                )
              : null,
        );
      }),
    );
  }

  Widget _buildSuccessScreen() {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    verticalSpace(120),
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: Colors.green.withAlpha(25),
                        shape: BoxShape.circle,
                      ),
                      child: Image.asset("assets/images/success.png"),
                    ),
                    verticalSpace(32),
                    const H4(
                      'Delivery Complete!',
                      color: AppColor.darkPrimary,
                      textAlign: TextAlign.center,
                    ),
                    verticalSpace(12),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 32),
                      child: BodySmall(
                        'Your package has been delivered successfully. Thank you for using Kipa!',
                        textAlign: TextAlign.center,
                        color: AppColor.lightText,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 52, vertical: 20),
              child: AnimatedButton(
                onTap: () {
                  Navigator.popUntil(context, (route) => route.isFirst);
                },
                child: CustomButton(title: "Back to Home", borderRadius: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
