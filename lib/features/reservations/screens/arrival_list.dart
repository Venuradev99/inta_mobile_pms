import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:inta_mobile_pms/core/widgets/custom_appbar.dart';
import 'package:inta_mobile_pms/features/dashboard/widgets/filter_bottom_sheet.dart';
import 'package:inta_mobile_pms/features/dashboard/widgets/tabbed_list_view.dart';
import 'package:inta_mobile_pms/features/reservations/models/guest_item.dart';
import 'package:inta_mobile_pms/features/reservations/screens/view_reservation.dart';
import 'package:inta_mobile_pms/features/reservations/widgets/action_bottom_sheet.dart';
import 'package:inta_mobile_pms/features/reservations/widgets/guest_card.dart';
import 'package:inta_mobile_pms/features/reservations/widgets/status_info_dialog.dart';
import 'package:inta_mobile_pms/router/app_routes.dart';

class ArrivalList extends StatefulWidget {
  const ArrivalList({super.key});

  @override
  State<ArrivalList> createState() => _ArrivalListState();
}

class _ArrivalListState extends State<ArrivalList> {
  late Map<String, List<GuestItem>> arrivalsMap;

  @override
  void initState() {
    super.initState();
    arrivalsMap = _getArrivalsMap();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Arrival List',
        onInfoTap: () => _showInfoDialog(context),
        onFilterTap: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (context) => DraggableScrollableSheet(
              initialChildSize: 0.8,
              minChildSize: 0.5,
              maxChildSize: 0.95,
              builder: (context, scrollController) => FilterBottomSheet(
                type: 'arrival',
                onApply: _applyArrivalFilters,
                scrollController: scrollController,
              ),
            ),
          );
        },
      ),
      body: TabbedListView<GuestItem>(
        tabLabels: const ['Today', 'Tomorrow', 'This Week'],
        dataMap: arrivalsMap,
        itemBuilder: (item) => _buildArrivalCard(item),
        emptySubMessage: (period) => 'No arrivals scheduled for this period',
      ),
    );
  }

  void _applyArrivalFilters(Map<String, dynamic> filters) {
    var fullData = _getArrivalsMap();

    DateTime? startDate = filters['startDate'];
    DateTime? endDate = filters['endDate'];
    String? roomType = filters['roomType'] != 'All' ? filters['roomType'] : null;
    String? reservationType = filters['reservationType'] != 'All' ? filters['reservationType'] : null;
    bool guestCheckedInToday = filters['guestCheckedInToday'] ?? false;

    Map<String, List<GuestItem>> filteredMap = {};
    fullData.forEach((tab, items) {
      filteredMap[tab] = items.where((item) {
        DateTime itemStart = _parseMockDate(item.startDate);
        bool dateMatch = true;
        if (startDate != null && endDate != null) {
          dateMatch = itemStart.isAfter(startDate.subtract(const Duration(days: 1))) &&
              itemStart.isBefore(endDate.add(const Duration(days: 1)));
        }

        bool roomMatch = roomType == null || item.roomType == roomType;
        bool checkedInMatch = !guestCheckedInToday || (tab == 'today' && itemStart == DateTime.now());

        return dateMatch && roomMatch && checkedInMatch;
      }).toList();
    });

    setState(() {
      arrivalsMap = filteredMap;
    });
  }

  DateTime _parseMockDate(String dateStr) {
    final parts = dateStr.split(' ');
    final month = _monthToInt(parts[0]);
    final day = int.parse(parts[1]);
    return DateTime(2025, month, day);
  }

  int _monthToInt(String month) {
    const months = {
      'Jan': 1, 'Feb': 2, 'Mar': 3, 'Apr': 4, 'May': 5, 'Jun': 6,
      'Jul': 7, 'Aug': 8, 'Sep': 9, 'Oct': 10, 'Nov': 11, 'Dec': 12,
    };
    return months[month] ?? 1;
  }

  void _showInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => StatusInfoDialog(
        title: 'Arrival Status',
        statusItems: const [
          StatusItem(
            status: 'Arrival',
            description: 'Guests expected to arrive today',
            color: Color(0xFF4CAF50),
            icon: Icons.login,
          ),
          StatusItem(
            status: 'Confirm Reservation',
            description: 'Reservations that need confirmation',
            color: Color(0xFFFF9800),
            icon: Icons.check_circle_outline,
          ),
          StatusItem(
            status: 'Unconfirmed Reservation',
            description: 'Reservations awaiting confirmation',
            color: Color(0xFFF44336),
            icon: Icons.schedule,
          ),
          StatusItem(
            status: 'Dayuse Reservation',
            description: 'Day-use bookings for today',
            color: Color(0xFF2196F3),
            icon: Icons.today,
          ),
          StatusItem(
            status: 'Day Used',
            description: 'Completed day-use reservations',
            color: Color(0xFF9E9E9E),
            icon: Icons.task_alt,
          ),
        ],
      ),
    );
  }

  Widget _buildArrivalCard(GuestItem item) {
    return GuestCard(
      guestName: item.guestName,
      resId: item.resId,
      folioId: item.folioId,
      startDate: item.startDate,
      endDate: item.endDate,
      nights: item.nights,
      nightsLabel: 'Nights Stay',
      adults: item.adults,
      totalAmount: item.totalAmount,
      balanceAmount: item.balanceAmount,
      actionButton: const SizedBox(height: 32),
      onTap: () => _showActions(context, item),
    );
  }

  

  // Alternative: If you want to use GoRouter with state passing
  void _navigateToViewReservationWithGoRouter(GuestItem item) {
    // Store the item temporarily (you might want to use a state management solution)
    context.go(AppRoutes.viewReservation, extra: item);
  }

  void _showActions(BuildContext context, GuestItem item) {
    showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => ActionBottomSheet(
        guestName: item.guestName,
        actions: [
          ActionItem(
            icon: Icons.visibility,
            label: 'View Reservation',
            onTap: () {
              Navigator.of(context).pop(); // Close bottom sheet first
              _navigateToViewReservationWithGoRouter(item); // Then navigate with proper data
            },
          ),
          ActionItem(
            icon: Icons.meeting_room,
            label: 'Assign Rooms',
            onTap: () {
              Navigator.of(context).pop();
              context.go(AppRoutes.maintenanceBlock);
            },
          ),
          ActionItem(
            icon: Icons.edit_calendar,
            label: 'Amend Stay',
            onTap: () {
              Navigator.of(context).pop();
              context.go(AppRoutes.maintenanceBlock);
            },
          ),
          ActionItem(
            icon: Icons.swap_horiz,
            label: 'Change Reservation Type',
            onTap: () {
              Navigator.of(context).pop();
              context.go(AppRoutes.maintenanceBlock);
            },
          ),
          ActionItem(
            icon: Icons.cancel,
            label: 'Cancel Reservation',
            onTap: () {
              Navigator.of(context).pop();
              context.go(AppRoutes.maintenanceBlock);
            },
          ),
          ActionItem(
            icon: Icons.block,
            label: 'Void Reservation',
            onTap: () {
              Navigator.of(context).pop();
              context.go(AppRoutes.maintenanceBlock);
            },
          ),
          ActionItem(
            icon: Icons.person,
            label: 'Edit Guest Details',
            onTap: () {
              Navigator.of(context).pop();
              context.go(AppRoutes.maintenanceBlock);
            },
          ),
          ActionItem(
            icon: Icons.receipt,
            label: 'Print Invoice',
            onTap: () {
              Navigator.of(context).pop();
              context.go(AppRoutes.maintenanceBlock);
            },
          ),
          ActionItem(
            icon: Icons.description,
            label: 'Print Res. Voucher',
            onTap: () {
              Navigator.of(context).pop();
              context.go(AppRoutes.maintenanceBlock);
            },
          ),
          ActionItem(
            icon: Icons.email,
            label: 'Send Res. Voucher',
            onTap: () {
              Navigator.of(context).pop();
              context.go(AppRoutes.maintenanceBlock);
            },
          ),
          ActionItem(
            icon: Icons.email,
            label: 'Resend Booking Email',
            onTap: () {
              Navigator.of(context).pop();
              context.go(AppRoutes.maintenanceBlock);
            },
          ),
        ],
      ),
    );
  }

  Map<String, List<GuestItem>> _getArrivalsMap() {
    return {
      'today': [
        GuestItem(
          guestName: 'Mr. John Doe',
          resId: 'BH3000',
          folioId: '3001',
          startDate: 'Sep 23',
          endDate: 'Sep 25',
          nights: 2,
          roomType: 'Double Room',
          adults: 2,
          totalAmount: 200.00,
          balanceAmount: 100.00,
        ),
      ],
      'tomorrow': [
        GuestItem(
          guestName: 'Mr. Dilini',
          resId: 'BH2800',
          folioId: '2253',
          startDate: 'Sep 24',
          endDate: 'Sep 25',
          nights: 1,
          roomType: 'Bunk Bed',
          adults: 1,
          totalAmount: 131.00,
          balanceAmount: 131.00,
        ),
        GuestItem(
          guestName: 'Ms. Pabasara Dissanayake',
          resId: 'BH2827',
          folioId: '2290',
          startDate: 'Sep 24',
          endDate: 'Sep 27',
          nights: 3,
          roomType: 'Double Room new /142',
          adults: 1,
          totalAmount: 0.00,
          balanceAmount: 0.00,
        ),
      ],
      'this week': [
        GuestItem(
          guestName: 'Ms. Jane Smith',
          resId: 'BH2900',
          folioId: '2400',
          startDate: 'Sep 26',
          endDate: 'Sep 28',
          nights: 2,
          roomType: 'Suite',
          adults: 3,
          totalAmount: 300.00,
          balanceAmount: 0.00,
        ),
      ],
    };
  }
}