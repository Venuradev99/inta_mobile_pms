import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:inta_mobile_pms/core/theme/app_theme.dart';
import 'package:inta_mobile_pms/features/dashboard/viewmodels/dashboard_vm.dart';
import 'package:inta_mobile_pms/features/dashboard/viewmodels/net_lock_vm.dart';
import 'package:inta_mobile_pms/features/dashboard/viewmodels/quick_reservation_vm.dart';
import 'package:inta_mobile_pms/features/housekeeping/viewmodels/house_status_vm.dart';
import 'package:inta_mobile_pms/features/housekeeping/viewmodels/maintenance_block_vm.dart';
import 'package:inta_mobile_pms/features/housekeeping/viewmodels/work_order_list_vm.dart';
import 'package:inta_mobile_pms/features/reports/viewmodels/manager_report_vm.dart';
import 'package:inta_mobile_pms/features/reports/viewmodels/night_audit_report_vm.dart';
import 'package:inta_mobile_pms/features/reservations/viewmodels/amend_stay_vm.dart';
import 'package:inta_mobile_pms/features/reservations/viewmodels/assign_rooms_vm.dart';
import 'package:inta_mobile_pms/features/reservations/viewmodels/audit_trail_vm.dart';
import 'package:inta_mobile_pms/features/reservations/viewmodels/cancel_reservation_vm.dart';
import 'package:inta_mobile_pms/features/reservations/viewmodels/change_reservation_type_vm.dart';
import 'package:inta_mobile_pms/features/reservations/viewmodels/edit_guest_details_vm.dart';
import 'package:inta_mobile_pms/features/reservations/viewmodels/inhouse_list_vm.dart';
import 'package:inta_mobile_pms/features/reservations/viewmodels/no_show_reservation_vm.dart';
import 'package:inta_mobile_pms/features/reservations/viewmodels/reservation_vm.dart';
import 'package:inta_mobile_pms/features/reservations/viewmodels/room_move_vm.dart';
import 'package:inta_mobile_pms/features/reservations/viewmodels/stop_room_move_vm.dart';
import 'package:inta_mobile_pms/features/reservations/viewmodels/void_reservation_vm.dart';
import 'package:inta_mobile_pms/features/stay_view/viewmodels/stay_view_vm.dart';
import 'package:inta_mobile_pms/router/app_router.dart';
import 'package:inta_mobile_pms/services/apiServices/dashboard_service.dart';
import 'package:inta_mobile_pms/services/apiServices/house_keeping_service.dart';
import 'package:inta_mobile_pms/services/apiServices/quick_reservation_service.dart';
import 'package:inta_mobile_pms/services/apiServices/reports_service.dart';
import 'package:inta_mobile_pms/services/apiServices/reservation_service.dart';
import 'package:inta_mobile_pms/services/apiServices/stay_view_service.dart';
import 'package:inta_mobile_pms/services/apiServices/user_api_service.dart';
import 'package:inta_mobile_pms/services/data_access_service.dart';
import 'package:inta_mobile_pms/services/message_service.dart';
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
  final stayViewService = StayViewService(dataAccessService, appResources);
  final dashboardService = DashboardService(dataAccessService, appResources);
  final reservationService = ReservationService(
    dataAccessService,
    appResources,
  );
  final houseKeepingService = HouseKeepingService(
    dataAccessService,
    appResources,
  );
  final quickReservationService = QuickReservationService(
    dataAccessService,
    appResources,
  );
  final reportsService = ReportsService(dataAccessService, appResources);

  //register Services
  Get.put<StayViewService>(stayViewService);
  Get.put<DashboardService>(dashboardService);
  Get.put<ReservationService>(reservationService);
  Get.put<HouseKeepingService>(houseKeepingService);
  Get.put<UserApiService>(userApiService);
  Get.put<QuickReservationService>(quickReservationService);
  Get.put<ReportsService>(reportsService);

  //Inject services
  Get.put<DashboardVm>(
    DashboardVm(
      Get.find<DashboardService>(),
      Get.find<UserApiService>(),
      Get.find<ReservationService>(),
    ),
  );
  Get.put<ReservationVm>(ReservationVm(Get.find<ReservationService>()));
  Get.put<VoidReservationVm>(
    VoidReservationVm(Get.find<ReservationService>()),
  );
  Get.put<StopRoomMoveVm>(StopRoomMoveVm(Get.find<ReservationService>()));
  Get.put<RoomMoveVm>(RoomMoveVm(Get.find<ReservationService>()));
  Get.put<NoShowReservationVm>(
    NoShowReservationVm(Get.find<ReservationService>()),
  );
  Get.put<InhouseListVm>(InhouseListVm(Get.find<ReservationService>()));
  Get.put<CancelReservationVm>(
    CancelReservationVm(Get.find<ReservationService>()),
  );
  Get.put<WorkOrderListVm>(WorkOrderListVm(Get.find<HouseKeepingService>()));
  Get.put<HouseStatusVm>(HouseStatusVm(Get.find<HouseKeepingService>()));
  Get.put<ChangeReservationTypeVm>(
    ChangeReservationTypeVm(Get.find<ReservationService>()),
  );
  Get.put<AssignRoomsVm>(AssignRoomsVm(Get.find<ReservationService>()));
  Get.put<AmendStayVm>(AmendStayVm(Get.find<ReservationService>()));
  Get.put<MaintenanceBlockVm>(
    MaintenanceBlockVm(Get.find<HouseKeepingService>()),
  );
  Get.put<NetLockVm>(NetLockVm(Get.find<DashboardService>()));
  Get.put<AuditTrailVm>(AuditTrailVm(Get.find<ReservationService>()));
  Get.put<EditGuestDetailsVm>(
    EditGuestDetailsVm(Get.find<ReservationService>()),
  );
  Get.put<StayViewVm>(
    StayViewVm(Get.find<StayViewService>(), Get.find<ReservationService>())
  );
  Get.put<QuickReservationVm>(
    QuickReservationVm(Get.find<QuickReservationService>()),
  );
  Get.put<NightAuditReportVm>(NightAuditReportVm(Get.find<ReportsService>()));
  Get.put<ManagerReportVm>(ManagerReportVm(Get.find<ReportsService>()));

  runApp(PMSApp());
}

class PMSApp extends StatelessWidget {
  final MessageService _messageService = MessageService();
  PMSApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Inta Mobile PMS',
      scaffoldMessengerKey: _messageService.messengerKey,
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      routerConfig: appRouter,
    );
  }
}
