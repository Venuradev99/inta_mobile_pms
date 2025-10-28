import 'package:flutter/material.dart';
import 'package:inta_mobile_pms/core/theme/app_colors.dart';
import 'package:inta_mobile_pms/features/housekeeping/widgets/empty_state_wgt.dart';


class TabbedListView<T> extends StatefulWidget {
  final List<String> tabLabels;
  final Map<String, List<T>> dataMap;
  final Widget Function(T item) itemBuilder;
  final Widget Function(String period)? emptyBuilder;
  final Future<void> Function()? onRefresh;
  final String Function(String period)? emptySubMessage; // Backward compat (deprecated)

  const TabbedListView({
    super.key,
    required this.tabLabels,
    required this.dataMap,
    required this.itemBuilder,
    this.emptyBuilder,
    this.onRefresh,
    this.emptySubMessage,
  });

  @override
  State<TabbedListView<T>> createState() => _TabbedListViewState<T>();
}

class _TabbedListViewState<T> extends State<TabbedListView<T>> with TickerProviderStateMixin {
  late TabController _tabController;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: widget.tabLabels.length, vsync: this);
    _tabController.addListener(() {
      if (!mounted) return;
      setState(() {
        _selectedIndex = _tabController.index;
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  String _getPeriodKey(String tabLabel) => tabLabel.toLowerCase().replaceAll(' ', '');

  @override
  Widget build(BuildContext context) {
    final periodKey = _getPeriodKey(widget.tabLabels[_selectedIndex]);
    final items = widget.dataMap[periodKey] ?? [];
    final isScrollable = widget.tabLabels.length > 3; // Auto for 4+ tabs

    Widget listView = ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: items.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) => widget.itemBuilder(items[index]),
    );

    if (widget.onRefresh != null) {
      listView = RefreshIndicator(
        onRefresh: widget.onRefresh!,
        child: listView,
      );
    }

    final content = items.isEmpty
        ? (widget.emptyBuilder != null
            ? widget.emptyBuilder!(periodKey)
            : EmptyStateWgt(
                title: 'No data found',
                subMessage: widget.emptySubMessage?.call(periodKey) ?? 'No items for this period',
              ))
        : listView;

    return Column(
      children: [
        Container(
          color: AppColors.surface,
          child: TabBar(
            controller: _tabController,
            indicatorColor: AppColors.primary,
            indicatorWeight: 3,
            labelColor: AppColors.primary,
            unselectedLabelColor: Colors.grey[600],
            labelStyle: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
            unselectedLabelStyle: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w400,
            ),
            isScrollable: isScrollable,
            tabs: widget.tabLabels.map((label) => Tab(text: label)).toList(),
          ),
        ),
        Expanded(child: content),
      ],
    );
  }
}