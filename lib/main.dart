import 'package:flutter/material.dart';
import 'package:inta_mobile_pms/core/theme/app_theme.dart';
import 'package:inta_mobile_pms/router/app_router.dart';

void main() {
  runApp(const PMSApp());
}

class PMSApp extends StatelessWidget {
  const PMSApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Inta Mobile PMS',
      routerConfig: appRouter,
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
    );
  }
}
