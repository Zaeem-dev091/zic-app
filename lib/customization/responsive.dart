import 'package:flutter/material.dart';

class AppBreakpoints {
  const AppBreakpoints._();

  static const double scaleCutoffWidth = 430;
  static const double tablet = 768;
  static const double desktop = 1100;
}

class ResponsiveFrame extends StatelessWidget {
  const ResponsiveFrame({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final maxWidth = _contentWidthFor(width);

    if (width <= maxWidth) {
      return child;
    }

    return ColoredBox(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: child,
        ),
      ),
    );
  }

  double _contentWidthFor(double width) {
    if (width >= AppBreakpoints.desktop) {
      return 640;
    }
    if (width >= AppBreakpoints.tablet) {
      return 560;
    }
    return width;
  }
}
