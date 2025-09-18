// lib/core/utils/responsive_config.dart
import 'package:flutter/material.dart';

class ResponsiveConfig {
  // Breakpoints for different device types
  static const double mobileBreakpoint = 600.0;
  static const double tabletBreakpoint = 1200.0;

  // Screen type helpers
  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < mobileBreakpoint;
  }

  static bool isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= mobileBreakpoint && width < tabletBreakpoint;
  }

  static bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= tabletBreakpoint;
  }

  // Scaled dimensions based on screen width (assuming design for 375px mobile width)
  static double scaleWidth(BuildContext context, double mobileWidth) {
    final screenWidth = MediaQuery.of(context).size.width;
    final scaleFactor = screenWidth / 375.0;
    return mobileWidth * scaleFactor.clamp(0.8, 1.2); // Clamp to prevent extreme scaling
  }

  static double scaleHeight(BuildContext context, double mobileHeight) {
    final screenHeight = MediaQuery.of(context).size.height;
    final scaleFactor = screenHeight / 812.0;
    return mobileHeight * scaleFactor.clamp(0.8, 1.2); // Clamp to prevent extreme scaling
  }

  // Responsive padding and margins
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

  static double cardRadius(BuildContext context) {
    if (isMobile(context)) return 12.0;
    return 16.0;
  }

  static double iconSize(BuildContext context) {
    if (isMobile(context)) return 20.0;
    return 24.0;
  }

  // Grid configurations
  static int gridCrossAxisCount(BuildContext context, {int mobileCount = 2, int tabletCount = 3, int desktopCount = 4}) {
    if (isMobile(context)) return mobileCount;
    if (isTablet(context)) return tabletCount;
    return desktopCount;
  }

  static double gridChildAspectRatio(BuildContext context) {
    if (isMobile(context)) return 1.15;
    return 1.2;
  }

  // Drawer and AppBar adjustments
  static double drawerAvatarRadius(BuildContext context) {
    if (isMobile(context)) return 26.0;
    return 32.0;
  }

  // ListView item spacing
  static double listItemSpacing(BuildContext context) {
    if (isMobile(context)) return 12.0;
    return 16.0;
  }

  // Font scaling
  static double fontScale(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width < 360) return 0.9; // Small phones
    if (width > 1200) return 1.1; // Large tablets/desktops
    return 1.0;
  }
}