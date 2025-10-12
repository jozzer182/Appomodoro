import 'package:flutter/material.dart';
import 'dart:math' as math;

class DialPainter extends CustomPainter {
  final double elapsedSeconds;
  final Color accentColor;

  DialPainter({required this.elapsedSeconds, required this.accentColor});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final outerRadius = size.width * 0.4;
    final innerRadius = size.width * 0.3;

    // Seconds ring angle
    final secondsAngle = -math.pi / 2 + 2 * math.pi * ((elapsedSeconds % 60.0) / 60.0);

    // Minutes ring angle
    final minutesAngle = -math.pi / 2 + 2 * math.pi * ((elapsedSeconds / 60.0) / 60.0);

    // Draw outer ring ticks
    final tickPaint = Paint()
      ..color = Colors.white.withOpacity(0.7)
      ..strokeWidth = 2;
    for (int i = 0; i < 60; i++) {
      final angle = i * 6 * math.pi / 180 - math.pi / 2;
      final isMajor = i % 5 == 0;
      final tickLength = isMajor ? 20 : 10;
      final startRadius = outerRadius - tickLength;
      final start = center + Offset(math.cos(angle) * startRadius, math.sin(angle) * startRadius);
      final end = center + Offset(math.cos(angle) * outerRadius, math.sin(angle) * outerRadius);
      canvas.drawLine(start, end, tickPaint);
    }

    // Draw inner ring ticks
    final innerTickPaint = Paint()
      ..color = Colors.white.withOpacity(0.5)
      ..strokeWidth = 1.5;
    for (int i = 0; i < 60; i++) {
      final angle = i * 6 * math.pi / 180 - math.pi / 2;
      final isMajor = i % 5 == 0;
      final tickLength = isMajor ? 15 : 8;
      final startRadius = innerRadius - tickLength;
      final start = center + Offset(math.cos(angle) * startRadius, math.sin(angle) * startRadius);
      final end = center + Offset(math.cos(angle) * innerRadius, math.sin(angle) * innerRadius);
      canvas.drawLine(start, end, innerTickPaint);
    }

    // Draw numerals for seconds (outer)
    final textPainter = TextPainter(textDirection: TextDirection.ltr);
    for (int i = 0; i < 60; i += 5) {
      final angle = i * 6 * math.pi / 180 - math.pi / 2;
      final radius = outerRadius + 10;
      final position = center + Offset(math.cos(angle) * radius, math.sin(angle) * radius);
      textPainter.text = TextSpan(
        text: i.toString().padLeft(2, '0'),
        style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 14, fontWeight: FontWeight.w500),
      );
      textPainter.layout();
      textPainter.paint(canvas, position - Offset(textPainter.width / 2, textPainter.height / 2));
    }

    // Draw numerals for minutes (inner)
    for (int i = 0; i < 60; i += 5) {
      final angle = i * 6 * math.pi / 180 - math.pi / 2;
      final radius = innerRadius + 8;
      final position = center + Offset(math.cos(angle) * radius, math.sin(angle) * radius);
      textPainter.text = TextSpan(
        text: i.toString().padLeft(2, '0'),
        style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 12, fontWeight: FontWeight.w400),
      );
      textPainter.layout();
      textPainter.paint(canvas, position - Offset(textPainter.width / 2, textPainter.height / 2));
    }

    // Draw rotating seconds ring
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(secondsAngle);
    canvas.translate(-center.dx, -center.dy);
    // The numerals are drawn fixed, but conceptually the ring rotates

    // Actually, to rotate the numerals, we need to draw them rotated
    for (int i = 0; i < 60; i++) {
      final angle = i * 6 * math.pi / 180;
      final radius = outerRadius + 10;
      final position = center + Offset(math.cos(angle) * radius, math.sin(angle) * radius);
      canvas.save();
      canvas.translate(position.dx, position.dy);
      canvas.rotate(angle + math.pi / 2); // Adjust rotation
      textPainter.text = TextSpan(
        text: i.toString().padLeft(2, '0'),
        style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 14, fontWeight: FontWeight.w500),
      );
      textPainter.layout();
      textPainter.paint(canvas, Offset(-textPainter.width / 2, -textPainter.height / 2));
      canvas.restore();
    }
    canvas.restore();

    // Similarly for minutes
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(minutesAngle);
    canvas.translate(-center.dx, -center.dy);
    for (int i = 0; i < 60; i++) {
      final angle = i * 6 * math.pi / 180;
      final radius = innerRadius + 8;
      final position = center + Offset(math.cos(angle) * radius, math.sin(angle) * radius);
      canvas.save();
      canvas.translate(position.dx, position.dy);
      canvas.rotate(angle + math.pi / 2);
      textPainter.text = TextSpan(
        text: i.toString().padLeft(2, '0'),
        style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 12, fontWeight: FontWeight.w400),
      );
      textPainter.layout();
      textPainter.paint(canvas, Offset(-textPainter.width / 2, -textPainter.height / 2));
      canvas.restore();
    }
    canvas.restore();

    // Fixed selector windows
    final windowPaint = Paint()..color = Colors.transparent;
    final windowBorderPaint = Paint()
      ..color = Colors.white.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    // Left window for seconds
    final leftWindowRect = Rect.fromCenter(center: Offset(center.dx - outerRadius * 0.8, center.dy), width: 40, height: 30);
    canvas.drawRRect(RRect.fromRectAndRadius(leftWindowRect, const Radius.circular(8)), windowPaint);
    canvas.drawRRect(RRect.fromRectAndRadius(leftWindowRect, const Radius.circular(8)), windowBorderPaint);

    // Right window for minutes
    final rightWindowRect = Rect.fromCenter(center: Offset(center.dx + innerRadius * 0.8, center.dy), width: 40, height: 30);
    canvas.drawRRect(RRect.fromRectAndRadius(rightWindowRect, const Radius.circular(8)), windowPaint);
    canvas.drawRRect(RRect.fromRectAndRadius(rightWindowRect, const Radius.circular(8)), windowBorderPaint);

    // Current seconds in left window
    final currentSeconds = (elapsedSeconds % 60).floor();
    textPainter.text = TextSpan(
      text: currentSeconds.toString().padLeft(2, '0'),
      style: TextStyle(color: accentColor, fontSize: 16, fontWeight: FontWeight.bold),
    );
    textPainter.layout();
    textPainter.paint(canvas, leftWindowRect.center - Offset(textPainter.width / 2, textPainter.height / 2));

    // Current minutes in right window
    final currentMinutes = ((elapsedSeconds / 60) % 60).floor();
    textPainter.text = TextSpan(
      text: currentMinutes.toString().padLeft(2, '0'),
      style: TextStyle(color: accentColor, fontSize: 16, fontWeight: FontWeight.bold),
    );
    textPainter.layout();
    textPainter.paint(canvas, rightWindowRect.center - Offset(textPainter.width / 2, textPainter.height / 2));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}