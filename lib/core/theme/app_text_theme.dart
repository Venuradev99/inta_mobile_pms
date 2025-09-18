import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:inta_mobile_pms/core/theme/app_colors.dart';

class AppTextTheme {
  AppTextTheme._();

  static TextTheme get lightTextTheme {
    return const TextTheme(
      bodyLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
      bodyMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
      bodySmall: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
      titleLarge: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
      titleMedium: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
      titleSmall: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
    );
  }

  static TextTheme get darkTextTheme {
    return const TextTheme(
      bodyLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: AppColors.surface),
      bodyMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: AppColors.surface),
      bodySmall: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: AppColors.surface),
      titleLarge: TextStyle(fontSize: 22, fontWeight: FontWeight.w600, color: AppColors.surface),
      titleMedium: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: AppColors.surface),
      titleSmall: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: AppColors.surface),
    );
  }

}