import 'package:go_router/go_router.dart';
import 'package:inta_mobile_pms/features/housekeeping/models/room_response.dart';
import 'package:inta_mobile_pms/features/housekeeping/screens/block_room_selection_screen.dart';
import 'package:inta_mobile_pms/features/login/login_page.dart';
import 'package:inta_mobile_pms/features/reservations/models/guest_item.dart';
import 'package:inta_mobile_pms/features/reservations/screens/amend_stay_scrn.dart';
import 'package:inta_mobile_pms/features/reservations/screens/arrival_list_scrn.dart';
import 'package:inta_mobile_pms/features/dashboard/screens/dashboard_scrn.dart';
import 'package:inta_mobile_pms/features/reservations/screens/audit_trail_scrn.dart';
import 'package:inta_mobile_pms/features/reservations/screens/cancel_reservation_scrn.dart';
import 'package:inta_mobile_pms/features/reservations/screens/departure_list_scrn.dart';
import 'package:inta_mobile_pms/features/dashboard/screens/settings_scrn.dart';
import 'package:inta_mobile_pms/features/housekeeping/screens/house_status_screen.dart';
import 'package:inta_mobile_pms/features/reservations/screens/edit_guest_details_scrn.dart';
import 'package:inta_mobile_pms/features/reservations/screens/inhouse_list_scrn.dart';
import 'package:inta_mobile_pms/features/housekeeping/screens/maintenance_block_screen.dart';
import 'package:inta_mobile_pms/features/dashboard/screens/net_lock_scrn.dart';
import 'package:inta_mobile_pms/features/dashboard/screens/notifications_scrn.dart';
import 'package:inta_mobile_pms/features/dashboard/screens/quick_reservation_scrn.dart';
import 'package:inta_mobile_pms/features/dashboard/screens/rates_inventory_scrn.dart';
import 'package:inta_mobile_pms/features/reservations/screens/no_show_reservation_scrn.dart';
import 'package:inta_mobile_pms/features/reservations/screens/reservation_list_scrn.dart';
import 'package:inta_mobile_pms/features/housekeeping/screens/work_order_list_screen.dart';
import 'package:inta_mobile_pms/features/reports/manager_report.dart';
import 'package:inta_mobile_pms/features/reservations/screens/room_move_scrn.dart';
import 'package:inta_mobile_pms/features/reservations/screens/stop_room_move_scrn.dart';
import 'package:inta_mobile_pms/features/reservations/screens/view_reservation_scrn.dart';
import 'package:inta_mobile_pms/features/reservations/screens/void_reservation_scrn.dart';
import 'package:inta_mobile_pms/features/reservations/widgets/change_reservation_type_wgt.dart';
import 'package:inta_mobile_pms/features/stay_view/stay_view.dart';
import 'package:inta_mobile_pms/router/app_routes.dart';
import 'package:inta_mobile_pms/services/navigation_service.dart';

import '../features/housekeeping/screens/block_room_selection_details.dart';

