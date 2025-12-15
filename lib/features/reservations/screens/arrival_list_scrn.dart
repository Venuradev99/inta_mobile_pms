import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:inta_mobile_pms/core/theme/app_colors.dart';
import 'package:inta_mobile_pms/core/widgets/custom_appbar.dart';
// Add this import
import 'package:inta_mobile_pms/features/dashboard/widgets/filter_bottom_sheet_wgt.dart';
import 'package:inta_mobile_pms/features/dashboard/widgets/tabbed_list_view_wgt.dart';
import 'package:inta_mobile_pms/features/reservations/models/guest_item.dart';
import 'package:inta_mobile_pms/features/reservations/screens/amend_stay_scrn.dart';
import 'package:inta_mobile_pms/features/reservations/screens/assign_rooms_scrn.dart';
import 'package:inta_mobile_pms/features/reservations/screens/audit_trail_scrn.dart';
import 'package:inta_mobile_pms/features/reservations/screens/cancel_reservation_scrn.dart';
import 'package:inta_mobile_pms/features/reservations/screens/no_show_reservation_scrn.dart';
import 'package:inta_mobile_pms/features/reservations/screens/room_move_scrn.dart';
import 'package:inta_mobile_pms/features/reservations/screens/stop_room_move_scrn.dart';
import 'package:inta_mobile_pms/features/reservations/screens/void_reservation_scrn.dart';
import 'package:inta_mobile_pms/features/reservations/viewmodels/reservation_vm.dart';
import 'package:inta_mobile_pms/features/reservations/widgets/action_bottom_sheet_wgt.dart';
import 'package:inta_mobile_pms/features/reservations/widgets/change_reservation_type_wgt.dart';
import 'package:inta_mobile_pms/features/reservations/widgets/confirmation_dialog_wgt.dart';
import 'package:inta_mobile_pms/features/reservations/widgets/guest_card_wgt.dart';
import 'package:inta_mobile_pms/features/reservations/widgets/message_dialog_wgt.dart';
import 'package:inta_mobile_pms/features/reservations/widgets/status_info_dialog_wgt.dart';
import 'package:inta_mobile_pms/router/app_routes.dart';

class ArrivalList extends StatefulWidget {
  const ArrivalList({super.key});

  @override
  State<ArrivalList> createState() => _ArrivalListState();
}

