import 'package:flutter/material.dart';

class Responsive {
  Responsive._();

  static double width(BuildContext context) =>
      MediaQuery.sizeOf(context).width;

  static double height(BuildContext context) =>
      MediaQuery.sizeOf(context).height;

  static bool isSmallScreen(BuildContext context) => width(context) < 360;

  static double horizontalPadding(BuildContext context) {
    final w = width(context);
    if (w < 360) return 16;
    if (w > 600) return 32;
    return 20;
  }

  static int gridCrossAxisCount(BuildContext context) {
    final w = width(context);
    if (w > 600) return 3;
    return 2;
  }

  static double fontScale(BuildContext context) {
    final w = width(context);
    if (w < 360) return 0.9;
    return 1.0;
  }
}