final appRouter = GoRouter(
  initialLocation: AppRoutes.login,
   navigatorKey: NavigationService().navigatorKey,
  routes: [
    GoRoute(
      path: AppRoutes.dashboard,
      builder: (context, state) => const Dashboard(),
    ),
    GoRoute(
      path: AppRoutes.stayView,
      builder: (context, state) => const StayView(),
    ),
    GoRoute(
      path: AppRoutes.arrivalList,
      builder: (context, state) => const ArrivalList(),
    ),
    GoRoute(
      path: AppRoutes.inhouseList,
      builder: (context, state) => const InHouseList(),
    ),
    GoRoute(
      path: AppRoutes.departureList,
      builder: (context, state) => const DepartureList(),
    ),
    GoRoute(
      path: AppRoutes.reservationList,
      builder: (context, state) => const ReservationList(),
    ),
    GoRoute(
      path: AppRoutes.quickReservation,
      builder: (context, state) => const QuickReservation(),
    ),
    GoRoute(
      path: AppRoutes.ratesInventory,
      builder: (context, state) => const RatesInventory(),
    ),
    GoRoute(
      path: AppRoutes.houseStatus,
      builder: (context, state) => const HouseStatus(),
    ),
    GoRoute(
      path: AppRoutes.netLock,
      builder: (context, state) => const NetLock(),
    ),
    GoRoute(
      path: AppRoutes.notifications,
      builder: (context, state) => const Notifications(),
    ),
    GoRoute(
      path: AppRoutes.workOrderList,
      builder: (context, state) => const WorkOrderList(),
    ),
    GoRoute(
      path: AppRoutes.managerReport,
      builder: (context, state) => const ManagerReport(),
    ),
    GoRoute(
      path: AppRoutes.maintenanceBlock,
      builder: (context, state) => const MaintenanceBlock(),
    ),
    GoRoute(
      path: AppRoutes.settings,
      builder: (context, state) => const Settings(),
    ),
    GoRoute(
      path: AppRoutes.viewReservation,
      builder: (context, state) =>
          ViewReservation(item: state.extra as GuestItem),
    ),
    GoRoute(
      path: AppRoutes.login,
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: AppRoutes.amendstay,
      builder: (context, state) =>
          AmendStay(guestItem: state.extra as GuestItem?),
    ),
    GoRoute(
      path: AppRoutes.stopRoomMove,
      builder: (context, state) => const StopRoomMoveScreen(),
    ),
    GoRoute(
      path: AppRoutes.roomMove,
      builder: (context, state) =>
          RoomMovePage(guestItem: state.extra as GuestItem?),
    ),
    GoRoute(
      path: AppRoutes.changeReservationType,
      builder: (context, state) => const ChangeReservationType(),
    ),
    GoRoute(
      path: AppRoutes.cancelReservation,
      builder: (context, state) => CancelReservation(
        reservationData: state.extra as Map<String, dynamic>,
      ),
    ),
    GoRoute(
      path: AppRoutes.voidReservation,
      builder: (context, state) => const VoidReservation(reservationData: {}),
    ),
    GoRoute(
      path: AppRoutes.noShowReservation,
      builder: (context, state) {
        final data = state.extra as NoShowReservationData;
        return NoShowReservationPage(data: data);
      },
    ),
    GoRoute(
      path: AppRoutes.blockRoomSelection,
      builder: (context, state) => const BlockRoomSelectionScreen(),
    ),
    GoRoute(
      path: AppRoutes.blockRoomDetails,
      builder: (context, state) {
        final selectedRooms = state.extra as List<RoomResponse>;
        return BlockRoomDetailsScreen(selectedRooms: selectedRooms);
      },
    ),
    GoRoute(
      path: AppRoutes.auditTrail,
      builder: (context, state) =>
          AuditTrail(guestItem: state.extra as GuestItem),
    ),
    GoRoute(
      path: AppRoutes.editGuestDetails,
      builder: (context, state) =>
          EditGuestDetails(guestItem: state.extra as GuestItem?),
    ),
  ],
);


// import 'package:get/get.dart';
// import 'package:inta_mobile_pms/features/housekeeping/models/room_response.dart';
// import 'package:inta_mobile_pms/features/housekeeping/screens/block_room_selection_screen.dart';
// import 'package:inta_mobile_pms/features/login/login_page.dart';
// import 'package:inta_mobile_pms/features/reservations/models/audit_trail_response.dart';
// import 'package:inta_mobile_pms/features/reservations/models/guest_item.dart';
// import 'package:inta_mobile_pms/features/reservations/screens/amend_stay_scrn.dart';
// import 'package:inta_mobile_pms/features/reservations/screens/arrival_list_scrn.dart';
// import 'package:inta_mobile_pms/features/dashboard/screens/dashboard_scrn.dart';
// import 'package:inta_mobile_pms/features/reservations/screens/audit_trail_scrn.dart';
// import 'package:inta_mobile_pms/features/reservations/screens/cancel_reservation_scrn.dart';
// import 'package:inta_mobile_pms/features/reservations/screens/departure_list_scrn.dart';
// import 'package:inta_mobile_pms/features/dashboard/screens/settings_scrn.dart';
// import 'package:inta_mobile_pms/features/housekeeping/screens/house_status_screen.dart';
// import 'package:inta_mobile_pms/features/reservations/screens/inhouse_list_scrn.dart';
// import 'package:inta_mobile_pms/features/housekeeping/screens/maintenance_block_screen.dart';
// import 'package:inta_mobile_pms/features/dashboard/screens/net_lock_scrn.dart';
// import 'package:inta_mobile_pms/features/dashboard/screens/notifications_scrn.dart';
// import 'package:inta_mobile_pms/features/dashboard/screens/quick_reservation_scrn.dart';
// import 'package:inta_mobile_pms/features/dashboard/screens/rates_inventory_scrn.dart';
// import 'package:inta_mobile_pms/features/reservations/screens/no_show_reservation_scrn.dart';
// import 'package:inta_mobile_pms/features/reservations/screens/reservation_list_scrn.dart';
// import 'package:inta_mobile_pms/features/housekeeping/screens/work_order_list_screen.dart';
// import 'package:inta_mobile_pms/features/reports/manager_report.dart';
// import 'package:inta_mobile_pms/features/reservations/screens/room_move_scrn.dart';
// import 'package:inta_mobile_pms/features/reservations/screens/stop_room_move_scrn.dart';
// import 'package:inta_mobile_pms/features/reservations/screens/view_reservation_scrn.dart';
// import 'package:inta_mobile_pms/features/reservations/screens/void_reservation_scrn.dart';
// import 'package:inta_mobile_pms/features/reservations/widgets/change_reservation_type_wgt.dart';
// import 'package:inta_mobile_pms/features/stay_view/stay_view.dart';
// import 'package:inta_mobile_pms/router/app_routes.dart';
// import '../features/housekeeping/screens/block_room_selection_details.dart';

