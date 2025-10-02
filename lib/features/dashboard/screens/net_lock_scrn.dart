import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:inta_mobile_pms/core/config/responsive_config.dart';
import 'package:inta_mobile_pms/core/theme/app_colors.dart';
import 'package:inta_mobile_pms/router/app_routes.dart';

class NetLock extends StatefulWidget {
  const NetLock({super.key});

  @override
  State<NetLock> createState() => _NetLockState();
}

class _NetLockState extends State<NetLock> {
  final TextEditingController _searchController = TextEditingController();
  List<ReservationData> _filteredReservations = [];
  List<ReservationData> _allReservations = [];
  Set<int> _selectedRows = <int>{};
  bool _selectAll = false;

  @override
  void initState() {
    super.initState();
    _loadMockData();
    _filteredReservations = List.from(_allReservations);
  }

  void _loadMockData() {
    _allReservations = [
      ReservationData(
        guestName: 'Mr.Wasana Mudalige',
        roomType: 'Deluxe Queen',
        roomName: '14',
        user: 'Admin',
        reservationNo: 'R-4068-2',
      ),
      ReservationData(
        guestName: 'Mr.Wasana Mudalige',
        roomType: 'Super Gold',
        roomName: 'SG-001',
        user: 'Admin',
        reservationNo: 'R-4263',
      ),
      ReservationData(
        guestName: 'Mr.Sameer Hishad',
        roomType: 'Deluxe King',
        roomName: '04',
        user: 'Admin',
        reservationNo: 'R-4271',
      ),
      ReservationData(
        guestName: 'Mr.Lio Fernando',
        roomType: 'Deluxe King',
        roomName: '03',
        user: 'Admin',
        reservationNo: 'R-4282',
      ),
      ReservationData(
        guestName: 'Mr.Wasana Mudalige',
        roomType: 'Deluxe Queen',
        roomName: '11',
        user: 'Admin',
        reservationNo: 'R-4330',
      ),
      ReservationData(
        guestName: 'Ms.Janani S Bandara',
        roomType: 'Deluxe King',
        roomName: '04',
        user: 'Admin',
        reservationNo: 'R-4386',
      ),
      ReservationData(
        guestName: 'Mr.Sameer Hishad',
        roomType: 'Deluxe King',
        roomName: '04',
        user: 'Admin',
        reservationNo: 'R-4271',
      ),
      ReservationData(
        guestName: 'Mr.Lio Fernando',
        roomType: 'Deluxe King',
        roomName: '03',
        user: 'Admin',
        reservationNo: 'R-4282',
      ),
      ReservationData(
        guestName: 'Mr.Wasana Mudalige',
        roomType: 'Deluxe Queen',
        roomName: '11',
        user: 'Admin',
        reservationNo: 'R-4330',
      ),
      ReservationData(
        guestName: 'Ms.Janani S Bandara',
        roomType: 'Deluxe King',
        roomName: '04',
        user: 'Admin',
        reservationNo: 'R-4386',
      ),
    ];
  }

