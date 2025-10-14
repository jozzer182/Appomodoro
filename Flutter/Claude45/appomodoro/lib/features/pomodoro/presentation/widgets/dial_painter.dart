import 'dart:math';
import 'package:flutter/material.dart';

class DialPainter extends CustomPainter {
  final double elapsedSeconds;
  final Color accentColor;
  final Color backgroundColor;
  final Color textColor;

  DialPainter({
    required this.elapsedSeconds,
    required this.accentColor,
    required this.backgroundColor,
    required this.textColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Draw background circle
    final bgPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, radius, bgPaint);

    // Calculate ring radii
    final outerRingRadius = radius * 0.85;
    final innerRingRadius = radius * 0.60;

    // Calculate rotation angles
    final secondsAngle = -pi / 2 + 2 * pi * ((elapsedSeconds % 60.0) / 60.0);
    final minutesAngle =
        -pi / 2 + 2 * pi * ((elapsedSeconds / 60.0) / 60.0);

    // Draw outer ticks (seconds reference)
    _drawTicks(canvas, center, outerRingRadius, 60, textColor.withOpacity(0.3));

    // Draw inner ticks (minutes reference)
    _drawTicks(
        canvas, center, innerRingRadius, 60, textColor.withOpacity(0.2));

    // Draw rotating seconds ring (outer)
    _drawSecondsRing(canvas, center, outerRingRadius, secondsAngle);

    // Draw rotating minutes ring (inner)
    _drawMinutesRing(canvas, center, innerRingRadius, minutesAngle);

    // Draw selector windows
    _drawSelectorWindow(
        canvas, center, outerRingRadius, -pi, 'SEC', isLeft: true);
    _drawSelectorWindow(
        canvas, center, innerRingRadius, 0, 'MIN', isLeft: false);
  }

  void _drawTicks(
      Canvas canvas, Offset center, double radius, int count, Color color) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round;

    for (int i = 0; i < count; i++) {
      final angle = -pi / 2 + (2 * pi * i) / count;
      final isLong = i % 5 == 0;
      final tickLength = isLong ? 12.0 : 6.0;

      final startRadius = radius + 5;
      final endRadius = radius + 5 + tickLength;

      final startX = center.dx + startRadius * cos(angle);
      final startY = center.dy + startRadius * sin(angle);
      final endX = center.dx + endRadius * cos(angle);
      final endY = center.dy + endRadius * sin(angle);

      canvas.drawLine(
          Offset(startX, startY), Offset(endX, endY), paint);
    }
  }

  void _drawSecondsRing(
      Canvas canvas, Offset center, double radius, double rotationAngle) {
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(rotationAngle);

    for (int i = 0; i < 60; i++) {
      final angle = (2 * pi * i) / 60;
      final x = radius * cos(angle);
      final y = radius * sin(angle);

      final textPainter = TextPainter(
        text: TextSpan(
          text: i.toString().padLeft(2, '0'),
          style: TextStyle(
            color: textColor,
            fontSize: 12,
            fontWeight: FontWeight.w400,
            letterSpacing: 0.5,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();

      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(-rotationAngle); // Keep text upright
      textPainter.paint(
          canvas, Offset(-textPainter.width / 2, -textPainter.height / 2));
      canvas.restore();
    }

    canvas.restore();
  }

  void _drawMinutesRing(
      Canvas canvas, Offset center, double radius, double rotationAngle) {
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(rotationAngle);

    for (int i = 0; i < 60; i++) {
      final angle = (2 * pi * i) / 60;
      final x = radius * cos(angle);
      final y = radius * sin(angle);

      final textPainter = TextPainter(
        text: TextSpan(
          text: i.toString().padLeft(2, '0'),
          style: TextStyle(
            color: textColor.withOpacity(0.9),
            fontSize: 10,
            fontWeight: FontWeight.w300,
            letterSpacing: 0.5,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();

      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(-rotationAngle); // Keep text upright
      textPainter.paint(
          canvas, Offset(-textPainter.width / 2, -textPainter.height / 2));
      canvas.restore();
    }

    canvas.restore();
  }

  void _drawSelectorWindow(Canvas canvas, Offset center, double radius,
      double angle, String label,
      {required bool isLeft}) {
    final x = center.dx + radius * cos(angle);
    final y = center.dy + radius * sin(angle);

    // Draw selector box
    final boxPaint = Paint()
      ..color = accentColor.withOpacity(0.2)
      ..style = PaintingStyle.fill;

    final boxRect = RRect.fromRectAndRadius(
      Rect.fromCenter(center: Offset(x, y), width: 40, height: 30),
      const Radius.circular(6),
    );
    canvas.drawRRect(boxRect, boxPaint);

    // Draw border
    final borderPaint = Paint()
      ..color = accentColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawRRect(boxRect, borderPaint);

    // Draw label
    final labelPainter = TextPainter(
      text: TextSpan(
        text: label,
        style: TextStyle(
          color: accentColor,
          fontSize: 8,
          fontWeight: FontWeight.bold,
          letterSpacing: 1,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    labelPainter.paint(
      canvas,
      Offset(
        x - labelPainter.width / 2,
        y + 20,
      ),
    );
  }

  @override
  bool shouldRepaint(DialPainter oldDelegate) {
    return oldDelegate.elapsedSeconds != elapsedSeconds ||
        oldDelegate.accentColor != accentColor;
  }
}
