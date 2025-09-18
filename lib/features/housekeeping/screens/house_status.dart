import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:inta_mobile_pms/core/theme/app_colors.dart';
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
    
    return Container(
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

// Enums and Data Models
enum HousekeepingStatus {
  clean,
  dirty,
  inspected,
  outOfOrder,
}

enum RoomType {
  standard,
  luxury,
  villa,
  cabana,
  beachHouse,
  garden,
  common,
}

class RoomItem {
  final String section;
  final String roomName;
  final String availability;
  final HousekeepingStatus housekeepingStatus;
  final RoomType roomType;
  final bool hasIssue;

  RoomItem({
    required this.section,
    required this.roomName,
    required this.availability,
    required this.housekeepingStatus,
    required this.roomType,
    this.hasIssue = false,
  });
}