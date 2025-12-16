import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:inta_mobile_pms/core/config/responsive_config.dart';
import 'package:inta_mobile_pms/core/theme/app_text_theme.dart';
import 'package:inta_mobile_pms/core/widgets/custom_appbar.dart';
import 'package:inta_mobile_pms/features/reservations/viewmodels/reservation_vm.dart';
import 'package:inta_mobile_pms/features/stay_view/viewmodels/stay_view_vm.dart';
import 'package:inta_mobile_pms/router/app_routes.dart';
import 'package:intl/intl.dart';
import 'package:inta_mobile_pms/core/theme/app_colors.dart';
import 'package:shimmer/shimmer.dart';

class StayViewPageScreen extends StatefulWidget {
  const StayViewPageScreen({super.key});

  @override
  State<StayViewPageScreen> createState() => _StayViewPageScreenState();
}

class _StayViewPageScreenState extends State<StayViewPageScreen> {
  final _stayViewVm = Get.find<StayViewVm>();
  final _reservationVm = Get.find<ReservationVm>();
  DateTime _centerDate = DateTime.now();
  double? _rowHeight = 40;
  double? _barHeight = 35;

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
                      // const SizedBox(height: 12),
                      // _buildIndicatorRow(
                      //   Icons.link,
                      //   'Connected Rooms',
                      //   Colors.grey[700]!,
                      // ),
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

  Widget _buildInfoItem(String title, String description, IconData icon) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 20, color: AppColors.primary),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey[700],
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = AppTextTheme.lightTextTheme;
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
      appBar: CustomAppBar(title: 'Stay View', onInfoTap: _showInfoDialog),
      body: Stack(
        children: [
          // MAIN CONTENT
          RefreshIndicator(
            onRefresh: () async {
              await Future.delayed(const Duration(seconds: 1));
            },
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              children: [
                _buildDateNavigator(textTheme),

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
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildHeaderRow(
                              roomWidth,
                              dayWidth,
                              dayLabels,
                              textTheme,
                              days,
                            ),
                            const SizedBox(height: 12),

                            Obx(() {
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
                            }),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          Obx(() {
            if (!_reservationVm.isBottomSheetDataLoading.value) {
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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Colors.grey[200]!, width: 1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            icon: Icon(Icons.chevron_left, color: Colors.grey[700]),
            onPressed: () {
              setState(() {
                _centerDate = _centerDate.subtract(const Duration(days: 1));
              });
              _stayViewVm.loadInitialData(_centerDate);
            },
            tooltip: 'Previous Day',
            style: IconButton.styleFrom(
              backgroundColor: Colors.grey[100],
              padding: const EdgeInsets.all(8),
            ),
          ),
          const SizedBox(width: 16),
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
                setState(() {
                  _centerDate = picked;
                });
                _stayViewVm.loadInitialData(_centerDate);
              }
            },
            borderRadius: BorderRadius.circular(8),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.calendar_today, size: 16, color: Colors.grey[700]),
                  const SizedBox(width: 8),
                  Text(
                    DateFormat('MMM d, yyyy').format(_centerDate),
                    style: textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[900],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 16),
          IconButton(
            icon: Icon(Icons.chevron_right, color: Colors.grey[700]),
            onPressed: () {
              setState(() {
                _centerDate = _centerDate.add(const Duration(days: 1));
              });
              _stayViewVm.loadInitialData(_centerDate);
            },
            tooltip: 'Next Day',
            style: IconButton.styleFrom(
              backgroundColor: Colors.grey[100],
              padding: const EdgeInsets.all(8),
            ),
          ),
          const SizedBox(width: 24),
          ElevatedButton.icon(
            onPressed: () {
              setState(() {
                _centerDate = _stayViewVm.today.value ?? DateTime.now();
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            icon: const Icon(Icons.today, size: 18),
            label: const Text(
              'Today',
              style: TextStyle(fontWeight: FontWeight.w500),
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
                'Room / Guest',
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
                            // showDialog(
                            //   context: context,
                            //   builder: (context) {
                            //     return BookingRoomDialog(
                            //       bookingRooms: bookingRoomsList,
                            //       onAssign: (booking, selectedRoom) {
                            //         Navigator.pop(context);
                            //       },
                            //       onCancel: () {
                            //         Navigator.pop(context);
                            //       },
                            //     );
                            //   },
                            // );
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
                Icon(Icons.build, size: 25, color: Colors.white),
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
              int.parse(groupColor.replaceFirst('#', '0xFF')),
            )!;
            barChild = Row(
              children: [
                Icon(Icons.star, size: 25, color: iconColor),
                const SizedBox(width: 2),
                if (isGroupLeader)
                  Icon(Icons.person, size: 25, color: AppColors.darkgrey),
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
                Icon(Icons.open_in_new, size: 30, color: AppColors.darkgrey),
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
              top: (_rowHeight! - _barHeight!) / 2 ,
              child: InkWell(
                onTap: () {
                  if (guestName == 'BLOCKED') return;
                  _handleGuestTap(item, days, section, checkIn, i);
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
          height: 48,
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

    // Add room indicators
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
    // Add more indicators as needed based on data

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

    // if(status == 0){
    //   return;
    // }

    await _reservationVm.getAllGuestData(bookingRoomId.toString());
    final guestItem = _reservationVm.allGuestDetails.value;
    context.push(AppRoutes.viewReservation, extra: guestItem);
  }
}
