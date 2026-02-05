// ignore_for_file: deprecated_member_use

import 'dart:math';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapMarkerGenerator {
  static Future<BitmapDescriptor> createCircleMarker({
    required Color fillColor,
    double size = 20,
  }) async {
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    final paint = Paint();

    final center = Offset(size / 2, size / 2);
    final ringRadius = size / 2;
    final circleRadius = size / 3;

    // Draw outer ring (lighter color)
    paint.color = fillColor.withOpacity(0.3);
    paint.style = PaintingStyle.fill;
    canvas.drawCircle(center, ringRadius, paint);

    // Draw inner circle (solid color)
    paint.color = fillColor;
    canvas.drawCircle(center, circleRadius, paint);

    // Add white border around inner circle for clarity
    paint.color = Colors.white;
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = 2;
    canvas.drawCircle(center, circleRadius, paint);

    final picture = recorder.endRecording();
    final image = await picture.toImage(size.toInt(), size.toInt());
    final bytes = await image.toByteData(format: ui.ImageByteFormat.png);

    return BitmapDescriptor.bytes(bytes!.buffer.asUint8List());
  }

  static Future<BitmapDescriptor> createRiderMarker({
    required Color fillColor,
    double heading = 0,
    double size = 50,
    bool isNearby = false,
  }) async {
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    final paint = Paint();
    paint.isAntiAlias = true;

    final center = Offset(size / 2, size / 2);

    // Rotate canvas to heading direction
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(heading * pi / 180);
    canvas.translate(-center.dx, -center.dy);

    // Draw directional wedge/cone FIRST (largest)
    final wedgePath = Path();
    final wedgeLength = size * 0.35;
    final wedgeAngle = 50.0; // degrees on each side

    final angleRad = wedgeAngle * pi / 180;
    wedgePath.moveTo(center.dx, center.dy);
    wedgePath.lineTo(
      center.dx - wedgeLength * sin(angleRad),
      center.dy - wedgeLength * cos(angleRad),
    );

    // Draw arc manually with multiple points
    final arcSteps = 20;
    for (int i = 0; i <= arcSteps; i++) {
      final t = i / arcSteps;
      final angle = -angleRad + (2 * angleRad * t);
      wedgePath.lineTo(
        center.dx + wedgeLength * sin(angle),
        center.dy - wedgeLength * cos(angle),
      );
    }

    wedgePath.close();

    // Fill wedge
    paint.color = fillColor.withOpacity(isNearby ? 0.35 : 0.5);
    paint.style = PaintingStyle.fill;
    canvas.drawPath(wedgePath, paint);

    canvas.restore();

    // Draw outer ring (lighter color)
    final ringRadius = size * 0.28;
    paint.color = fillColor.withOpacity(isNearby ? 0.15 : 0.25);
    paint.style = PaintingStyle.fill;
    canvas.drawCircle(center, ringRadius, paint);

    // Draw main circle
    final circleRadius = size * 0.2;
    paint.color = isNearby ? fillColor.withOpacity(0.7) : fillColor;
    canvas.drawCircle(center, circleRadius, paint);

    // Add white border to circle
    paint.color = Colors.white;
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = 2.5;
    canvas.drawCircle(center, circleRadius, paint);

    // Draw arrow on top of circle to show direction
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(heading * pi / 180);
    canvas.translate(-center.dx, -center.dy);

    final arrowPath = Path();
    final arrowSize = circleRadius * 0.6;
    arrowPath.moveTo(center.dx, center.dy - arrowSize);
    arrowPath.lineTo(center.dx - arrowSize * 0.4, center.dy);
    arrowPath.lineTo(center.dx + arrowSize * 0.4, center.dy);
    arrowPath.close();

    paint.color = Colors.white;
    paint.style = PaintingStyle.fill;
    canvas.drawPath(arrowPath, paint);

    canvas.restore();

    final picture = recorder.endRecording();
    final image = await picture.toImage(size.toInt(), size.toInt());
    final bytes = await image.toByteData(format: ui.ImageByteFormat.png);

    return BitmapDescriptor.bytes(bytes!.buffer.asUint8List());
  }

  /// Predefined marker colors
  static const Color pickupColor = Color(0xFF2196F3); // Blue
  static const Color dropoffColor = Color(0xFF4CAF50); // Green
  static const Color riderColor = Color(0xFF2196F3); // Blue
  static const Color nearbyRiderColor = Color(
    0xFF2196F3,
  ); // Blue (lighter opacity)
}
