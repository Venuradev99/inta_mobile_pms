import 'package:flutter/material.dart';
import 'package:inta_mobile_pms/core/theme/app_colors.dart';
import 'package:inta_mobile_pms/features/reservations/models/guest_item.dart';
import 'package:inta_mobile_pms/features/reservations/widgets/action_bottom_sheet.dart';
import 'package:inta_mobile_pms/core/widgets/custom_appbar.dart';
import 'package:inta_mobile_pms/features/dashboard/widgets/filter_bottom_sheet.dart';
import 'package:inta_mobile_pms/features/reservations/widgets/guest_card.dart';
import 'package:inta_mobile_pms/features/reservations/widgets/status_info_dialog.dart';
import 'package:inta_mobile_pms/features/dashboard/widgets/tabbed_list_view.dart';

class DepartureList extends StatefulWidget {
  const DepartureList({super.key});

  @override
  State<DepartureList> createState() => _DepartureListState();
}

class _DepartureListState extends State<DepartureList> {
  late Map<String, List<GuestItem>> departuresMap;

  @override
  void initState() {
    super.initState();
    departuresMap = _getDeparturesMap();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        title: 'Departure List',
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
                type: 'departure',
                onApply: _applyDepartureFilters,
                scrollController: scrollController,  // Pass the controller
              ),
            ),
          );
        },
      ),
      body: TabbedListView<GuestItem>(
        tabLabels: const ['Today', 'Tomorrow', 'This Week'],
        dataMap: _getDeparturesMap(),
        itemBuilder: (item) => _buildDepartureCard(item),
        emptySubMessage: (period) => 'No departures scheduled for this period',
      ),
    );
  }

  void _applyDepartureFilters(Map<String, dynamic> filters) {
  
    var fullData = _getDeparturesMap();

    // Example filtering logic (expand as needed)
    DateTime? startDate = filters['startDate'];
    DateTime? endDate = filters['endDate'];
    String? roomType = filters['roomType'] != 'All' ? filters['roomType'] : null;
    String? reservationType = filters['reservationType'] != 'All' ? filters['reservationType'] : null;
    bool guestCheckedOutToday = filters['guestCheckedOutToday'] ?? false;

    // Filter each tab's list
    Map<String, List<GuestItem>> filteredMap = {};
    fullData.forEach((tab, items) {
      filteredMap[tab] = items.where((item) {
        // Date filtering (parse mock dates; in real app, use DateTime.parse on API data)
        DateTime itemEnd = _parseMockDate(item.endDate);
        bool dateMatch = true;
        if (startDate != null && endDate != null) {
          dateMatch = itemEnd.isAfter(startDate.subtract(const Duration(days: 1))) &&
              itemEnd.isBefore(endDate.add(const Duration(days: 1)));
        }

        // Room type filtering
        bool roomMatch = roomType == null || item.roomType == roomType;

        bool checkedOutMatch = !guestCheckedOutToday || (tab == 'today' && itemEnd == DateTime.now());

        return dateMatch && roomMatch /* && resTypeMatch */ && checkedOutMatch;
      }).toList();
    });

    setState(() {
      departuresMap = filteredMap;
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
        title: 'Departure Status',
        statusItems: const [
          StatusItem(
            status: 'CheckedOut',
            description: 'Guests who have already checked out',
            color: Color(0xFF4CAF50),
            icon: Icons.logout,
          ),
          StatusItem(
            status: 'DueOut',
            description: 'Guests scheduled to check out today',
            color: Color(0xFFFF9800),
            icon: Icons.schedule,
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

  Widget _buildDepartureCard(GuestItem item) {
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
      actionButton: SizedBox(
        height: 32,
        child: ElevatedButton(
          onPressed: () {}, // Handle checkout
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            foregroundColor: AppColors.surface,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
            padding: const EdgeInsets.symmetric(horizontal: 16),
          ),
          child: const Text('Check Out'),
        ),
      ),
      onTap: () => _showActions(context, item),
    );
  }

  void _showActions(BuildContext context, GuestItem item) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => ActionBottomSheet(
        guestName: item.guestName,
        actions: [
          const ActionItem(icon: Icons.visibility, label: 'View Reservation'),
          const ActionItem(icon: Icons.check, label: 'Check Out'),
          const ActionItem(icon: Icons.edit_calendar, label: 'Extend Stay'),
          const ActionItem(icon: Icons.person, label: 'Edit Guest Details'),
          const ActionItem(icon: Icons.receipt, label: 'Print Invoice'),
          const ActionItem(icon: Icons.description, label: 'Print Res. Voucher'),
          const ActionItem(icon: Icons.email, label: 'Send Res. Voucher'),
          const ActionItem(icon: Icons.email, label: 'Resend Booking Email'),
          const ActionItem(icon: Icons.cleaning_services, label: 'Request Housekeeping'),
        ],
      ),
    );
  }

  Map<String, List<GuestItem>> _getDeparturesMap() {
    // Mock data - replace with API
    return {
      'today': [
        GuestItem(
          guestName: 'Emily Davis',
          resId: 'BH3001',
          folioId: '3004',
          startDate: 'Sep 10',
          endDate: 'Sep 14',
          nights: 4,
          roomType: 'Beach House',
          adults: 3,
          totalAmount: 500.00,
          balanceAmount: 0.00,
        ),
      ],
      'tomorrow': [
        GuestItem(
          guestName: 'Lisa Anderson',
          resId: 'BH3006',
          folioId: '3009',
          startDate: 'Sep 8',
          endDate: 'Sep 15',
          nights: 7,
          roomType: 'Garden Villa',
          adults: 5,
          totalAmount: 700.00,
          balanceAmount: 100.00,
        ),
      ],
      'this week': [],
    };
  }
}