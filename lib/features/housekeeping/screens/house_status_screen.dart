// house_status.dart (Updated Screen)

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:go_router/go_router.dart';
import 'package:inta_mobile_pms/core/theme/app_colors.dart';
import 'package:inta_mobile_pms/features/housekeeping/models/room_item_model.dart';
import 'package:inta_mobile_pms/features/housekeeping/viewmodels/house_status_vm.dart';
import 'package:inta_mobile_pms/features/housekeeping/widgets/remark_dialog_wgt.dart';
import 'package:inta_mobile_pms/features/housekeeping/widgets/set_status_dialog_wgt.dart';
import 'package:inta_mobile_pms/features/reservations/widgets/confirmation_dialog_wgt.dart';
import 'package:inta_mobile_pms/router/app_routes.dart';
import 'package:shimmer/shimmer.dart';

class HouseStatus extends StatefulWidget {
  const HouseStatus({super.key});
  @override
  State<HouseStatus> createState() => _HouseStatusState();
}

class _HouseStatusState extends State<HouseStatus> {
  final _houseStatusVm = Get.find<HouseStatusVm>();
  List<RoomItem> rooms = [];
  bool isEditMode = false;
  Set<RoomItem> selectedRooms = {};
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (mounted) {
        await _houseStatusVm.loadRooms();
        rooms = _houseStatusVm.roomList;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.black),
          onPressed: () => context.go(AppRoutes.dashboard),
        ),
        title: Text(
          'House Status',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: AppColors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline, color: AppColors.black),
            onPressed: () => _showStatusInfoDialog(context),
          ),
          if (!isEditMode)
            IconButton(
              icon: const Icon(Icons.edit, color: AppColors.black),
              onPressed: () {
                setState(() {
                  isEditMode = true;
                });
              },
            ),
          if (isEditMode)
            IconButton(
              icon: const Icon(Icons.close, color: AppColors.black),
              onPressed: () {
                setState(() {
                  isEditMode = false;
                  selectedRooms.clear();
                });
              },
            ),
        ],
      ),
      body: Obx(() {
        final groupedRooms = _houseStatusVm.groupedRooms;
        final isLoading = _houseStatusVm.isLoading;

        return Column(
          children: [
            if (isEditMode) _buildActionButtons(),
            Expanded(
              child: isLoading.value
                  ? ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: 10,
                      itemBuilder: (context, index) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 20,
                              width: 150,
                              margin: const EdgeInsets.only(bottom: 12),
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(6),
                              ),
                            ),
                            const SizedBox(height: 8),
                            ...List.generate(
                              3,
                              (i) => Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: _buildRoomCardShimmer(),
                              ),
                            ),
                            const SizedBox(height: 24),
                          ],
                        );
                      },
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: groupedRooms.keys.length,
                      itemBuilder: (context, index) {
                        final section = groupedRooms.keys.elementAt(index);
                        final sectionRooms = groupedRooms[section]!;
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (index > 0) const SizedBox(height: 24),
                            _buildSectionHeader(section, sectionRooms),
                            const SizedBox(height: 12),
                            ...sectionRooms.map(
                              (room) => Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: _buildRoomCard(room),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildActionButtons() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: _bulkSetStatus,
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Column(
                children: [
                  Icon(Icons.handyman_outlined, size: 24),
                  SizedBox(height: 4),
                  Text('Set Status', style: TextStyle(fontSize: 12)),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: OutlinedButton(
              onPressed: _bulkEditHousekeeper,
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Column(
                children: [
                  Icon(Icons.person_outline, size: 24),
                  SizedBox(height: 4),
                  Text('Edit Housekeeper', style: TextStyle(fontSize: 12)),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: OutlinedButton(
              onPressed: _bulkClearStatus,
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Column(
                children: [
                  Icon(Icons.clear_all, size: 24),
                  SizedBox(height: 4),
                  Text('Clear Status', style: TextStyle(fontSize: 12)),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: OutlinedButton(
              onPressed: _bulkClearRemark,
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Column(
                children: [
                  Icon(Icons.delete_outline, size: 24),
                  SizedBox(height: 4),
                  Text('Clear Remark', style: TextStyle(fontSize: 12)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String section, List<RoomItem> sectionRooms) {
    if (!isEditMode) {
      return Text(
        section == ''? 'No Housekeeper Assigned' : section,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w700,
          color: AppColors.darkgrey,
          fontSize: 20,
        ),
      );
    }
    final allSelected = sectionRooms.every(
      (room) => selectedRooms.contains(room),
    );
    return Row(
      children: [
        Text(
         section == ''? 'No Housekeeper Assigned' : section,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
            color: AppColors.darkgrey,
            fontSize: 20,
          ),
        ),
        const Spacer(),
        Text(
          'Select All',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AppColors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
        Checkbox(
          value: allSelected,
          onChanged: (value) {
            setState(() {
              if (value == true) {
                selectedRooms.addAll(sectionRooms);
              } else {
                selectedRooms.removeWhere(
                  (room) => sectionRooms.contains(room),
                );
              }
            });
          },
        ),
      ],
    );
  }

  Widget _buildRoomCard(RoomItem room) {
    final statusColor = _houseStatusVm.getHousekeepingColor(
      room.housekeepingStatus,
    );
    final bgColor = _houseStatusVm.getBackgroundColor(room.housekeepingStatus);
    return InkWell(
      // onTap: isEditMode ? null : () => _showRoomActionsSheet(room),
      onTap: isEditMode
          ? null
          : () {
              _showRoomActionsSheet(room);
            },
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.withOpacity(0.2), width: 1),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    room.roomName,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: _houseStatusVm.getTextColor(
                        room.housekeepingStatus,
                      ),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Availability: ${room.availability}',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[600],
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (room.hasIssue) ...[
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.visibility,
                      color: AppColors.surface,
                      size: 12,
                    ),
                  ),
                  const SizedBox(width: 8),
                ],
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: statusColor,
                    shape: BoxShape.circle,
                  ),
                ),
                if (isEditMode) ...[
                  const SizedBox(width: 8),
                  Checkbox(
                    value: selectedRooms.contains(room),
                    onChanged: (value) {
                      setState(() {
                        if (value == true) {
                          selectedRooms.add(room);
                        } else {
                          selectedRooms.remove(room);
                        }
                      });
                    },
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRoomCardShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(height: 16, width: 120, color: Colors.white),
                  const SizedBox(height: 8),
                  Container(height: 14, width: 180, color: Colors.white),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Container(
              width: 20,
              height: 20,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
            ),
          ],
        ),
      ),
    );
  }
  void _bulkSetStatus() async {
    if (selectedRooms.isEmpty) return;

    final selectedId = await showDialog<int>(
      context: context,
      barrierDismissible: false,
      builder: (_) => SetStatusDialog(
        room: selectedRooms.first,
        isBulk: true,
        bulkRooms: selectedRooms.toList(),
      ),
    );

    if (selectedId == null) return;

    await _houseStatusVm.bulkUpdateStatus(selectedRooms.toList(), selectedId);
    setState(() {
      selectedRooms.clear();
      isEditMode = false;
    });
  }

  void _bulkEditHousekeeper() {
    if (selectedRooms.isEmpty) return;
    // Implement bulk edit housekeeper logic
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Edit housekeeper for ${selectedRooms.length} rooms'),
      ),
    );
    setState(() => selectedRooms.clear());
  }

  void _bulkClearStatus() {
    if (selectedRooms.isEmpty) return;
    // Implement bulk clear status logic
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Clear status for ${selectedRooms.length} rooms')),
    );
    setState(() => selectedRooms.clear());
  }

  void _bulkClearRemark() async {
    if (selectedRooms.isEmpty) return;
     final confirmed = await ConfirmationDialog.show(
      context: context,
      title: 'Clear Remarks',
      message: 'Are you sure you want to clear remarks?',
      confirmText: 'Yes',
      cancelText: 'No',
      confirmColor: AppColors.red,
      // icon: Icons.meeting_room,
    );
    if (confirmed == true) {
       await _houseStatusVm.bulkClearStatus(selectedRooms);
      if (!mounted) return;
    }
  }

  void _showRoomActionsSheet(RoomItem room) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _RoomActionsSheet(
        room: room,
        onActionSelected: (action) => _handleRoomAction(action, room),
      ),
    );
  }

  void _handleRoomAction(String action, RoomItem room) {
    context.pop();
    // Handle different actions
    switch (action) {
      case 'set_status':
        _showSetStatusDialog(room);
        break;
      case 'clear_status':
        _clearStatus(room);
        break;
      case 'edit_housekeeper':
        _showEditHousekeeperDialog(room);
        break;
      case 'unassign_housekeeper':
        _unassignHousekeeper(room);
        break;
      case 'add_remark':
        _showAddRemarkDialog(room);
        break;
      case 'edit_remark':
        _showEditRemarkDialog(room);
        break;
      case 'view_remark':
        _showViewRemarkDialog(room);
        break;
      case 'clear_remark':
        _clearRemark(room);
        break;
    }
  }
  void _showSetStatusDialog(RoomItem room) async {
    final selectedId = await showDialog<int>(
      context: context,
      barrierDismissible: false,
      builder: (_) => SetStatusDialog(room: room),
    );

    if (selectedId == null) return; // cancelled

    await _houseStatusVm.updateStatus(room, selectedId);
  }

  void _clearStatus(RoomItem room) async {
    final confirmed = await ConfirmationDialog.show(
      context: context,
      title: 'Clear Status',
      message: 'Are you sure you want to clear status?',
      confirmText: 'Yes',
      cancelText: 'No',
      confirmColor: AppColors.red,
      // icon: Icons.meeting_room,
    );
    if (confirmed == true) {
       await _houseStatusVm.clearStatus(room);
      if (!mounted) return;
    }
  }

  void _showEditHousekeeperDialog(RoomItem room) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Edit housekeeper for ${room.roomName}')),
    );
  }

  void _unassignHousekeeper(RoomItem room) async{
    final confirmed = await ConfirmationDialog.show(
      context: context,
      title: 'Unassign Housekeeper',
      message: 'Are you sure you want to unassign housekeeper?',
      confirmText: 'Yes',
      cancelText: 'No',
      confirmColor: AppColors.red,
      // icon: Icons.visibility,
    );
    if (confirmed == true) {
      await _houseStatusVm.unassignHouseKeeper(room);
      if (!mounted) return;
    }
  }

  void _showAddRemarkDialog(RoomItem room) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: '',
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, anim1, anim2) {
        return Align(
          alignment: Alignment.center,
          child: RemarkDialog(room: room, startInEdit: true),
        );
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return FadeTransition(
          opacity: anim1,
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.9, end: 1.0).animate(anim1),
            child: child,
          ),
        );
      },
    );
  }

  void _showEditRemarkDialog(RoomItem room) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: '',
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, anim1, anim2) {
        return Align(
          alignment: Alignment.center,
          child: RemarkDialog(room: room, startInEdit: true),
        );
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return FadeTransition(
          opacity: anim1,
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.9, end: 1.0).animate(anim1),
            child: child,
          ),
        );
      },
    );
  }

  void _showViewRemarkDialog(RoomItem room) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: '',
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, anim1, anim2) {
        return Align(
          alignment: Alignment.center,
          child: RemarkDialog(room: room, startInEdit: false),
        );
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return FadeTransition(
          opacity: anim1,
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.9, end: 1.0).animate(anim1),
            child: child,
          ),
        );
      },
    );
  }

  void _clearRemark(RoomItem room) async {
    await _houseStatusVm.clearRemark(room);
  }
  void _showStatusInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: AppColors.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 400),
            padding: const EdgeInsets.all(24),
            child: Obx(() {
              final houseKeepingStatusList =
                  _houseStatusVm.houseKeepingStatusList;
              return SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: AppColors.primary,
                          size: 24,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Status & Indicators Info',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: AppColors.black,
                                fontSize: 18,
                              ),
                        ),
                        const Spacer(),
                        IconButton(
                          onPressed: () => context.pop(),
                          icon: Icon(
                            Icons.close,
                            color: Colors.grey[600],
                            size: 20,
                          ),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Housekeeping Status',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.black,
                      ),
                    ),
                    ...houseKeepingStatusList.map(
                      (status) => Column(
                        children: [
                          const SizedBox(height: 12),
                          _buildStatusInfoItem(
                            context,
                            status['name'],
                            status['description'],
                            status['colorCode'],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Housekeeping Indicators',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.black,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildIndicatorInfoItem(
                      context,
                      'Eye Icon',
                      'Room has special attention or maintenance issues',
                      Icons.visibility,
                      Colors.black,
                    ),
                    const SizedBox(height: 8),
                    _buildIndicatorInfoItem(
                      context,
                      'Color Dots',
                      'Quick visual status indicator for housekeeping teams',
                      Icons.circle,
                      Colors.grey[600]!,
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => context.pop(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: AppColors.onPrimary,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          'Got it',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                color: AppColors.onPrimary,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
        );
      },
    );
  }

  Widget _buildStatusInfoItem(
    BuildContext context,
    String status,
    String description,
    Color color,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                status,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.black,
                ),
              ),
              Text(
                description,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey[600],
                  height: 1.3,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildIndicatorInfoItem(
    BuildContext context,
    String indicator,
    String description,
    IconData icon,
    Color color,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Icon(icon, size: 14, color: color),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                indicator,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.black,
                ),
              ),
              Text(
                description,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey[600],
                  height: 1.3,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _RoomActionsSheet extends StatelessWidget {
  final RoomItem room;
  final Function(String) onActionSelected;
  const _RoomActionsSheet({required this.room, required this.onActionSelected});
  @override
  Widget build(BuildContext context) {
    final hasRemark = room.remark != null && room.remark!.isNotEmpty;
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Drag handle
            Container(
              margin: const EdgeInsets.only(top: 12, bottom: 8),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            // Room info header
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
              child: Obx(() {
                final houseStatusVm = Get.find<HouseStatusVm>();
                return Row(
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: houseStatusVm.getStatusColor(
                          room.housekeepingStatus,
                        ),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            room.roomName,
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.black,
                                ),
                          ),
                          Text(
                            '${room.section} • ${room.availability}',
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () => context.pop(),
                      icon: Icon(Icons.close, color: Colors.grey[600]),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                );
              }),
            ),
            const Divider(height: 1),
            // Actions list
            ListView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(vertical: 8),
              children: [
                _buildActionTile(
                  context,
                  icon: Icons.check_circle_outline,
                  title: 'Set Status',
                  onTap: () => onActionSelected('set_status'),
                ),
                _buildActionTile(
                  context,
                  icon: Icons.clear,
                  title: 'Clear Status',
                  onTap: () => onActionSelected('clear_status'),
                ),
                const Divider(height: 1, indent: 64, endIndent: 16),
                _buildActionTile(
                  context,
                  icon: Icons.person_outline,
                  title: 'Edit Housekeeper',
                  onTap: () => onActionSelected('edit_housekeeper'),
                ),
                _buildActionTile(
                  context,
                  icon: Icons.person_remove_outlined,
                  title: 'Unassign Housekeeper',
                  onTap: () => onActionSelected('unassign_housekeeper'),
                ),
                const Divider(height: 1, indent: 64, endIndent: 16),
                if (!hasRemark)
                  _buildActionTile(
                    context,
                    icon: Icons.note_add_outlined,
                    title: 'Add Remark',
                    onTap: () => onActionSelected('add_remark'),
                  ),
                if (hasRemark) ...[
                  _buildActionTile(
                    context,
                    icon: Icons.visibility_outlined,
                    title: 'View Remark',
                    onTap: () => onActionSelected('view_remark'),
                  ),
                  _buildActionTile(
                    context,
                    icon: Icons.edit_note_outlined,
                    title: 'Edit Remark',
                    onTap: () => onActionSelected('edit_remark'),
                  ),
                  _buildActionTile(
                    context,
                    icon: Icons.delete_outline,
                    title: 'Clear Remark',
                    onTap: () => onActionSelected('clear_remark'),
                    isDestructive: true,
                  ),
                ],
              ],
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget _buildActionTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    final color = isDestructive ? Colors.red[700] : AppColors.black;
    return ListTile(
      leading: Icon(icon, color: color, size: 24),
      title: Text(
        title,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
          color: color,
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
      visualDensity: VisualDensity.compact,
    );
  }
}