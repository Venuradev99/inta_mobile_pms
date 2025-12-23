// lib/widgets/common/app_bar_widget.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:inta_mobile_pms/core/theme/app_colors.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onInfoTap;
  final VoidCallback? onFilterTap;
  final VoidCallback? onRefreshTap;
  final ValueChanged<String>? onSearchChanged;

  const CustomAppBar({
    super.key,
    required this.title,
    this.onInfoTap,
    this.onFilterTap,
    this.onRefreshTap,
    this.onSearchChanged,
  });

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _CustomAppBarState extends State<CustomAppBar> {
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _closeSearch() {
    setState(() {
      _isSearching = false;
      _searchController.clear();
    });

    widget.onSearchChanged?.call("");
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.surface,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: AppColors.black),
        onPressed: () => context.pop(),
      ),
      title: _isSearching
          ? SizedBox(
              height: 40,
              child: TextField(
                controller: _searchController,
                autofocus: true,
                onChanged: widget.onSearchChanged,
                style: const TextStyle(color: AppColors.black),
                decoration: InputDecoration(
                  hintText: 'Search...',
                  hintStyle: const TextStyle(color: AppColors.darkgrey),
                  prefixIcon:
                      const Icon(Icons.search, color: AppColors.darkgrey),
                  suffixIcon: IconButton(
                    icon:
                        const Icon(Icons.close, color: AppColors.darkgrey),
                    onPressed: _closeSearch,
                  ),
                  filled: true,
                  fillColor: AppColors.onPrimary,
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 0, horizontal: 8),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            )
          : Text(
              widget.title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppColors.black,
                    fontWeight: FontWeight.w600,
                  ),
            ),
      actions: [
        // 🔍 Search icon ONLY if callback exists
        if (!_isSearching && widget.onSearchChanged != null)
          IconButton(
            icon: const Icon(Icons.search, color: AppColors.black),
            onPressed: () {
              setState(() {
                _isSearching = true;
              });
            },
          ),

        if (widget.onInfoTap != null)
          IconButton(
            icon: const Icon(Icons.info_outline, color: AppColors.black),
            onPressed: widget.onInfoTap,
          ),

        if (widget.onFilterTap != null)
          IconButton(
            icon: const Icon(Icons.filter_list, color: AppColors.black),
            onPressed: widget.onFilterTap,
          ),

        if (widget.onRefreshTap != null)
          IconButton(
            icon: const Icon(Icons.refresh, color: AppColors.black),
            onPressed: widget.onRefreshTap,
          ),
      ],
    );
  }
}
