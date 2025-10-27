import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:inta_mobile_pms/core/theme/app_theme.dart';
import 'package:inta_mobile_pms/features/dashboard/viewmodels/dashboard_vm.dart';
import 'package:inta_mobile_pms/features/dashboard/viewmodels/net_lock_vm.dart';
import 'package:inta_mobile_pms/features/housekeeping/viewmodels/house_status_vm.dart';
import 'package:inta_mobile_pms/features/housekeeping/viewmodels/maintenance_block_vm.dart';
import 'package:inta_mobile_pms/features/housekeeping/viewmodels/work_order_list_vm.dart';
import 'package:inta_mobile_pms/features/reservations/viewmodels/amend_stay_vm.dart';
import 'package:inta_mobile_pms/features/reservations/viewmodels/arrival_list_vm.dart';
import 'package:inta_mobile_pms/features/reservations/viewmodels/assign_rooms_vm.dart';
import 'package:inta_mobile_pms/features/reservations/viewmodels/audit_trail_vm.dart';
import 'package:inta_mobile_pms/features/reservations/viewmodels/cancel_reservation_vm.dart';
import 'package:inta_mobile_pms/features/reservations/viewmodels/change_reservation_type_vm.dart';
import 'package:inta_mobile_pms/features/reservations/viewmodels/departure_list_vm.dart';
import 'package:inta_mobile_pms/features/reservations/viewmodels/inhouse_list_vm.dart';
import 'package:inta_mobile_pms/features/reservations/viewmodels/no_show_reservation_vm.dart';
import 'package:inta_mobile_pms/features/reservations/viewmodels/reservation_list_vm.dart';
import 'package:inta_mobile_pms/features/reservations/viewmodels/room_move_vm.dart';
import 'package:inta_mobile_pms/features/reservations/viewmodels/stop_room_move_vm.dart';
import 'package:inta_mobile_pms/features/reservations/viewmodels/void_reservation_vm.dart';
import 'package:inta_mobile_pms/router/app_router.dart';
import 'package:inta_mobile_pms/router/app_routes.dart';
import 'package:inta_mobile_pms/services/apiServices/dashboard_service.dart';
import 'package:inta_mobile_pms/services/apiServices/house_keeping_service.dart';
import 'package:inta_mobile_pms/services/apiServices/reservation_list_service.dart';
import 'package:inta_mobile_pms/services/apiServices/user_api_service.dart';
import 'package:inta_mobile_pms/services/data_access_service.dart';
import 'package:inta_mobile_pms/services/resource.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final configString = await rootBundle.loadString('assets/config.json');
  final config = jsonDecode(configString);
  String baseUrl = config['baseUrl'];

  final appResources = AppResources(baseUrl: baseUrl);
  final dataAccessService = DataAccessService();

  //services
  final userApiService = UserApiService();
  final dashboardService = DashboardService(dataAccessService, appResources);
  final reservationListService = ReservationListService(
    dataAccessService,
    appResources,
  );
  final houseKeepingService = HouseKeepingService(
    dataAccessService,
    appResources,
  );

  //register Services
  Get.put<DashboardService>(dashboardService);
  Get.put<ReservationListService>(reservationListService);
  Get.put<HouseKeepingService>(houseKeepingService);
  Get.put<UserApiService>(userApiService);

  //Inject services
  Get.put<DashboardVm>(
    DashboardVm(Get.find<DashboardService>(), Get.find<UserApiService>()),
  );
  Get.put<ArrivalListVm>(ArrivalListVm(Get.find<ReservationListService>()));
  Get.put<VoidReservationVm>(
    VoidReservationVm(Get.find<ReservationListService>()),
  );
  Get.put<StopRoomMoveVm>(StopRoomMoveVm(Get.find<ReservationListService>()));
  Get.put<RoomMoveVm>(RoomMoveVm(Get.find<ReservationListService>()));
  Get.put<NoShowReservationVm>(
    NoShowReservationVm(Get.find<ReservationListService>()),
  );
  Get.put<InhouseListVm>(InhouseListVm(Get.find<ReservationListService>()));
  Get.put<CancelReservationVm>(
    CancelReservationVm(Get.find<ReservationListService>()),
  );
  Get.put<DepartureListVm>(DepartureListVm(Get.find<ReservationListService>()));
  Get.put<ReservationListVm>(
    ReservationListVm(Get.find<ReservationListService>()),
  );
  Get.put<WorkOrderListVm>(WorkOrderListVm(Get.find<HouseKeepingService>()));
  Get.put<HouseStatusVm>(HouseStatusVm(Get.find<HouseKeepingService>()));
  Get.put<ChangeReservationTypeVm>(
    ChangeReservationTypeVm(Get.find<ReservationListService>()),
  );
  Get.put<AssignRoomsVm>(AssignRoomsVm(Get.find<ReservationListService>()));
  Get.put<AmendStayVm>(AmendStayVm(Get.find<ReservationListService>()));
  Get.put<MaintenanceBlockVm>(
    MaintenanceBlockVm(Get.find<HouseKeepingService>()),
  );
  Get.put<NetLockVm>(NetLockVm(Get.find<DashboardService>()));
  Get.put<AuditTrailVm>(AuditTrailVm(Get.find<ReservationListService>()));

  runApp(const PMSApp());
}

class PMSApp extends StatelessWidget {
  const PMSApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Inta Mobile PMS',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      initialRoute: AppRoutes.login,
      getPages: appRoutes,
    );
  }
}