class _ArrivalListState extends State<ArrivalList> {
  final _arrivalListVm = Get.find<ReservationVm>();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (mounted) {
        await _arrivalListVm.getReservationsMap(3);
      }
    });
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
              builder: (context, scrollController) => Obx(() {
                return FilterBottomSheet(
                  type: 'arrival',
                  roomTypes: _arrivalListVm.roomTypes.toList(),
                  reservationTypes: _arrivalListVm.reservationTypes.toList(),
                  statuses: _arrivalListVm.statuses.toList(),
                  businessSources: _arrivalListVm.businessSources.toList(),
                  filteredData: _arrivalListVm.receivedFilters.value ?? {},
                  onApply: _arrivalListVm.applyFilters,
                  scrollController: scrollController,
                );
              }),
            ),
          );
        },
      ),
      body: Obx(() {
        final isLoading = _arrivalListVm.isLoading;
        final isBottomSheetDataLoading =
            _arrivalListVm.isBottomSheetDataLoading.value;
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
            TabbedListView<GuestItem>(
              tabLabels: const ['Today', 'Tomorrow', 'This Week'],
              dataMap: isLoading.value
                  ? {
                      'today': List.generate(3, (_) => guestItem),
                      'tomorrow': List.generate(3, (_) => guestItem),
                      'thisweek': List.generate(3, (_) => guestItem),
                    }
                  : _arrivalListVm.filteredList.value ?? {},
              itemBuilder: (item) => isLoading.value
                  ? _buildArrivalCardShimmer()
                  : _buildArrivalCard(item),
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
          final statusList = _arrivalListVm.statusList;

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
      reservationType: item.reservationType,
      totalAmount: item.totalAmount,
      balanceAmount: item.balanceAmount,
      baseCurrencySymbol: item.baseCurrencySymbol,
      actionButton: const SizedBox(height: 32),
      onTap: () => _showActions(context, item),
    );
  }

  void _showActions(BuildContext context, GuestItem item) async {
    await _arrivalListVm.getAllGuestData(item.bookingRoomId);
    if (!mounted) return;
    final guestData = _arrivalListVm.allGuestDetails.value;
    final isNoShowResponse = await _arrivalListVm.isNoShow(item);
    int status = int.tryParse(guestData?.status.toString() ?? '') ?? 0;
    bool isNoShow = isNoShowResponse["isNoShow"];
    bool isAssign = guestData?.roomId == 0;
    bool isUnAssignRoom = !isAssign && status != 2 && status != 3;

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
            onTap: () async {
              if (!mounted) return;
              context.pop();
              context.push(AppRoutes.viewReservation, extra: guestData);
            },
          ),
          if (isAssign == true)
            ActionItem(
              icon: Icons.meeting_room,
              label: 'Assign Rooms',
              onTap: () async {
                context.pop();
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
                context.pop();
                final confirmed = await ConfirmationDialog.show(
                  context: Get.context!,
                  title: 'Unassign Rooms',
                  message:
                      'Are you sure you want to unassign rooms for this reservation?',
                  confirmText: 'Unassign',
                  cancelText: 'Cancel',
                  confirmColor: AppColors.red,
                  icon: Icons.meeting_room,
                );
                if (confirmed == true) {
                  context.pop();
                  await _arrivalListVm.unassignRoom(guestData!);
                  if (!mounted) return;
                }
              },
            ),

          ActionItem(
            icon: Icons.edit_calendar,
            label: 'Amend Stay',
            onTap: () {
              context.pop();
              Navigator.of(context).push(
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      AmendStay(guestItem: guestData),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                        const begin = Offset(0.0, 1.0); // slide from bottom
                        const end = Offset.zero;
                        const curve = Curves.ease;

                        var tween = Tween(
                          begin: begin,
                          end: end,
                        ).chain(CurveTween(curve: curve));
                        return SlideTransition(
                          position: animation.drive(tween),
                          child: child,
                        );
                      },
                  transitionDuration: const Duration(milliseconds: 300),
                ),
              );
            },
          ),
          ActionItem(
            icon: Icons.swap_horiz,
            label: 'Change Reservation Type',
            onTap: () async {
              context.pop();

              WidgetsBinding.instance.addPostFrameCallback((_) async {
                await context.showChangeReservationTypeDialog(
                  guestItem: guestData,
                );
              });
            },
          ),
          ActionItem(
            icon: Icons.cancel,
            label: 'Cancel Reservation',
            onTap: () async {
              final cancelReservationData = await _arrivalListVm
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
              context.pop();
              Navigator.of(context).push(
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      CancelReservation(reservationData: data),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                        // Slide from bottom to top
                        const begin = Offset(0.0, 1.0);
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
            icon: Icons.block,
            label: 'Void Reservation',
            onTap: () async {
              final voidReservationData = await _arrivalListVm
                  .getVoidReservationData(item);
              if (!mounted) return;
              context.pop();
              final data = {
                'reasons': voidReservationData["reasons"],
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
              Navigator.of(context).push(
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      VoidReservation(reservationData: data),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                        // Slide from bottom to top
                        const begin = Offset(0.0, 1.0);
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
          if (isNoShow == true)
            ActionItem(
              icon: Icons.not_interested,
              label: 'No Show Reservation',
              onTap: () async {
                final noShowReservationData = await _arrivalListVm
                    .getNoShowReservationData(item);
                if (!mounted) return;
                context.pop();
                final noShowData = NoShowReservationData(
                  reasons: noShowReservationData["reasons"],
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
                Navigator.of(context).push(
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        NoShowReservationPage(data: noShowData),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                          // Slide from bottom to top (downToUp)
                          const begin = Offset(0.0, 1.0);
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
            icon: Icons.person,
            label: 'Edit Guest Details',
            onTap: () {
              context.pop();
              context.push(AppRoutes.editGuestDetails, extra: guestData);
            },
          ),
          ActionItem(
            icon: Icons.move_to_inbox,
            label: 'Room Move',
            onTap: () async {
              if (!mounted) return;
              context.pop();
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
              Navigator.of(context).push(
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      RoomMovePage(guestItem: data),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                        // Slide from bottom to top
                        const begin = Offset(0.0, 1.0);
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
            icon: Icons.stop_circle_outlined,
            label: 'Stop Room Move',
            onTap: () async {
              if (!mounted) return;
              context.pop();
              Navigator.of(context).push(
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      StopRoomMoveScreen(
                        bookingRoomId: guestData?.bookingRoomId ?? '',
                      ),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                        // Slide from bottom to top
                        const begin = Offset(0.0, 1.0);
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
            icon: Icons.receipt,
            label: 'Print Invoice',
            onTap: () {
              context.pop();
              context.push(AppRoutes.maintenanceBlock);
            },
          ),
          ActionItem(
            icon: Icons.description,
            label: 'Print Res. Voucher',
            onTap: () {
              context.pop();
              context.push(AppRoutes.maintenanceBlock);
            },
          ),
          // UPDATED: Send Res. Voucher with MessageDialog
          ActionItem(
            icon: Icons.email,
            label: 'Send Res. Voucher',
            onTap: () async {
              context.pop();

              // Simulate sending process
              await Future.delayed(const Duration(milliseconds: 300));

              if (context.mounted) {
                MessageDialog.show(
                  context,
                  title: 'Voucher Sent!',
                  message:
                      'Reservation voucher has been sent successfully to ${item.guestName}.',
                  type: MessageType.success,
                  buttonText: 'Perfect!',
                );
              }
            },
          ),
          // UPDATED: Resend Booking Email with MessageDialog
          ActionItem(
            icon: Icons.email,
            label: 'Resend Booking Email',
            onTap: () async {
              context.pop();

              // Simulate sending process
              await Future.delayed(const Duration(milliseconds: 300));

              if (context.mounted) {
                MessageDialog.show(
                  context,
                  title: 'Email Sent!',
                  message:
                      'Booking confirmation email has been resent successfully to ${item.guestName}.',
                  type: MessageType.success,
                  buttonText: 'Great!',
                );
              }
            },
          ),
          // UPDATED: Resend Review Email with MessageDialog
          ActionItem(
            icon: Icons.mark_email_unread,
            label: 'Resend Review Email',
            onTap: () async {
              context.pop();

              // Simulate sending process
              await Future.delayed(const Duration(milliseconds: 300));

              if (context.mounted) {
                MessageDialog.show(
                  context,
                  title: 'Review Email Sent!',
                  message:
                      'Review request email has been sent successfully to ${item.guestName}.',
                  type: MessageType.success,
                  buttonText: 'Awesome!',
                );
              }
            },
          ),
          ActionItem(
            icon: Icons.assignment,
            label: 'Audit Trail',
            onTap: () async {
              context.pop();
              Navigator.of(context).push(
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      AuditTrail(guestItem: guestData),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                        // Slide from bottom to top (downToUp)
                        const begin = Offset(0.0, 1.0);
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
        ],
      ),
    );
  }
}
