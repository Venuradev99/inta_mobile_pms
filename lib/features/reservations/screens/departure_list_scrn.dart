import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:go_router/go_router.dart';
import 'package:inta_mobile_pms/core/theme/app_colors.dart';
import 'package:inta_mobile_pms/features/reservations/models/guest_item.dart';
import 'package:inta_mobile_pms/features/reservations/screens/amend_stay_scrn.dart';
import 'package:inta_mobile_pms/features/reservations/screens/no_show_reservation_scrn.dart';
import 'package:inta_mobile_pms/features/reservations/screens/room_move_scrn.dart';
import 'package:inta_mobile_pms/features/reservations/screens/stop_room_move_scrn.dart';
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
  final _departureListVm = Get.find<DepartureListVm>();
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
                  roomTypes:_departureListVm.roomTypes.toList(),
                  reservationTypes:_departureListVm.reservationTypes.toList(),
                  statuses:_departureListVm.statuses.toList(),
                  businessSources:_departureListVm.businessSources.toList(),
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
        GuestItem guestItem = GuestItem(
          bookingRoomId: '',
          guestName: '',
          resId: '',
          folioId: '',
          startDate: '',
          endDate: '',
          nights: 0,
          adults: 0,
          totalAmount: 0,
          balanceAmount: 0,
        );

        final isBottomSheetDataLoading =
            _departureListVm.isBottomSheetDataLoading.value;
        return Stack(
          children: [
            TabbedListView<GuestItem>(
              tabLabels: const ['Today', 'Tomorrow', 'This Week'],
              dataMap: _departureListVm.isLoading.value
                  ? {
                      'today': List.generate(3, (_) => guestItem),
                      'tomorrow': List.generate(3, (_) => guestItem),
                      'thisweek': List.generate(3, (_) => guestItem),
                    }
                  : _departureListVm.departureFilteredList.value ?? {},
              itemBuilder: (item) => _departureListVm.isLoading.value
                  ? _buildArrivalCardShimmer()
                  : _buildDepartureCard(item),
              emptySubMessage: (period) =>
                  'No arrivals scheduled for this period',
            ),
            if (isBottomSheetDataLoading == true)
              Container(
                color: Colors.black.withOpacity(0.2), // slight dim effect
                child: const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppColors.lightgrey,
                    ),
                  ),
                ),
              ),
          ],
        );
      }),
    );
  }

  void _showInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return Obx(() {
          final statusList = _departureListVm.statusList;

          final List<StatusItem> items = statusList.map((status) {
            return StatusItem(
              status: status['name'],
              description: status['description'],
              color: status['colorCode'],
              icon: Icons.check_circle,
            );
          }).toList();

          return StatusInfoDialog(
            title: 'Housekeeping Status',
            statusItems: items,
          );
        });
      },
    );
  }

  Widget _buildArrivalCardShimmer() {
    return GuestCardShimmer();
  }

  Widget _buildDepartureCard(GuestItem item) {
    return Obx(() {
      return _departureListVm.isLoading.value
          ? GuestCardShimmer()
          : GuestCard(
              guestName: item.guestName,
              resId: item.resId,
              folioId: item.folioId,
              startDate: item.startDate,
              endDate: item.endDate,
              reservationType: item.reservationType,
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
    });
  }

  void _showActions(BuildContext context, GuestItem item) async {
    await _departureListVm.getAllGuestData(item);
    if (!mounted) return;
    final guestData = _departureListVm.allGuestDetails.value;
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
            onTap: () async {
              Get.toNamed(AppRoutes.viewReservation, arguments: guestData);
            },
          ),
          ActionItem(
            icon: Icons.move_to_inbox,
            label: 'Room Move',
            onTap: () async {
              if (!mounted) return;
              Get.back();
              GuestItem data = GuestItem(
                bookingRoomId: guestData?.bookingRoomId ?? '',
                guestName: guestData?.guestName ?? '',
                resId: guestData?.resId ?? '',
                folioId: guestData?.folioId ?? '',
                startDate: guestData?.startDate ?? '',
                endDate: guestData?.endDate ?? '',
                nights: guestData?.nights ?? 0,
                adults: guestData?.adults ?? 0,
                totalAmount: guestData?.totalAmount ?? 0.0,
                balanceAmount: guestData?.balanceAmount ?? 0.0,
                roomType: guestData?.roomType ?? '',
                room: guestData?.room ?? '',
              );
              Get.to(
                () => RoomMovePage(guestItem: data),
                transition: Transition
                    .downToUp, 
                curve: Curves.ease,
                duration: const Duration(
                  milliseconds: 300,
                ), 
              );
            },
          ),
          ActionItem(
            icon: Icons.stop_circle_outlined,
            label: 'Stop Room Move',
            onTap: () async {
              if (!mounted) return;
              Get.back();
              Get.to(
                () => StopRoomMoveScreen(
                  bookingRoomId: guestData?.bookingRoomId ?? '',
                ),
                transition: Transition.downToUp,
                curve: Curves.ease,
                duration: const Duration(milliseconds: 300),
              );
            },
          ),
          ActionItem(
            icon: Icons.edit_calendar,
            label: 'Amend Stay',
            onTap: () {
              Get.back();
              Get.to(
                () => AmendStay(guestItem: guestData),
                transition: Transition.downToUp,
                curve: Curves.ease,
                duration: const Duration(milliseconds: 300),
              );
            },
          ),
          // ActionItem(
          //   icon: Icons.not_interested,
          //   label: 'No Show Reservation',
          //   onTap: () {
          //  Get.back();
          //     final noShowData = NoShowReservationData(
          //       reasons: [],
          //       bookingRoomId: '',
          //       guestName: item.guestName,
          //       reservationNumber: item.resId,
          //       folio: item.folioId,
          //       arrivalDate: item.startDate,
          //       departureDate: item.endDate,
          //       roomType: item.roomType ?? 'N/A',
          //       room: 'TBD',
          //       total: item.totalAmount,
          //       deposit: item.totalAmount - item.balanceAmount,
          //       balance: item.balanceAmount,
          //       initialNoShowFee: null,
          //     );
          //     Get.toNamed(
          //       context,
          //       PageRouteBuilder(
          //         pageBuilder: (context, animation, secondaryAnimation) =>
          //             NoShowReservationPage(data: noShowData),
          //         transitionsBuilder:
          //             (context, animation, secondaryAnimation, child) {
          //               var begin = const Offset(0.0, 1.0);
          //               var end = Offset.zero;
          //               var curve = Curves.ease;
          //               var tween = Tween(
          //                 begin: begin,
          //                 end: end,
          //               ).chain(CurveTween(curve: curve));
          //               return SlideTransition(
          //                 position: animation.drive(tween),
          //                 child: child,
          //               );
          //             },
          //       ),
          //     );
          //   },
          // ),
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
