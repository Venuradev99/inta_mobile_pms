import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:inta_mobile_pms/core/theme/app_colors.dart';
import 'package:inta_mobile_pms/features/reservations/models/guest_item.dart';
import 'package:inta_mobile_pms/features/reservations/screens/assign_rooms_scrn.dart';
import 'package:inta_mobile_pms/features/reservations/screens/no_show_reservation_scrn.dart';
import 'package:inta_mobile_pms/features/reservations/viewmodels/reservation_vm.dart';
import 'package:inta_mobile_pms/features/reservations/widgets/action_bottom_sheet_wgt.dart';
import 'package:inta_mobile_pms/core/widgets/custom_appbar.dart';
import 'package:inta_mobile_pms/features/dashboard/widgets/filter_bottom_sheet_wgt.dart';
import 'package:inta_mobile_pms/features/reservations/widgets/change_reservation_type_wgt.dart';
import 'package:inta_mobile_pms/features/reservations/widgets/confirmation_dialog_wgt.dart';
import 'package:inta_mobile_pms/features/reservations/widgets/edit_reservation_screen.dart';
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
  final _reservationVm = Get.find<ReservationVm>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) {
        return;
      } else {
        await _reservationVm.getReservationsMap(1);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        title: 'Reservation List',
        // onSearchChanged: (query) => _reservationVm.search(query),
        onRefreshTap: () async {
           await _reservationVm.getReservationsMap(1);
        },
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
              builder: (context, scrollController) => Obx(() {
                return FilterBottomSheet(
                  type: 'reservation',
                  roomTypes: _reservationVm.roomTypes.toList(),
                  reservationTypes: _reservationVm.reservationTypes
                      .toList(),
                  statuses: _reservationVm.statuses.toList(),
                  businessSources: _reservationVm.businessSources.toList(),
                  filteredData: _reservationVm.receivedFilters.value ?? {},
                  onApply: _reservationVm.applyFilters,
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

        return Stack(
          children: [
            if (_reservationVm.isLoading.value == true)
              TabbedListView<GuestItem>(
                tabLabels: const ['Today', 'Tomorrow', 'This Week'],
                dataMap: {
                  'today': List.generate(3, (_) => guestItem),
                  'tomorrow': List.generate(3, (_) => guestItem),
                  'thisweek': List.generate(3, (_) => guestItem),
                },
                itemBuilder: (item) => _buildReservationCardShimmer(),
                emptySubMessage: (period) => 'No reservations for this period',
              ),
            if (_reservationVm.isLoading.value == false)
              TabbedListView<GuestItem>(
                tabLabels: const ['Today', 'Tomorrow', 'This Week'],
                dataMap: _reservationVm.filteredList.value ?? {},
                itemBuilder: (item) => _buildReservationCard(item),
                emptySubMessage: (period) => 'No reservations for this period',
              ),
            if (_reservationVm.isAllGuestDataLoading.value)
              Container(
                color: Colors.black.withOpacity(0.2),
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
          final statusList = _reservationVm.statusList;

          final List<StatusItem> items = statusList.map((status) {
            return StatusItem(
              status: status['name'] ?? '',
              description: status['description'] ?? '',
              color: status['colorCode'] ?? Colors.grey,
              icon: Icons.check_circle,
            );
          }).toList();

          return StatusInfoDialog(
            title: 'Booking Room Status',
            statusItems: items,
          );
        });
      },
    );
  }

  Widget _buildReservationCardShimmer() {
    return GuestCardShimmer();
  }

  Widget _buildReservationCard(GuestItem item) {
    return GuestCard(
      guestName: item.guestName!,
      resId: item.resId!,
      room: item.room,
      startDate: item.startDate!,
      endDate: item.endDate!,
      nights: item.nights!,
      colorCode: item.colorCode,
      nightsLabel: 'Nights Stay',
      adults: item.adults!,
      statusName: item.statusName,
      children: item.children!,
      reservationType: item.reservationType,
      totalAmount: item.totalAmount!,
      balanceAmount: item.balanceAmount!,
      baseCurrencySymbol: item.baseCurrencySymbol,
      onTap: () => _showActions(context, item),
    );
  }

  void _showActions(BuildContext context, GuestItem item) async {
    await _reservationVm.getAllGuestData(item.bookingRoomId!);
    final guestData = _reservationVm.allGuestDetails.value;

    if (!mounted) return;
    bool isNoshow = int.tryParse(item.status.toString()) == 2;
    int status = int.tryParse(guestData?.status.toString() ?? '') ?? 0;
    bool isAssign = guestData?.roomId == 0;
    bool isUnAssignRoom = _reservationVm.isUnAssign(guestData!);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return ActionBottomSheet(
          guestName: item.guestName!,
          actions: [
            ActionItem(
              icon: Icons.visibility,
              label: 'View Reservation',
              onTap: () {
                Navigator.of(context).pop();
                context.push(
                  AppRoutes.viewReservation,
                  extra: _reservationVm.allGuestDetails.value,
                );
              },
            ),
            ActionItem(
              icon: Icons.edit,
              label: 'Edit Reservation',
              onTap: () async {
                Navigator.of(context).pop();
                Navigator.of(context).push(
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        EditReservationScreen(guestItem: guestData),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                          const begin = Offset(0.0, 1.0); // start from bottom
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
            if (isNoshow == true)
              ActionItem(
                icon: Icons.not_interested,
                label: 'No Show Reservation',
                onTap: () async {
                  final noShowReasons = await _reservationVm
                      .getNoShowReservationData(item);
                  if (!mounted) return;
                  final noShowData = NoShowReservationData(
                    reasons: noShowReasons["reasons"],
                    bookingRoomId: guestData?.bookingRoomId ?? '',
                    guestName: guestData?.guestName ?? '',
                    reservationNumber: guestData?.resId ?? '',
                    folio: guestData?.folioId ?? '',
                    arrivalDate: guestData?.startDate ?? '',
                    departureDate: guestData?.endDate ?? '',
                    roomType: guestData?.roomType ?? '',
                    room: guestData?.room ?? '',
                    total: guestData?.totalAmount ?? 0.0,
                    deposit:
                        (guestData?.totalAmount ?? 0.0) -
                        (guestData?.balanceAmount ?? 0.0),
                    balance: guestData?.balanceAmount ?? 0.0,
                    initialNoShowFee: null,
                  );
                  Navigator.of(context).pop();
                  Navigator.of(context).push(
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) =>
                          NoShowReservationPage(data: noShowData),
                      transitionsBuilder:
                          (context, animation, secondaryAnimation, child) {
                            const begin = Offset(0.0, 1.0); // start from bottom
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
            ActionItem(
              icon: Icons.cancel,
              label: 'Cancel Reservation',
              onTap: () async {
                final cancelReservationData = await _reservationVm
                    .getCancelReservationData(item);
                if (!mounted) return;
                final data = {
                  'reasons': cancelReservationData["reasons"],
                  'bookingRoomId': guestData?.bookingRoomId,
                  'guestName': guestData?.guestName,
                  'resNumber': guestData?.resId,
                  'folio': guestData?.folioId,
                  'arrivalDate': guestData?.startDate,
                  'departureDate': guestData?.endDate,
                  'roomType': guestData?.roomType,
                  'room': guestData?.room,
                  'total': guestData?.totalAmount,
                  'deposit':
                      (guestData?.totalAmount ?? 0.0) -
                      (guestData?.balanceAmount ?? 0.0),
                };

                Navigator.of(context).pop();
                context.push(AppRoutes.cancelReservation, extra: data);
              },
            ),
            if (isAssign == true)
              ActionItem(
                icon: Icons.meeting_room,
                label: 'Assign Rooms',
                onTap: () async {
                  Navigator.of(context).pop();
                  await AssignRoomsBottomSheet.show(
                    context: context,
                    guestItem: guestData!,
                  );
                },
              ),
            if (isUnAssignRoom == true)
              ActionItem(
                icon: Icons.meeting_room,
                label: 'Unassign Rooms',
                onTap: () async {
                  Navigator.of(context).pop();
                  final confirmed = await ConfirmationDialog.show(
                    context: context,
                    title: 'Unassign Rooms',
                    message:
                        'Are you sure you want to unassign rooms for this reservation?',
                    confirmText: 'Unassign',
                    cancelText: 'Cancel',
                    confirmColor: AppColors.red,
                    icon: Icons.meeting_room,
                  );
                  if (confirmed == true) {
                    await _reservationVm.unassignRoom(guestData);
                    if (!mounted) return;
                  }
                },
              ),
            ActionItem(
              icon: Icons.swap_horiz,
              label: 'Change Reservation Type',
              onTap: () async {
                Navigator.of(context).pop();

                WidgetsBinding.instance.addPostFrameCallback((_) async {
                  await context.showChangeReservationTypeDialog(
                    guestItem: guestData,
                  );
                });
              },
            ),
            ActionItem(
              icon: Icons.person,
              label: 'Edit Guest Details',
              onTap: () {
                context.pop();
                context.push(AppRoutes.editGuestDetails, extra: guestData);
              },
            ),
            ActionItem(icon: Icons.receipt, label: 'Print Invoice'),
            ActionItem(icon: Icons.description, label: 'Print Res. Voucher'),
            ActionItem(icon: Icons.email, label: 'Send Res. Voucher'),
            ActionItem(icon: Icons.email, label: 'Resend Booking Email'),
          ],
        );
      },
    );
  }
}
