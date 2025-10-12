import 'dart:math';
import 'package:flutter/material.dart';

class DialPainter extends CustomPainter {
  final Duration remainingTime;

  DialPainter({required this.remainingTime});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Draw background
    final backgroundPaint = Paint()..color = const Color(0xFF1C1D21);
    canvas.drawCircle(center, radius, backgroundPaint);

    final double elapsedSec = (remainingTime.inMilliseconds / 1000.0);

    // Draw rings, ticks, and numerals
    _drawSecondsRing(canvas, size, elapsedSec);
    _drawMinutesRing(canvas, size, elapsedSec);
    _drawTicks(canvas, size);
    _drawCenterReadout(canvas, size);
    _drawSelectorWindows(canvas, size);
  }

  void _drawSecondsRing(Canvas canvas, Size size, double elapsedSec) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width * 0.4;
    final angle = -pi / 2 + 2 * pi * ((elapsedSec % 60.0) / 60.0);

    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(angle);
    canvas.translate(-center.dx, -center.dy);

    for (int i = 0; i < 60; i++) {
      final textPainter = TextPainter(
        text: TextSpan(
          text: i.toString().padLeft(2, '0'),
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      final textAngle = 2 * pi * (i / 60.0);
      final textOffset = Offset(
        center.dx + radius * cos(textAngle - pi / 2) - textPainter.width / 2,
        center.dy + radius * sin(textAngle - pi / 2) - textPainter.height / 2,
      );
      textPainter.paint(canvas, textOffset);
    }
    canvas.restore();
  }

  void _drawMinutesRing(Canvas canvas, Size size, double elapsedSec) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width * 0.3;
    final angle = -pi / 2 + 2 * pi * ((elapsedSec / 60.0) / 60.0);

    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(angle);
    canvas.translate(-center.dx, -center.dy);

    for (int i = 0; i < 60; i++) {
      final textPainter = TextPainter(
        text: TextSpan(
          text: i.toString().padLeft(2, '0'),
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      final textAngle = 2 * pi * (i / 60.0);
      final textOffset = Offset(
        center.dx + radius * cos(textAngle - pi / 2) - textPainter.width / 2,
        center.dy + radius * sin(textAngle - pi / 2) - textPainter.height / 2,
      );
      textPainter.paint(canvas, textOffset);
    }
    canvas.restore();
  }

  void _drawTicks(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    final tickPaint = Paint()
      ..color = Colors.white54
      ..strokeWidth = 2;

    for (int i = 0; i < 60; i++) {
      final tickLength = i % 5 == 0 ? 15.0 : 5.0;
      final start = center + Offset(cos(2 * pi * i / 60), sin(2 * pi * i / 60)) * (radius - 5);
      final end = center + Offset(cos(2 * pi * i / 60), sin(2 * pi * i / 60)) * (radius - 5 - tickLength);
      canvas.drawLine(start, end, tickPaint);
    }
  }

  void _drawCenterReadout(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final minutes = remainingTime.inMinutes.toString().padLeft(2, '0');
    final seconds = (remainingTime.inSeconds % 60).toString().padLeft(2, '0');

    final minutePainter = TextPainter(
      text: TextSpan(
        text: minutes,
        style: const TextStyle(
            color: Colors.white, fontSize: 80, fontWeight: FontWeight.bold),
      ),
      textDirection: TextDirection.ltr,
    );
    minutePainter.layout();
    minutePainter.paint(
        canvas, center - Offset(minutePainter.width / 2, minutePainter.height / 2));

    final secondsBadgePaint = Paint()..color = const Color(0xFFFF6464);
    final secondsBadgeRect = RRect.fromRectAndRadius(
      Rect.fromCenter(
          center: center + Offset(0, minutePainter.height / 2 + 15),
          width: 60,
          height: 30),
      const Radius.circular(15),
    );
    canvas.drawRRect(secondsBadgeRect, secondsBadgePaint);

    final secondsPainter = TextPainter(
      text: TextSpan(
        text: seconds,
        style: const TextStyle(color: Colors.white, fontSize: 20),
      ),
      textDirection: TextDirection.ltr,
    );
    secondsPainter.layout();
    secondsPainter.paint(
        canvas,
        center +
            Offset(-secondsPainter.width / 2,
                minutePainter.height / 2 + 15 - secondsPainter.height / 2));
  }

  void _drawSelectorWindows(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final secondsRadius = size.width * 0.4;
    final minutesRadius = size.width * 0.3;

    final selectorPaint = Paint()
      ..color = Colors.transparent
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..blendMode = BlendMode.srcIn; // This is tricky, might need adjustment

    // Seconds window (left)
    final secondsWindowRect = RRect.fromRectAndRadius(
      Rect.fromCenter(
          center: Offset(center.dx - secondsRadius, center.dy),
          width: 50,
          height: 30),
      const Radius.circular(10),
    );
    canvas.drawRRect(secondsWindowRect, selectorPaint..color = Colors.red.withOpacity(0.5));

    // Minutes window (right)
    final minutesWindowRect = RRect.fromRectAndRadius(
      Rect.fromCenter(
          center: Offset(center.dx + minutesRadius, center.dy),
          width: 50,
          height: 30),
      const Radius.circular(10),
    );
    canvas.drawRRect(minutesWindowRect, selectorPaint..color = Colors.blue.withOpacity(0.5));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
