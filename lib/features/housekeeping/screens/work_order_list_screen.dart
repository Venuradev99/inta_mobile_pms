import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:go_router/go_router.dart';
import 'package:inta_mobile_pms/core/theme/app_colors.dart';
import 'package:inta_mobile_pms/features/housekeeping/models/dropdown_data.dart';
import 'package:inta_mobile_pms/features/housekeeping/models/work_order.dart';
import 'package:inta_mobile_pms/features/housekeeping/viewmodels/work_order_list_vm.dart';
import 'package:inta_mobile_pms/features/housekeeping/widgets/add_work_order_dialog.dart';
import 'package:inta_mobile_pms/router/app_routes.dart';
import 'package:shimmer/shimmer.dart';

class WorkOrderList extends StatefulWidget {
  const WorkOrderList({super.key});

  @override
  State<WorkOrderList> createState() => _WorkOrderListState();
}

class _WorkOrderListState extends State<WorkOrderList> {
  final _workOrderListVm = Get.find<WorkOrderListVm>();

  String _selectedFilter = 'All';
  String _searchQuery = '';
  bool _isSearchVisible = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (mounted) {
        await _workOrderListVm.loadWorkOrders();
        await _workOrderListVm.loadDataForAddWorkOrder();
      }
    });
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
        backgroundColor: AppColors.surface,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            _isSearchVisible ? Icons.arrow_back : Icons.arrow_back,
            color: AppColors.black,
          ),
          onPressed: () {
            if (_isSearchVisible) {
              _searchController.clear();
              _workOrderListVm.searchWorkOrders(''); // reset filter
              setState(() {
                _isSearchVisible = false;
              });
            } else {
              context.go(AppRoutes.dashboard);
            }
          },
        ),
        title: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: _isSearchVisible
              ? TextField(
                  key: const ValueKey('searchField'),
                  controller: _searchController,
                  autofocus: true,
                  decoration: const InputDecoration(
                    hintText: 'Search ...',
                    border: InputBorder.none,
                  ),
                  onChanged: (value) {
                    _workOrderListVm.searchWorkOrders(value);
                  },
                )
              : Text(
                  'Work Orders',
                  key: const ValueKey('titleText'),
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppColors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
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
                _searchController.clear();
                _workOrderListVm.searchWorkOrders(''); // reset filter
                setState(() {
                  _isSearchVisible = false;
                });
              },
            ),
          IconButton(
            icon: const Icon(Icons.filter_list, color: AppColors.black),
            onPressed: _showFilterBottomSheet,
          ),
        ],
      ),

      body: Obx(() {
        final workOrders = _workOrderListVm.workOrdersFiltered.toList();
        final isLoading = _workOrderListVm.isLoading;
        return Column(
          children: [
            // Header with count
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total Work Orders: ${workOrders.length}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: AppColors.primary,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.secondary,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'Active',
                      style: TextStyle(
                        color: AppColors.surface,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Work Order List
            Expanded(
              child: isLoading.value
                  ? ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: 10,
                      itemBuilder: (context, index) =>
                          _buildWorkOrderCardShimmer(),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: workOrders.length,
                      itemBuilder: (context, index) {
                        final workOrder = workOrders[index];
                        return _buildWorkOrderCard(workOrder);
                      },
                    ),
            ),
          ],
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddWorkOrderDialog(context),
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: AppColors.surface),
      ),
    );
  }

  Widget _buildWorkOrderCard(WorkOrder workOrder) {
    Color statusColor = _getStatusColor(workOrder.status);
    Color priorityColor = _getPriorityColor(workOrder.priority);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  workOrder.orderNo,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: statusColor, width: 1),
                  ),
                  child: Text(
                    workOrder.status,
                    style: TextStyle(
                      color: statusColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    workOrder.category,
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: priorityColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    workOrder.priority,
                    style: TextStyle(
                      color: priorityColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Details Grid
            Row(
              children: [
                Expanded(
                  child: _buildDetailItem('Unit/Room', workOrder.unitRoom),
                ),
                Expanded(
                  child: _buildDetailItem(
                    'Block',
                    '${workOrder.blockFrom.day}/${workOrder.blockFrom.month}/${workOrder.blockFrom.year} → ${workOrder.blockTo.day}/${workOrder.blockTo.month}/${workOrder.blockTo.year}',
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            Row(
              children: [
                Expanded(
                  child: _buildDetailItem('Assigned to', workOrder.assignedTo),
                ),
                Expanded(
                  child: _buildDetailItem(
                    'Due Date',
                    '${workOrder.dueDate.day}/${workOrder.dueDate.month}/${workOrder.dueDate.year}',
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Description
            Text(
              'Description:',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.lightgrey,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              workOrder.description,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: AppColors.darkgrey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWorkOrderCardShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Row shimmer
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _shimmerBox(width: 100, height: 18),
                  _shimmerBox(width: 60, height: 18, radius: 12),
                ],
              ),
              const SizedBox(height: 12),

              // Category + Priority Row shimmer
              Row(
                children: [
                  _shimmerBox(width: 70, height: 16, radius: 8),
                  const SizedBox(width: 8),
                  _shimmerBox(width: 50, height: 16, radius: 8),
                ],
              ),
              const SizedBox(height: 16),

              // Details grid shimmer
              Row(
                children: [
                  Expanded(child: _buildDetailShimmer()),
                  const SizedBox(width: 12),
                  Expanded(child: _buildDetailShimmer()),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(child: _buildDetailShimmer()),
                  const SizedBox(width: 12),
                  Expanded(child: _buildDetailShimmer()),
                ],
              ),

              const SizedBox(height: 16),

              // Description shimmer
              _shimmerBox(width: 80, height: 14),
              const SizedBox(height: 8),
              _shimmerBox(width: double.infinity, height: 14),
              const SizedBox(height: 4),
              _shimmerBox(width: 250, height: 14),
            ],
          ),
        ),
      ),
    );
  }

  Widget _shimmerBox({
    double width = double.infinity,
    double height = 16,
    double radius = 6,
  }) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }

  Widget _buildDetailShimmer() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _shimmerBox(width: 80, height: 12),
        const SizedBox(height: 6),
        _shimmerBox(width: double.infinity, height: 14),
      ],
    );
  }

  Widget _buildDetailItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: AppColors.lightgrey,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: AppColors.darkgrey,
          ),
        ),
      ],
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'assigned':
        return AppColors.green;
      case 'in progress':
        return AppColors.yellow;
      case 'completed':
        return AppColors.purple;
      case 'new':
        return AppColors.blue;
      default:
        return AppColors.lightgrey;
    }
  }

  Color _getPriorityColor(String priority) {
    switch (priority.toLowerCase()) {
      case 'high':
        return AppColors.red;
      case 'medium':
        return AppColors.yellow;
        ;
      case 'low':
        return AppColors.green;
      default:
        return AppColors.lightgrey;
    }
  }

  void _showAddWorkOrderDialog(BuildContext context) {
    try {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return const AddWorkOrderDialog();
        },
      ).then((newWorkOrder) async {
        if (newWorkOrder != null) {
          await _workOrderListVm.saveWorkOrder(newWorkOrder);
          if (!mounted) return;
        }
      });
    } catch (e) {
      throw Exception('_showAddWorkOrderDialog error: $e');
    }
  }
}

