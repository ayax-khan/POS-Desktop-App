import 'package:flutter/material.dart';

class AppSpacing {
  /// Returns spacing as a percentage of screen height
  static double height(BuildContext context, double percent) {
    return MediaQuery.of(context).size.height * percent;
  }

  /// Returns spacing as a percentage of screen width
  static double width(BuildContext context, double percent) {
    return MediaQuery.of(context).size.width * percent;
  }

  static double all(BuildContext context, double percent) {
    final size = MediaQuery.of(context).size;
    return ((size.width + size.height) / 2) * percent;
  }

  static double extraSmall(BuildContext context) {
    return all(context, 0.005);
  }

  static double small([BuildContext? context]) {
    if (context != null) {
      return all(context, 0.01); // responsive based on context
    } else {
      return 8.0; // fallback if context not available
    }
  }

  static double medium([BuildContext? context]) {
    if (context != null) {
      return all(context, 0.015);
    } else {
      return 16.0;
    }
  }

  static double large(BuildContext context) {
    return all(context, 0.02);
  }

  static double extraLarge(BuildContext context) {
    return all(context, 0.025);
  }

  // Responsive spacing based on screen size
  static double responsive(
    BuildContext context, {
    required double mobile,
    required double tablet,
    required double desktop,
  }) {
    final width = MediaQuery.of(context).size.width;
    if (width < 600) return mobile;
    if (width < 1200) return tablet;
    return desktop;
  }
}