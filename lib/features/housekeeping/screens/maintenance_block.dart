import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:inta_mobile_pms/core/config/responsive_config.dart';
import 'package:inta_mobile_pms/core/theme/app_colors.dart';
import 'package:inta_mobile_pms/core/theme/app_text_theme.dart';
import 'package:inta_mobile_pms/features/housekeeping/models/maintenance_block_item.dart';
import 'package:inta_mobile_pms/features/housekeeping/widgets/empty_state.dart';
import 'package:inta_mobile_pms/features/housekeeping/widgets/maintenance_block_card.dart';
import 'package:inta_mobile_pms/features/housekeeping/widgets/stat_card.dart';
import 'package:inta_mobile_pms/router/app_routes.dart';


class MaintenanceBlock extends StatefulWidget {
  const MaintenanceBlock({super.key});

  @override
  State<MaintenanceBlock> createState() => _MaintenanceBlockState();
}

class _MaintenanceBlockState extends State<MaintenanceBlock>
    with TickerProviderStateMixin {
  late TabController _tabController;
  String _selectedFilter = 'All';
  String _searchQuery = '';
  bool _isSearchVisible = false;
  final TextEditingController _searchController = TextEditingController();

  // Sample data - replace with actual data source
  final List<MaintenanceBlockItem> _allMaintenanceBlocks = [
    MaintenanceBlockItem(
      id: 'MB001',
      title: 'HVAC System Maintenance',
      description: 'Regular maintenance and inspection of HVAC system in Building A',
      status: 'In Progress',
      priority: 'High',
      createdDate: DateTime.now().subtract(const Duration(days: 2)),
      scheduledDate: DateTime.now().add(const Duration(days: 1)),
      assignedTo: 'John Smith',
      category: 'HVAC',
      estimatedCost: 1200.0,
      tags: ['Preventive', 'Scheduled'],
    ),
    MaintenanceBlockItem(
      id: 'MB002',
      title: 'Elevator Inspection',
      description: 'Monthly safety inspection and maintenance of elevator systems',
      status: 'Pending',
      priority: 'Medium',
      createdDate: DateTime.now().subtract(const Duration(days: 5)),
      scheduledDate: DateTime.now().add(const Duration(days: 3)),
      assignedTo: 'Mike Johnson',
      category: 'Elevator',
      estimatedCost: 800.0,
      tags: ['Safety', 'Inspection'],
    ),
    MaintenanceBlockItem(
      id: 'MB003',
      title: 'Plumbing Repair - Unit 205',
      description: 'Fix leaking pipes and replace faulty fixtures in apartment 205',
      status: 'Completed',
      priority: 'High',
      createdDate: DateTime.now().subtract(const Duration(days: 10)),
      assignedTo: 'Sarah Wilson',
      category: 'Plumbing',
      estimatedCost: 450.0,
      tags: ['Emergency', 'Tenant Request'],
    ),
    MaintenanceBlockItem(
      id: 'MB004',
      title: 'Landscaping Service',
      description: 'Monthly landscaping and garden maintenance for common areas',
      status: 'Scheduled',
      priority: 'Low',
      createdDate: DateTime.now().subtract(const Duration(days: 1)),
      scheduledDate: DateTime.now().add(const Duration(days: 7)),
      assignedTo: 'Green Care Services',
      category: 'Landscaping',
      estimatedCost: 600.0,
      tags: ['Recurring', 'Aesthetic'],
    ),
    MaintenanceBlockItem(
      id: 'MB005',
      title: 'Fire Safety System Check',
      description: 'Annual fire safety system inspection and testing',
      status: 'In Progress',
      priority: 'High',
      createdDate: DateTime.now().subtract(const Duration(days: 3)),
      scheduledDate: DateTime.now(),
      assignedTo: 'Safety First Inc.',
      category: 'Safety',
      estimatedCost: 2000.0,
      tags: ['Annual', 'Compliance'],
    ),
  ];

  List<MaintenanceBlockItem> get filteredMaintenanceBlocks {
    List<MaintenanceBlockItem> filtered = _allMaintenanceBlocks;

    // Apply status filter
    if (_selectedFilter != 'All') {
      filtered = filtered
          .where((block) => block.status == _selectedFilter)
          .toList();
    }

    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      filtered = filtered
          .where((block) =>
              block.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              block.description
                  .toLowerCase()
                  .contains(_searchQuery.toLowerCase()) ||
              block.assignedTo
                  .toLowerCase()
                  .contains(_searchQuery.toLowerCase()))
          .toList();
    }

    return filtered;
  }

  Map<String, int> get statusCounts {
    final counts = <String, int>{
      'All': _allMaintenanceBlocks.length,
      'Pending': 0,
      'In Progress': 0,
      'Completed': 0,
      'Scheduled': 0,
    };

    for (final block in _allMaintenanceBlocks) {
      counts[block.status] = (counts[block.status] ?? 0) + 1;
    }

    return counts;
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        setState(() {
          _selectedFilter = statusCounts.keys.elementAt(_tabController.index);
        });
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Color _getPriorityColor(String priority) {
    switch (priority) {
      case 'High':
        return AppColors.red;
      case 'Medium':
        return AppColors.yellow;
      case 'Low':
        return AppColors.green;
      default:
        return AppColors.lightgrey;
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Completed':
        return AppColors.green;
      case 'In Progress':
        return AppColors.yellow;
      case 'Pending':
        return AppColors.red;
      case 'Scheduled':
        return AppColors.secondary;
      default:
        return AppColors.lightgrey;
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'HVAC':
        return Icons.air;
      case 'Plumbing':
        return Icons.plumbing;
      case 'Elevator':
        return Icons.elevator;
      case 'Safety':
        return Icons.security;
      case 'Landscaping':
        return Icons.grass;
      default:
        return Icons.build;
    }
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(ResponsiveConfig.cardRadius(context)),
        ),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(ResponsiveConfig.defaultPadding(context)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.lightgrey,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Filter by Status',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            ...statusCounts.entries.map(
              (entry) => ListTile(
                title: Text(entry.key),
                trailing: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getStatusColor(entry.key).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${entry.value}',
                    style: TextStyle(
                      color: _getStatusColor(entry.key),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                onTap: () {
                  setState(() {
                    _selectedFilter = entry.key;
                    _tabController.animateTo(
                      statusCounts.keys.toList().indexOf(entry.key),
                    );
                  });
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: _isSearchVisible
            ? TextField(
                controller: _searchController,
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: 'Search maintenance blocks...',
                  border: InputBorder.none,
                ),
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
              )
            : Text(
                'Maintenance Block',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: AppColors.black,
                      fontWeight: FontWeight.w600,
                    ),
              ),
        backgroundColor: AppColors.surface,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            _isSearchVisible ? Icons.arrow_back : Icons.arrow_back,
            color: AppColors.black,
          ),
          onPressed: () {
            if (_isSearchVisible) {
              setState(() {
                _isSearchVisible = false;
                _searchQuery = '';
                _searchController.clear();
              });
            } else {
              context.go(AppRoutes.dashboard);
            }
          },
        ),
        actions: [
          if (!_isSearchVisible)
            IconButton(
              icon: const Icon(Icons.search, color: AppColors.black),
              onPressed: () {
                setState(() {
                  _isSearchVisible = true;
                });
              },
            ),
          if (_isSearchVisible)
            IconButton(
              icon: const Icon(Icons.clear, color: AppColors.black),
              onPressed: () {
                setState(() {
                  _searchQuery = '';
                  _searchController.clear();
                });
              },
            ),
          IconButton(
            icon: const Icon(Icons.filter_list, color: AppColors.black),
            onPressed: _showFilterBottomSheet,
          ),
          IconButton(
            icon: const Icon(Icons.add, color: AppColors.black),
            onPressed: () {
              // Navigate to add new maintenance block
            },
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48.0),
          child: Container(
            color: AppColors.surface,
            child: TabBar(
              controller: _tabController,
              isScrollable: true,
              labelColor: AppColors.primary,
              unselectedLabelColor: AppColors.lightgrey,
              indicator: const UnderlineTabIndicator(
                borderSide: BorderSide(color: AppColors.primary, width: 2),
              ),
              tabs: statusCounts.entries
                  .map((entry) => Tab(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(entry.key),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: _getStatusColor(entry.key).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                '${entry.value}',
                                style: TextStyle(
                                  color: _getStatusColor(entry.key),
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ))
                  .toList(),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          // Statistics Header
          Container(
            width: double.infinity,
            padding: ResponsiveConfig.horizontalPadding(context).add(
              ResponsiveConfig.verticalPadding(context),
            ),
            decoration: const BoxDecoration(
              color: AppColors.surface,
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: StatCard(
                    title: 'Total Active',
                    value: '${filteredMaintenanceBlocks.length}',
                    color: AppColors.primary,
                    icon: Icons.assignment,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: StatCard(
                    title: 'High Priority',
                    value: '${filteredMaintenanceBlocks.where((b) => b.priority == 'High').length}',
                    color: AppColors.red,
                    icon: Icons.priority_high,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: StatCard(
                    title: 'Completed',
                    value: '${statusCounts['Completed']}',
                    color: AppColors.green,
                    icon: Icons.check_circle,
                  ),
                ),
              ],
            ),
          ),
          // Maintenance Block List
          Expanded(
            child: filteredMaintenanceBlocks.isEmpty
                ? EmptyState(
                    title: 'No Maintenance Blocks',
        subMessage: 'No in-house guests at the moment',
      )
                : RefreshIndicator(
                    onRefresh: () async {
                      // Implement refresh logic
                      await Future.delayed(const Duration(seconds: 1));
                    },
                    child: ListView.builder(
                      padding: ResponsiveConfig.horizontalPadding(context)
                          .add(const EdgeInsets.symmetric(vertical: 8)),
                      itemCount: filteredMaintenanceBlocks.length,
                      itemBuilder: (context, index) {
                        final block = filteredMaintenanceBlocks[index];
                        return MaintenanceBlockCard(
                          block: block,
                          onTap: () {
                            // Navigate to detailed view
                          },
                        );
                      },
                    ),
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Navigate to create new maintenance block
        },
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add, color: AppColors.onPrimary),
        label: const Text(
          'New Block',
          style: TextStyle(color: AppColors.onPrimary),
        ),
      ),
    );
  }
}


