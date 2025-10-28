import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:go_router/go_router.dart';
import 'package:inta_mobile_pms/core/config/responsive_config.dart';
import 'package:inta_mobile_pms/core/theme/app_colors.dart';
import 'package:inta_mobile_pms/features/housekeeping/viewmodels/maintenance_block_vm.dart';
import 'package:inta_mobile_pms/features/housekeeping/widgets/empty_state_wgt.dart';
import 'package:inta_mobile_pms/features/housekeeping/widgets/maintenance_block_card_wgt.dart';
import 'package:inta_mobile_pms/features/reservations/widgets/action_bottom_sheet_wgt.dart';
import 'package:inta_mobile_pms/router/app_routes.dart';

class MaintenanceBlock extends StatefulWidget {
  const MaintenanceBlock({super.key});

  @override
  State<MaintenanceBlock> createState() => _MaintenanceBlockState();
}

class _MaintenanceBlockState extends State<MaintenanceBlock>
    with TickerProviderStateMixin {
  final _maintenanceBlockVm = Get.find<MaintenanceBlockVm>();

  late TabController _tabController;
  String _selectedFilter = 'All';
  String _searchQuery = '';
  bool _isSearchVisible = false;
  final TextEditingController _searchController = TextEditingController();

 
  @override
  void initState() {
    super.initState();
    // _tabController = TabController(length: 5, vsync: this);
    // _tabController.addListener(() {
    //   if (!_tabController.indexIsChanging) {
    //     setState(() {
    //       _selectedFilter = statusCounts.keys.elementAt(_tabController.index);
    //     });
    //   }
    // });
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (mounted) {
        await _maintenanceBlockVm.loadAllMaintenanceBlocks();
      }
    });
  }

  @override
  void dispose() {
    // _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

 // Replace the existing _showActionsBottomSheet method in MaintenanceBlock class

void _showActionsBottomSheet(dynamic block) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true, // Important for DraggableScrollableSheet
    backgroundColor: Colors.transparent, // Let ActionBottomSheet handle the background
    builder: (context) => ActionBottomSheet(
      guestName: block.roomNumber ?? 'Room ${block.id}', // Adjust based on your block model
      actions: [
        ActionItem(
          icon: Icons.edit,
          label: 'Edit Blocked Room',
          onTap: () {
            Navigator.pop(context);
            // Navigate to edit screen
            // context.push(AppRoutes.editBlockRoom, extra: block);
          },
        ),
        // ActionItem(
        //   icon: Icons.lock_open,
        //   label: 'Unblock Room',
        //   onTap: () {
        //     Navigator.pop(context);
        //     // Call unblock functionality
        //     _maintenanceBlockVm.unblockRoom(block.id).then((_) {
        //       _maintenanceBlockVm.loadAllMaintenanceBlocks();
        //     }).catchError((error) {
        //       // Show error snackbar
        //       Get.snackbar(
        //         'Error',
        //         'Failed to unblock room: $error',
        //         snackPosition: SnackPosition.BOTTOM,
        //         backgroundColor: AppColors.red,
        //         colorText: AppColors.onPrimary,
        //       );
        //     });
        //   },
        // ),
        ActionItem(
          icon: Icons.info_outline,
          label: 'View Details',
          onTap: () {
            Navigator.pop(context);
            // Navigate to details screen
            // context.push(AppRoutes.blockRoomDetails, extra: block);
          },
        ),
      ],
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
                    // _searchQuery = value;
                    _maintenanceBlockVm.filteredMaintenanceBlocks(value);
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
                  _isSearchVisible = false;
                });
              },
            ),
          IconButton(
            icon: const Icon(Icons.filter_list, color: AppColors.black),
            // onPressed: _showFilterBottomSheet,
            onPressed: () => {},
          ),
          IconButton(
            icon: const Icon(Icons.add, color: AppColors.black),
            onPressed: () {
             context.push(AppRoutes.blockRoomSelection);
            },
          ),
        ],
        // bottom: PreferredSize(
        //   preferredSize: const Size.fromHeight(48.0),
        //   child: Container(
        //     color: AppColors.surface,
        //     child: TabBar(
        //       controller: _tabController,
        //       isScrollable: true,
        //       labelColor: AppColors.primary,
        //       unselectedLabelColor: AppColors.lightgrey,
        //       indicator: const UnderlineTabIndicator(
        //         borderSide: BorderSide(color: AppColors.primary, width: 2),
        //       ),
        //       tabs: statusCounts.entries
        //           .map(
        //             (entry) => Tab(
        //               child: Row(
        //                 mainAxisSize: MainAxisSize.min,
        //                 children: [
        //                   Text(entry.key),
        //                   const SizedBox(width: 8),
        //                   Container(
        //                     padding: const EdgeInsets.symmetric(
        //                       horizontal: 6,
        //                       vertical: 2,
        //                     ),
        //                     decoration: BoxDecoration(
        //                       color: _getStatusColor(
        //                         entry.key,
        //                       ).withOpacity(0.1),
        //                       borderRadius: BorderRadius.circular(8),
        //                     ),
        //                     child: Text(
        //                       '${entry.value}',
        //                       style: TextStyle(
        //                         color: _getStatusColor(entry.key),
        //                         fontSize: 11,
        //                         fontWeight: FontWeight.w500,
        //                       ),
        //                     ),
        //                   ),
        //                 ],
        //               ),
        //             ),
        //           )
        //           .toList(),
        //     ),
        //   ),
        // ),
      ),
      body: Column(
        children: [
          // Statistics Header
          // Container(
          //   width: double.infinity,
          //   padding: ResponsiveConfig.horizontalPadding(
          //     context,
          //   ).add(ResponsiveConfig.verticalPadding(context)),
          //   decoration: const BoxDecoration(
          //     color: AppColors.surface,
          //     boxShadow: [
          //       BoxShadow(
          //         color: Colors.black12,
          //         blurRadius: 4,
          //         offset: Offset(0, 2),
          //       ),
          //     ],
          //   ),
          //   child: Row(
          //     children: [
          //       Expanded(
          //         child: StatCard(
          //           title: 'Total Active',
          //           value: '${filteredMaintenanceBlocks.length}',
          //           color: AppColors.primary,
          //           icon: Icons.assignment,
          //         ),
          //       ),
          //       const SizedBox(width: 16),
          //       Expanded(
          //         child: StatCard(
          //           title: 'High Priority',
          //           value:
          //               '${filteredMaintenanceBlocks.where((b) => b.priority == 'High').length}',
          //           color: AppColors.red,
          //           icon: Icons.priority_high,
          //         ),
          //       ),
          //       const SizedBox(width: 16),
          //       Expanded(
          //         child: StatCard(
          //           title: 'Completed',
          //           value: '${statusCounts['Completed']}',
          //           color: AppColors.green,
          //           icon: Icons.check_circle,
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
          // Maintenance Block List
          Expanded(
            child: Obx(() {
              if (_maintenanceBlockVm.isLoading.value) {
                return ListView.builder(
                  padding: ResponsiveConfig.horizontalPadding(
                    context,
                  ).add(const EdgeInsets.symmetric(vertical: 8)),
                  itemCount: 8, 
                  itemBuilder: (context, index) =>
                      const MaintenanceBlockCardShimmer(),
                );
              }

              if (_maintenanceBlockVm.maintenanceBlockListFiltered.isEmpty) {
                return const EmptyStateWgt(
                  title: 'No Maintenance Blocks',
                  subMessage: 'No in-house guests at the moment',
                );
              }

              return RefreshIndicator(
                onRefresh: () async {
                  await _maintenanceBlockVm.loadAllMaintenanceBlocks();
                },
                child: ListView.builder(
                  padding: ResponsiveConfig.horizontalPadding(
                    context,
                  ).add(const EdgeInsets.symmetric(vertical: 8)),
                  itemCount:
                      _maintenanceBlockVm.maintenanceBlockListFiltered.length,
                  itemBuilder: (context, index) {
                    final block =
                        _maintenanceBlockVm.maintenanceBlockListFiltered[index];
                    return MaintenanceBlockCardWgt(
                      block: block,
                      onTap: () {
                        _showActionsBottomSheet(block);
                      },
                    );
                  },
                ),
              );
            }),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
         context.go(AppRoutes.blockRoomSelection);
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