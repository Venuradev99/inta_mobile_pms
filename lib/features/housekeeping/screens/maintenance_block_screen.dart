import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:go_router/go_router.dart';
import 'package:inta_mobile_pms/core/config/responsive_config.dart';
import 'package:inta_mobile_pms/core/theme/app_colors.dart';
import 'package:inta_mobile_pms/features/housekeeping/models/room_response.dart';
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
      guestName: block.roomName ?? 'Room ${block.maintenanceBlockId}',
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
        //     _maintenanceBlockVm.unblockRoom(block.maintenanceBlockId).then((_) {
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

void _showFilterBottomSheet() {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => const FilterBottomSheet(),
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
            onPressed: _showFilterBottomSheet,
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

class FilterBottomSheet extends StatefulWidget {
  const FilterBottomSheet({super.key});

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  final _maintenanceBlockVm = Get.find<MaintenanceBlockVm>();

  DateTime? _startDate;
  DateTime? _endDate;
  RoomTypeResponse? _selectedRoomType;
  RoomResponse? _selectedRoom;
  bool _unblockRoom = false;

  @override
  void initState() {
    super.initState();
    // Prefill with current filter values from VM
    _startDate = _maintenanceBlockVm.filterStartDate.value;
    _endDate = _maintenanceBlockVm.filterEndDate.value;
    _selectedRoomType = _maintenanceBlockVm.roomTypesList.firstWhereOrNull(
      (type) => type.roomTypeId == _maintenanceBlockVm.filterRoomTypeId.value,
    );
    _selectedRoom = _maintenanceBlockVm.roomsList.firstWhereOrNull(
      (room) => room.roomId == _maintenanceBlockVm.filterRoomId.value,
    );
    _unblockRoom = _maintenanceBlockVm.filterIsUnblock.value;
  }

  Future<void> _selectDate(BuildContext context, bool isStart) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isStart ? (_startDate ?? DateTime.now()) : (_endDate ?? DateTime.now()),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          _startDate = picked;
          if (_endDate != null && _endDate!.isBefore(_startDate!)) {
            _endDate = _startDate;
          }
        } else {
          _endDate = picked;
          if (_startDate != null && _endDate!.isBefore(_startDate!)) {
            _startDate = _endDate;
          }
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      minChildSize: 0.4,
      maxChildSize: 0.9,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
          child: Column(
            children: [
              // Header with title and close button
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Filter',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(16),
                  children: [
                    // Start and End Date
                    Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () => _selectDate(context, true),
                            child: InputDecorator(
                              decoration: const InputDecoration(
                                labelText: 'Start Date',
                                border: OutlineInputBorder(),
                              ),
                              child: Text(
                                _startDate != null
                                    ? '${_startDate!.day.toString().padLeft(2, '0')}-${(_startDate!.month).toString().padLeft(2, '0')}-${_startDate!.year}'
                                    : 'Select Date',
                                style: TextStyle(
                                  color: _startDate != null ? AppColors.black : AppColors.lightgrey,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: InkWell(
                            onTap: () => _selectDate(context, false),
                            child: InputDecorator(
                              decoration: const InputDecoration(
                                labelText: 'End Date',
                                border: OutlineInputBorder(),
                              ),
                              child: Text(
                                _endDate != null
                                    ? '${_endDate!.day.toString().padLeft(2, '0')}-${(_endDate!.month).toString().padLeft(2, '0')}-${_endDate!.year}'
                                    : 'Select Date',
                                style: TextStyle(
                                  color: _endDate != null ? AppColors.black : AppColors.lightgrey,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Room Type Dropdown
                    Obx(() => DropdownButtonFormField<RoomTypeResponse>(
                          decoration: const InputDecoration(
                            labelText: 'Room Type',
                            border: OutlineInputBorder(),
                          ),
                          value: _selectedRoomType,
                          hint: const Text('Select Room Type'),
                          items: _maintenanceBlockVm.roomTypesList.map((type) {
                            return DropdownMenuItem<RoomTypeResponse>(
                              value: type,
                              child: Text(type.name),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedRoomType = value;
                            });
                          },
                        )),
                    const SizedBox(height: 16),
                    // Room Dropdown
                    Obx(() => DropdownButtonFormField<RoomResponse>(
                          decoration: const InputDecoration(
                            labelText: 'Room',
                            border: OutlineInputBorder(),
                          ),
                          value: _selectedRoom,
                          hint: const Text('Select Room'),
                          items: _maintenanceBlockVm.roomsList.map((room) {
                            return DropdownMenuItem<RoomResponse>(
                              value: room,
                              child: Text(room.name),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedRoom = value;
                            });
                          },
                        )),
                    const SizedBox(height: 16),
                    // Unblock Room Switch
                    SwitchListTile(
                      title: const Text('Unblock Room'),
                      value: _unblockRoom,
                      onChanged: (bool value) {
                        setState(() {
                          _unblockRoom = value;
                        });
                      },
                      activeColor: AppColors.primary,
                    ),
                    const SizedBox(height: 24),
                    // Buttons
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Navigator.pop(context),
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: AppColors.primary),
                              foregroundColor: AppColors.primary,
                            ),
                            child: const Text('Cancel'),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              // Apply filters
                              _maintenanceBlockVm.filterStartDate.value = _startDate;
                              _maintenanceBlockVm.filterEndDate.value = _endDate;
                              _maintenanceBlockVm.filterRoomTypeId.value = _selectedRoomType?.roomTypeId;
                              _maintenanceBlockVm.filterRoomId.value = _selectedRoom?.roomId;
                              _maintenanceBlockVm.filterIsUnblock.value = _unblockRoom;
                              _maintenanceBlockVm.loadAllMaintenanceBlocks();
                              Navigator.pop(context);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                            ),
                            child: const Text('Submit'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}