// lib/widgets/common/app_bar_widget.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:go_router/go_router.dart';
import 'package:inta_mobile_pms/core/theme/app_colors.dart';
import 'package:inta_mobile_pms/router/app_routes.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onInfoTap;
  final VoidCallback? onFilterTap;
  final VoidCallback? onRefreshTap;

  const CustomAppBar({
    super.key,
    required this.title,
    this.onInfoTap,
    this.onFilterTap,
    this.onRefreshTap,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.surface,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: AppColors.black),
        onPressed: () => Get.toNamed(AppRoutes.dashboard),
      ),
      title: Text(
        title,
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
          color: AppColors.black,
          fontWeight: FontWeight.w600,
        ),
      ),
      actions: [
        if (onInfoTap != null)
          IconButton(
            icon: const Icon(Icons.info_outline, color: AppColors.black),
            onPressed: onInfoTap,
          ),
        if (onFilterTap != null)
          IconButton(
            icon: const Icon(Icons.filter_list, color: AppColors.black),
            onPressed: onFilterTap,
          ),
        if (onRefreshTap != null)
          IconButton(
            icon: const Icon(Icons.refresh, color: AppColors.black),
            onPressed: onRefreshTap,
          ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}