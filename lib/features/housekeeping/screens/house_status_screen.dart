import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:inta_mobile_pms/core/theme/app_colors.dart';
import 'package:inta_mobile_pms/features/housekeeping/models/room_item_model.dart';
import 'package:inta_mobile_pms/router/app_routes.dart';

class HouseStatus extends StatefulWidget {
  const HouseStatus({super.key});

  @override
  State<HouseStatus> createState() => _HouseStatusState();
}

class _HouseStatusState extends State<HouseStatus> {
  List<RoomItem> rooms = [];
  
  @override
  void initState() {
    super.initState();
    _loadRooms();
  }

  void _loadRooms() {
    rooms = [
      // Alan section rooms
      RoomItem(
        section: 'Alan',
        roomName: 'GR 2',
        availability: 'Available',
        housekeepingStatus: HousekeepingStatus.clean,
        roomType: RoomType.garden,
      ),
      RoomItem(
        section: 'Alan',
        roomName: '3',
        availability: 'Available',
        housekeepingStatus: HousekeepingStatus.clean,
        roomType: RoomType.garden,
        hasIssue: true,
      ),
      RoomItem(
        section: 'Alan',
        roomName: 'Cabana 2',
        availability: 'Available',
        housekeepingStatus: HousekeepingStatus.dirty,
        roomType: RoomType.cabana,
      ),
      RoomItem(
        section: 'Alan',
        roomName: 'LX 11',
        availability: 'Available',
        housekeepingStatus: HousekeepingStatus.dirty,
        roomType: RoomType.luxury,
      ),
      RoomItem(
        section: 'Alan',
        roomName: '1',
        availability: 'Available',
        housekeepingStatus: HousekeepingStatus.dirty,
        roomType: RoomType.standard,
      ),
      RoomItem(
        section: 'George',
        roomName: '5',
        availability: 'Available',
        housekeepingStatus: HousekeepingStatus.dirty,
        roomType: RoomType.standard,
      ),
      RoomItem(
        section: 'Alan',
        roomName: '205',
        availability: 'Available',
        housekeepingStatus: HousekeepingStatus.dirty,
        roomType: RoomType.standard,
         remark: 'should be available at 10.00am',
      ),
      // Alex section rooms
      RoomItem(
        section: 'Alex',
        roomName: 'Family Villa',
        availability: 'Available',
        housekeepingStatus: HousekeepingStatus.clean,
        roomType: RoomType.villa,
        hasIssue: true,
      ),
      RoomItem(
        section: 'Alex',
        roomName: 'Reception Area',
        availability: '-NA-',
        housekeepingStatus: HousekeepingStatus.clean,
        roomType: RoomType.common,
      ),
      RoomItem(
        section: 'George',
        roomName: '106',
        availability: 'Available',
        housekeepingStatus: HousekeepingStatus.dirty,
        roomType: RoomType.standard,
      ),
      RoomItem(
        section: 'Peter',
        roomName: 'BH 101',
        availability: 'Available',
        housekeepingStatus: HousekeepingStatus.dirty,
        roomType: RoomType.beachHouse,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final groupedRooms = _groupRoomsBySection();
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
          IconButton(
            icon: const Icon(Icons.refresh, color: AppColors.black),
            onPressed: () => _refreshData(),
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: groupedRooms.keys.length,
        itemBuilder: (context, index) {
          final section = groupedRooms.keys.elementAt(index);
          final sectionRooms = groupedRooms[section]!;
          
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (index > 0) const SizedBox(height: 24),
              _buildSectionHeader(section),
              const SizedBox(height: 12),
              ...sectionRooms.map((room) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: _buildRoomCard(room),
              )),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSectionHeader(String section) {
    return Text(
      section,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.w700,
        color: AppColors.black,
        fontSize: 20,
      ),
    );
  }

  Widget _buildRoomCard(RoomItem room) {
    final statusColor = _getHousekeepingColor(room.housekeepingStatus);
    final bgColor = _getBackgroundColor(room.housekeepingStatus);
    
    return InkWell(
      onTap: () => _showRoomActionsSheet(room),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: Colors.grey.withOpacity(0.2),
            width: 1,
          ),
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
                      color: _getTextColor(room.housekeepingStatus),
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
              ],
            ),
          ],
        ),
      ),
    );
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
    Navigator.pop(context);
    
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

  void _showSetStatusDialog(RoomItem room) {
    // Implement set status dialog
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Set status for ${room.roomName}')),
    );
  }

  void _clearStatus(RoomItem room) {
    // Implement clear status logic
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Status cleared for ${room.roomName}')),
    );
  }

  void _showEditHousekeeperDialog(RoomItem room) {
    // Implement edit housekeeper dialog
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Edit housekeeper for ${room.roomName}')),
    );
  }

  void _unassignHousekeeper(RoomItem room) {
    // Implement unassign housekeeper logic
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Housekeeper unassigned from ${room.roomName}')),
    );
  }

  void _showAddRemarkDialog(RoomItem room) {
    // Implement add remark dialog
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Add remark for ${room.roomName}')),
    );
  }

  void _showEditRemarkDialog(RoomItem room) {
    // Implement edit remark dialog
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Edit remark for ${room.roomName}')),
    );
  }

  void _showViewRemarkDialog(RoomItem room) {
    // Implement view remark dialog
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('View remark for ${room.roomName}')),
    );
  }

  void _clearRemark(RoomItem room) {
    // Implement clear remark logic
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Remark cleared for ${room.roomName}')),
    );
  }

  Color _getHousekeepingColor(HousekeepingStatus status) {
    switch (status) {
      case HousekeepingStatus.clean:
        return AppColors.green;
      case HousekeepingStatus.dirty:
        return AppColors.red;
      case HousekeepingStatus.inspected:
        return AppColors.blue;
      case HousekeepingStatus.outOfOrder:
        return AppColors.black;
    }
  }

  Color _getBackgroundColor(HousekeepingStatus status) {
    switch (status) {
      case HousekeepingStatus.clean:
        return const Color(0xFFF0F8E8);
      case HousekeepingStatus.dirty:
        return const Color(0xFFFFF0F0);
      case HousekeepingStatus.inspected:
        return const Color(0xFFE8F4FD);
      case HousekeepingStatus.outOfOrder:
        return const Color(0xFFF5F5F5);
    }
  }

  Color _getTextColor(HousekeepingStatus status) {
    switch (status) {
      case HousekeepingStatus.clean:
        return Colors.green[800]!;
      case HousekeepingStatus.dirty:
        return Colors.red[800]!;
      case HousekeepingStatus.inspected:
        return Colors.blue[800]!;
      case HousekeepingStatus.outOfOrder:
        return Colors.grey[800]!;
    }
  }

  Map<String, List<RoomItem>> _groupRoomsBySection() {
    final Map<String, List<RoomItem>> grouped = {};
    for (final room in rooms) {
      grouped.putIfAbsent(room.section, () => []).add(room);
    }
    return grouped;
  }

  void _refreshData() {
    setState(() {
      _loadRooms();
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('House status refreshed'),
        backgroundColor: AppColors.secondary,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
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
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.black,
                        fontSize: 18,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
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
                const SizedBox(height: 12),
                _buildStatusInfoItem(
                  context,
                  'Clean',
                  'Room is cleaned and ready for guests',
                  Colors.green,
                ),
                const SizedBox(height: 8),
                _buildStatusInfoItem(
                  context,
                  'Dirty',
                  'Room needs housekeeping attention',
                  Colors.red,
                ),
                const SizedBox(height: 8),
                _buildStatusInfoItem(
                  context,
                  'Inspected',
                  'Room has been inspected and approved',
                  Colors.blue,
                ),
                const SizedBox(height: 8),
                _buildStatusInfoItem(
                  context,
                  'Out of Order',
                  'Room is temporarily unavailable',
                  Colors.black,
                ),
                const SizedBox(height: 20),
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
                    onPressed: () => Navigator.of(context).pop(),
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
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.onPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
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
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
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
          child: Icon(
            icon,
            size: 14,
            color: color,
          ),
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

  const _RoomActionsSheet({
    required this.room,
    required this.onActionSelected,
  });

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
              child: Row(
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: _getStatusColor(room.housekeepingStatus),
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
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppColors.black,
                          ),
                        ),
                        Text(
                          '${room.section} • ${room.availability}',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(Icons.close, color: Colors.grey[600]),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
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

  Color _getStatusColor(HousekeepingStatus status) {
    switch (status) {
      case HousekeepingStatus.clean:
        return AppColors.green;
      case HousekeepingStatus.dirty:
        return AppColors.red;
      case HousekeepingStatus.inspected:
        return AppColors.blue;
      case HousekeepingStatus.outOfOrder:
        return AppColors.black;
    }
  }
}