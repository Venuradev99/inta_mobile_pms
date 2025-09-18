import 'package:flutter/material.dart';
import 'package:inta_mobile_pms/core/theme/app_colors.dart';
import 'package:inta_mobile_pms/core/theme/app_text_theme.dart';


class PmsAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget> actions;

  const PmsAppBar({
    Key? key,
    required this.title,
    this.actions = const [],
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).brightness == Brightness.dark
        ? AppTextTheme.darkTextTheme
        : AppTextTheme.lightTextTheme;

    return AppBar(
      backgroundColor: AppColors.surface,
      elevation: 4,
      centerTitle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(16),
        ),
      ),
      title: Text(
        title,
        style: textTheme.titleLarge?.copyWith(color: AppColors.onPrimary),
      ),
      actions: actions,
      iconTheme: const IconThemeData(color: AppColors.black),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
