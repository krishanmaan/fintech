import 'package:flutter/material.dart';

// Base design dimensions (for reference - 375px width mobile)
const double _baseWidth = 375.0;
const double _baseHeight = 812.0;

/// Helper class for responsive calculations jo sab screens aur components me use hota hai.
class Responsive {
  final BuildContext context;
  final MediaQueryData mediaQuery;

  Responsive(this.context) : mediaQuery = MediaQuery.of(context);

  double width(double baseWidth) => (baseWidth / _baseWidth) * mediaQuery.size.width;
  double height(double baseHeight) => (baseHeight / _baseHeight) * mediaQuery.size.height;
  double fontSize(double baseSize) => (baseSize / _baseWidth) * mediaQuery.size.width;
  
  // Get screen dimensions
  double get screenWidth => mediaQuery.size.width;
  double get screenHeight => mediaQuery.size.height;
  
  // Responsive padding/margin (scales with width)
  double padding(double basePadding) => width(basePadding);
  
  // Responsive radius (scales with width)
  double radius(double baseRadius) => width(baseRadius);
}

