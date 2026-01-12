import 'package:flutter/material.dart';
import 'package:inta_mobile_pms/core/theme/app_text_theme.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    fontFamily: 'Roboto', 
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
    textTheme: AppTextTheme.lightTextTheme,
    
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    fontFamily: 'Roboto', 
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue, brightness: Brightness.dark),
    textTheme: AppTextTheme.darkTextTheme
    
  );
}
