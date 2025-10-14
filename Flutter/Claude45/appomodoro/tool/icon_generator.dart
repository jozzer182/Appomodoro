import 'dart:io';
import 'dart:math' as math;
import 'package:image/image.dart' as img;

void main() async {
  print('Generating app icon...');

  try {
    // Create 1024x1024 image
    final image = img.Image(width: 1024, height: 1024);

    // Background color (dark graphite)
    final bgColor = img.ColorRgb8(17, 18, 20);
    img.fill(image, color: bgColor);

    final centerX = 512;
    final centerY = 512;

    // Accent color (cyan)
    final accentColor = img.ColorRgb8(0, 188, 212);
    final tickColor = img.ColorRgb8(232, 234, 237);

    // Draw outer ring
    final outerRadius = 420;
    _drawRing(image, centerX, centerY, outerRadius, 8, accentColor);

    // Draw inner ring
    final innerRadius = 300;
    _drawRing(image, centerX, centerY, innerRadius, 6, accentColor);

    // Draw ticks around outer ring
    for (int i = 0; i < 60; i++) {
      final angle = -math.pi / 2 + (2 * math.pi * i) / 60;
      final isLong = i % 5 == 0;
      final tickLength = isLong ? 30 : 15;
      final tickWidth = isLong ? 4 : 2;

      final startRadius = outerRadius + 10;
      final endRadius = outerRadius + 10 + tickLength;

      final startX = centerX + (startRadius * math.cos(angle)).toInt();
      final startY = centerY + (startRadius * math.sin(angle)).toInt();
      final endX = centerX + (endRadius * math.cos(angle)).toInt();
      final endY = centerY + (endRadius * math.sin(angle)).toInt();

      _drawThickLine(image, startX, startY, endX, endY, tickWidth, tickColor);
    }

    // Draw small accent oval on right (selector window representation)
    final selectorX = centerX + (innerRadius + 40).toInt();
    final selectorY = centerY;
    _drawOval(image, selectorX, selectorY, 35, 25, accentColor);

    // Save icon
    final directory = Directory('assets/icons');
    if (!directory.existsSync()) {
      directory.createSync(recursive: true);
    }

    final file = File('assets/icons/appicon_1024.png');
    await file.writeAsBytes(img.encodePng(image));

    print('✅ App icon generated successfully at assets/icons/appicon_1024.png');
  } catch (e) {
    print('❌ Failed to generate icon: $e');
    exit(1);
  }
}

void _drawRing(img.Image image, int cx, int cy, int radius, int thickness,
    img.Color color) {
  // Draw circle outline using multiple circles for thickness
  for (int t = 0; t < thickness; t++) {
    final r = radius - t ~/ 2;
    for (int angle = 0; angle < 360; angle++) {
      final rad = angle * math.pi / 180;
      final x = cx + (r * math.cos(rad)).toInt();
      final y = cy + (r * math.sin(rad)).toInt();
      if (x >= 0 && x < image.width && y >= 0 && y < image.height) {
        image.setPixel(x, y, color);
      }
    }
  }
}

void _drawThickLine(img.Image image, int x1, int y1, int x2, int y2,
    int thickness, img.Color color) {
  // Bresenham's line algorithm with thickness
  final dx = (x2 - x1).abs();
  final dy = (y2 - y1).abs();
  final sx = x1 < x2 ? 1 : -1;
  final sy = y1 < y2 ? 1 : -1;
  var err = dx - dy;

  var x = x1;
  var y = y1;

  while (true) {
    // Draw thick point
    for (int i = -thickness ~/ 2; i <= thickness ~/ 2; i++) {
      for (int j = -thickness ~/ 2; j <= thickness ~/ 2; j++) {
        final px = x + i;
        final py = y + j;
        if (px >= 0 && px < image.width && py >= 0 && py < image.height) {
          image.setPixel(px, py, color);
        }
      }
    }

    if (x == x2 && y == y2) break;

    final e2 = 2 * err;
    if (e2 > -dy) {
      err -= dy;
      x += sx;
    }
    if (e2 < dx) {
      err += dx;
      y += sy;
    }
  }
}

void _drawOval(
    img.Image image, int cx, int cy, int radiusX, int radiusY, img.Color color) {
  for (int y = -radiusY; y <= radiusY; y++) {
    for (int x = -radiusX; x <= radiusX; x++) {
      if ((x * x) / (radiusX * radiusX) + (y * y) / (radiusY * radiusY) <= 1) {
        final px = cx + x;
        final py = cy + y;
        if (px >= 0 && px < image.width && py >= 0 && py < image.height) {
          image.setPixel(px, py, color);
        }
      }
    }
  }
}
