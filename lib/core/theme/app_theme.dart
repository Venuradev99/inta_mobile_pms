import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static ThemeData light(BuildContext context) => ThemeData(
        brightness: Brightness.light,
        // fontFamily: 'Montserrat',
        
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        // textTheme: AppTextTheme.lightTextTheme(context),
        textTheme: GoogleFonts.robotoFlexTextTheme(),
      );

  // static ThemeData dark(BuildContext context) => ThemeData(
  //       brightness: Brightness.dark,
  //       fontFamily: 'Montserrat',
  //       colorScheme: ColorScheme.fromSeed(
  //         seedColor: Colors.blue,
  //         brightness: Brightness.dark,
  //       ),
  //       textTheme: AppTextTheme.darkTextTheme(context),
  //     );
}
