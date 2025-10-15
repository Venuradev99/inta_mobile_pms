import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inta_mobile_pms/core/theme/app_theme.dart';
import 'package:inta_mobile_pms/router/app_router.dart';
import 'package:inta_mobile_pms/services/loading_controller.dart';

void main() {
  Get.put(LoadingController(), permanent: true);
  runApp(const PMSApp());
}

class PMSApp extends StatelessWidget {
  const PMSApp({super.key});

  @override
  Widget build(BuildContext context) {
    final loadingController = Get.find<LoadingController>();

    return MaterialApp.router(
      title: 'Inta Mobile PMS',
      routerConfig: appRouter,
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      builder: (context, child) {
        return Stack(
          children: [
            child!,
            Obx(() {
              return loadingController.isLoading.value
                  ? Container(
                      color: Colors.black.withOpacity(0.4),
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CircularProgressIndicator(
                              color: Colors.white,
                            ),
                            SizedBox(height: 12),
                          ],
                        ),
                      ),
                    )
                  : const SizedBox.shrink();
            }),
          ],
        );
      },
    );
  }
}
