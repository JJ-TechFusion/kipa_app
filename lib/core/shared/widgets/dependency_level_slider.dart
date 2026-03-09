import 'package:flutter/material.dart';
import 'package:kipa/core/shared/widgets/custom_text.dart';
import 'package:kipa/theme/app_colors.dart';
import 'package:kipa/utils/constant.dart';

class DependencyLevelSlider extends StatefulWidget {
  final String label;
  final int initialValue;
  final Function(int) onChanged;

  const DependencyLevelSlider({
    super.key,
    required this.label,
    this.initialValue = 0,
    required this.onChanged,
  });

  @override
  State<DependencyLevelSlider> createState() => _DependencyLevelSliderState();
}

class _DependencyLevelSliderState extends State<DependencyLevelSlider> {
  late double _value;
  final List<Color> _segmentColors = [Colors.green, Colors.amber, Colors.red];

  @override
  void initState() {
    super.initState();
    _value = widget.initialValue.toDouble().clamp(0.0, 2.0);
  }

  int get _currentLevel => _value.round().clamp(0, 2);

  Color _getThumbColor() {
    if (_value <= 0.5) {
      return _segmentColors[0];
    } else if (_value <= 1.5) {
      return _segmentColors[1];
    } else {
      return _segmentColors[2];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label.isNotEmpty) ...[
          BodySmall(
            widget.label,
            fontWeight: FontWeight.w500,
            color: AppColor.kipaGrey2,
          ),
          verticalSpace(8),
        ],
        SliderTheme(
          data: SliderThemeData(
            trackHeight: 3.0,
            activeTrackColor: Colors.transparent,
            inactiveTrackColor: Colors.transparent,
            thumbColor: Colors.white,
            thumbShape: _CustomThumbShape(
              thumbRadius: 10.0,
              borderColor: _getThumbColor(),
            ),
            overlayColor: _getThumbColor().withAlpha(15),
            overlayShape: const RoundSliderOverlayShape(overlayRadius: 18.0),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                height: 3.0,
                margin: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  spacing: 4,
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: _segmentColors[0],
                          borderRadius: const BorderRadius.horizontal(
                            left: Radius.circular(3),
                          ),
                        ),
                      ),
                    ),
                    Expanded(child: Container(color: _segmentColors[1])),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: _segmentColors[2],
                          borderRadius: const BorderRadius.horizontal(
                            right: Radius.circular(3),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Slider(
                value: _value,
                min: 0.0,
                max: 2.0,
                divisions: 20,
                onChanged: (newValue) {
                  setState(() {
                    _value = newValue;
                  });

                  final newLevel = newValue.round().clamp(0, 2);
                  if (newLevel != _currentLevel) {
                    widget.onChanged(newLevel);
                  }
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _CustomThumbShape extends SliderComponentShape {
  final double thumbRadius;
  final Color borderColor;

  const _CustomThumbShape({
    required this.thumbRadius,
    required this.borderColor,
  });

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size.fromRadius(thumbRadius);
  }

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double value,
    required double textScaleFactor,
    required Size sizeWithOverflow,
  }) {
    final Canvas canvas = context.canvas;
    final shadowPaint = Paint()
      ..color = AppColor.neutral.withAlpha(10)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2);
    canvas.drawCircle(center, thumbRadius + 1, shadowPaint);
    final fillPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, thumbRadius, fillPaint);
    final borderPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawCircle(center, thumbRadius, borderPaint);
  }
}
