// lib/core/utils/responsive_config.dart
import 'package:flutter/material.dart';

class ResponsiveConfig {
  // Breakpoints for different device types
  static const double mobileBreakpoint = 600.0;
  static const double tabletBreakpoint = 1200.0;
  static const double desktopBreakpoint = 1800.0; // optional for ultra-wide screens

  // Screen type helpers
  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < mobileBreakpoint;

  static bool isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= mobileBreakpoint && width < tabletBreakpoint;
  }

  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= tabletBreakpoint;

  // Orientation helpers
  static bool isPortrait(BuildContext context) =>
      MediaQuery.of(context).orientation == Orientation.portrait;

  static bool isLandscape(BuildContext context) =>
      MediaQuery.of(context).orientation == Orientation.landscape;

  // Safe area helpers
  static EdgeInsets safePadding(BuildContext context) =>
      MediaQuery.of(context).padding;

  // Scaled dimensions based on screen width (assuming design width: 375)
  static double scaleWidth(BuildContext context, double size) {
    final screenWidth = MediaQuery.of(context).size.width;
    final scaleFactor = screenWidth / 375.0;
    return size * scaleFactor.clamp(0.7, 1.3);
  }

  static double scaleHeight(BuildContext context, double size) {
    final screenHeight = MediaQuery.of(context).size.height;
    final scaleFactor = screenHeight / 812.0;
    return size * scaleFactor.clamp(0.7, 1.3);
  }

  // Responsive padding/margins
  static EdgeInsets horizontalPadding(BuildContext context) {
    if (isMobile(context)) return const EdgeInsets.symmetric(horizontal: 16.0);
    if (isTablet(context)) return const EdgeInsets.symmetric(horizontal: 24.0);
    return const EdgeInsets.symmetric(horizontal: 32.0);
  }

  static EdgeInsets verticalPadding(BuildContext context) {
    if (isMobile(context)) return const EdgeInsets.symmetric(vertical: 12.0);
    if (isTablet(context)) return const EdgeInsets.symmetric(vertical: 16.0);
    return const EdgeInsets.symmetric(vertical: 20.0);
  }

  static double defaultPadding(BuildContext context) {
    if (isMobile(context)) return 12.0;
    if (isTablet(context)) return 20.0;
    return 32.0;
  }

  static double spacing(BuildContext context, {double base = 8.0}) =>
      base * fontScale(context);

  static double cardRadius(BuildContext context) {
    if (isMobile(context)) return 12.0;
    if (isTablet(context)) return 16.0;
    return 20.0;
  }

  // Icon and text helpers
  static double iconSize(BuildContext context, {double base = 20}) {
    return base * fontScale(context);
  }

  // Font scaling
  static double fontScale(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width < 360) return 0.85; // small phones
    if (width >= 360 && width < 600) return 1.0; // normal phones
    if (width >= 600 && width < 1200) return 1.05; // tablets
    if (width >= 1200 && width < 1800) return 1.1; // desktop
    return 1.2; // ultra-wide monitors
  }

  static double responsiveFont(BuildContext context, double fontSize,
      {double min = 10, double max = 32}) {
    final scaled = fontSize * fontScale(context);
    return scaled.clamp(min, max);
  }

  // Grid configurations
  static int gridCrossAxisCount(BuildContext context,
      {int mobileCount = 2, int tabletCount = 3, int desktopCount = 4}) {
    if (isMobile(context)) return mobileCount;
    if (isTablet(context)) return tabletCount;
    return desktopCount;
  }

  static double gridChildAspectRatio(BuildContext context,
      {double mobile = 1.15, double desktop = 1.2}) {
    if (isMobile(context)) return mobile;
    return desktop;
  }

  // ListView spacing
  static double listItemSpacing(BuildContext context) {
    if (isMobile(context)) return 12.0;
    if (isTablet(context)) return 16.0;
    return 20.0;
  }

  // Drawer & avatar radius
  static double drawerAvatarRadius(BuildContext context) {
    if (isMobile(context)) return 26.0;
    if (isTablet(context)) return 32.0;
    return 36.0;
  }

  // TextField height (for consistent sizing)
  static double textFieldHeight(BuildContext context, {double base = 48}) {
    return scaleHeight(context, base);
  }

  // Example: dynamic button height
  static double buttonHeight(BuildContext context, {double base = 48}) {
    return scaleHeight(context, base);
  }
}
