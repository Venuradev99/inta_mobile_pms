import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:inta_mobile_pms/core/config/responsive_config.dart';
import 'package:inta_mobile_pms/core/theme/app_text_theme.dart';
import 'package:inta_mobile_pms/core/widgets/custom_appbar.dart';
import 'package:inta_mobile_pms/features/reservations/screens/view_reservation_scrn.dart';
import 'package:inta_mobile_pms/features/stay_view/viewmodels/stay_view_vm.dart';
import 'package:intl/intl.dart';
import 'package:inta_mobile_pms/core/theme/app_colors.dart';
import 'package:inta_mobile_pms/features/reservations/models/guest_item.dart';

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
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (mounted) {
        await _stayViewVm.loadInitialData();
      }
    });
  }

  void _showInfoDialog() {
    List<Map<String, dynamic>> statuses = _stayViewVm.statusList
        .map((status) => {'label': status.label, 'color': status.color})
        .toList();

    // [
    //   {'label': 'Arrival', 'color': const Color(0xFF00838F)},
    //   {'label': 'Checked Out', 'color': const Color(0xFFD32F2F)},
    //   {'label': 'Due Out', 'color': const Color(0xFF00BCD4)},
    //   {'label': 'Confirm Reservation', 'color': const Color(0xFF4CAF50)},
    //   {'label': 'Maintenance Block', 'color': const Color(0xFF616161)},
    //   {'label': 'Stayover', 'color': const Color(0xFF9C27B0)},
    //   {'label': 'Dayuse Reservation', 'color': const Color(0xFFFF8F00)},
    //   {'label': 'Day Used', 'color': const Color(0xFFFFD600)},
    // ];


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
                      _buildLegendItem('Inventory', Colors.pink[100]!),
                      const SizedBox(height: 12),
                      _buildLegendItem('Unassigned Room', Colors.blue[100]!),
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

    // Dynamic width calculation: 35% for room names, 65% distributed among 3 days
    final double roomWidth = availableWidth * 0.35;
    final double dayWidth = (availableWidth * 0.65) / 3;
    final double totalWidth = availableWidth;

    final List<DateTime> days = [
      _centerDate.subtract(const Duration(days: 1)),
      _centerDate,
      _centerDate.add(const Duration(days: 1)),
    ];

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
                          ),
                          const SizedBox(height: 12),
                          ..._buildRoomSections(
                            roomWidth,
                            dayWidth,
                            textTheme,
                            days,
                          ),
                          const SizedBox(height: 20),
                          _buildOccupancyCard(roomWidth, dayWidth, [
                            50,
                            60,
                            70,
                          ], textTheme),
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
              return Expanded(
                child: Container(
                  width: dayWidth,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: isToday ? AppColors.primary.withOpacity(0.08) : null,
                    border: Border(left: BorderSide(color: Colors.grey[200]!)),
                  ),
                  child: Text(
                    dayLabels[index],
                    style: textTheme.bodySmall!.copyWith(
                      fontWeight: FontWeight.w600,
                      color: isToday ? AppColors.primary : Colors.grey[700],
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
    final List<Map<String, dynamic>> roomTypes = [
      {
        'name': 'Bunk Bed',
        'items': [
          {
            'type': 'room',
            'name': '4',
            'statuses': [5, 5, 5],
            'color': const Color(0xFFFFC0CB),
          },
          {
            'type': 'room',
            'name': '501-1',
            'statuses': [null, null, null],
            'color': null,
          },
          {
            'type': 'room',
            'name': '501-2',
            'statuses': [null, null, null],
            'color': null,
          },
          {'type': 'maintenance', 'name': '501-3'},
          {
            'type': 'room',
            'name': '501-4',
            'statuses': [null, null, null],
            'color': null,
          },
          {
            'type': 'room',
            'name': '501-5',
            'statuses': [null, null, null],
            'color': null,
          },
          {
            'type': 'room',
            'name': '501-6',
            'statuses': [null, null, null],
            'color': null,
          },
        ],
      },
      {
        'name': 'Double Room new',
        'items': [
          {
            'type': 'room',
            'name': 'KC5',
            'statuses': [7, 7, 1],
            'color': const Color(0xFFBBDEFB),
          },
          {
            'type': 'room',
            'name': 'Test',
            'statuses': [null, null, null],
            'color': null,
          },
          {
            'type': 'room',
            'name': 'TT V',
            'statuses': [null, null, null],
            'color': null,
          },
          {
            'type': 'guest',
            'name': 'Ms. Palasar..',
            'color': AppColors.purple,
            'statuses': [false, false, true],
          },
          {
            'type': 'room',
            'name': '142',
            'statuses': [null, null, null],
            'color': null,
          },
          {
            'type': 'room',
            'name': '141',
            'statuses': [null, null, null],
            'color': null,
          },
          {
            'type': 'room',
            'name': '140',
            'statuses': [null, null, null],
            'color': null,
          },
          {
            'type': 'guest',
            'name': 'Ms. Vindhya Keert.',
            'color': AppColors.green,
            'statuses': [false, true, true],
          },
          {
            'type': 'room',
            'name': '139',
            'statuses': [null, null, null],
            'color': null,
          },
          {
            'type': 'room',
            'name': '138',
            'statuses': [null, null, null],
            'color': null,
          },
          {
            'type': 'room',
            'name': '137',
            'statuses': [null, null, null],
            'color': null,
          },
          {
            'type': 'guest',
            'name': 'Ms. K.',
            'color': AppColors.green,
            'statuses': [true, false, false],
          },
        ],
      },
      {
        'name': 'Gami Gedara',
        'items': [
          {
            'type': 'room',
            'name': '01',
            'statuses': [5, 5, 5],
            'color': const Color(0xFFFFC0CB),
          },
          {
            'type': 'room',
            'name': '02',
            'statuses': [null, null, null],
            'color': null,
          },
          {
            'type': 'room',
            'name': '03',
            'statuses': [null, null, null],
            'color': null,
          },
        ],
      },
      {
        'name': 'Super Deluxe Single Room',
        'items': [
          {
            'type': 'room',
            'name': '301',
            'statuses': [2, 2, 3],
            'color': const Color(0xFFE0F7FA),
          },
          {
            'type': 'room',
            'name': '302',
            'statuses': [null, null, null],
            'color': null,
          },
        ],
      },
      {
        'name': 'Family Suite',
        'items': [
          {
            'type': 'room',
            'name': 'Child Room2',
            'statuses': [4, 4, 4],
            'color': const Color(0xFFFFF9C4),
          },
          {
            'type': 'room',
            'name': 'Family Villa',
            'statuses': [null, null, null],
            'color': null,
          },
          {
            'type': 'room',
            'name': 'Temp room',
            'statuses': [null, null, null],
            'color': null,
          },
        ],
      },
      {
        'name': 'Utility',
        'items': [
          {
            'type': 'room',
            'name': '105',
            'statuses': [null, null, null],
            'color': null,
          },
        ],
      },
    ];

    return roomTypes.map((section) {
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
                    '${section['items'].length}',
                    style: textTheme.labelSmall?.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  section['name'],
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
            children: section['items'].map<Widget>((item) {
              return _buildItemRow(item, roomWidth, dayWidth, textTheme, days);
            }).toList(),
          ),
        ),
      );
    }).toList();
  }

  Widget _buildItemRow(
    Map<String, dynamic> item,
    double roomWidth,
    double dayWidth,
    TextTheme textTheme,
    List<DateTime> days,
  ) {
    final String name = item['name'];
    final String type = item['type'];
    final bool isGuest = type == 'guest';
    final bool isMaintenance = type == 'maintenance';
    final Color? color = item['color'];
    final List<dynamic>? statuses = item['statuses'];

    final double namePaddingLeft = isGuest ? 32.0 : 16.0;

    TextStyle nameStyle = textTheme.bodyMedium!.copyWith(
      fontWeight: isGuest ? FontWeight.w500 : FontWeight.w400,
      letterSpacing: -0.1,
    );

    if (isGuest) {
      nameStyle = nameStyle.copyWith(color: color);
    } else {
      nameStyle = nameStyle.copyWith(color: Colors.grey[800]);
    }

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
    } else if (isGuest) {
      for (int i = 0; i < (statuses! as List<bool>).length; i++) {
        final occupied = statuses[i];
        dayCells.add(
          Expanded(
            child: Container(
              height: 48,
              decoration: BoxDecoration(
                color: occupied ? color?.withOpacity(0.15) : null,
                border: Border(left: BorderSide(color: Colors.grey[200]!)),
              ),
              child: occupied
                  ? Container(
                      margin: const EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 8,
                      ),
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.circular(6),
                      ),
                    )
                  : null,
            ),
          ),
        );
      }
    } else {
      for (int i = 0; i < statuses!.length; i++) {
        final status = statuses[i];
        dayCells.add(
          Expanded(
            child: Container(
              height: 48,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                border: Border(left: BorderSide(color: Colors.grey[200]!)),
              ),
              child: status == null
                  ? const SizedBox.shrink()
                  : Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.06),
                            blurRadius: 4,
                            offset: const Offset(0, 1),
                          ),
                        ],
                      ),
                      child: Text(
                        status.toString(),
                        style: TextStyle(
                          color: Colors.grey[900],
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
            ),
          ),
        );
      }
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
                height: 48,
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(left: namePaddingLeft),
                child: Row(
                  children: [
                    if (isGuest)
                      Container(
                        width: 6,
                        height: 6,
                        margin: const EdgeInsets.only(right: 8),
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                        ),
                      ),
                    Expanded(
                      child: Tooltip(
                        message: isGuest ? 'Guest: $name' : 'Room: $name',
                        child: Text(
                          isGuest ? name : '$name ₩',
                          style: nameStyle,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              ...dayCells,
            ],
          ),
        ),
      ],
    );

    return isGuest
        ? InkWell(
            onTap: () => _handleGuestTap(item, days),
            splashColor: AppColors.primary.withOpacity(0.1),
            highlightColor: AppColors.primary.withOpacity(0.05),
            child: content,
          )
        : content;
  }

  void _handleGuestTap(Map<String, dynamic> item, List<DateTime> days) {
    final String name = item['name'];
    final List<bool> occupied = item['statuses'] as List<bool>;

    int? startIndex, endIndex;
    for (int i = 0; i < occupied.length; i++) {
      if (occupied[i]) {
        startIndex ??= i;
        endIndex = i;
      }
    }

    if (startIndex == null) return; // No occupancy, do nothing

    final DateTime startDate = days[startIndex];
    final DateTime endDate = days[endIndex!].add(const Duration(days: 1));
    final int nights = endIndex - startIndex + 1;

    String roomNumber;
    switch (name) {
      case 'Ms. Palasar..':
        roomNumber = 'TT V';
        break;
      case 'Ms. Vindhya Keert.':
        roomNumber = '140';
        break;
      case 'Ms. K.':
        roomNumber = '137';
        break;
      default:
        roomNumber = 'Unknown';
    }

    final guestItem = GuestItem(
      guestName: name,
      startDate: DateFormat('MMM d, yyyy').format(startDate),
      endDate: DateFormat('MMM d, yyyy').format(endDate),
      nights: nights,
      roomNumber: roomNumber,
      roomType: 'Double Room new',
      reservationType: 'Dinner Only',
      avgDailyRate: 3125.0 / nights,
      totalAmount: 3660.0,
      totalCredits: 3660.0,
      balanceAmount: 0.0,
      adults: 1,
      children: 0,
      phone: '+94 123 456789',
      mobile: '+94 987 654321',
      email: 'guest@example.com',
      idType: 'Passport',
      idNumber: 'N1234567',
      expiryDate: '2028-12-31',
      dob: '1990-01-01',
      nationality: 'Sri Lanka',
      arrivalBy: 'Flight',
      departureBy: 'Flight',
      businessSource: 'Direct',
      company: 'N/A',
      travelAgent: 'N/A',
      childAge: null,
      roomCharges: 3125.0,
      discount: 0.0,
      tax: 531.25,
      adjustment: 3.75,
      netAmount: 3660.0,
      folioId: '12345',
      remarks: 'No special requests.',
      folioCharges: [],
      bookingRoomId: '',
      resId:
          '', // Use empty list for demo; populate with FolioCharge instances if class is defined
    );

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ViewReservation(item: guestItem)),
    );
  }

  Widget _buildOccupancyCard(
    double roomWidth,
    double dayWidth,
    List<int> occupancies,
    TextTheme textTheme,
  ) {
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
