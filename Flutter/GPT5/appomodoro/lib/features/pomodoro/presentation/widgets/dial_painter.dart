import 'dart:math';
import 'package:flutter/material.dart';

class DialPainter extends CustomPainter {
  DialPainter({
    required this.thetaS,
    required this.thetaM,
    required this.accent,
    required this.textStyle,
  });

  final double thetaS;
  final double thetaM;
  final Color accent;
  final TextStyle textStyle;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = size.shortestSide * 0.42;
    final secRadius = radius;
    final minRadius = radius * 0.75;

    final bgPaint = Paint()
      ..color = const Color(0xFF0E0F12)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, radius * 1.15, bgPaint);

    _drawTicks(canvas, center, secRadius, longEvery: 5);
    // selector windows rects
    final windows = _selectorWindows(size, center, secRadius, minRadius);

    // draw seconds numerals clipped to left window
    canvas.save();
    canvas.clipRRect(windows.$1);
    _drawNumeralRing(canvas, center, secRadius, thetaS);
    canvas.restore();

    // draw minutes numerals clipped to right window
    canvas.save();
    canvas.clipRRect(windows.$2);
    _drawNumeralRing(canvas, center, minRadius, thetaM);
    canvas.restore();

    // selector window chrome on top
    _drawSelectorChrome(canvas, windows);
  }

  void _drawTicks(Canvas canvas, Offset c, double r, {int longEvery = 5}) {
    final tickPaint = Paint()
      ..color = Colors.white.withOpacity(0.9)
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 2;
    for (int i = 0; i < 60; i++) {
      final isLong = i % longEvery == 0;
      final a = -pi / 2 + 2 * pi * (i / 60);
      final p1 = Offset(
        c.dx + cos(a) * (r + (isLong ? 10 : 4)),
        c.dy + sin(a) * (r + (isLong ? 10 : 4)),
      );
      final p2 = Offset(
        c.dx + cos(a) * (r + (isLong ? 20 : 10)),
        c.dy + sin(a) * (r + (isLong ? 20 : 10)),
      );
      canvas.drawLine(p1, p2, tickPaint);
    }
  }

  void _drawNumeralRing(Canvas canvas, Offset c, double r, double theta) {
    final numeralPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    // draw ring
    canvas.drawCircle(
      c,
      r,
      numeralPaint..color = Colors.white.withOpacity(0.12),
    );

    // rotating numbers
    canvas.save();
    canvas.translate(c.dx, c.dy);
    canvas.rotate(theta);
    final tp = TextPainter(
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );
    for (int i = 0; i < 60; i++) {
      final label = i.toString().padLeft(2, '0');
      final a = 2 * pi * (i / 60);
      final pos = Offset(cos(a) * r, sin(a) * r);
      tp.text = TextSpan(text: label, style: textStyle);
      tp.layout();
      final offset = pos - Offset(tp.width / 2, tp.height / 2);
      tp.paint(canvas, offset);
    }
    canvas.restore();
  }

  (RRect, RRect) _selectorWindows(Size size, Offset c, double rs, double rm) {
    final windowH = size.shortestSide * 0.1;
    final windowW = windowH * 1.8;
    final rrectLeft = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset(c.dx - rs * 0.9, c.dy),
        width: windowW,
        height: windowH,
      ),
      const Radius.circular(14),
    );
    final rrectRight = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset(c.dx + rm * 0.9, c.dy),
        width: windowW,
        height: windowH,
      ),
      const Radius.circular(14),
    );
    return (rrectLeft, rrectRight);
  }

  void _drawSelectorChrome(Canvas canvas, (RRect, RRect) windows) {
    final rrectLeft = windows.$1;
    final rrectRight = windows.$2;
    final winPaint = Paint()..color = Colors.white.withOpacity(0.08);
    final winBorder = Paint()
      ..color = accent
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5;
    canvas.drawRRect(rrectLeft, winPaint);
    canvas.drawRRect(rrectLeft, winBorder);
    canvas.drawRRect(rrectRight, winPaint);
    canvas.drawRRect(rrectRight, winBorder);
  }

  @override
  bool shouldRepaint(covariant DialPainter oldDelegate) {
    return oldDelegate.thetaS != thetaS ||
        oldDelegate.thetaM != thetaM ||
        oldDelegate.accent != accent;
  }
}
