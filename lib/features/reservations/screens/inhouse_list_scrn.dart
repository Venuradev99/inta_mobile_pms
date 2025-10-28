// lib/pages/in_house_list.dart (Refactored - Reduced to ~70 lines)
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:go_router/go_router.dart';
import 'package:inta_mobile_pms/core/theme/app_colors.dart';
import 'package:inta_mobile_pms/features/reservations/models/guest_item.dart';
import 'package:inta_mobile_pms/features/reservations/screens/void_reservation_scrn.dart';
import 'package:inta_mobile_pms/features/reservations/viewmodels/inhouse_list_vm.dart';
import 'package:inta_mobile_pms/features/reservations/widgets/action_bottom_sheet_wgt.dart';
import 'package:inta_mobile_pms/core/widgets/custom_appbar.dart';
import 'package:inta_mobile_pms/features/reservations/widgets/guest_card_wgt.dart';
import 'package:inta_mobile_pms/features/reservations/widgets/status_info_dialog_wgt.dart';
import 'package:inta_mobile_pms/features/housekeeping/widgets/empty_state_wgt.dart';
import 'package:inta_mobile_pms/router/app_routes.dart';

class InHouseList extends StatefulWidget {
  const InHouseList({super.key});

  @override
  State<InHouseList> createState() => _InHouseListState();
}

class _InHouseListState extends State<InHouseList> {
  final InhouseListVm _inhouseListVm = Get.find<InhouseListVm>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (mounted) {
        await _inhouseListVm.getInhouseMap();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        title: 'In House List',
        onInfoTap: () => _showInfoDialog(context),
        onFilterTap: () {},
      ),
      body: _buildInHouseList(),
    );
  }

  Widget _buildInHouseList() {
    return Obx(() {
      final items = _inhouseListVm.inhouseFilteredList.value ?? [];
      if (items.isEmpty) {
        return const EmptyStateWgt(
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
    });
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
    return Obx(() {
      return _inhouseListVm.isLoading.value
          ? GuestCardShimmer()
          : GuestCard(
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
    });
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
          ActionItem(icon: Icons.visibility, label: 'View Reservation'),
          ActionItem(
            icon: Icons.move_to_inbox,
            label: 'Room Move',
            onTap: () {
              context.pop();
              context.push(AppRoutes.roomMove);
            },
          ),
          ActionItem(
            icon: Icons.stop_circle_outlined,
            label: 'Stop Room Move',
            onTap: () {
              context.pop();
              context.push(AppRoutes.stopRoomMove);
            },
          ),
          ActionItem(
            icon: Icons.edit_calendar,
            label: 'Amend Stay',
            onTap: () {
              context.pop();
              context.push(AppRoutes.amendstay, extra: item);
            },
          ),
          ActionItem(
            icon: Icons.block,
            label: 'Void Reservation',
            onTap: () {
              context.pop();
              final data = {
                'guestName': item.guestName,
                'resNumber': item.resId,
                'folio': item.folioId,
                'arrivalDate': item.startDate,
                'departureDate': item.endDate,
                'roomType': item.roomType ?? 'N/A',
                'room': item.room ?? 'TBD',
                'total': item.totalAmount,
                'deposit': item.totalAmount - item.balanceAmount,
              };
              Navigator.of(context).push(
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      VoidReservation(reservationData: data),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                        const begin = Offset(0.0, 1.0); // Slide from bottom
                        const end = Offset.zero;
                        final tween = Tween(
                          begin: begin,
                          end: end,
                        ).chain(CurveTween(curve: Curves.ease));
                        final offsetAnimation = animation.drive(tween);

                        return SlideTransition(
                          position: offsetAnimation,
                          child: child,
                        );
                      },
                  transitionDuration: const Duration(milliseconds: 300),
                ),
              );
            },
          ),
          ActionItem(icon: Icons.check, label: 'Check Out'),
          ActionItem(icon: Icons.edit_calendar, label: 'Extend Stay'),
          ActionItem(icon: Icons.meeting_room, label: 'Change Room'),
          ActionItem(icon: Icons.person, label: 'Edit Guest Details'),
          ActionItem(icon: Icons.receipt, label: 'Print Invoice'),
          ActionItem(icon: Icons.email, label: 'Send Folio'),
          ActionItem(
            icon: Icons.cleaning_services,
            label: 'Request Housekeeping',
          ),
        ],
      ),
    );
  }
}
