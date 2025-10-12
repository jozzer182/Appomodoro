import 'dart:io';
import 'dart:math';
import 'package:image/image.dart';

void main() async {
  const width = 1024;
  const height = 1024;
  final image = Image(width: width, height: height);

  // Background
  final background = ColorRgb8(28, 29, 33); // #1c1d21
  fill(image, color: background);

  // Outer ring
  drawCircle(image,
      x: width ~/ 2,
      y: height ~/ 2,
      radius: (width * 0.45).round(),
      color: ColorRgb8(80, 80, 80));

  // Inner ring
  drawCircle(image,
      x: width ~/ 2,
      y: height ~/ 2,
      radius: (width * 0.35).round(),
      color: ColorRgb8(80, 80, 80));

  // Ticks
  final tickColor = ColorRgb8(120, 120, 120);
  for (var i = 0; i < 60; i++) {
    final angle = (i / 60) * 360.0;
    final length = i % 5 == 0 ? 20 : 10;
    final startRadius = (width * 0.45) - 5;
    final endRadius = startRadius - length;

    final start = _pointOnCircle(width / 2, height / 2, startRadius, angle);
    final end = _pointOnCircle(width / 2, height / 2, endRadius, angle);

    drawLine(image, x1: start.x.round(), y1: start.y.round(), x2: end.x.round(), y2: end.y.round(), color: tickColor, thickness: 2);
  }
  
  // Accent oval
  final accentColor = ColorRgb8(255, 100, 100);
  fillCircle(image, x: (width * 0.75).round(), y: (height * 0.5).round(), radius: 20, color: accentColor);


  final file = File('assets/icons/appicon_1024.png');
  await file.create(recursive: true);
  await file.writeAsBytes(encodePng(image));

  // ignore: avoid_print
  print('Icon generated at assets/icons/appicon_1024.png');
}

Point _pointOnCircle(double centerX, double centerY, double radius, double angleDegrees) {
  final radians = (angleDegrees - 90) * (pi / 180.0);
  return Point(centerX + radius * cos(radians), centerY + radius * sin(radians));
}
