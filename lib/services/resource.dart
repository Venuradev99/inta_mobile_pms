class AppResources {

  // static final String loginUrl = 'http://192.168.1.200:3535/api/';
  static String baseUrlDynamic = '';
  static final String logoutUrl = 'http://pms_service.intapos.com:3334/api/userAccount/Logout';

  static Future<void> init(String url) async {
    baseUrlDynamic = url;
  }

  //authentication
  static const String authentication = 'authentication';

  //dashboard
  static const String getBookingStats = 'dashboard/GetBookingStatic';
  static const String getInventoryStats = 'calenderBooking/GetQuickOverview';

}
