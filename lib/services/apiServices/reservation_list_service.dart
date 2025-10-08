import 'package:inta_mobile_pms/services/data_access_service.dart';
import 'package:inta_mobile_pms/services/resource.dart';

class ReservationListService {
  final DataAccessService _dataAccess = DataAccessService();

  Future<Map<String, dynamic>> getAllReservationList(Map<String, dynamic> body) async {
     try {
      final url = AppResources.searchReservationList;
      final response = await _dataAccess.post(body, url);
      return response;
    } catch (error) {
      return {"error": error.toString()};
    }
  }
  
}