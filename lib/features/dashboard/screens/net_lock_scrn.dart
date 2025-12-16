import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:go_router/go_router.dart';
import 'package:inta_mobile_pms/core/config/responsive_config.dart';
import 'package:inta_mobile_pms/core/theme/app_colors.dart';
import 'package:inta_mobile_pms/features/dashboard/viewmodels/net_lock_vm.dart';
import 'package:inta_mobile_pms/router/app_routes.dart';
import 'package:shimmer/shimmer.dart';

class NetLock extends StatefulWidget {
  const NetLock({super.key});

  @override
  State<NetLock> createState() => _NetLockState();
}

class _NetLockState extends State<NetLock> {
  final _netLockVm = Get.find<NetLockVm>();
  final TextEditingController _searchController = TextEditingController();
  Set<int> _selectedRows = <int>{};
  bool _selectAll = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (mounted) {
        await _netLockVm.loadInitialData();
      }
    });
    // _loadMockData();
    // _filteredReservations = List.from(_allReservations);
  }

  void _toggleSelectAll(bool? value) {
    setState(() {
      _selectAll = value ?? false;
      if (_selectAll) {
        _selectedRows = Set.from(
          List.generate(
            _netLockVm.netlockDataFiltered.toList().length,
            (index) => index,
          ),
        );
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
      _selectAll =
          _selectedRows.length ==
          _netLockVm.netlockDataFiltered.toList().length;
    });
  }

  void _unlockSelected() async {
    if (_selectedRows.isNotEmpty) {
      // final selectedCount = _selectedRows.length;
      await _netLockVm.unlockBooking(_selectedRows);
      _selectedRows.clear();
      _selectAll = false;
      if (!mounted) return;
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
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                ),
              ),
            ),
          IconButton(
            icon: const Icon(Icons.refresh, color: AppColors.black),
            onPressed: () async {
              await _netLockVm.loadInitialData();
              // _filteredReservations = List.from(_allReservations);
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
            padding: ResponsiveConfig.horizontalPadding(
              context,
            ).add(ResponsiveConfig.verticalPadding(context)),
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
                      border: Border.all(
                        color: AppColors.lightgrey.withOpacity(0.3),
                      ),
                    ),
                    child: TextField(
                      controller: _searchController,
                      onChanged: (value) {
                        _netLockVm.filterReservations(value);
                        _selectedRows.clear();
                        _selectAll = false;
                      },
                      style: Theme.of(context).textTheme.bodyMedium,
                      decoration: InputDecoration(
                        hintText: 'Search',
                        hintStyle: Theme.of(context).textTheme.bodyMedium
                            ?.copyWith(color: AppColors.lightgrey),
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
                                  _netLockVm.filterReservations('');
                                  _selectedRows.clear();
                                  _selectAll = false;
                                },
                              )
                            : null,
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 12,
                        ),
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
                  borderRadius: BorderRadius.circular(
                    ResponsiveConfig.cardRadius(context),
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(
                    ResponsiveConfig.cardRadius(context),
                  ),
                  child: Column(
                    children: [
                      // Table Header
                      Container(
                        color: AppColors.primary,
                        padding: EdgeInsets.symmetric(
                          horizontal: ResponsiveConfig.defaultPadding(context),
                          vertical: ResponsiveConfig.isMobile(context)
                              ? 12
                              : 16,
                        ),
                        child: Row(
                          children: [
                            // Select All Checkbox
                            SizedBox(
                              width: ResponsiveConfig.isMobile(context)
                                  ? 40
                                  : 50,
                              child: Checkbox(
                                value: _selectAll,
                                onChanged: _toggleSelectAll,
                                activeColor: AppColors.primary,
                                checkColor: Colors.white,
                                materialTapTargetSize:
                                    MaterialTapTargetSize.shrinkWrap,
                              ),
                            ),
                            // Headers
                            Expanded(
                              flex: ResponsiveConfig.isMobile(context) ? 3 : 4,
                              child: Text(
                                'Details',
                                style: Theme.of(context).textTheme.titleSmall
                                    ?.copyWith(
                                      color: AppColors.surface,
                                      fontWeight: FontWeight.w600,
                                      fontSize:
                                          ResponsiveConfig.isMobile(context)
                                          ? 14
                                          : 16,
                                    ),
                              ),
                            ),
                            if (!ResponsiveConfig.isMobile(context))
                              Expanded(
                                flex: 2,
                                child: Text(
                                  'User',
                                  style: Theme.of(context).textTheme.titleSmall
                                      ?.copyWith(
                                        color: AppColors.primary,
                                        fontWeight: FontWeight.w600,
                                      ),
                                ),
                              ),
                            Expanded(
                              flex: ResponsiveConfig.isMobile(context) ? 2 : 2,
                              child: Text(
                                'Reservation No',
                                style: Theme.of(context).textTheme.titleSmall
                                    ?.copyWith(
                                      color: AppColors.surface,
                                      fontWeight: FontWeight.w600,
                                      fontSize:
                                          ResponsiveConfig.isMobile(context)
                                          ? 14
                                          : 16,
                                    ),
                                textAlign: TextAlign.end,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Table Body
                      Expanded(
                        child: Obx(() {
                          if (_netLockVm.isLoading.value) {
                            return ListView.separated(
                              padding: const EdgeInsets.all(8),
                              itemCount: 10,
                              separatorBuilder: (context, index) => Divider(
                                height: 1,
                                color: AppColors.lightgrey.withOpacity(0.2),
                              ),
                              itemBuilder: (context, index) =>
                                  _buildTableRowShimmer(context),
                            );
                          }

                          if (_netLockVm.netlockDataFiltered.isEmpty) {
                            return _buildEmptyState();
                          }

                          return ListView.separated(
                            itemCount: _netLockVm.netlockDataFiltered.length,
                            separatorBuilder: (context, index) => Divider(
                              height: 1,
                              color: AppColors.lightgrey.withOpacity(0.2),
                            ),
                            itemBuilder: (context, index) {
                              final item =
                                  _netLockVm.netlockDataFiltered[index];
                              return _buildTableRow(item, index);
                            },
                          );
                        }),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: ResponsiveConfig.defaultPadding(context)),
        ],
      ),
    );
  }

  Widget _buildTableRowShimmer(BuildContext context) {
    final baseColor = AppColors.lightgrey.withOpacity(0.3);
    final highlightColor = AppColors.lightgrey.withOpacity(0.1);

    return Shimmer.fromColors(
      baseColor: baseColor,
      highlightColor: highlightColor,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: ResponsiveConfig.defaultPadding(context),
          vertical: ResponsiveConfig.isMobile(context) ? 12 : 16,
        ),
        child: Row(
          children: [
            // Checkbox placeholder
            SizedBox(
              width: ResponsiveConfig.isMobile(context) ? 40 : 50,
              child: Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: baseColor,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),

            // Details Column
            Expanded(
              flex: ResponsiveConfig.isMobile(context) ? 3 : 4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Guest name shimmer
                  Container(
                    width: double.infinity,
                    height: 14,
                    color: baseColor,
                  ),
                  const SizedBox(height: 6),
                  // Room info shimmer
                  Container(
                    width: MediaQuery.of(context).size.width * 0.5,
                    height: 12,
                    color: baseColor,
                  ),
                  if (ResponsiveConfig.isMobile(context)) ...[
                    const SizedBox(height: 6),
                    Container(width: 100, height: 12, color: baseColor),
                  ],
                ],
              ),
            ),

            // User Column (Desktop/Tablet only)
            if (!ResponsiveConfig.isMobile(context))
              Expanded(
                flex: 2,
                child: Container(
                  height: 20,
                  decoration: BoxDecoration(
                    color: baseColor,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),

            // Reservation Number shimmer
            Expanded(
              flex: 2,
              child: Container(
                height: 20,
                decoration: BoxDecoration(
                  color: baseColor,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ],
        ),
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
                  onChanged: (value) {
                    _toggleRowSelection(index);
                  },
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
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
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
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
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
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: AppColors.lightgrey),
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
  final int? bookingRoomId;
  final String guestName;
  final String roomType;
  final String roomName;
  final String user;
  final String reservationNo;

  ReservationData({
    this.bookingRoomId,
    required this.guestName,
    required this.roomType,
    required this.roomName,
    required this.user,
    required this.reservationNo,
  });
}
