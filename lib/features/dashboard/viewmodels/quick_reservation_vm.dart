import 'package:get/get.dart';
import 'package:inta_mobile_pms/services/apiServices/quick_reservation_service.dart';

class QuickReservationVm extends GetxController {
  final QuickReservationService _quickReservationService;

  var isLoading = true.obs;

  QuickReservationVm(this._quickReservationService);

  Future<void> loadInitialData() async {
    // try{
    //   isLoading.value = true;

    //   final response = await Future.wait([
     
    //   ]);

    // }catch(e){

    // }finally{
    //   isLoading.value = false;
    // }
  }
}
