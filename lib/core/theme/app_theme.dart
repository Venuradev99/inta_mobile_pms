import 'package:flutter/material.dart';
import 'package:inta_mobile_pms/core/theme/app_text_theme.dart';

class AppTheme {
  static ThemeData light(BuildContext context) => ThemeData(
        brightness: Brightness.light,
        fontFamily: 'Montserrat',
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        textTheme: AppTextTheme.lightTextTheme(context),
      );

  static ThemeData dark(BuildContext context) => ThemeData(
        brightness: Brightness.dark,
        fontFamily: 'Montserrat',
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.dark,
        ),
        textTheme: AppTextTheme.darkTextTheme(context),
      );
}
