class AppResources {
  // static final String loginUrl = 'http://192.168.1.200:3535/api/';
  static String baseUrlDynamic = '';
  static final String logoutUrl =
      'http://pms_service.intapos.com:3334/api/userAccount/Logout';

  static Future<void> init(String url) async {
    baseUrlDynamic = url;
  }

  static const String dashboard = 'dashboard';
  static const String calenderBooking = 'calenderBooking';
  static const String booking = 'booking';
  static const String roomTypes = 'roomTypes';
  static const String reservationTypes = 'reservationTypes';
  static const String roomstatus = 'roomstatus';
  static const String businessSources = 'businessSources';

  //authentication
  static const String authentication = 'authentication';
  static const String getSystemWorkingDate = 'system/GetSystemWorkingDate';

  //dashboard
  static const String getBookingStats = '$dashboard/GetBookingStatic';
  static const String getInventoryStats = '$calenderBooking/GetQuickOverview';

  //reservation list
  static const String searchReservationList = '$booking/SearchReservationList';
  static const String getAllRoomTypes =
      '$roomTypes/GetAll?startIndex=0&PageSize=0&withInactive=false&onlyRoomExistType=true';

  static const String getAllreservationTypes =
      '$reservationTypes/GetAll?startIndex=0&PageSize=15';

  static const String getAllroomstatus =
      '$roomstatus/GetAll?startIndex=0&PageSize=20';

  static const String getAllbusinessSources =
      '$businessSources/GetAll?startIndex=0&PageSize=0&withInactive=true';
}
