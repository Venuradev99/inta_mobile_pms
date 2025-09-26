// lib/pages/in_house_list.dart (Refactored - Reduced to ~70 lines)
import 'package:flutter/material.dart';
import 'package:inta_mobile_pms/core/theme/app_colors.dart';
import 'package:inta_mobile_pms/features/reservations/models/guest_item.dart';
import 'package:inta_mobile_pms/features/reservations/widgets/action_bottom_sheet.dart';
import 'package:inta_mobile_pms/core/widgets/custom_appbar.dart';
import 'package:inta_mobile_pms/features/reservations/widgets/guest_card.dart';
import 'package:inta_mobile_pms/features/reservations/widgets/status_info_dialog.dart';
import 'package:inta_mobile_pms/features/housekeeping/widgets/empty_state.dart';

class InHouseList extends StatefulWidget {
  const InHouseList({super.key});

  @override
  State<InHouseList> createState() => _InHouseListState();
}

class _InHouseListState extends State<InHouseList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        title: 'In House List',
        onInfoTap: () => _showInfoDialog(context),
        onFilterTap: () {}, // Implement filter
      ),
      body: _buildInHouseList(),
    );
  }

  Widget _buildInHouseList() {
    final items = _getInHouseItems();
    if (items.isEmpty) {
      return const EmptyState(
        title: 'No In-House Guests',
        subMessage: 'No in-house guests at the moment',
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: items.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) => _buildInHouseCard(items[index]),
    );
  }

  void _showInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => StatusInfoDialog(
        title: 'In-House Status',
        statusItems: const [
          StatusItem(
            status: 'Arrival',
            description: 'Guests who checked in today',
            color: Color(0xFF4CAF50),
            icon: Icons.login,
          ),
          StatusItem(
            status: 'DueOut',
            description: 'Guests scheduled to check out today',
            color: Color(0xFFFF9800),
            icon: Icons.schedule,
          ),
          StatusItem(
            status: 'Stayover',
            description: 'Guests continuing their stay',
            color: Color(0xFF2196F3),
            icon: Icons.hotel,
          ),
          StatusItem(
            status: 'Day Used',
            description: 'Day-use reservations currently active',
            color: Color(0xFF9E9E9E),
            icon: Icons.today,
          ),
        ],
      ),
    );
  }

  Widget _buildInHouseCard(GuestItem item) {
    return GuestCard(
      guestName: item.guestName,
      resId: item.resId,
      folioId: item.folioId,
      startDate: item.startDate,
      endDate: item.endDate,
      nights: item.remainingNights ?? item.nights,
      nightsLabel: 'Nights Remaining',
      adults: item.adults,
      totalAmount: item.totalAmount,
      balanceAmount: item.balanceAmount,
      roomNumber: item.roomNumber,
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
          const ActionItem(icon: Icons.meeting_room, label: 'Change Room'),
          const ActionItem(icon: Icons.person, label: 'Edit Guest Details'),
          const ActionItem(icon: Icons.receipt, label: 'Print Invoice'),
          const ActionItem(icon: Icons.email, label: 'Send Folio'),
          const ActionItem(icon: Icons.cleaning_services, label: 'Request Housekeeping'),
        ],
      ),
    );
  }

 List<GuestItem> _getInHouseItems() {
  return [
    GuestItem(
      guestName: 'John Smith',
      resId: 'BH2500',
      folioId: '2250',
      startDate: 'Sep 10',
      endDate: 'Sep 15',
      nights: 4, // Original nights
      roomType: '',
      adults: 2,
      totalAmount: 400.00,
      balanceAmount: 50.00,
      remainingNights: 2, // Now part of GuestItem
      roomNumber: 'Room 101', // Now part of GuestItem
    ),
    GuestItem(
      guestName: 'Sarah Johnson',
      resId: 'BH2510',
      folioId: '2260',
      startDate: 'Sep 12',
      endDate: 'Sep 18',
      nights: 6, // Original nights
      roomType: '',
      adults: 1,
      totalAmount: 300.00,
      balanceAmount: 0.00,
      remainingNights: 4,
      roomNumber: 'Room 205',
    ),
  ];
}
}