  void _filterReservations(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredReservations = List.from(_allReservations);
      } else {
        _filteredReservations = _allReservations
            .where((reservation) =>
                reservation.guestName.toLowerCase().contains(query.toLowerCase()) ||
                reservation.roomType.toLowerCase().contains(query.toLowerCase()) ||
                reservation.reservationNo.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
      _selectedRows.clear();
      _selectAll = false;
    });
  }

  void _toggleSelectAll(bool? value) {
    setState(() {
      _selectAll = value ?? false;
      if (_selectAll) {
        _selectedRows = Set.from(List.generate(_filteredReservations.length, (index) => index));
      } else {
        _selectedRows.clear();
      }
    });
  }

  void _toggleRowSelection(int index) {
    setState(() {
      if (_selectedRows.contains(index)) {
        _selectedRows.remove(index);
      } else {
        _selectedRows.add(index);
      }
      _selectAll = _selectedRows.length == _filteredReservations.length;
    });
  }

  void _unlockSelected() {
    if (_selectedRows.isNotEmpty) {
      final selectedCount = _selectedRows.length;
      final selectedIndices = _selectedRows.toList()..sort((a, b) => b.compareTo(a));
      
      setState(() {

        for (final index in selectedIndices) {
          final reservation = _filteredReservations[index];
          _filteredReservations.removeAt(index);
          _allReservations.remove(reservation);
        }
        _selectedRows.clear();
        _selectAll = false;
      });
      
      // Show success feedback
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle, color: AppColors.onPrimary, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  '$selectedCount reservation${selectedCount > 1 ? 's' : ''} unlocked and removed',
                ),
              ),
            ],
          ),
          backgroundColor: AppColors.secondary,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.black),
          onPressed: () => context.go(AppRoutes.dashboard),
        ),
        title: Text(
          'Net Lock',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: AppColors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          if (_selectedRows.isNotEmpty)
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 8.0),
              child: ElevatedButton.icon(
                onPressed: _unlockSelected,
                icon: const Icon(Icons.lock_open, size: 16),
                label: const Text('Unlock'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.secondary,
                  foregroundColor: AppColors.onPrimary,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
              ),
            ),
          IconButton(
            icon: const Icon(Icons.refresh, color: AppColors.black),
            onPressed: () {
              _loadMockData();
              _filteredReservations = List.from(_allReservations);
              setState(() {});
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Header
          Container(
            color: AppColors.surface,
            padding: ResponsiveConfig.horizontalPadding(context)
                .add(ResponsiveConfig.verticalPadding(context)),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: ResponsiveConfig.isMobile(context) ? 40 : 44,
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(
                        ResponsiveConfig.cardRadius(context) - 4,
                      ),
                      border: Border.all(color: AppColors.lightgrey.withOpacity(0.3)),
                    ),
                    child: TextField(
                      controller: _searchController,
                      onChanged: _filterReservations,
                      style: Theme.of(context).textTheme.bodyMedium,
                      decoration: InputDecoration(
                        hintText: 'Search reservations...',
                        hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.lightgrey,
                        ),
                        prefixIcon: Icon(
                          Icons.search,
                          size: ResponsiveConfig.iconSize(context),
                          color: AppColors.lightgrey,
                        ),
                        suffixIcon: _searchController.text.isNotEmpty
                            ? IconButton(
                                icon: Icon(
                                  Icons.clear,
                                  size: ResponsiveConfig.iconSize(context),
                                  color: AppColors.lightgrey,
                                ),
                                onPressed: () {
                                  _searchController.clear();
                                  _filterReservations('');
                                },
                              )
                            : null,
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Table Content
          Expanded(
            child: Container(
              margin: ResponsiveConfig.horizontalPadding(context),
              child: Card(
                elevation: 2,
                shadowColor: AppColors.surface,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(ResponsiveConfig.cardRadius(context)),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(ResponsiveConfig.cardRadius(context)),
                  child: Column(
                    children: [
                      // Table Header
                      Container(
                        color: AppColors.primary,
                        padding: EdgeInsets.symmetric(
                          horizontal: ResponsiveConfig.defaultPadding(context),
                          vertical: ResponsiveConfig.isMobile(context) ? 12 : 16,
                        ),
                        child: Row(
                          children: [
                            // Select All Checkbox
                            SizedBox(
                              width: ResponsiveConfig.isMobile(context) ? 40 : 50,
                              child: Checkbox(
                              value: _selectAll,
                              onChanged: _toggleSelectAll,
                              activeColor: AppColors.primary,
                              checkColor: Colors.white,
                              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                            ),
                            // Headers
                            Expanded(
                              flex: ResponsiveConfig.isMobile(context) ? 3 : 4,
                              child: Text(
                                'Details',
                                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                  color: AppColors.surface,
                                  fontWeight: FontWeight.w600,
                                  fontSize: ResponsiveConfig.isMobile(context) ? 14 : 16,
                                ),
                              ),
                            ),
                            if (!ResponsiveConfig.isMobile(context))
                              Expanded(
                                flex: 2,
                                child: Text(
                                  'User',
                                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            Expanded(
                              flex: ResponsiveConfig.isMobile(context) ? 2 : 2,
                              child: Text(
                                'Reservation No',
                                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                  color: AppColors.surface,
                                  fontWeight: FontWeight.w600,
                                  fontSize: ResponsiveConfig.isMobile(context) ? 14 : 16,
                                ),
                                textAlign: TextAlign.end,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Table Body
                      Expanded(
                        child: _filteredReservations.isEmpty
                            ? _buildEmptyState()
                            : ListView.separated(
                                itemCount: _filteredReservations.length,
                                separatorBuilder: (context, index) => Divider(
                                  height: 1,
                                  color: AppColors.lightgrey.withOpacity(0.2),
                                ),
                                itemBuilder: (context, index) {
                                  return _buildTableRow(
                                    _filteredReservations[index],
                                    index,
                                  );
                                },
                              ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          // Bottom spacing for mobile
          SizedBox(height: ResponsiveConfig.defaultPadding(context)),
        ],
      ),
    );
  }

  Widget _buildTableRow(ReservationData reservation, int index) {
    final isSelected = _selectedRows.contains(index);
    
    return Container(
      color: isSelected ? AppColors.primary.withOpacity(0.05) : null,
      child: InkWell(
        onTap: () => _toggleRowSelection(index),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: ResponsiveConfig.defaultPadding(context),
            vertical: ResponsiveConfig.isMobile(context) ? 12 : 16,
          ),
          child: Row(
            children: [
              // Checkbox
              SizedBox(
                width: ResponsiveConfig.isMobile(context) ? 40 : 50,
                child: Checkbox(
                  value: isSelected,
                  onChanged: (_) => _toggleRowSelection(index),
                  activeColor: AppColors.primary,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ),
              // Details Column
              Expanded(
                flex: ResponsiveConfig.isMobile(context) ? 3 : 4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      reservation.guestName,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.black,
                        fontSize: ResponsiveConfig.isMobile(context) ? 13 : 14,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Room Type: ${reservation.roomType}, Room Name: ${reservation.roomName}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.lightgrey,
                        fontSize: ResponsiveConfig.isMobile(context) ? 11 : 12,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (ResponsiveConfig.isMobile(context)) ...[
                      const SizedBox(height: 4),
                      Text(
                        'User: ${reservation.user}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.lightgrey,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              // User Column (Desktop/Tablet only)
              if (!ResponsiveConfig.isMobile(context))
                Expanded(
                  flex: 2,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      reservation.user,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              // Reservation Number
              Expanded(
                flex: ResponsiveConfig.isMobile(context) ? 2 : 2,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.secondary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    reservation.reservationNo,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.secondary,
                      fontWeight: FontWeight.w600,
                      fontSize: ResponsiveConfig.isMobile(context) ? 11 : 12,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: ResponsiveConfig.horizontalPadding(context),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: ResponsiveConfig.isMobile(context) ? 48 : 64,
              color: AppColors.lightgrey.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'No reservations found',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppColors.lightgrey,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Try adjusting your search criteria',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.lightgrey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}

class ReservationData {
  final String guestName;
  final String roomType;
  final String roomName;
  final String user;
  final String reservationNo;

  ReservationData({
    required this.guestName,
    required this.roomType,
    required this.roomName,
    required this.user,
    required this.reservationNo,
  });
}