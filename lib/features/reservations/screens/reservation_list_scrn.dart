import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:get/get_core/src/get_main.dart';
import 'package:go_router/go_router.dart';
import 'package:inta_mobile_pms/core/theme/app_colors.dart';
import 'package:inta_mobile_pms/features/reservations/models/guest_item.dart';
import 'package:inta_mobile_pms/features/reservations/screens/assign_rooms_scrn.dart';
import 'package:inta_mobile_pms/features/reservations/screens/no_show_reservation_scrn.dart';
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
              builder: (context, scrollController) => Obx( () {
                return  FilterBottomSheet(
                type: 'reservation',
                filteredData: _reservationListVm.receivedFilters.value ?? {},
                onApply: _reservationListVm.applyReservationFilters,
                scrollController: scrollController,
              );
              }),
            ),
          );
        },
      ),

      body: Obx(() {
        final reservations = _reservationListVm.reservationFilteredList.value ?? {};
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
      reservationType: item.reservationType,
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
          ActionItem(
            icon: Icons.not_interested,
            label: 'No Show Reservation',
            onTap: () {
              Navigator.of(context).pop();
              final noShowData = NoShowReservationData(
                guestName: item.guestName,
                reservationNumber: item.resId,
                folio: item.folioId,
                arrivalDate: item.startDate,
                departureDate: item.endDate,
                roomType: item.roomType ?? 'N/A',
                room: 'TBD',
                total: item.totalAmount,
                deposit: item.totalAmount - item.balanceAmount,
                balance: item.balanceAmount,
                initialNoShowFee: null,
              );
              Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      NoShowReservationPage(data: noShowData),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                        var begin = const Offset(0.0, 1.0);
                        var end = Offset.zero;
                        var curve = Curves.ease;
                        var tween = Tween(
                          begin: begin,
                          end: end,
                        ).chain(CurveTween(curve: curve));
                        return SlideTransition(
                          position: animation.drive(tween),
                          child: child,
                        );
                      },
                ),
              );
            },
          ),
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
}