// final appRoutes = [
//   GetPage(name: AppRoutes.login, page: () => const LoginPage()),
//   GetPage(name: AppRoutes.dashboard, page: () => const Dashboard()),
//   GetPage(name: AppRoutes.stayView, page: () => const StayView()),
//   GetPage(name: AppRoutes.arrivalList, page: () => const ArrivalList()),
//   GetPage(name: AppRoutes.inhouseList, page: () => const InHouseList()),
//   GetPage(name: AppRoutes.departureList, page: () => const DepartureList()),
//   GetPage(name: AppRoutes.reservationList, page: () => const ReservationList()),
//   GetPage(name: AppRoutes.quickReservation, page: () => const QuickReservation()),
//   GetPage(name: AppRoutes.ratesInventory, page: () => const RatesInventory()),
//   GetPage(name: AppRoutes.houseStatus, page: () => const HouseStatus()),
//   GetPage(name: AppRoutes.netLock, page: () => const NetLock()),
//   GetPage(name: AppRoutes.notifications, page: () => const Notifications()),
//   GetPage(name: AppRoutes.workOrderList, page: () => const WorkOrderList()),
//   GetPage(name: AppRoutes.managerReport, page: () => const ManagerReport()),
//   GetPage(name: AppRoutes.maintenanceBlock, page: () => const MaintenanceBlock()),
//   GetPage(name: AppRoutes.settings, page: () => const Settings()),
  
//   // Extra data screens
//   GetPage(
//     name: AppRoutes.viewReservation,
//     page: () => ViewReservation(item: Get.arguments as GuestItem),
//   ),
//   GetPage(
//     name: AppRoutes.amendstay,
//     page: () => AmendStay(guestItem: Get.arguments as GuestItem?),
//   ),
//   GetPage(
//     name: AppRoutes.roomMove,
//     page: () => RoomMovePage(guestItem: Get.arguments as GuestItem?),
//   ),
//   GetPage(name: AppRoutes.stopRoomMove, page: () => const StopRoomMoveScreen()),
//   GetPage(name: AppRoutes.changeReservationType, page: () => const ChangeReservationType()),
//   GetPage(
//     name: AppRoutes.cancelReservation,
//     page: () => CancelReservation(reservationData: Get.arguments as Map<String, dynamic>),
//   ),
//   GetPage(
//     name: AppRoutes.voidReservation,
//     page: () => const VoidReservation(reservationData: {}),
//   ),
//   GetPage(
//     name: AppRoutes.noShowReservation,
//     page: () => NoShowReservationPage(data: Get.arguments as NoShowReservationData),
//   ),
//   GetPage(name: AppRoutes.blockRoomSelection, page: () => const BlockRoomSelectionScreen()),
//   GetPage(
//     name: AppRoutes.blockRoomDetails,
//     page: () => BlockRoomDetailsScreen(selectedRooms: Get.arguments as List<RoomResponse>),
//   ),
//   GetPage(name: AppRoutes.auditTrail, page: () => AuditTrail(guestItem: Get.arguments as GuestItem)),
// ];
