import 'package:flutter/widgets.dart';

class Breakpoints {
  static const double tablet = 768;
  static const double desktop = 1024;
}

extension LayoutX on BoxConstraints {
  bool get isTablet => maxWidth >= Breakpoints.tablet;
  bool get isDesktop => maxWidth >= Breakpoints.desktop;
}
