import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:inta_mobile_pms/core/config/responsive_config.dart';
import 'package:inta_mobile_pms/core/theme/app_text_theme.dart';
import 'package:inta_mobile_pms/core/widgets/custom_appbar.dart';
import 'package:inta_mobile_pms/features/dashboard/viewmodels/dashboard_vm.dart';
import 'package:inta_mobile_pms/features/dashboard/widgets/hotel_list_dialog_wgt.dart';
import 'package:inta_mobile_pms/features/reservations/viewmodels/reservation_vm.dart';
import 'package:inta_mobile_pms/features/stay_view/viewmodels/stay_view_vm.dart';
import 'package:inta_mobile_pms/features/stay_view/widgets/day_use_list_dialog_wgt.dart';
import 'package:inta_mobile_pms/features/stay_view/widgets/maintenanceblock_dialog_wgt.dart';
import 'package:inta_mobile_pms/features/stay_view/widgets/unassign_room_dialog.dart';
import 'package:inta_mobile_pms/router/app_routes.dart';
import 'package:intl/intl.dart';
import 'package:inta_mobile_pms/core/theme/app_colors.dart';
import 'package:shimmer/shimmer.dart';

class StayViewScreen extends StatefulWidget {
  const StayViewScreen({super.key});

  @override
  State<StayViewScreen> createState() => _StayViewScreenState();
}

class _StayViewScreenState extends State<StayViewScreen> {
  final _stayViewVm = Get.find<StayViewVm>();
  final _dashboardVm = Get.find<DashboardVm>();
  final _reservationVm = Get.find<ReservationVm>();
  DateTime _centerDate = DateTime.now();
  double? _rowHeight = 30;
  double? _barHeight = 20;
  double? _indicatorIconSize = 15;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _stayViewVm.loadToday();

      setState(() {
        _centerDate = _stayViewVm.today.value ?? DateTime.now();
      });

