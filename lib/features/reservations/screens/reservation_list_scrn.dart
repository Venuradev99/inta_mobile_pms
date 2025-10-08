import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:get/get_core/src/get_main.dart';
import 'package:go_router/go_router.dart';
import 'package:inta_mobile_pms/core/theme/app_colors.dart';
import 'package:inta_mobile_pms/features/reservations/models/guest_item.dart';
import 'package:inta_mobile_pms/features/reservations/screens/assign_rooms_scrn.dart';
import 'package:inta_mobile_pms/features/reservations/viewmodels/reservation_list_vm.dart';
import 'package:inta_mobile_pms/features/reservations/widgets/action_bottom_sheet_wgt.dart';
import 'package:inta_mobile_pms/core/widgets/custom_appbar.dart';
import 'package:inta_mobile_pms/features/dashboard/widgets/filter_bottom_sheet_wgt.dart';
import 'package:inta_mobile_pms/features/reservations/widgets/guest_card_wgt.dart';
import 'package:inta_mobile_pms/features/reservations/widgets/status_info_dialog_wgt.dart';
import 'package:inta_mobile_pms/features/dashboard/widgets/tabbed_list_view_wgt.dart';
import 'package:inta_mobile_pms/router/app_routes.dart';

class ReservationList extends StatefulWidget {
  const ReservationList({super.key});

  @override
  State<ReservationList> createState() => _ReservationListState();
}

