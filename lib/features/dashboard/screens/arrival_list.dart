
import 'package:flutter/material.dart';
import 'package:inta_mobile_pms/core/theme/app_colors.dart';
import 'package:inta_mobile_pms/features/dashboard/models/guest_item.dart';
import 'package:inta_mobile_pms/features/dashboard/widgets/action_bottom_sheet.dart';
import 'package:inta_mobile_pms/features/dashboard/widgets/custom_appbar.dart';
import 'package:inta_mobile_pms/features/dashboard/widgets/guest_card.dart';
import 'package:inta_mobile_pms/features/dashboard/widgets/status_info_dialog.dart';
import 'package:inta_mobile_pms/features/dashboard/widgets/tabbed_list_view.dart';



class ArrivalList extends StatefulWidget {
  const ArrivalList({super.key});

  @override
  State<ArrivalList> createState() => _ArrivalListState();
}

class _ArrivalListState extends State<ArrivalList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        title: 'Arrival List',
        onInfoTap: () => _showInfoDialog(context),
        onFilterTap: () {}, // Implement filter
      ),
      body: TabbedListView<GuestItem>(
        tabLabels: const ['Today', 'Tomorrow', 'This Week'],
        dataMap: _getArrivalsMap(),
        itemBuilder: (item) => _buildArrivalCard(item),
        emptySubMessage: (period) => 'No arrivals scheduled for this period',
      ),
    );
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
      actionButton: SizedBox(
        height: 32,
        child: ElevatedButton(
          onPressed: () {}, // Handle confirm
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            foregroundColor: AppColors.surface,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
            padding: const EdgeInsets.symmetric(horizontal: 16),
          ),
          child: const Text('Confirm Reservation'),
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
          const ActionItem(icon: Icons.meeting_room, label: 'Assign Rooms'),
          const ActionItem(icon: Icons.edit_calendar, label: 'Amend Stay'),
          const ActionItem(icon: Icons.swap_horiz, label: 'Change Reservation Type'),
          const ActionItem(icon: Icons.cancel, label: 'Cancel Reservation'),
          const ActionItem(icon: Icons.block, label: 'Void Reservation'),
          const ActionItem(icon: Icons.person, label: 'Edit Guest Details'),
          const ActionItem(icon: Icons.receipt, label: 'Print Invoice'),
          const ActionItem(icon: Icons.description, label: 'Print Res. Voucher'),
          const ActionItem(icon: Icons.email, label: 'Send Res. Voucher'),
          const ActionItem(icon: Icons.email, label: 'Resend Booking Email'),
        ],
      ),
    );
  }

  Map<String, List<GuestItem>> _getArrivalsMap() {
    // Mock data - replace with API
    return {
      'today': [],
      'tomorrow': [
        GuestItem(
          guestName: 'Mr. Dilini',
          resId: 'BH2800',
          folioId: '2253',
          startDate: 'Sep 12',
          endDate: 'Sep 13',
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
          startDate: 'Sep 12',
          endDate: 'Sep 15',
          nights: 1,
          roomType: 'Double Room new /142',
          adults: 1,
          totalAmount: 0.00,
          balanceAmount: 0.00,
        ),
      ],
      'this week': [],
    };
  }
}