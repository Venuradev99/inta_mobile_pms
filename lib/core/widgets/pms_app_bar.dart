import 'package:flutter/material.dart';
import 'package:inta_mobile_pms/core/theme/app_colors.dart';
import 'package:inta_mobile_pms/core/theme/app_text_theme.dart';

class PmsAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget> actions;
  final Widget? leading;
  final bool showSearch;
  final Function(String)? onSearchChanged;
  final String? searchHint;
  final TextEditingController? searchController;

  const PmsAppBar({
    Key? key,
    required this.title,
    this.actions = const [],
    this.leading,
    this.showSearch = false,
    this.onSearchChanged,
    this.searchHint = 'Search...',
    this.searchController,
  }) : super(key: key);

  @override
  State<PmsAppBar> createState() => _PmsAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _PmsAppBarState extends State<PmsAppBar> {
  bool _isSearching = false;
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = widget.searchController ?? TextEditingController();
  }

  @override
  void dispose() {
    if (widget.searchController == null) {
      _searchController.dispose();
    }
    super.dispose();
  }

  void _startSearch() {
    setState(() {
      _isSearching = true;
    });
  }

  void _stopSearch() {
    setState(() {
      _isSearching = false;
      _searchController.clear();
    });
    if (widget.onSearchChanged != null) {
      widget.onSearchChanged!('');
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).brightness == Brightness.dark
        ? AppTextTheme.darkTextTheme
        : AppTextTheme.lightTextTheme;

    return AppBar(
      backgroundColor: AppColors.surface,
      elevation: 4,
      centerTitle: !_isSearching,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(16),
        ),
      ),
      title: _isSearching ? _buildSearchField(textTheme) : _buildTitle(textTheme),
      actions: _buildActions(),
      iconTheme: const IconThemeData(color: AppColors.black),
      leading: _isSearching ? _buildBackButton() : widget.leading,
    );
  }

  Widget _buildTitle(TextTheme textTheme) {
    return Text(
      widget.title,
      style: textTheme.titleLarge?.copyWith(color: AppColors.onPrimary),
    );
  }

  Widget _buildSearchField(TextTheme textTheme) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: AppColors.onPrimary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.onPrimary.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: TextField(
        controller: _searchController,
        autofocus: true,
        decoration: InputDecoration(
          hintText: widget.searchHint,
          hintStyle: textTheme.bodyMedium?.copyWith(
            color: AppColors.onPrimary.withOpacity(0.7),
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: Icon(
                    Icons.clear,
                    color: AppColors.onPrimary.withOpacity(0.7),
                    size: 20,
                  ),
                  onPressed: () {
                    _searchController.clear();
                    if (widget.onSearchChanged != null) {
                      widget.onSearchChanged!('');
                    }
                  },
                )
              : null,
        ),
        style: textTheme.bodyMedium?.copyWith(color: AppColors.onPrimary),
        onChanged: widget.onSearchChanged,
      ),
    );
  }

  Widget _buildBackButton() {
    return IconButton(
      icon: const Icon(Icons.arrow_back, color: AppColors.black),
      onPressed: _stopSearch,
    );
  }

  List<Widget> _buildActions() {
    if (_isSearching) {
      return [];
    }

    List<Widget> actions = [];

    // Add search button if search is enabled
    if (widget.showSearch) {
      actions.add(
        IconButton(
          icon: const Icon(Icons.search, color: AppColors.black),
          onPressed: _startSearch,
        ),
      );
    }

    // Add other actions
    actions.addAll(widget.actions);

    return actions;
  }
}

// Alternative: Always visible search bar version
class PmsAppBarWithSearch extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget> actions;
  final Widget? leading;
  final Function(String)? onSearchChanged;
  final String? searchHint;
  final TextEditingController? searchController;

  const PmsAppBarWithSearch({
    Key? key,
    required this.title,
    this.actions = const [],
    this.leading,
    this.onSearchChanged,
    this.searchHint = 'Search...',
    this.searchController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).brightness == Brightness.dark
        ? AppTextTheme.darkTextTheme
        : AppTextTheme.lightTextTheme;

    return AppBar(
      backgroundColor: AppColors.surface,
      elevation: 4,
      centerTitle: false,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(16),
        ),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title.isNotEmpty)
            Text(
              title,
              style: textTheme.titleMedium?.copyWith(color: AppColors.onPrimary),
            ),
          const SizedBox(height: 8),
          Container(
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.onPrimary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: AppColors.onPrimary.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: searchHint,
                hintStyle: textTheme.bodySmall?.copyWith(
                  color: AppColors.onPrimary.withOpacity(0.7),
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                prefixIcon: Icon(
                  Icons.search,
                  color: AppColors.onPrimary.withOpacity(0.7),
                  size: 20,
                ),
              ),
              style: textTheme.bodySmall?.copyWith(color: AppColors.onPrimary),
              onChanged: onSearchChanged,
            ),
          ),
        ],
      ),
      actions: actions,
      iconTheme: const IconThemeData(color: AppColors.black),
      leading: leading,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 20);
}