class FilterBottomSheet extends StatefulWidget {
  const FilterBottomSheet({super.key});

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  final _workOrderListVm = Get.find<WorkOrderListVm>();

  DateTime? _startDate;
  DateTime? _endDate;
  String? _orderNo;
  DropdownData? _selectedRoom;
  DropdownData? _selectedCategory;
  DropdownData? _selectedPriority;
  DropdownData? _selectedStatus;
  DropdownData? _selectedAssignTo;
  bool? _isCompleted = false;

  @override
  void initState() {
    super.initState();
    _startDate = _workOrderListVm.filterStartDate.value;
    _endDate = _workOrderListVm.filterEndDate.value;
    _orderNo = _workOrderListVm.filterOrderNo.value;
    _selectedCategory = _workOrderListVm.categoryList.firstWhereOrNull(
      (category) => category.id == _workOrderListVm.filterCategoryId.value,
    );
    _selectedRoom = _workOrderListVm.unitRoomList.firstWhereOrNull(
      (room) => room.id == _workOrderListVm.filterRoomId.value,
    );
    _selectedPriority = _workOrderListVm.priorityList.firstWhereOrNull(
      (priority) => priority.id == _workOrderListVm.filterPriorityId.value,
    );
    _selectedStatus = _workOrderListVm.statusList.firstWhereOrNull(
      (status) => status.id == _workOrderListVm.filterStatusId.value,
    );
    _selectedAssignTo = _workOrderListVm.houseKeeperList.firstWhereOrNull(
      (houseKeeper) =>
          houseKeeper.id == _workOrderListVm.filterAssignToId.value,
    );
    _isCompleted = _workOrderListVm.filterIsCompleted.value;
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
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
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
                      () => DropdownButtonFormField<DropdownData>(
                        decoration: const InputDecoration(
                          labelText: 'Category',
                          border: OutlineInputBorder(),
                        ),
                        value: _selectedCategory,
                        hint: const Text('Select Category'),
                        items: _workOrderListVm.unitRoomList.map((item) {
                          return DropdownMenuItem<DropdownData>(
                            value: item,
                            child: Text(item.description),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedCategory = value;
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Room Dropdown
                    Obx(
                      () => DropdownButtonFormField<DropdownData>(
                        decoration: const InputDecoration(
                          labelText: 'Room',
                          border: OutlineInputBorder(),
                        ),
                        value: _selectedRoom,
                        hint: const Text('Select Room'),
                        items: _workOrderListVm.unitRoomList.map((item) {
                          return DropdownMenuItem<DropdownData>(
                            value: item,
                            child: Text(item.description),
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
                    // Room Dropdown
                    Obx(
                      () => DropdownButtonFormField<DropdownData>(
                        decoration: const InputDecoration(
                          labelText: 'Status',
                          border: OutlineInputBorder(),
                        ),
                        value: _selectedStatus,
                        hint: const Text('Select Room'),
                        items: _workOrderListVm.statusList.map((item) {
                          return DropdownMenuItem<DropdownData>(
                            value: item,
                            child: Text(item.description),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedStatus = value;
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Room Dropdown
                    Obx(
                      () => DropdownButtonFormField<DropdownData>(
                        decoration: const InputDecoration(
                          labelText: 'Priority',
                          border: OutlineInputBorder(),
                        ),
                        value: _selectedPriority,
                        hint: const Text('Select Room'),
                        items: _workOrderListVm.priorityList.map((item) {
                          return DropdownMenuItem<DropdownData>(
                            value: item,
                            child: Text(item.description),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedPriority = value;
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Room Dropdown
                    Obx(
                      () => DropdownButtonFormField<DropdownData>(
                        decoration: const InputDecoration(
                          labelText: 'Assign To',
                          border: OutlineInputBorder(),
                        ),
                        value: _selectedAssignTo,
                        hint: const Text('Select Room'),
                        items: _workOrderListVm.houseKeeperList.map((item) {
                          return DropdownMenuItem<DropdownData>(
                            value: item,
                            child: Text(item.description),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedAssignTo = value;
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Unblock Room Switch
                    SwitchListTile(
                      title: const Text('Is Completed Work Order'),
                      value: _isCompleted ?? false,
                      onChanged: (bool? value) {
                        setState(() {
                          _isCompleted = value;
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
                                _selectedRoom = null;
                                _isCompleted = false;
                                _orderNo = '';
                                _selectedAssignTo = null;
                                _selectedCategory = null;
                                _selectedPriority = null;
                                _selectedStatus = null;
                              });
                              _workOrderListVm.filterByFilterBottomSheet(
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
                              _workOrderListVm.filterStartDate.value =
                                  _startDate;
                              _workOrderListVm.filterEndDate.value = _endDate;
                              _workOrderListVm.filterOrderNo.value = _orderNo;
                              _workOrderListVm.filterRoomId.value =
                                  _selectedRoom?.id;
                              _workOrderListVm.filterAssignToId.value =
                                  _selectedAssignTo?.id;
                              _workOrderListVm.filterStatusId.value =
                                  _selectedStatus?.id;
                              _workOrderListVm.filterPriorityId.value =
                                  _selectedPriority?.id;
                              _workOrderListVm.filterCategoryId.value =
                                  _selectedCategory?.id;
                              _workOrderListVm.filterIsCompleted.value =
                                  _isCompleted;
                              _workOrderListVm.filterByFilterBottomSheet(
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
