class AppResources {
  static final String logoutUrl =
      'http://pms_service.intapos.com:3334/api/userAccount/Logout';

  String baseUrl;

  AppResources({required this.baseUrl});

  static const String dashboard = 'dashboard';
  static const String currency = 'currency';
  static const String calenderBooking = 'calenderBooking';
  static const String booking = 'booking';
  static const String roomTypes = 'roomTypes';
  static const String reservationTypes = 'reservationTypes';
  static const String roomstatus = 'roomstatus';
  static const String businessSources = 'businessSources';
  static const String workorder = 'workorder';
  static const String reportParams = 'reportParams';
  static const String user = 'user';
  static const String rooms = 'rooms';
  static const String reason = 'reason';
  static const String payment = 'payment';
  static const String amendStay = 'amendStay';
  static const String houseKeepingStatus = 'houseKeepingStatus';
  static const String maintenanceblock = 'maintenanceblock';
  static const String auditTrial = 'auditTrial';

  //authentication
  static const String authentication = 'authentication';
  static const String getSystemWorkingDate = 'system/GetSystemWorkingDate';
  static const String getBaseCurrency = '$currency/Base';

  //dashboard
  static const String getBookingStats = '$dashboard/GetBookingStatic';
  static const String getInventoryStats = '$calenderBooking/GetQuickOverview';
  static const String getAllLockReservations =
      '$booking/GetAllLockReservations';
  static const String lockBooking = '$booking/lock';

  //reservation
  static const String searchReservationList = '$booking/SearchReservationList';
  static const String getAllRoomTypes =
      '$roomTypes/GetAll?startIndex=0&PageSize=0&withInactive=false&onlyRoomExistType=true';

  static const String getAllreservationTypes =
      '$reservationTypes/GetAll?startIndex=0&PageSize=0&withInactive=false';

  static const String getAllroomstatus =
      '$roomstatus/GetAll?startIndex=0&PageSize=20';

  static const String getAllbusinessSources =
      '$businessSources/GetAll?startIndex=0&PageSize=0&withInactive=true';
  static const String getByBookingRoomId = '$booking/GetByBookingRoomId';
  static const String getCancellationReasons =
      '$reason/GetByCategory?ResonCategoryId=15&withInactive=false';
  static const String updateBooking = '$booking/updateBooking';
  static const String getNoShowReasons =
      '$reason/GetByCategory?ResonCategoryId=17&withInactive=false';
  static const String getVoidReasons =
      '$reason/GetByCategory?ResonCategoryId=20&withInactive=false';
  static const String getAvailableRooms = '$rooms/Available';
  static const String getStopRoomMoveReasons =
      '$reason/GetByCategory?ResonCategoryId=18&withInactive=false';
  static const String saveReason = '$reason';
  static const String getAmendStayData = '$amendStay';
  static const String getFolioPayments = '$payment';
  static const String saveOtherInformation = '$booking/otherInformation';
  static const String getAuditTrial = '$auditTrial/getAuditTrial/';

  //Housekeeping
  static const String getAllWorkOrders = '$workorder/Search';
  static const String getWorkOrderStatus = '$reportParams/GetWorkOrderStatus';
  static const String getWorkOrderCategories =
      '$reportParams/GetWorkOrderCategory';
  static const String getWellKnownPriorities =
      '$reportParams/GetWellKnownPriority';
  static const String getHouseKeepers = '$user/GetHouseKeepers';
  static const String getAllRoomsForHouseStatus =
      '$rooms/GetAllRoomsForHouseStatus?startIndex=0&PageSize=0&withInactive=false';
  static const String getReasons =
      '$reason/GetByCategory?ResonCategoryId=1&withInactive=false';
  static const String saveWorkOrder = '$workorder/save';
  static const String checkUserPrivilege = '$user/CheckUrlPrivilege';
  static const String getAllHouseKeepingStatus =
      '$houseKeepingStatus/GetAll?startIndex=0&PageSize=0&withInactive=false';
  static const String getAllMaintenanceblock = '$maintenanceblock/GetAll';
  static const String getAllRooms =
      '$rooms/GetAll?startIndex=0&PageSize=0&withInactive=false';
  static const String getAllBlockRoomReasons =
      '$reason/GetByCategory?ResonCategoryId=1&withInactive=false';
  static const String saveMaintenanceblock = '$maintenanceblock/save';
}
