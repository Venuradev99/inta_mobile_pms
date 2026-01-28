import 'package:inta_mobile_pms/services/data_access_service.dart';
import 'package:inta_mobile_pms/services/resource.dart';

class HouseKeepingService {
  final DataAccessService _dataAccess;
  final AppResources _appResources;

  HouseKeepingService(this._dataAccess, this._appResources);

  Future<Map<String, dynamic>> getAllWorkOrdersApi(
    Map<String, dynamic> body,
  ) async {
    try {
      final url = '${AppResources.getAllWorkOrders}';
      final response = await _dataAccess.post(body, url);
      return response;
    } catch (error) {
      return {"error": error.toString()};
    }
  }

  Future<Map<String, dynamic>> saveNewWorkOrderApi(
    Map<String, dynamic> body,
  ) async {
    try {
      final url = '${AppResources.saveWorkOrder}';
      final response = await _dataAccess.post(body, url);
      return response;
    } catch (error) {
      return {"error": error.toString()};
    }
  }

  Future<Map<String, dynamic>> getWorkOrderStatusApi() async {
    try {
      final url = '${AppResources.getWorkOrderStatus}';
      final response = await _dataAccess.get(url);
      return response;
    } catch (error) {
      return {"error": error.toString()};
    }
  }

  Future<Map<String, dynamic>> getWorkOrderCategoriesApi() async {
    try {
      final url =
          '${AppResources.getWorkOrderCategories}';
      final response = await _dataAccess.get(url);
      return response;
    } catch (error) {
      return {"error": error.toString()};
    }
  }

  Future<Map<String, dynamic>> getWellKnownPrioritiesApi() async {
    try {
      final url =
          '${AppResources.getWellKnownPriorities}';
      final response = await _dataAccess.get(url);
      return response;
    } catch (error) {
      return {"error": error.toString()};
    }
  }

  Future<Map<String, dynamic>> getHouseKeepersApi() async {
    try {
      final url = '${AppResources.getHouseKeepers}';
      final response = await _dataAccess.get(url);
      return response;
    } catch (error) {
      return {"error": error.toString()};
    }
  }

  Future<Map<String, dynamic>> updateHouseStatusApi(
    Map<String, dynamic> body,
  ) async {
    try {
      final url = '${AppResources.updateHouseStatus}';
      final response = await _dataAccess.post(body, url);
      return response;
    } catch (error) {
      return {"error": error.toString()};
    }
  }

  Future<Map<String, dynamic>> getAllHouseKeepingAuditTrailApi(
    int id,
    int type,
    bool isRoom,
    DateTime date,
  ) async {
    try {
      final url =
          '${AppResources.getAllHouseKeepingAuditTrail}/${id}?type=${type}&isRoom=${isRoom}&date=${date}';
      final response = await _dataAccess.get(url);
      return response;
    } catch (error) {
      return {"error": error.toString()};
    }
  }

  Future<Map<String, dynamic>> getAllRoomsForHouseStatusApi() async {
    try {
      final url =
          '${AppResources.getAllRoomsForHouseStatus}';
      final response = await _dataAccess.get(url);
      return response;
    } catch (error) {
      return {"error": error.toString()};
    }
  }

  Future<Map<String, dynamic>> getMaintenanceBlockByIdApi(int id) async {
    try {
      final url =
          '${AppResources.getMaintenanceBlockById}/${id}';
      final response = await _dataAccess.get(url);
      return response;
    } catch (error) {
      return {"error": error.toString()};
    }
  }

  Future<Map<String, dynamic>> unblockMaintenanceBlockApi(
    int maintenanceBlockId,
    int currentUserId,
  ) async {
    try {
      final url =
          '${AppResources.unblockMaintenanceBLock}/${maintenanceBlockId}?CurrentUserId=${currentUserId}';
      final response = await _dataAccess.put({}, url);
      return response;
    } catch (error) {
      return {"error": error.toString()};
    }
  }

  Future<Map<String, dynamic>> getReasonsApi() async {
    try {
      final url = '${AppResources.getReasons}';
      final response = await _dataAccess.get(url);
      return response;
    } catch (error) {
      return {"error": error.toString()};
    }
  }

  Future<Map<String, dynamic>> getAllBlockRoomReasonsApi() async {
    try {
      final url =
          '${AppResources.getAllBlockRoomReasons}';
      final response = await _dataAccess.get(url);
      return response;
    } catch (error) {
      return {"error": error.toString()};
    }
  }

  Future<Map<String, dynamic>> saveMaintenanceblockApi(
    Map<String, dynamic> body,
  ) async {
    try {
      final url =
          '${AppResources.saveMaintenanceblock}';
      final response = await _dataAccess.post(body, url);
      return response;
    } catch (error) {
      return {"error": error.toString()};
    }
  }

  Future<Map<String, dynamic>> checkUserPrivilegeApi(
    Map<String, dynamic> body,
  ) async {
    try {
      final url = '${AppResources.checkUserPrivilege}';
      final response = await _dataAccess.post(body, url);
      return response;
    } catch (error) {
      return {"error": error.toString()};
    }
  }

  Future<Map<String, dynamic>> getAllHouseKeepingStatusApi() async {
    try {
      final url =
          '${AppResources.getAllHouseKeepingStatus}';
      final response = await _dataAccess.get(url);
      return response;
    } catch (error) {
      return {"error": error.toString()};
    }
  }

  Future<Map<String, dynamic>> getAllRoomTypesApi({
    bool? withInactive = false,
    bool? onlyRoomExistType = true,
  }) async {
    try {
      final url =
          '${AppResources.getAllRoomTypes}startIndex=0&PageSize=0&withInactive=${withInactive}&onlyRoomExistType=${onlyRoomExistType}';
      final response = await _dataAccess.get(url);
      return response;
    } catch (error) {
      return {"error": error.toString()};
    }
  }

  Future<Map<String, dynamic>> getAllRoomsApi() async {
    try {
      final url = '${AppResources.getAllRooms}';
      final response = await _dataAccess.get(url);
      return response;
    } catch (error) {
      return {"error": error.toString()};
    }
  }

  Future<Map<String, dynamic>> unblockRoomApi(
    Map<String, dynamic> body,
    int maintenanceblockRoomId,
  ) async {
    try {
      final url =
          '${AppResources.unblockMaintenanceblock}/$maintenanceblockRoomId';
      final response = await _dataAccess.put(body, url);
      return response;
    } catch (error) {
      return {"error": error.toString()};
    }
  }

  Future<Map<String, dynamic>> getAllMaintenanceblockApi(
    Map<String, dynamic> body,
  ) async {
    try {
      final url =
          '${AppResources.getAllMaintenanceblock}';
      final response = await _dataAccess.post(body, url);
      return response;
    } catch (error) {
      return {"error": error.toString()};
    }
  }

  Future<Map<String, dynamic>> updatePostNoteApi(
    Map<String, dynamic> body,
    int workOrderId,
  ) async {
    try {
      final url =
          '${AppResources.updatePostNote}/${workOrderId}';
      final response = await _dataAccess.put(body, url);
      return response;
    } catch (error) {
      return {"error": error.toString()};
    }
  }
}