      await _stayViewVm.loadInitialData(_centerDate);
    });
  }

  void _showInfoDialog() {
    final List<Map<String, dynamic>> statuses = _stayViewVm.statusList
        .map((item) => {"color": item.color, "label": item.label})
        .toList();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          contentPadding: const EdgeInsets.all(0),
          title: const Text(
            'Status & Indicators Information',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Divider(height: 1),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Booking Status',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildLegendGrid(statuses),
                      const SizedBox(height: 24),
                      const Text(
                        'Booking Indicators',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildIndicatorRow(
                        Icons.star,
                        'Group Reservation',
                        AppColors.red,
                      ),
                      const SizedBox(height: 12),
                      _buildIndicatorRow(
                        Icons.person,
                        'Group Leader',
                        const Color(0xFF795548),
                      ),
                      const SizedBox(height: 12),
                      _buildIndicatorRow(
                        Icons.open_in_new,
                        'Day Use Reservation',
                        const Color(0xFF795548),
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'Room Indicators',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildIndicatorRow(
                        Icons.smoke_free,
                        'No Smoking',
                        Colors.grey[700]!,
                      ),
                      const SizedBox(height: 12),
                      _buildIndicatorRow(
                        Icons.cleaning_services,
                        'Dirty',
                        Colors.grey[700]!,
                      ),
                      const SizedBox(height: 12),
                      _buildIndicatorRow(
                        Icons.smoking_rooms,
                        'Smoking',
                        Colors.grey[700]!,
                      ),
                      const SizedBox(height: 12),
                      _buildLegendItem('Inventory', Colors.blue[100]!),
                      const SizedBox(height: 12),
                      _buildLegendItem('Unassigned Room', Colors.red[100]!),
                    ],
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
              child: const Text(
                'Cancel',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildLegendGrid(List<Map<String, dynamic>> items) {
    return Column(
      children: [
        for (int i = 0; i < items.length; i += 2)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              children: [
                Expanded(
                  child: _buildLegendItem(items[i]['label'], items[i]['color']),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: i + 1 < items.length
                      ? _buildLegendItem(
                          items[i + 1]['label'],
                          items[i + 1]['color'],
                        )
                      : const SizedBox.shrink(),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildIndicatorRow(IconData icon, String label, Color color) {
    return Row(
      children: [
        Icon(icon, size: 24, color: color),
        const SizedBox(width: 12),
        Text(
          label,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = AppTextTheme.lightTextTheme(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final horizontalPadding = ResponsiveConfig.horizontalPadding(context);
    final availableWidth =
        screenWidth - (horizontalPadding.left + horizontalPadding.right);

    final List<DateTime> days = [
      _centerDate.subtract(const Duration(days: 1)),
      _centerDate,
      _centerDate.add(const Duration(days: 1)),
    ];
    final int numDays = days.length;
    final double roomWidth = availableWidth * 0.35;
    final double dayWidth = (availableWidth * 0.65) / numDays;

    final List<String> dayLabels = days.map((d) {
      final String weekday = DateFormat('E').format(d);
      final String day = DateFormat('d').format(d);
      return '$weekday\n$day';
    }).toList();

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: CustomAppBar(
        title: 'Stay View',
        onInfoTap: _showInfoDialog,
        onChangeProperty: () async {
          await _dashboardVm.getAllHotels();
          showDialog(
            context: context,
            builder: (_) => HotelListDialog(
              onHotelSelected: (hotel) async {
                await _stayViewVm.changeProperty(hotel, _centerDate);
                await _dashboardVm.changeProperty(hotel);

                setState(
                  () => _centerDate = _stayViewVm.today.value ?? DateTime.now(),
                );
                // _stayViewVm.refreshStayView(_centerDate);
              },
            ),
          );
        },
      ),
      body: Stack(
        children: [
          Column(
            children: [
              _buildDateNavigator(textTheme),
              Padding(
                padding: const EdgeInsets.only(top: 12.0),
                child: _buildHeaderRow(
                  roomWidth,
                  dayWidth,
                  dayLabels,
                  textTheme,
                  days,
                ),
              ),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async {
                    _stayViewVm.refreshStayView(_centerDate);
                  },
                  child: ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: EdgeInsets.zero,
                    children: [
                      Padding(
                        padding: ResponsiveConfig.horizontalPadding(
                          context,
                        ).copyWith(top: 20, bottom: 24),
                        child: GestureDetector(
                          onHorizontalDragEnd: (details) {
                            if (details.primaryVelocity! > 300) {
                              setState(() {
                                _centerDate = _centerDate.subtract(
                                  const Duration(days: 1),
                                );
                              });
                            } else if (details.primaryVelocity! < -300) {
                              setState(() {
                                _centerDate = _centerDate.add(
                                  const Duration(days: 1),
                                );
                              });
                            }
                          },
                          child: LayoutBuilder(
                            builder: (context, constraints) {
                              return Obx(() {
                                return _stayViewVm.isLoading.value
                                    ? Column(
                                        children: _buildRoomSectionsShimmer(
                                          roomWidth,
                                          dayWidth,
                                        ),
                                      )
                                    : Column(
                                        children: _buildRoomSections(
                                          roomWidth,
                                          dayWidth,
                                          textTheme,
                                          days,
                                        ),
                                      );
                              });
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // Loading overlay remains on top
          Obx(() {
            if (!_reservationVm.isAllGuestDataLoading.value) {
              return const SizedBox.shrink();
            }
            return Container(
              color: Colors.black.withOpacity(0.25),
              child: Center(
                child: CircularProgressIndicator(
                  strokeWidth: 6.0,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Theme.of(context).primaryColor,
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  List<Widget> _buildRoomSectionsShimmer(double roomWidth, double dayWidth) {
    return List.generate(10, (index) {
      return Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[200]!),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Left side shimmer (room type name)
              Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: Container(
                  width: 140,
                  height: 18,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),

              // Right side shimmer (like expand icon)
              Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: Container(
                  width: 24,
                  height: 24,
                  decoration: const BoxDecoration(
                    color: Colors.grey,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildDateNavigator(TextTheme textTheme) {
    final bool isMobile = ResponsiveConfig.isMobile(context);
    final double fontScale = ResponsiveConfig.fontScale(context);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 8 : 16,
        vertical: isMobile ? 8 : 12,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Colors.grey[200]!, width: 1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            iconSize: isMobile ? 20 : 24,
            icon: Icon(Icons.chevron_left, color: Colors.grey[700]),
            onPressed: () {
              setState(
                () =>
                    _centerDate = _centerDate.subtract(const Duration(days: 1)),
              );
              _stayViewVm.loadInitialData(_centerDate);
            },
            style: IconButton.styleFrom(
              backgroundColor: Colors.grey[100],
              padding: EdgeInsets.all(isMobile ? 4 : 8),
            ),
          ),

          SizedBox(width: isMobile ? 8 : 16),

          InkWell(
            onTap: () async {
              final DateTime? picked = await showDatePicker(
                context: context,
                initialDate: _centerDate,
                firstDate: DateTime(2000),
                lastDate: DateTime(2100),
                builder: (context, child) {
                  return Theme(
                    data: Theme.of(context).copyWith(
                      colorScheme: ColorScheme.light(
                        primary: AppColors.primary,
                      ),
                    ),
                    child: child!,
                  );
                },
              );
              if (picked != null && picked != _centerDate) {
                setState(() => _centerDate = picked);
                _stayViewVm.loadInitialData(_centerDate);
              }
            },
            borderRadius: BorderRadius.circular(8),
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: isMobile ? 8 : 16,
                vertical: isMobile ? 6 : 10,
              ),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.calendar_today,
                    size: isMobile ? 14 : 16,
                    color: Colors.grey[700],
                  ),
                  SizedBox(width: isMobile ? 4 : 8),
                  Text(
                    DateFormat('MMM d, yyyy').format(_centerDate),
                    style: textTheme.bodyMedium?.copyWith(
                      fontSize: (isMobile ? 12 : 14) * fontScale,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[900],
                    ),
                  ),
                ],
              ),
            ),
          ),

          SizedBox(width: isMobile ? 8 : 16),

          IconButton(
            iconSize: isMobile ? 20 : 24,
            icon: Icon(Icons.chevron_right, color: Colors.grey[700]),
            onPressed: () {
              setState(
                () => _centerDate = _centerDate.add(const Duration(days: 1)),
              );
              _stayViewVm.loadInitialData(_centerDate);
            },
            style: IconButton.styleFrom(
              backgroundColor: Colors.grey[100],
              padding: EdgeInsets.all(isMobile ? 4 : 8),
            ),
          ),

          SizedBox(width: isMobile ? 8 : 24),

          isMobile
              ? IconButton(
                  tooltip: "Today",
                  icon: Icon(Icons.today, size: 18, color: Colors.white),
                  style: IconButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.all(8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    setState(
                      () => _centerDate =
                          _stayViewVm.today.value ?? DateTime.now(),
                    );
                    _stayViewVm.loadInitialData(_centerDate);
                  },
                )
              // 🖥 Desktop/Tablet: full button
              : ElevatedButton.icon(
                  onPressed: () {
                    setState(
                      () => _centerDate =
                          _stayViewVm.today.value ?? DateTime.now(),
                    );
                    _stayViewVm.loadInitialData(_centerDate);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  icon: const Icon(Icons.today, size: 18),
                  label: Text(
                    'Today',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 14 * fontScale,
                    ),
                  ),
                ),
        ],
      ),
    );
  }

  Widget _buildHeaderRow(
    double roomWidth,
    double dayWidth,
    List<String> dayLabels,
    TextTheme textTheme,
    List<DateTime> days,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            Container(
              width: roomWidth,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
              alignment: Alignment.centerLeft,
              child: Text(
                'Room',
                style: textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[900],
                  letterSpacing: -0.2,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            ...List.generate(dayLabels.length, (index) {
              final bool isToday = index == 1;
              final bool isWeekend =
                  days[index].weekday == DateTime.saturday ||
                  days[index].weekday == DateTime.sunday;
              final Color? bgColor = isToday
                  ? AppColors.primary.withOpacity(0.08)
                  : isWeekend
                  ? Colors.red.withOpacity(0.05)
                  : null;
              final Color textColor = isToday
                  ? AppColors.primary
                  : isWeekend
                  ? Colors.red[700]!
                  : Colors.grey[700]!;
              return Expanded(
                child: Container(
                  width: dayWidth,
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: bgColor,
                    border: Border(left: BorderSide(color: Colors.grey[200]!)),
                  ),
                  child: Text(
                    dayLabels[index],
                    style: textTheme.bodySmall!.copyWith(
                      fontWeight: FontWeight.w600,
                      color: textColor,
                      height: 1.4,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildRoomSections(
    double roomWidth,
    double dayWidth,
    TextTheme textTheme,
    List<DateTime> days,
  ) {
    return _stayViewVm.roomTypes.map((section) {
      final items = section['rooms'] as List<Map<String, dynamic>>;
      return Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[200]!),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            initiallyExpanded: true,
            title: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    '${items.length}',
                    style: textTheme.labelSmall?.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  section['roomTypeName'],
                  style: textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    letterSpacing: -0.2,
                  ),
                ),
              ],
            ),
            tilePadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 4,
            ),
            childrenPadding: const EdgeInsets.all(0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            children: [
              _buildAvailabilityRow(
                section,
                roomWidth,
                dayWidth,
                textTheme,
                days,
              ),
              ...items.map<Widget>((item) {
                return _buildItemRow(
                  item,
                  roomWidth,
                  dayWidth,
                  textTheme,
                  days,
                  section,
                );
              }).toList(),
            ],
          ),
        ),
      );
    }).toList();
  }

  Widget _buildAvailabilityRow(
    Map<String, dynamic> section,
    double roomWidth,
    double dayWidth,
    TextTheme textTheme,
    List<DateTime> days,
  ) {
    final List<dynamic> datas = section['datas'] as List<dynamic>;
    final roomTypeId = section['roomTypeId'] as int;
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[50],
        border: Border(bottom: BorderSide(color: Colors.grey[200]!)),
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            Container(
              width: roomWidth,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              alignment: Alignment.centerLeft,
              child: Text(
                'Availability',
                style: textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[800],
                ),
              ),
            ),
            ...List.generate(datas.length, (index) {
              final assignCount = datas[index]['availability'].toInt();
              final total = datas[index]['totalNoOfRooms'];
              final unassignCount = datas[index]['bookingRooms'].length;
              final List<Map<String, dynamic>> bookingRoomsList =
                  (datas[index]['bookingRooms'] as List)
                      .map((e) => Map<String, dynamic>.from(e as Map))
                      .toList();

              return Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: Border(left: BorderSide(color: Colors.grey[200]!)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () {},
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.blue[50],
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            '$assignCount',
                            style: textTheme.bodySmall!.copyWith(
                              fontWeight: FontWeight.w500,
                              color: Colors.blue[700],
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: Text(
                          ' ',
                          style: textTheme.bodySmall!.copyWith(
                            fontWeight: FontWeight.w500,
                            color: Colors.grey[300],
                          ),
                        ),
                      ),
                      if (unassignCount > 0)
                        InkWell(
                          onTap: () async {
                            await _stayViewVm.loadAvailableRooms(
                              bookingRoomsList,
                            );
                            showDialog(
                              context: context,
                              builder: (context) {
                                return UnassignRoomDialog(
                                  unassignBookingList: _stayViewVm
                                      .unassignBookingList
                                      .toList(),
                                  onViewReservation: (unassignItem) async {
                                    await _reservationVm.getAllGuestData(
                                      unassignItem.bookingRoomId.toString(),
                                    );
                                    final guestItem =
                                        _reservationVm.allGuestDetails.value;
                                    context.push(
                                      AppRoutes.viewReservation,
                                      extra: guestItem,
                                    );
                                  },
                                  onAssignRoom:
                                      (unassignItem, selectedRoom) async {
                                        await _stayViewVm.assignRoom(
                                          unassignItem,
                                          selectedRoom,
                                        );
                                      },
                                );
                              },
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.red[50],
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              '$unassignCount',
                              style: textTheme.bodySmall!.copyWith(
                                fontWeight: FontWeight.w500,
                                color: Colors.red[700],
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildItemRow(
    Map<String, dynamic> item,
    double roomWidth,
    double dayWidth,
    TextTheme textTheme,
    List<DateTime> days,
    Map<String, dynamic> section,
  ) {
    final String name = item['roomNo'];
    final bool isMaintenance = (item['maintenanceBlockId'] ?? 0) > 0;
    final bool hasOccupancy = item['roomData'].any(
      (dayData) =>
          dayData['checkInExist'] != null && dayData['checkInExist'].isNotEmpty,
    );

    final int numDays = days.length;
    final double totalDaysWidth = dayWidth * numDays;

    final double namePaddingLeft = 16.0;

    TextStyle nameStyle = textTheme.bodyMedium!.copyWith(
      fontWeight: FontWeight.w400,
      letterSpacing: -0.1,
      color: Colors.grey[800],
    );

    List<Widget> reservationBars = [];
    for (int i = 0; i < numDays; i++) {
      final dayData = item['roomData'][i];
      if (dayData['checkInExist'] != null &&
          dayData['checkInExist'].isNotEmpty) {
        int startOn = dayData['startOn'] ?? 1;
        List checkInList = dayData['checkInExist'];
        for (int k = 0; k < checkInList.length; k++) {
          final checkIn = checkInList[k];
          String guestName = checkIn['guestName'] ?? '';
          String colorCode = checkIn['colorCode'] ?? '#000000';
          bool isGroup = checkIn['isGroupBooking'] ?? false;
          bool isGroupLeader = checkIn['isGroupLeader'] ?? false;
          String groupColor = checkIn['groupColor'] ?? '#000000';
          Color guestColor = Color(
            int.parse(colorCode.replaceFirst('#', '0xFF')),
          );
          double noNights = checkIn['noOfNights'] ?? 1.0;
          double barWidth = noNights * dayWidth;
          if (noNights == 0) barWidth = dayWidth;
          double offset = 0;
          if (startOn == 1)
            offset = 0;
          else if (startOn == 2)
            offset = dayWidth / 2;
          else if (startOn == 3)
            offset = (checkIn['index'] ?? k) == 0 ? 0 : dayWidth / 2;
          double left = i * dayWidth + offset;
          bool isMaintenanceDay =
              (checkIn['maintenanceBlockId'] ?? 0) > 0 ||
              (dayData['isCheckinDate'] ?? 0) == 3;
          Widget barChild;
          if (isMaintenanceDay) {
            guestName = checkIn['guestName'] ?? '';
            guestColor = Color(int.parse(colorCode.replaceFirst('#', '0xFF')))!;
            barChild = Row(
              children: [
                Icon(
                  Icons.build,
                  size: _indicatorIconSize,
                  color: Colors.white,
                ),
                const SizedBox(width: 4),
                Text(
                  guestName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            );
          } else if (isGroup) {
            guestName = checkIn['guestName'] ?? '';
            Color iconColor = Color(
              int.tryParse(groupColor?.replaceFirst('#', '0xFF') ?? '') ??
                  0xFF000000,
            );
            barChild = Row(
              children: [
                Icon(Icons.star, size: _indicatorIconSize, color: iconColor),
                const SizedBox(width: 2),
                if (isGroupLeader)
                  Icon(
                    Icons.person,
                    size: _indicatorIconSize,
                    color: AppColors.darkgrey,
                  ),
                const SizedBox(width: 2),
                Text(
                  guestName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            );
          } else if (colorCode == "#fdf51c") {
            guestName = checkIn['guestName'] ?? '';

            barChild = Row(
              children: [
                Icon(
                  Icons.open_in_new,
                  size: _indicatorIconSize,
                  color: AppColors.darkgrey,
                ),
                const SizedBox(width: 2),
                Text(
                  guestName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            );
          } else {
            barChild = Text(
              guestName,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
              overflow: TextOverflow.ellipsis,
            );
          }
          reservationBars.add(
            Positioned(
              left: left,
              top: (_rowHeight! - _barHeight!) / 2,
              child: InkWell(
                onTap: () {
                  if (guestName == 'BLOCKED') {
                    _handleMaintenanceBlockTap(item, days, section, checkIn, i);
                    return;
                  }
                  if (colorCode == "#fdf51c") {
                    _handleDayUseTap(item, days, section, checkIn, i);
                    return;
                  } else {
                    _handleGuestTap(item, days, section, checkIn, i);
                    return;
                  }
                },
                child: Container(
                  width: barWidth,
                  height: _barHeight,
                  decoration: BoxDecoration(
                    color: guestColor,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  alignment: Alignment.centerLeft,
                  child: barChild,
                ),
              ),
            ),
          );
        }
      }
    }

    final List<Widget> backgroundDayCells = List.generate(numDays, (index) {
      return Expanded(
        child: Container(
          height: _rowHeight,
          decoration: BoxDecoration(
            border: Border(
              left: BorderSide(
                color: index == 0 ? Colors.transparent : Colors.grey[200]!,
              ),
            ),
          ),
        ),
      );
    });

    List<Widget> indicators = [];
    if (item['isSmokingRoom'] ?? false) {
      indicators.add(
        Icon(Icons.smoking_rooms, size: 14, color: Colors.grey[700]),
      );
    } else {
      indicators.add(Icon(Icons.smoke_free, size: 14, color: Colors.grey[700]));
    }

    if (item['isDirty'] ?? false) {
      indicators.add(
        Icon(Icons.cleaning_services, size: 14, color: Colors.grey[700]),
      );
    }

    final content = Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(top: BorderSide(color: Colors.grey[100]!, width: 1)),
          ),
          child: Row(
            children: [
              Container(
                width: roomWidth,
                height: _rowHeight,
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(left: namePaddingLeft),
                child: Row(
                  children: [
                    Expanded(
                      child: Tooltip(
                        message: 'Room: $name',
                        child: Text(
                          name,
                          style: nameStyle,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    ...indicators,
                  ],
                ),
              ),
              Expanded(
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Row(children: backgroundDayCells),
                    ...reservationBars,
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );

    return content;
  }

  void _handleGuestTap(
    Map<String, dynamic> item,
    List<DateTime> days,
    Map<String, dynamic> section,
    Map<String, dynamic> checkIn,
    int startIndex,
  ) async {
    final String guestName = checkIn['guestName'];
    final int bookingRoomId = checkIn['bookingRoomId'];
    final DateTime startDate = days[startIndex];
    final double nights = checkIn['noOfNights'] ?? 1.0;
    final DateTime endDate = startDate.add(Duration(days: nights.toInt()));
    final String roomNumber = item['roomNo'];
    final int status = checkIn['status'] ?? 0;

    await _reservationVm.getAllGuestData(bookingRoomId.toString());
    final guestItem = _reservationVm.allGuestDetails.value;
    context.push(AppRoutes.viewReservation, extra: guestItem);
  }

  void _handleMaintenanceBlockTap(
    Map<String, dynamic> item,
    List<DateTime> days,
    Map<String, dynamic> section,
    Map<String, dynamic> checkIn,
    int startIndex,
  ) async {
    final String guestName = checkIn['guestName'];
    final maintenanceBlockId = checkIn['maintenanceBlockId'];

    await _stayViewVm.loadMaintenanceBlockData(maintenanceBlockId);
    print(_stayViewVm.maintenanceBlockData.value);

    showDialog(
      context: context,
      builder: (_) => MaintenanceBlockDialog(
        blockItem: _stayViewVm.maintenanceBlockData.value!,
        onUnblock: () async {
          await _stayViewVm.unblockBlock(maintenanceBlockId);
        },
      ),
    );
  }

  void _handleDayUseTap(
    Map<String, dynamic> item,
    List<DateTime> days,
    Map<String, dynamic> section,
    Map<String, dynamic> checkIn,
    int startIndex,
  ) async {
    final String guestName = checkIn['guestName'];
    final int bookingRoomId = checkIn['bookingRoomId'];
    final DateTime startDate = days[startIndex];
    final double nights = checkIn['noOfNights'] ?? 1.0;
    final DateTime endDate = startDate.add(Duration(days: nights.toInt()));
    final String roomNumber = item['roomNo'];
    final int status = checkIn['status'] ?? 0;

    final String arrivalDate = "${formatArrivalDate(startDate)} 00:00";
    final String departureDate =
        "${formatArrivalDate(startDate.add(Duration(days: 1)))} 00:00";

    final payload = {
      "ArrivalDate": arrivalDate,
      "departureDate": departureDate,
      "RoomId": item["roomId"],
      "RoomTypeId": section["roomTypeId"],
    };

    await _stayViewVm.loadAllDayUseList(payload);

    showDialog(
      context: context,
      builder: (_) => DayUseListDialog(
        dayUseList: _stayViewVm.datUseList,
        onViewReservation: (item) async {
          await _reservationVm.getAllGuestData(item.bookingRoomId.toString());
          final guestItem = _reservationVm.allGuestDetails.value;
          context.push(AppRoutes.viewReservation, extra: guestItem);
        },
      ),
    );
  }

  String formatArrivalDate(DateTime date) {
    return "${date.year.toString().padLeft(4, '0')}-"
        "${date.month.toString().padLeft(2, '0')}-"
        "${date.day.toString().padLeft(2, '0')}";
  }
}
