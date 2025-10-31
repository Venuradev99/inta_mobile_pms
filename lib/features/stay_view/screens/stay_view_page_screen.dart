import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:inta_mobile_pms/core/config/responsive_config.dart';
import 'package:inta_mobile_pms/core/theme/app_text_theme.dart';
import 'package:inta_mobile_pms/core/widgets/custom_appbar.dart';
import 'package:inta_mobile_pms/features/reservations/screens/view_reservation_scrn.dart';
import 'package:inta_mobile_pms/features/stay_view/viewmodels/stay_view_vm.dart';
import 'package:inta_mobile_pms/router/app_routes.dart';
import 'package:intl/intl.dart';
import 'package:inta_mobile_pms/core/theme/app_colors.dart';
import 'package:inta_mobile_pms/features/reservations/models/guest_item.dart';
import 'package:shimmer/shimmer.dart';

class StayViewPageScreen extends StatefulWidget {
  const StayViewPageScreen({super.key});

  @override
  State<StayViewPageScreen> createState() => _StayViewPageScreenState();
}

class _StayViewPageScreenState extends State<StayViewPageScreen> {
  final _stayViewVm = Get.find<StayViewVm>();
  DateTime _centerDate = DateTime(2025, 10, 29);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _stayViewVm.loadToday();
      _stayViewVm.loadInitialData(_centerDate);
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
                        Icons.call_split,
                        'Split Reservation',
                        const Color(0xFF00BCD4),
                      ),
                      const SizedBox(height: 12),
                      _buildIndicatorRow(
                        Icons.groups,
                        'Group Owner',
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
                      _buildIndicatorRow(
                        Icons.link,
                        'Connected Rooms',
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

    // Dynamic width calculation: 35% for room names, 65% distributed among days
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
      body: RefreshIndicator(
        onRefresh: () async {
          await Future.delayed(const Duration(seconds: 1));
        },
        child: SingleChildScrollView(
          child: Column(
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
                        _centerDate = _centerDate.add(const Duration(days: 1));
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
                            return _stayViewVm.isLoading.value == true
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
                          // const SizedBox(height: 20),
                          // _buildOccupancyCard(
                          //   roomWidth,
                          //   dayWidth,
                          //   days,
                          //   textTheme,
                          // ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // List<Widget> _buildRoomSectionsShimmer(double roomWidth, double dayWidth) {
  //   return List.generate(3, (index) {
  //     return Container(
  //       margin: const EdgeInsets.only(bottom: 12),
  //       decoration: BoxDecoration(
  //         color: Colors.white,
  //         borderRadius: BorderRadius.circular(12),
  //         border: Border.all(color: Colors.grey[200]!),
  //         boxShadow: [
  //           BoxShadow(
  //             color: Colors.black.withOpacity(0.02),
  //             blurRadius: 8,
  //             offset: const Offset(0, 2),
  //           ),
  //         ],
  //       ),
  //       child: Padding(
  //         padding: const EdgeInsets.all(16),
  //         child: Column(
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             // Header shimmer
  //             Row(
  //               children: [
  //                 Shimmer.fromColors(
  //                   baseColor: Colors.grey[300]!,
  //                   highlightColor: Colors.grey[100]!,
  //                   child: Container(
  //                     width: 30,
  //                     height: 24,
  //                     decoration: BoxDecoration(
  //                       color: Colors.white,
  //                       borderRadius: BorderRadius.circular(6),
  //                     ),
  //                   ),
  //                 ),
  //                 const SizedBox(width: 12),
  //                 Shimmer.fromColors(
  //                   baseColor: Colors.grey[300]!,
  //                   highlightColor: Colors.grey[100]!,
  //                   child: Container(
  //                     width: 120,
  //                     height: 16,
  //                     decoration: BoxDecoration(
  //                       color: Colors.white,
  //                       borderRadius: BorderRadius.circular(4),
  //                     ),
  //                   ),
  //                 ),
  //               ],
  //             ),
  //             const SizedBox(height: 16),
  //             // Availability row shimmer
  //             Row(
  //               children: [
  //                 Shimmer.fromColors(
  //                   baseColor: Colors.grey[300]!,
  //                   highlightColor: Colors.grey[100]!,
  //                   child: Container(
  //                     width: roomWidth,
  //                     height: 40,
  //                     decoration: BoxDecoration(
  //                       color: Colors.white,
  //                       borderRadius: BorderRadius.circular(4),
  //                     ),
  //                   ),
  //                 ),
  //                 const SizedBox(width: 8),
  //                 Expanded(
  //                   child: Row(
  //                     children: List.generate(7, (dayIndex) {
  //                       return Expanded(
  //                         child: Padding(
  //                           padding: const EdgeInsets.symmetric(horizontal: 2),
  //                           child: Shimmer.fromColors(
  //                             baseColor: Colors.grey[300]!,
  //                             highlightColor: Colors.grey[100]!,
  //                             child: Container(
  //                               height: 40,
  //                               decoration: BoxDecoration(
  //                                 color: Colors.white,
  //                                 borderRadius: BorderRadius.circular(4),
  //                               ),
  //                             ),
  //                           ),
  //                         ),
  //                       );
  //                     }),
  //                   ),
  //                 ),
  //               ],
  //             ),
  //             const SizedBox(height: 8),
  //             // Room rows shimmer
  //             ...List.generate(2, (rowIndex) {
  //               return Padding(
  //                 padding: const EdgeInsets.only(bottom: 8),
  //                 child: Row(
  //                   children: [
  //                     Shimmer.fromColors(
  //                       baseColor: Colors.grey[300]!,
  //                       highlightColor: Colors.grey[100]!,
  //                       child: Container(
  //                         width: roomWidth,
  //                         height: 50,
  //                         decoration: BoxDecoration(
  //                           color: Colors.white,
  //                           borderRadius: BorderRadius.circular(4),
  //                         ),
  //                       ),
  //                     ),
  //                     const SizedBox(width: 8),
  //                     Expanded(
  //                       child: Row(
  //                         children: List.generate(7, (dayIndex) {
  //                           return Expanded(
  //                             child: Padding(
  //                               padding: const EdgeInsets.symmetric(
  //                                 horizontal: 2,
  //                               ),
  //                               child: Shimmer.fromColors(
  //                                 baseColor: Colors.grey[300]!,
  //                                 highlightColor: Colors.grey[100]!,
  //                                 child: Container(
  //                                   height: 50,
  //                                   decoration: BoxDecoration(
  //                                     color: Colors.white,
  //                                     borderRadius: BorderRadius.circular(4),
  //                                   ),
  //                                 ),
  //                               ),
  //                             ),
  //                           );
  //                         }),
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //               );
  //             }),
  //           ],
  //         ),
  //       ),
  //     );
  //   });
  // }

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
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
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
                  padding: const EdgeInsets.symmetric(vertical: 16),
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
                        onTap: () {
                          // Handle avail button tap
                        },
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
                          onTap: () {
                            // Handle total button tap
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
      (dayData) => dayData['checkInExist'] != null,
    );

    // Process guest per day, spanning noOfNights
    final int numDays = days.length;
    List<Map<String, dynamic>?> guestPerDay = List.filled(numDays, null);
    for (int i = 0; i < numDays; i++) {
      final dayData = item['roomData'][i];
      if (dayData['checkInExist'] != null &&
          dayData['checkInExist'].isNotEmpty) {
        final checkIn = dayData['checkInExist'][0];
        final double nights = checkIn['noOfNights'] ?? 1.0;
        for (int j = 0; j < nights; j++) {
          if (i + j < numDays) {
            guestPerDay[i + j] = checkIn;
          }
        }
      }
    }

    final double namePaddingLeft = 16.0;

    TextStyle nameStyle = textTheme.bodyMedium!.copyWith(
      fontWeight: FontWeight.w400,
      letterSpacing: -0.1,
      color: Colors.grey[800],
    );

    final List<Widget> dayCells = [];
    if (isMaintenance) {
      dayCells.add(
        Expanded(
          flex: 3,
          child: Container(
            height: 48,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              border: Border(left: BorderSide(color: Colors.grey[200]!)),
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.orange[50],
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: Colors.orange[200]!),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.build, size: 14, color: Colors.orange[700]),
                  const SizedBox(width: 6),
                  Flexible(
                    child: Text(
                      'Maintenance',
                      style: TextStyle(
                        color: Colors.orange[700],
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    } else {
      for (int i = 0; i < numDays; i++) {
        final dayData = item['roomData'][i];
        Widget? child;
        Color? cellBgColor;
        if (guestPerDay[i] != null) {
          final checkIn = guestPerDay[i]!;
          final String guestName = checkIn['guestName'] ?? '';
          final String colorCode = checkIn['colorCode'] ?? '#000000';
          final Color guestColor = Color(
            int.parse(colorCode.replaceFirst('#', '0xFF')),
          );
          cellBgColor = guestColor.withOpacity(0.15);
          child = Container(
            margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 6),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: guestColor,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              guestName,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.w500,
                letterSpacing: -0.1,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          );
        } else if (!(dayData['available'] ?? true)) {
          cellBgColor = AppColors.onPrimary;
          child = const SizedBox.shrink(); // Or add text/icon if needed
        } else {
          child = const SizedBox.shrink();
        }
        dayCells.add(
          Expanded(
            child: Container(
              height: 48,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: cellBgColor,
                border: Border(left: BorderSide(color: Colors.grey[200]!)),
              ),
              child: child,
            ),
          ),
        );
      }
    }

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
                height: 48,
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
              ...dayCells,
            ],
          ),
        ),
      ],
    );

    return hasOccupancy
        ? InkWell(
            onTap: () => _handleGuestTap(item, days, section, guestPerDay),
            splashColor: AppColors.primary.withOpacity(0.1),
            highlightColor: AppColors.primary.withOpacity(0.05),
            child: content,
          )
        : content;
  }

  void _handleGuestTap(
    Map<String, dynamic> item,
    List<DateTime> days,
    Map<String, dynamic> section,
    List<Map<String, dynamic>?> guestPerDay,
  ) async {
    int? startIndex, endIndex;
    for (int i = 0; i < guestPerDay.length; i++) {
      if (guestPerDay[i] != null) {
        startIndex ??= i;
        endIndex = i;
      }
    }

    if (startIndex == null) return;

    final checkIn = guestPerDay[startIndex]!;
    final String guestName = checkIn['guestName'];
    final int bookingRoomId = checkIn['bookingRoomId'];
    final DateTime startDate = days[startIndex];
    final double nights = checkIn['noOfNights'] ?? 1.0;
    final DateTime endDate = startDate.add(Duration(days: nights.toInt()));
    final String roomNumber = item['roomNo'];

    await _stayViewVm.getAllGuestData(bookingRoomId);
    final guestItem = _stayViewVm.allGuestDetails.value;

     context.push(AppRoutes.viewReservation, extra: guestItem);
  }

  Widget _buildOccupancyCard(
    double roomWidth,
    double dayWidth,
    List<DateTime> days,
    TextTheme textTheme,
  ) {
    final List<Map<String, dynamic>> roomTypes = [
      {
        "roomTypeName": "Deluxe Queen",
        "roomTypeId": 1,
        "datas": [
          {
            "calenderDate": "2025-10-28T00:00:00",
            "availability": 3.00,
            "totalNoOfRooms": 4,
            "bookingRooms": [],
          },
          {
            "calenderDate": "2025-10-29T00:00:00",
            "availability": 2.00,
            "totalNoOfRooms": 4,
            "bookingRooms": [],
          },
          {
            "calenderDate": "2025-10-30T00:00:00",
            "availability": 2.00,
            "totalNoOfRooms": 4,
            "bookingRooms": [],
          },
        ],
        // ... rooms omitted for brevity
      },
      // Add more if needed
    ];

    final int numDays = days.length;
    List<int> occupancies = [];
    for (int i = 0; i < numDays; i++) {
      double totalRooms = 0.0;
      double totalAvailable = 0.0;
      for (var section in roomTypes) {
        final dayData = section['datas'][i];
        totalRooms += dayData['totalNoOfRooms'] ?? 0.0;
        totalAvailable += dayData['availability'] ?? 0.0;
      }
      final double occupancyPercent = totalRooms > 0
          ? ((totalRooms - totalAvailable) / totalRooms * 100).roundToDouble()
          : 0.0;
      occupancies.add(occupancyPercent.toInt());
    }

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary.withOpacity(0.05),
            AppColors.primary.withOpacity(0.02),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primary.withOpacity(0.2)),
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            Container(
              width: roomWidth,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              alignment: Alignment.centerLeft,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.analytics_outlined,
                    size: 20,
                    color: AppColors.primary,
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      'Occupancy',
                      style: textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                        letterSpacing: -0.2,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            ...occupancies.map(
              (o) => Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: Border(
                      left: BorderSide(
                        color: AppColors.primary.withOpacity(0.2),
                      ),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '$o%',
                        style: textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 4),
                        width: 32,
                        height: 3,
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(2),
                        ),
                        child: FractionallySizedBox(
                          alignment: Alignment.centerLeft,
                          widthFactor: o / 100,
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
