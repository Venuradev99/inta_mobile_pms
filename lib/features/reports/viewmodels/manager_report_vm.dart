import 'package:get/Get.dart';
import 'package:inta_mobile_pms/services/apiServices/reports_service.dart';
import 'package:inta_mobile_pms/services/message_service.dart';
import 'package:url_launcher/url_launcher.dart';

class ManagerReportVm extends GetxController{
  final ReportsService _reportsService;

  ManagerReportVm(this._reportsService);

  Future<void> loadInitialData() async {
    try {
      final response = await Future.wait([
        _reportsService.getAllHotel(),
        _reportsService.getCurrencies()
      ]);

      final hotelResponse = response[0];
      final currencyResponse = response[1];

      if(hotelResponse["isSuccessful"] == true){

      }else{
         MessageService().error(hotelResponse["error"][0] ?? 'Error gettings Hotels');
      }

       if(currencyResponse["isSuccessful"] == true){

      }else{
         MessageService().error(currencyResponse["error"][0] ?? 'Error gettings Hotels');
      }

    } catch (e) {
       MessageService().error('Error loading Audit Trails: $e');
      throw Exception('Error loading Audit Trails: $e');
    }
  }

    void openBrowser(String url) async {
    final uri = Uri.parse(url);
    try {
      if (!await launchUrl(uri, mode: LaunchMode.platformDefault)) {
        throw Exception('Count not launch!');
      }
    } catch (e) {
      throw Exception('Error launching URL: $e');
    }
  }
  
}