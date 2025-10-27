import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:go_router/go_router.dart';
import 'package:inta_mobile_pms/core/config/responsive_config.dart';
import 'package:inta_mobile_pms/core/theme/app_colors.dart';
import 'package:inta_mobile_pms/features/housekeeping/models/room_response.dart';
import 'package:inta_mobile_pms/features/housekeeping/viewmodels/maintenance_block_vm.dart';
import 'package:inta_mobile_pms/router/app_routes.dart';

class BlockRoomSelectionScreen extends StatefulWidget {
  const BlockRoomSelectionScreen({super.key});

  @override
  State<BlockRoomSelectionScreen> createState() =>
      _BlockRoomSelectionScreenState();
}

class _BlockRoomSelectionScreenState extends State<BlockRoomSelectionScreen> {
  final _maintenanceBlockVm = Get.find<MaintenanceBlockVm>();
  final List<RoomResponse> _selectedRooms = [];
  bool _selectAll = false;

  // final List<String> _rooms = [
  //   '501-1',
  //   '501-2',
  //   '501-3',
  //   '501-4',
  //   '501-5',
  //   '501-6',
  //   '501-7',
  //   '501-8',
  //   '501-9',
  //   '501-10',
  //   '501-11',
  //   '501-12',
  //   '501-13',
  //   '501-14',
  //   '501-15',
  //   '501-16',
  //   '501-17',
  //   '501-18',
  //   '501-19',
  //   '501-20',
  // ];

  void _toggleRoom(RoomResponse room) {
    setState(() {
      if (_selectedRooms.contains(room)) {
        _selectedRooms.remove(room);
        _selectAll = false;
      } else {
        _selectedRooms.add(room);
        if (_selectedRooms.length == _maintenanceBlockVm.roomsList.length) {
          _selectAll = true;
        }
      }
    });
  }

  void _toggleSelectAll() {
    setState(() {
      _selectAll = !_selectAll;
      if (_selectAll) {
        _selectedRooms.addAll(_maintenanceBlockVm.roomsList);
      } else {
        _selectedRooms.clear();
      }
    });
  }

  void _proceedToNextStep() {
    if (_selectedRooms.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select at least one room'),
          backgroundColor: AppColors.red,
        ),
      );
      return;
    }

    // Navigate to the next screen with selected rooms
   Get.toNamed(AppRoutes.blockRoomDetails, arguments: _selectedRooms.toList());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Block Room',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: AppColors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: AppColors.surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: AppColors.black),
          onPressed: () => Get.back(),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            width: double.infinity,
            padding: ResponsiveConfig.horizontalPadding(
              context,
            ).add(const EdgeInsets.symmetric(vertical: 16)),
            color: AppColors.surface,
            child: Text(
              'Select Rooms',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w500),
            ),
          ),

          // Room Grid
          Obx(() {
           return Expanded(
              child: SingleChildScrollView(
                padding: ResponsiveConfig.horizontalPadding(
                  context,
                ).add(const EdgeInsets.symmetric(vertical: 16)),
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _maintenanceBlockVm.roomsList.map((room) {
                    final isSelected = _selectedRooms.contains(room);
                    return InkWell(
                      onTap: () => _toggleRoom(room),
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.primary.withOpacity(0.1)
                              : AppColors.surface,
                          border: Border.all(
                            color: isSelected
                                ? AppColors.primary
                                : AppColors.lightgrey,
                            width: isSelected ? 2 : 1,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          room.name,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                color: isSelected
                                    ? AppColors.primary
                                    : AppColors.black,
                                fontWeight: isSelected
                                    ? FontWeight.w600
                                    : FontWeight.normal,
                              ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            );
          }),

          // Bottom Action Bar
          Container(
            padding: ResponsiveConfig.horizontalPadding(
              context,
            ).add(const EdgeInsets.symmetric(vertical: 16)),
            decoration: BoxDecoration(
              color: AppColors.surface,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              child: Row(
                children: [
                  // Select All Checkbox
                  InkWell(
                    onTap: _toggleSelectAll,
                    borderRadius: BorderRadius.circular(4),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            color: _selectAll
                                ? AppColors.primary
                                : Colors.transparent,
                            border: Border.all(
                              color: _selectAll
                                  ? AppColors.primary
                                  : AppColors.lightgrey,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: _selectAll
                              ? const Icon(
                                  Icons.check,
                                  size: 16,
                                  color: AppColors.onPrimary,
                                )
                              : null,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Select All',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  // Next Button
                  ElevatedButton(
                    onPressed: _selectedRooms.isEmpty
                        ? null
                        : _proceedToNextStep,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: AppColors.onPrimary,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      disabledBackgroundColor: AppColors.lightgrey,
                    ),
                    child: Text(
                      _selectedRooms.isEmpty
                          ? 'Next'
                          : 'Next (${_selectedRooms.length})',
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
