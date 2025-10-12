import 'dart:io';
import 'dart:math' as math;
import 'package:image/image.dart' as img;

void main() {
  const size = 1024;
  final image = img.Image(width: size, height: size);

  // Fill with graphite background
  img.fill(image, color: img.ColorRgb8(17, 18, 20));

  final centerX = size / 2;
  final centerY = size / 2;
  final outerRadius = size * 0.4;
  final innerRadius = size * 0.3;

  // Draw outer ring (seconds)
  for (int i = 0; i < 60; i++) {
    final angle = (i * 6 - 90) * math.pi / 180;
    final x = centerX + outerRadius * math.cos(angle);
    final y = centerY + outerRadius * math.sin(angle);
    final tickLength = i % 5 == 0 ? 20 : 10;
    final innerX = centerX + (outerRadius - tickLength) * math.cos(angle);
    final innerY = centerY + (outerRadius - tickLength) * math.sin(angle);
    img.drawLine(image,
        x1: x.toInt(), y1: y.toInt(),
        x2: innerX.toInt(), y2: innerY.toInt(),
        color: img.ColorRgb8(200, 200, 200));
  }

  // Draw inner ring (minutes)
  for (int i = 0; i < 60; i++) {
    final angle = (i * 6 - 90) * math.pi / 180;
    final x = centerX + innerRadius * math.cos(angle);
    final y = centerY + innerRadius * math.sin(angle);
    final tickLength = i % 5 == 0 ? 15 : 8;
    final innerX = centerX + (innerRadius - tickLength) * math.cos(angle);
    final innerY = centerY + (innerRadius - tickLength) * math.sin(angle);
    img.drawLine(image,
        x1: x.toInt(), y1: y.toInt(),
        x2: innerX.toInt(), y2: innerY.toInt(),
        color: img.ColorRgb8(150, 150, 150));
  }

  // Draw accent oval on the right
  final ovalX = centerX + innerRadius * 0.7;
  final ovalY = centerY;
  img.fillCircle(image,
      x: ovalX.toInt(), y: ovalY.toInt(),
      radius: 20,
      color: img.ColorRgb8(255, 100, 100));

  // Save the image
  final png = img.encodePng(image);
  File('assets/icons/appicon_1024.png').writeAsBytesSync(png);
  print('Icon generated at assets/icons/appicon_1024.png');
}