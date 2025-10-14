import 'dart:io';
import 'dart:math' as math;
import 'package:image/image.dart' as img;

void main() async {
  const size = 1024;
  final canvas = img.Image(width: size, height: size);
  final bg = img.ColorRgba8(0x11, 0x12, 0x14, 0xFF);
  img.fill(canvas, color: bg);

  final center = size ~/ 2;
  final accent = img.ColorRgba8(0x5A, 0xC8, 0xFA, 0xFF);
  final ringColor = img.ColorRgba8(0xFF, 0xFF, 0xFF, 0x20);

  // Two thin concentric rings
  void ring(int r) {
    img.drawCircle(canvas, x: center, y: center, radius: r, color: ringColor);
  }

  ring(360);
  ring(270);

  // 60 ticks, every 5th longer
  for (int i = 0; i < 60; i++) {
    final isLong = i % 5 == 0;
    final a = 2 * math.pi * (i / 60) - math.pi / 2;
    final r1 = 380;
    final len = isLong ? 28 : 14;
    final x1 = center + (r1 * math.cos(a)).round();
    final y1 = center + (r1 * math.sin(a)).round();
    final x2 = center + ((r1 + len) * math.cos(a)).round();
    final y2 = center + ((r1 + len) * math.sin(a)).round();
    img.drawLine(canvas, x1: x1, y1: y1, x2: x2, y2: y2, color: img.ColorRgba8(0xFF, 0xFF, 0xFF, 0xC0));
  }

  // small accent oval on right (approximate with horizontal lines)
  final cx = center + 310;
  final ry = 40;
  final rx = 80;
  for (int dy = -ry; dy <= ry; dy++) {
    final yy = center + dy;
    final t = 1 - (dy * dy) / (ry * ry);
    final span = (rx * math.sqrt(t.clamp(0, 1).toDouble())).round();
    img.drawLine(canvas, x1: cx - span, y1: yy, x2: cx + span, y2: yy, color: accent);
  }

  final outPath = 'assets/icons/appicon_1024.png';
  await File(outPath).create(recursive: true);
  await File(outPath).writeAsBytes(img.encodePng(canvas));
  stdout.writeln('Wrote $outPath');
}

