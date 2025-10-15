import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:go_router/go_router.dart';
import 'package:inta_mobile_pms/core/theme/app_colors.dart';
import 'package:inta_mobile_pms/features/reservations/models/guest_item.dart';
import 'package:inta_mobile_pms/features/reservations/screens/no_show_reservation_scrn.dart';
import 'package:inta_mobile_pms/features/reservations/viewmodels/departure_list_vm.dart';
import 'package:inta_mobile_pms/features/reservations/widgets/action_bottom_sheet_wgt.dart';
import 'package:inta_mobile_pms/core/widgets/custom_appbar.dart';
import 'package:inta_mobile_pms/features/dashboard/widgets/filter_bottom_sheet_wgt.dart';
import 'package:inta_mobile_pms/features/reservations/widgets/guest_card_wgt.dart';
import 'package:inta_mobile_pms/features/reservations/widgets/status_info_dialog_wgt.dart';
import 'package:inta_mobile_pms/features/dashboard/widgets/tabbed_list_view_wgt.dart';
import 'package:inta_mobile_pms/router/app_routes.dart';

class DepartureList extends StatefulWidget {
  const DepartureList({super.key});

  @override
  State<DepartureList> createState() => _DepartureListState();
}

class _DepartureListState extends State<DepartureList> {
  final DepartureListVm _departureListVm = Get.put(DepartureListVm());
  late Map<String, List<GuestItem>> departuresMap;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (mounted) {
        await _departureListVm.getDepartureMap();
      }
    });
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
              builder: (context, scrollController) => Obx(() {
                return FilterBottomSheet(
                  type: 'departure',
                  filteredData: _departureListVm.receivedFilters.value ?? {},
                  onApply: _departureListVm.applydepartureFilters,
                  scrollController: scrollController,
                );
              }),
            ),
          );
        },
      ),
      body: Obx(() {
        return TabbedListView<GuestItem>(
          tabLabels: const ['Today', 'Tomorrow', 'This Week'],
          dataMap: _departureListVm.departureFilteredList.value ?? {},
          itemBuilder: (item) => _buildDepartureCard(item),
          emptySubMessage: (period) =>
              'No departures scheduled for this period',
        );
      }),
    );
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
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            ),
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
          ActionItem(
            icon: Icons.visibility,
            label: 'View Reservation',
            onTap: () {
              Navigator.of(context).pop();
              context.go(AppRoutes.viewReservation, extra: item);
            },
          ),
          ActionItem(
            icon: Icons.move_to_inbox,
            label: 'Room Move',
            onTap: () {
              Navigator.of(context).pop();
              context.go(AppRoutes.roomMove);
            },
          ),
          ActionItem(
            icon: Icons.stop_circle_outlined,
            label: 'Stop Room Move',
            onTap: () {
              Navigator.of(context).pop();
              context.go(AppRoutes.stopRoomMove);
            },
          ),
          ActionItem(
            icon: Icons.edit_calendar,
            label: 'Amend Stay',
            onTap: () {
              Navigator.of(context).pop();
              context.go(AppRoutes.amendstay);
            },
          ),
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
          ActionItem(icon: Icons.person, label: 'Edit Guest Details'),
          ActionItem(icon: Icons.receipt, label: 'Print Invoice'),
          ActionItem(icon: Icons.description, label: 'Print Res. Voucher'),
          ActionItem(icon: Icons.email, label: 'Send Res. Voucher'),
          ActionItem(icon: Icons.email, label: 'Resend Booking Email'),
          ActionItem(
            icon: Icons.cleaning_services,
            label: 'Request Housekeeping',
          ),
        ],
      ),
    );
  }
}
