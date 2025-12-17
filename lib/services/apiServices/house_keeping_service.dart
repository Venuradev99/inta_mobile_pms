import 'package:inta_mobile_pms/services/data_access_service.dart';
import 'package:inta_mobile_pms/services/resource.dart';

class HouseKeepingService {
  final DataAccessService _dataAccess;
  final AppResources _appResources;

  HouseKeepingService(this._dataAccess, this._appResources);

  Future<Map<String, dynamic>> getAllWorkOrders(
    Map<String, dynamic> body,
  ) async {
    try {
      final url = '${_appResources.baseUrl}${AppResources.getAllWorkOrders}';
      final response = await _dataAccess.post(body, url);
      return response;
    } catch (error) {
      return {"error": error.toString()};
    }
  }

  Future<Map<String, dynamic>> saveNewWorkOrder(
    Map<String, dynamic> body,
  ) async {
    try {
      final url = '${_appResources.baseUrl}${AppResources.saveWorkOrder}';
      final response = await _dataAccess.post(body, url);
      return response;
    } catch (error) {
      return {"error": error.toString()};
    }
  }

  Future<Map<String, dynamic>> getWorkOrderStatus() async {
    try {
      final url = '${_appResources.baseUrl}${AppResources.getWorkOrderStatus}';
      final response = await _dataAccess.get(url);
      return response;
    } catch (error) {
      return {"error": error.toString()};
    }
  }

  Future<Map<String, dynamic>> getWorkOrderCategories() async {
    try {
      final url =
          '${_appResources.baseUrl}${AppResources.getWorkOrderCategories}';
      final response = await _dataAccess.get(url);
      return response;
    } catch (error) {
      return {"error": error.toString()};
    }
  }

  Future<Map<String, dynamic>> getWellKnownPriorities() async {
    try {
      final url =
          '${_appResources.baseUrl}${AppResources.getWellKnownPriorities}';
      final response = await _dataAccess.get(url);
      return response;
    } catch (error) {
      return {"error": error.toString()};
    }
  }

  Future<Map<String, dynamic>> getHouseKeepers() async {
    try {
      final url = '${_appResources.baseUrl}${AppResources.getHouseKeepers}';
      final response = await _dataAccess.get(url);
      return response;
    } catch (error) {
      return {"error": error.toString()};
    }
  }

  Future<Map<String, dynamic>> updateHouseStatus(
    Map<String, dynamic> body,
  ) async {
    try {
      final url = '${_appResources.baseUrl}${AppResources.updateHouseStatus}';
      final response = await _dataAccess.post(body, url);
      return response;
    } catch (error) {
      return {"error": error.toString()};
    }
  }

   Future<Map<String, dynamic>> getAllHouseKeepingAuditTrail(
    int id,int type, bool isRoom, DateTime date
  ) async {
    try {
      final url = '${_appResources.baseUrl}${AppResources.getAllHouseKeepingAuditTrail}/${id}?type=${type}&isRoom=${isRoom}&date=${date}';
      final response = await _dataAccess.get(url);
      return response;
    } catch (error) {
      return {"error": error.toString()};
    }
  }

  Future<Map<String, dynamic>> getAllRoomsForHouseStatus() async {
    try {
      final url =
          '${_appResources.baseUrl}${AppResources.getAllRoomsForHouseStatus}';
      final response = await _dataAccess.get(url);
      return response;
    } catch (error) {
      return {"error": error.toString()};
    }
  }

  Future<Map<String, dynamic>> getReasons() async {
    try {
      final url = '${_appResources.baseUrl}${AppResources.getReasons}';
      final response = await _dataAccess.get(url);
      return response;
    } catch (error) {
      return {"error": error.toString()};
    }
  }

  Future<Map<String, dynamic>> getAllBlockRoomReasons() async {
    try {
      final url =
          '${_appResources.baseUrl}${AppResources.getAllBlockRoomReasons}';
      final response = await _dataAccess.get(url);
      return response;
    } catch (error) {
      return {"error": error.toString()};
    }
  }

  Future<Map<String, dynamic>> saveMaintenanceblock(
    Map<String, dynamic> body,
  ) async {
    try {
      final url =
          '${_appResources.baseUrl}${AppResources.saveMaintenanceblock}';
      final response = await _dataAccess.post(body, url);
      return response;
    } catch (error) {
      return {"error": error.toString()};
    }
  }

  Future<Map<String, dynamic>> checkUserPrivilege(
    Map<String, dynamic> body,
  ) async {
    try {
      final url = '${_appResources.baseUrl}${AppResources.checkUserPrivilege}';
      final response = await _dataAccess.post(body, url);
      return response;
    } catch (error) {
      return {"error": error.toString()};
    }
  }

  Future<Map<String, dynamic>> getAllHouseKeepingStatus() async {
    try {
      final url =
          '${_appResources.baseUrl}${AppResources.getAllHouseKeepingStatus}';
      final response = await _dataAccess.get(url);
      return response;
    } catch (error) {
      return {"error": error.toString()};
    }
  }

  Future<Map<String, dynamic>> getAllRoomTypes() async {
    try {
      final url = '${_appResources.baseUrl}${AppResources.getAllRoomTypes}';
      final response = await _dataAccess.get(url);
      return response;
    } catch (error) {
      return {"error": error.toString()};
    }
  }

  Future<Map<String, dynamic>> getAllRooms() async {
    try {
      final url = '${_appResources.baseUrl}${AppResources.getAllRooms}';
      final response = await _dataAccess.get(url);
      return response;
    } catch (error) {
      return {"error": error.toString()};
    }
  }

  Future<Map<String, dynamic>> unblockRoom(
    Map<String, dynamic> body,
    int maintenanceblockRoomId,
  ) async {
    try {
      final url =
          '${_appResources.baseUrl}${AppResources.unblockMaintenanceblock}/$maintenanceblockRoomId';
      final response = await _dataAccess.put(body, url);
      return response;
    } catch (error) {
      return {"error": error.toString()};
    }
  }

  Future<Map<String, dynamic>> getAllMaintenanceblock(
    Map<String, dynamic> body,
  ) async {
    try {
      final url =
          '${_appResources.baseUrl}${AppResources.getAllMaintenanceblock}';
      final response = await _dataAccess.post(body, url);
      return response;
    } catch (error) {
      return {"error": error.toString()};
    }
  }
}
