import 'package:flutter/material.dart';

class Responsive {
  static bool isTablet(BuildContext context) {
    return MediaQuery.of(context).size.shortestSide >= 600;
  }

  static double scaleText(BuildContext context, double baseSize) {
    final scale = MediaQuery.of(context).textScaler.scale(baseSize);
    return scale;
  }

  static EdgeInsets padding(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width < 600) {
      return const EdgeInsets.all(16);
    } else {
      return const EdgeInsets.all(24);
    }
  }
}