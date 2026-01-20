import 'package:flutter/material.dart';
import 'package:inta_mobile_pms/core/config/responsive_config.dart';
import 'package:inta_mobile_pms/core/theme/app_colors.dart';

class AppTextTheme {
  AppTextTheme._();

  // ---------- LIGHT THEME ----------
  static TextTheme lightTextTheme(BuildContext context) {
    return TextTheme(
      // DISPLAY (very large text – dashboards, hero numbers)
      displayLarge: _style(context, 46, FontWeight.w700),
      displayMedium: _style(context, 38, FontWeight.w700),
      displaySmall: _style(context, 30, FontWeight.w600),

      // HEADLINE (page headers, section titles)
      headlineLarge: _style(context, 30, FontWeight.w600),
      headlineMedium: _style(context, 26, FontWeight.w600),
      headlineSmall: _style(context, 22, FontWeight.w600),

      // TITLE (cards, dialogs, table headers)
      titleLarge: _style(context, 18, FontWeight.w600),
      titleMedium: _style(context, 16, FontWeight.w500),
      titleSmall: _style(context, 14, FontWeight.w500),

      // BODY (main content)
      bodyLarge: _style(context, 14, FontWeight.w400),
      bodyMedium: _style(context, 12, FontWeight.w400),
      bodySmall: _style(context, 10, FontWeight.w400),

      // LABEL (buttons, chips, badges)
      labelLarge: _style(context, 12, FontWeight.w600),
      labelMedium: _style(context, 10, FontWeight.w500),
      labelSmall: _style(context, 8, FontWeight.w500),
    );
  }

  // ---------- DARK THEME ----------
  // static TextTheme darkTextTheme(BuildContext context) {
  //   return TextTheme(
  //     displayLarge: _style(context, 46, FontWeight.w700, AppColors.surface),
  //     displayMedium: _style(context, 38, FontWeight.w700, AppColors.surface),
  //     displaySmall: _style(context, 30, FontWeight.w600, AppColors.surface),

  //     headlineLarge: _style(context, 28, FontWeight.w600, AppColors.surface),
  //     headlineMedium: _style(context, 24, FontWeight.w600, AppColors.surface),
  //     headlineSmall: _style(context, 20, FontWeight.w600, AppColors.surface),

  //     titleLarge: _style(context, 18, FontWeight.w600, AppColors.surface),
  //     titleMedium: _style(context, 16, FontWeight.w500, AppColors.surface),
  //     titleSmall: _style(context, 14, FontWeight.w500, AppColors.surface),

  //     bodyLarge: _style(context, 14, FontWeight.w400, AppColors.surface),
  //     bodyMedium: _style(context, 12, FontWeight.w400, AppColors.surface),
  //     bodySmall: _style(context, 10, FontWeight.w400, AppColors.surface),

  //     labelLarge: _style(context, 12, FontWeight.w600, AppColors.surface),
  //     labelMedium: _style(context, 10, FontWeight.w500, AppColors.surface),
  //     labelSmall: _style(context, 8, FontWeight.w500, AppColors.surface),
  //   );
  // }

  // ---------- SHARED RESPONSIVE TEXT STYLE ----------
  static TextStyle _style(
    BuildContext context,
    double baseSize,
    FontWeight weight, [
    Color? color,
  ]) {
    return TextStyle(
      fontSize: ResponsiveConfig.responsiveFont(context, baseSize),
      fontWeight: weight,
      color: color,
    );
  }
}
