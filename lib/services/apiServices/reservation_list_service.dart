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

  Future<Map<String, dynamic>> getAllRoomTypes() async {
     try {
      final url = AppResources.getAllRoomTypes;
      final response = await _dataAccess.get(url);
      return response;
    } catch (error) {
      return {"error": error.toString()};
    }
  }

  Future<Map<String, dynamic>> getAllreservationTypes() async {
     try {
      final url = AppResources.getAllreservationTypes;
      final response = await _dataAccess.get(url);
      return response;
    } catch (error) {
      return {"error": error.toString()};
    }
  }
  
   Future<Map<String, dynamic>> getAllroomstatus() async {
     try {
      final url = AppResources.getAllroomstatus;
      final response = await _dataAccess.get(url);
      return response;
    } catch (error) {
      return {"error": error.toString()};
    }
  }

    Future<Map<String, dynamic>> getAllbusinessSources() async {
     try {
      final url = AppResources.getAllbusinessSources;
      final response = await _dataAccess.get(url);
      return response;
    } catch (error) {
      return {"error": error.toString()};
    }
  }
  
}