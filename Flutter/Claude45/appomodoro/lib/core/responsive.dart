import 'package:flutter/material.dart';

class Responsive {
  static const double tabletBreakpoint = 600;
  static const double desktopBreakpoint = 1200;

  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < tabletBreakpoint;

  static bool isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= tabletBreakpoint && width < desktopBreakpoint;
  }

  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= desktopBreakpoint;

  static bool isTabletOrLarger(BuildContext context) =>
      MediaQuery.of(context).size.width >= tabletBreakpoint;

  static double getDialSize(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    
    if (isMobile(context)) {
      return (width < height ? width : height) * 0.7;
    } else {
      return (width < height ? width : height) * 0.5;
    }
  }
}
