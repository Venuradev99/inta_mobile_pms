import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:go_router/go_router.dart';
import 'package:inta_mobile_pms/core/config/responsive_config.dart';
import 'package:inta_mobile_pms/core/theme/app_colors.dart';
import 'package:inta_mobile_pms/core/widgets/custom_appbar.dart';
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

  // void _unblockRoom(dynamic block) async {
  //   final confirmed = await ConfirmationDialog.show(
  //     context: context,
  //     title: 'Clear Status',
  //     message: 'Are you sure you want to unblock Room?',
  //     confirmText: 'Yes',
  //     cancelText: 'No',
  //     confirmColor: AppColors.red,
  //   );
  //   if (confirmed == true) {
  //     await _maintenanceBlockVm.unblockRoom(block);
  //     if (!mounted) return;
  //   }
  // }

  Future<Map<String, DateTime?>?> _showDateRangeDialog(
    BuildContext context,
    dynamic block,
  ) {
    DateTime? fromDate = block.fromDate != null
        ? DateTime.parse(block.fromDate)
        : null;
    DateTime? toDate = block.toDate != null
        ? DateTime.parse(block.toDate)
        : null;

    return showDialog<Map<String, DateTime?>?>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              title: const Text(
                "Unblock Room",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // From Date
                  InkWell(
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: fromDate ?? DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );
                      if (picked != null) {
                        setState(() {
                          fromDate = picked;
                          if (toDate != null && toDate!.isBefore(fromDate!)) {
                            toDate = fromDate;
                          }
                        });
                      }
                    },
                    child: InputDecorator(
                      decoration: const InputDecoration(
                        labelText: "From Date",
                        border: OutlineInputBorder(),
                      ),
                      child: Text(
                        fromDate != null
                            ? "${fromDate!.day}-${fromDate!.month}-${fromDate!.year}"
                            : "Select date",
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // To Date
                  InkWell(
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: toDate ?? DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );
                      if (picked != null) {
                        setState(() {
                          toDate = picked;
                          if (fromDate != null && toDate!.isBefore(fromDate!)) {
                            fromDate = toDate;
                          }
                        });
                      }
                    },
                    child: InputDecorator(
                      decoration: const InputDecoration(
                        labelText: "To Date",
                        border: OutlineInputBorder(),
                      ),
                      child: Text(
                        toDate != null
                            ? "${toDate!.day}-${toDate!.month}-${toDate!.year}"
                            : "Select date",
                      ),
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancel"),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.background,
                  ),
                  onPressed: () {
                    Navigator.pop(context, {"from": fromDate, "to": toDate});
                  },
                  child: const Text("OK"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showActionsBottomSheet(dynamic block) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ActionBottomSheet(
        guestName: block.roomName ?? 'Room ${block.maintenanceBlockId}',
        actions: [
          ActionItem(
            icon: Icons.edit,
            label: 'Edit Blocked Room',
            onTap: () {
              Navigator.pop(context);
              // context.push(AppRoutes.editBlockRoom, extra: block);
            },
          ),
          ActionItem(
            icon: Icons.lock_open,
            label: 'Unblock Room',
            onTap: () async {
              Navigator.pop(context);
              _showDateRangeDialog(context, block).then((dateRange) async {
                if (dateRange != null) {
                  final fromDate = dateRange['from'];
                  final toDate = dateRange['to'];
                  if (fromDate != null && toDate != null) {
                    await _maintenanceBlockVm.unblockRoom(
                      block,
                      fromDate,
                      toDate,
                    );
                  }
                }
              });
            },
          ),
          ActionItem(
            icon: Icons.list_alt,
            label: 'Audit Trail',
            onTap: () {
              Navigator.pop(context);
              context.push(AppRoutes.blockRoomAuditTrail, extra: block);
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
      appBar: CustomAppBar(
        title: 'Maintenance Block',
        // onSearchChanged: (value) {
        //   _maintenanceBlockVm.filteredMaintenanceBlocks(value);
        // },
        onFilterTap: _showFilterBottomSheet,
        onRefreshTap: () async {
          await _maintenanceBlockVm.loadAllMaintenanceBlocks();
        },
      ),

      body: Column(
        children: [
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
          context.push(AppRoutes.blockRoomSelection);
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
      initialDate: isStart
          ? (_startDate ?? DateTime.now())
          : (_endDate ?? DateTime.now()),
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
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Search',
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
                                  color: _startDate != null
                                      ? AppColors.black
                                      : AppColors.lightgrey,
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
                                  color: _endDate != null
                                      ? AppColors.black
                                      : AppColors.lightgrey,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Room Type Dropdown
                    Obx(
                      () => DropdownButtonFormField<RoomTypeResponse>(
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
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Room Dropdown
                    Obx(
                      () => DropdownButtonFormField<RoomResponse>(
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
                      ),
                    ),
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
                            onPressed: () {
                              setState(() {
                                _startDate = null;
                                _endDate = null;
                                _selectedRoomType = null;
                                _selectedRoom = null;
                                _unblockRoom = false;
                              });
                              _maintenanceBlockVm.filterByFilterBottomSheet(
                                isReset: true,
                              );
                              Navigator.pop(context);
                            },
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: AppColors.primary),
                              foregroundColor: AppColors.primary,
                            ),
                            child: const Text('Reset'),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              // Apply filters
                              _maintenanceBlockVm.filterStartDate.value =
                                  _startDate;
                              _maintenanceBlockVm.filterEndDate.value =
                                  _endDate;
                              _maintenanceBlockVm.filterRoomTypeId.value =
                                  _selectedRoomType?.roomTypeId;
                              _maintenanceBlockVm.filterRoomId.value =
                                  _selectedRoom?.roomId;
                              _maintenanceBlockVm.filterIsUnblock.value =
                                  _unblockRoom;
                              _maintenanceBlockVm.filterByFilterBottomSheet(
                                isReset: false,
                              );
                              Navigator.pop(context);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: AppColors.onPrimary,
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
