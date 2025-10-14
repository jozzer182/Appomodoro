import 'package:flutter/widgets.dart';

enum DeviceSize { phone, tablet, desktop }

class Breakpoints {
  const Breakpoints._();

  static const double phoneMaxWidth = 600;
  static const double tabletMaxWidth = 1024;
}

DeviceSize deviceSizeOf(BoxConstraints constraints) {
  final width = constraints.maxWidth;
  if (width >= Breakpoints.tabletMaxWidth) {
    return DeviceSize.desktop;
  }
  if (width >= Breakpoints.phoneMaxWidth) {
    return DeviceSize.tablet;
  }
  return DeviceSize.phone;
}

class ResponsiveLayout extends StatelessWidget {
  const ResponsiveLayout({
    super.key,
    required this.phone,
    this.tablet,
    this.desktop,
  });

  final WidgetBuilder phone;
  final WidgetBuilder? tablet;
  final WidgetBuilder? desktop;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = deviceSizeOf(constraints);
        switch (size) {
          case DeviceSize.desktop:
            return (desktop ?? tablet ?? phone).call(context);
          case DeviceSize.tablet:
            return (tablet ?? phone).call(context);
          case DeviceSize.phone:
            return phone(context);
        }
      },
    );
  }
}

extension BuildContextResponsive on BuildContext {
  bool get isTabletOrLarger => MediaQuery.sizeOf(this).width >= Breakpoints.phoneMaxWidth;
  bool get isDesktop => MediaQuery.sizeOf(this).width >= Breakpoints.tabletMaxWidth;
}