class _ReservationListState extends State<ReservationList> {
  final ReservationListVm _reservationListVm = Get.put(ReservationListVm());
  late Map<String, List<GuestItem>> reservationsMap;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (mounted) {
        await _reservationListVm.getReservationsMap();
      }
    });
    // reservationsMap = _getReservationsMap();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        title: 'Reservation List',
        onInfoTap: () => _showInfoDialog(context),
        onFilterTap: () {
          showModalBottomSheet(
            context: context,
            backgroundColor: Colors.transparent,
            isScrollControlled: true,
            builder: (context) => DraggableScrollableSheet(
              initialChildSize: 0.8,
              minChildSize: 0.5,
              maxChildSize: 0.95,
              builder: (context, scrollController) => FilterBottomSheet(
                type: 'reservation',
                onApply: _applyReservationFilters,
                scrollController: scrollController,
              ),
            ),
          );
        },
      ),

      body: Obx(() {
        final reservations = _reservationListVm.reservationList.value ?? {};

        if (reservations.isEmpty) {
          return const Center(child: Text('No reservations found'));
        }
        return TabbedListView<GuestItem>(
          tabLabels: const ['Today', 'Tomorrow', 'This Week'],
          dataMap: reservations,
          itemBuilder: (item) => _buildReservationCard(item),
          emptySubMessage: (period) => 'No reservations for this period',
        );
      }),
    );
  }

  void _applyReservationFilters(Map<String, dynamic> filters) {
    var fullData = _reservationListVm.reservationList.value ?? {};

    // Extract filters
    DateTime? startDate = filters['startDate'];
    DateTime? endDate = filters['endDate'];
    String? roomType = filters['roomType'] != 'All'
        ? filters['roomType']
        : null;
    String? reservationType = filters['reservationType'] != 'All'
        ? filters['reservationType']
        : null;
    String dateFilterType = filters['dateFilterType'] ?? 'reserved';
    String? status = filters['status'] != 'All' ? filters['status'] : null;
    String? businessSource = filters['businessSource'] != 'All'
        ? filters['businessSource']
        : null;
    bool showUnassignedRooms = filters['showUnassignedRooms'] ?? false;
    bool showFailedBookings = filters['showFailedBookings'] ?? false;
    String guestName = (filters['guestName'] ?? '').toLowerCase();
    String reservationNumber = filters['reservationNumber'] ?? '';
    String cancellationNumber = filters['cancellationNumber'] ?? '';
    String voucherNumber = filters['voucherNumber'] ?? '';

    // Filter each tab's list
    Map<String, List<GuestItem>> filteredMap = {};
    fullData.forEach((tab, items) {
      filteredMap[tab] = items.where((item) {
        // Date filtering
        DateTime itemDate = dateFilterType == 'reserved'
            ? _parseMockDate(item.reservedDate ?? item.startDate)
            : _parseMockDate(item.startDate);
        bool dateMatch = true;
        if (startDate != null && endDate != null) {
          dateMatch =
              itemDate.isAfter(startDate.subtract(const Duration(days: 1))) &&
              itemDate.isBefore(endDate.add(const Duration(days: 1)));
        }
        bool roomMatch = roomType == null || item.roomType == roomType;
        bool resTypeMatch =
            reservationType == null || item.reservationType == reservationType;
        bool statusMatch = status == null || item.status == status;
        bool sourceMatch =
            businessSource == null || item.businessSource == businessSource;
        // Text searches
        bool nameMatch =
            guestName.isEmpty ||
            item.guestName.toLowerCase().contains(guestName);
        bool resNumMatch =
            reservationNumber.isEmpty || item.resId == reservationNumber;
        bool cancelNumMatch =
            cancellationNumber.isEmpty ||
            (item.cancellationNumber ?? '') == cancellationNumber;
        bool voucherMatch =
            voucherNumber.isEmpty ||
            (item.voucherNumber ?? '') == voucherNumber;
        // Flags
        bool unassignedMatch =
            !showUnassignedRooms ||
            (item.roomNumber == null || item.roomNumber!.isEmpty);
        bool failedMatch =
            !showFailedBookings ||
            (item.status == 'Failed' || item.status == 'Incomplete');

        return dateMatch &&
            roomMatch &&
            resTypeMatch &&
            statusMatch &&
            sourceMatch &&
            nameMatch &&
            resNumMatch &&
            cancelNumMatch &&
            voucherMatch &&
            unassignedMatch &&
            failedMatch;
      }).toList();
    });

    setState(() {
      reservationsMap = filteredMap;
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
      'Jan': 1,
      'Feb': 2,
      'Mar': 3,
      'Apr': 4,
      'May': 5,
      'Jun': 6,
      'Jul': 7,
      'Aug': 8,
      'Sep': 9,
      'Oct': 10,
      'Nov': 11,
      'Dec': 12,
    };
    return months[month] ?? 1;
  }

  void _showInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => StatusInfoDialog(
        title: 'Reservation Status',
        statusItems: const [
          StatusItem(
            status: 'Confirmed',
            description: 'Reservations that are confirmed',
            color: Color(0xFF4CAF50),
            icon: Icons.check_circle,
          ),
          StatusItem(
            status: 'Pending',
            description: 'Reservations awaiting confirmation',
            color: Color(0xFFFF9800),
            icon: Icons.hourglass_empty,
          ),
          StatusItem(
            status: 'Cancelled',
            description: 'Cancelled reservations',
            color: Color(0xFFF44336),
            icon: Icons.cancel,
          ),
          StatusItem(
            status: 'Checked In',
            description: 'Guests who have checked in',
            color: Color(0xFF2196F3),
            icon: Icons.login,
          ),
          StatusItem(
            status: 'Checked Out',
            description: 'Guests who have checked out',
            color: Color(0xFF9E9E9E),
            icon: Icons.logout,
          ),
          StatusItem(
            status: 'Failed/Incomplete',
            description: 'Failed or incomplete bookings',
            color: Color(0xFFE91E63),
            icon: Icons.error,
          ),
        ],
      ),
    );
  }

  Widget _buildReservationCard(GuestItem item) {
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
          ActionItem(
            icon: Icons.visibility,
            label: 'View Reservation',
            onTap: () => context.go(AppRoutes.viewReservation, extra: item),
          ),
          ActionItem(icon: Icons.edit, label: 'Edit Reservation'),
          ActionItem(icon: Icons.check_circle, label: 'Confirm Reservation'),
          ActionItem(
            icon: Icons.cancel,
            label: 'Cancel Reservation',
            onTap: () => context.go(AppRoutes.cancelReservation, extra: item),
          ),
          ActionItem(
            icon: Icons.meeting_room,
            label: 'Assign Rooms',
            onTap: () async {
              Navigator.pop(context);
              final result = await AssignRoomsBottomSheet.show(
                context: context,
                guestName: item.guestName,
                reservationId: item.resId,
                initialRoomType: item.roomType,
                initialRoom: item.roomNumber,
              );
              if (result != null) {
                setState(() {
                  // Find and update the specific item in the map
                  for (var tab in reservationsMap.keys) {
                    final index = reservationsMap[tab]!.indexWhere(
                      (g) => g.resId == item.resId,
                    );
                    if (index != -1) {
                      reservationsMap[tab]![index] = GuestItem(
                        guestName: item.guestName,
                        resId: item.resId,
                        folioId: item.folioId,
                        startDate: item.startDate,
                        endDate: item.endDate,
                        nights: item.nights,
                        roomType: result['roomType'],
                        adults: item.adults,
                        totalAmount: item.totalAmount,
                        balanceAmount: item.balanceAmount,
                        remainingNights: item.remainingNights,
                        roomNumber: result['room'],
                        reservedDate: item.reservedDate,
                        reservationType: item.reservationType,
                        status: item.status,
                        businessSource: item.businessSource,
                        cancellationNumber: item.cancellationNumber,
                        voucherNumber: item.voucherNumber,
                        room:
                            result['room'], // If room is separate, update it; otherwise remove if duplicate
                      );
                    }
                  }
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Room assigned successfully: ${result['room']} (${result['roomType']})',
                    ),
                    backgroundColor: Colors.green,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              }
            },
          ),
          ActionItem(icon: Icons.swap_horiz, label: 'Change Reservation Type'),
          ActionItem(icon: Icons.person, label: 'Edit Guest Details'),
          ActionItem(icon: Icons.receipt, label: 'Print Invoice'),
          ActionItem(icon: Icons.description, label: 'Print Res. Voucher'),
          ActionItem(icon: Icons.email, label: 'Send Res. Voucher'),
          ActionItem(icon: Icons.email, label: 'Resend Booking Email'),
        ],
      ),
    );
  }

  // Map<String, List<GuestItem>> _getReservationsMap() {
  //   final reservationList = _reservationListVm.reservationList.value ?? {};
  //   print('reservationList$reservationList');
  //   return reservationList;
    // {
    //   'today': [
    //     GuestItem(
    //       guestName: 'Mr. Ethan Harris',
    //       resId: 'BH3500',
    //       folioId: '3501',
    //       startDate: 'Sep 23',
    //       endDate: 'Sep 25',
    //       nights: 2,
    //       roomType: 'Double Room',
    //       adults: 2,
    //       totalAmount: 220.00,
    //       balanceAmount: 220.00,
    //       reservedDate: 'Sep 23',
    //       reservationType: 'Standard',
    //       status: 'Pending',
    //       businessSource: 'Direct',
    //       roomNumber: '101',
    //     ),
    //   ],
    //   'tomorrow': [
    //     GuestItem(
    //       guestName: 'Ms. Fiona Irving',
    //       resId: 'BH3600',
    //       folioId: '3601',
    //       startDate: 'Sep 24',
    //       endDate: 'Sep 26',
    //       nights: 2,
    //       roomType: 'Suite',
    //       adults: 2,
    //       totalAmount: 350.00,
    //       balanceAmount: 0.00,
    //       reservedDate: 'Sep 20',
    //       reservationType: 'Corporate',
    //       status: 'Confirmed',
    //       businessSource: 'OTA',
    //       roomNumber: null,
    //     ),
    //     GuestItem(
    //       guestName: 'Mr. George Jackson',
    //       resId: 'BH3700',
    //       folioId: '3701',
    //       startDate: 'Sep 24',
    //       endDate: 'Sep 27',
    //       nights: 3,
    //       roomType: 'Single Room',
    //       adults: 1,
    //       totalAmount: 180.00,
    //       balanceAmount: 90.00,
    //       reservedDate: 'Sep 22',
    //       reservationType: 'Day Use',
    //       status: 'Failed',
    //       businessSource: 'Walk-in',
    //     ),
    //     GuestItem(
    //       guestName: 'Ms. Emily Carter',
    //       resId: 'BH4825',
    //       folioId: '4826',
    //       startDate: 'Oct 10',
    //       endDate: 'Oct 14',
    //       nights: 4,
    //       roomType: 'Deluxe Suite',
    //       adults: 2,
    //       totalAmount: 520.00,
    //       balanceAmount: 130.00,
    //       reservedDate: 'Oct 8',
    //       reservationType: 'Overnight',
    //       status: 'Confirmed',
    //       businessSource: 'Online Booking',
    //     ),
    //   ],
    //   'this week': [
    //     GuestItem(
    //       guestName: 'Ms. Hannah King',
    //       resId: 'BH3800',
    //       folioId: '3801',
    //       startDate: 'Sep 25',
    //       endDate: 'Sep 28',
    //       nights: 3,
    //       roomType: 'Bunk Bed',
    //       adults: 1,
    //       totalAmount: 120.00,
    //       balanceAmount: 0.00,
    //       reservedDate: 'Sep 23',
    //       reservationType: 'Group',
    //       status: 'Confirmed',
    //       businessSource: 'Agent',
    //       roomNumber: '205',
    //       room: '205',
    //     ),
    //   ],
    // };
  // }
}
