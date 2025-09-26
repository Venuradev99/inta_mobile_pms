import 'package:go_router/go_router.dart';
import 'package:inta_mobile_pms/features/login/login_page.dart';
import 'package:inta_mobile_pms/features/reservations/models/guest_item.dart';
import 'package:inta_mobile_pms/features/reservations/screens/arrival_list.dart';
import 'package:inta_mobile_pms/features/dashboard/screens/dashboard.dart';
import 'package:inta_mobile_pms/features/reservations/screens/departure_list.dart';
import 'package:inta_mobile_pms/features/dashboard/screens/settings.dart';
import 'package:inta_mobile_pms/features/housekeeping/screens/house_status.dart';
import 'package:inta_mobile_pms/features/reservations/screens/inhouse_list.dart';
import 'package:inta_mobile_pms/features/housekeeping/screens/maintenance_block.dart';
import 'package:inta_mobile_pms/features/dashboard/screens/net_lock.dart';
import 'package:inta_mobile_pms/features/dashboard/screens/notifications.dart';
import 'package:inta_mobile_pms/features/dashboard/screens/quick_reservation.dart';
import 'package:inta_mobile_pms/features/dashboard/screens/rates_inventory.dart';
import 'package:inta_mobile_pms/features/reservations/screens/reservation_list.dart';
import 'package:inta_mobile_pms/features/housekeeping/screens/work_order_list.dart';
import 'package:inta_mobile_pms/features/reports/manager_report.dart';
import 'package:inta_mobile_pms/features/reservations/screens/view_reservation.dart';
import 'package:inta_mobile_pms/features/stay_view/stay_view.dart';
import 'package:inta_mobile_pms/router/app_routes.dart';

final  appRouter = GoRouter(
  initialLocation: AppRoutes.login,
  routes: [
    GoRoute(path: AppRoutes.dashboard, builder: (context, state) => const Dashboard()),
    GoRoute(path: AppRoutes.stayView, builder: (context, state) => const StayView()),
    GoRoute(path: AppRoutes.arrivalList, builder: (context, state) => const ArrivalList()),
    GoRoute(path: AppRoutes.inhouseList, builder: (context, state) => const InHouseList()),
    GoRoute(path: AppRoutes.departureList, builder: (context, state) => const DepartureList()),
    GoRoute(path: AppRoutes.reservationList, builder: (context, state) => const ReservationList()),
    GoRoute(path: AppRoutes.quickReservation, builder: (context, state) => const QuickReservation()),
    GoRoute(path: AppRoutes.ratesInventory, builder: (context, state) => const RatesInventory()),
    GoRoute(path: AppRoutes.houseStatus, builder: (context, state) => const HouseStatus()),
    GoRoute(path: AppRoutes.netLock, builder: (context, state) => const NetLock()),
    GoRoute(path: AppRoutes.notifications, builder: (context, state) => const Notifications()),
    GoRoute(path: AppRoutes.workOrderList, builder: (context, state) => const WorkOrderList()),
    GoRoute(path: AppRoutes.managerReport, builder: (context, state) => const ManagerReport()),
    GoRoute(path: AppRoutes.maintenanceBlock, builder: (context, state) => const MaintenanceBlock()),
    GoRoute(path: AppRoutes.settings, builder: (context, state) => const Settings()),
    GoRoute(path: AppRoutes.viewReservation, builder: (context, state) => ViewReservation(item: state.extra as GuestItem,)),
    GoRoute(path: AppRoutes.login, builder: (context, state) => const LoginPage()),
    // Define your app routes here
  ],
);