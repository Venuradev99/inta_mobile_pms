import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:inta_mobile_pms/services/data_access_service.dart';
import 'package:inta_mobile_pms/services/resource.dart';

class ReservationService {
  final DataAccessService _dataAccess;
  final AppResources _appResources;

  ReservationService(this._dataAccess, this._appResources);

  Future<Map<String, dynamic>> getAllReservationListApi(
    Map<String, dynamic> body,
  ) async {
    try {
      final url =
          '${_appResources.baseUrl}${AppResources.searchReservationList}';
      final response = await _dataAccess.post(body, url);
      return response;
    } catch (error) {
      return {"error": error.toString()};
    }
  }

  Future<Map<String, dynamic>> getAllRoomTypesApi() async {
    try {
      final url = '${_appResources.baseUrl}${AppResources.getAllRoomTypes}';
      final response = await _dataAccess.get(url);
      return response;
    } catch (error) {
      return {"error": error.toString()};
    }
  }

  Future<Map<String, dynamic>> transportationModesApi() async {
    try {
      final url = '${_appResources.baseUrl}${AppResources.transportationModes}';
      final response = await _dataAccess.get(url);
      return response;
    } catch (error) {
      return {"error": error.toString()};
    }
  }

  Future<Map<String, dynamic>> getAllBusinessCategoryApi() async {
    try {
      final url =
          '${_appResources.baseUrl}${AppResources.getAllBusinessCategory}';
      final response = await _dataAccess.get(url);
      return response;
    } catch (error) {
      return {"error": error.toString()};
    }
  }

  Future<Map<String, dynamic>> getAvailableRoomsApi(
    Map<String, dynamic> body,
  ) async {
    try {
      final url = '${_appResources.baseUrl}${AppResources.getAvailableRooms}';
      final response = await _dataAccess.post(body, url);
      return response;
    } catch (error) {
      return {"error": error.toString()};
    }
  }

  Future<Map<String, dynamic>> getAllreservationTypesApi() async {
    try {
      final url =
          '${_appResources.baseUrl}${AppResources.getAllreservationTypes}';
      final response = await _dataAccess.get(url);
      return response;
    } catch (error) {
      return {"error": error.toString()};
    }
  }

  Future<Map<String, dynamic>> getAllroomstatusApi() async {
    try {
      final url = '${_appResources.baseUrl}${AppResources.getAllroomstatus}';
      final response = await _dataAccess.get(url);
      return response;
    } catch (error) {
      return {"error": error.toString()};
    }
  }

  Future<Map<String, dynamic>> getAllbusinessSourcesApi() async {
    try {
      final url =
          '${_appResources.baseUrl}${AppResources.getAllbusinessSources}';
      final response = await _dataAccess.get(url);
      return response;
    } catch (error) {
      return {"error": error.toString()};
    }
  }

  Future<Map<String, dynamic>> getByBookingRoomIdApi(int bookingRoomId) async {
    try {
      final url =
          '${_appResources.baseUrl}${AppResources.getByBookingRoomId}/$bookingRoomId';
      final response = await _dataAccess.get(url);
      return response;
    } catch (error) {
      return {"error": error.toString()};
    }
  }

  Future<Map<String, dynamic>> getCancellationReasonsApi() async {
    try {
      final url =
          '${_appResources.baseUrl}${AppResources.getCancellationReasons}';
      final response = await _dataAccess.get(url);
      return response;
    } catch (error) {
      return {"error": error.toString()};
    }
  }

  Future<Map<String, dynamic>> getNoShowReasonsApi() async {
    try {
      final url = '${_appResources.baseUrl}${AppResources.getNoShowReasons}';
      final response = await _dataAccess.get(url);
      return response;
    } catch (error) {
      return {"error": error.toString()};
    }
  }

  Future<Map<String, dynamic>> getVoidReasonsApi() async {
    try {
      final url = '${_appResources.baseUrl}${AppResources.getVoidReasons}';
      final response = await _dataAccess.get(url);
      return response;
    } catch (error) {
      return {"error": error.toString()};
    }
  }

  Future<Map<String, dynamic>> getStopRoomMoveReasonsApi() async {
    try {
      final url =
          '${_appResources.baseUrl}${AppResources.getStopRoomMoveReasons}';
      final response = await _dataAccess.get(url);
      return response;
    } catch (error) {
      return {"error": error.toString()};
    }
  }

  Future<Map<String, dynamic>> getAuditTrialApi(
    int bookingId,
    int bookingRoomId,
    int masterFolioBookingTransId,
    int roomId,
  ) async {
    try {
      final url =
          '${_appResources.baseUrl}${AppResources.getAuditTrial}$bookingId/$bookingRoomId/$masterFolioBookingTransId/$roomId';
      final response = await _dataAccess.get(url);
      return response;
    } catch (error) {
      return {"error": error.toString()};
    }
  }

  Future<Map<String, dynamic>> getAmendStayDataApi(
    int roomId,
    int bookingRoomId,
    String amendCheckinDate,
  ) async {
    try {
      final url =
          '${_appResources.baseUrl}${AppResources.getAmendStayData}/$roomId?bookingRoomId=$bookingRoomId&amendCheckinDate=$amendCheckinDate';
      final response = await _dataAccess.get(url);
      return response;
    } catch (error) {
      return {"error": error.toString()};
    }
  }

  Future<Map<String, dynamic>> updateBookingApi(Map<String, dynamic> body) async {
    try {
      final url = '${_appResources.baseUrl}${AppResources.updateBooking}';
      final response = await _dataAccess.post(body, url);
      return response;
    } catch (error) {
      return {"error": error.toString()};
    }
  }

  Future<Map<String, dynamic>> getFoliosApi(int bookingId) async {
    try {
      final url =
          '${_appResources.baseUrl}${AppResources.getFolios}/$bookingId';
      final response = await _dataAccess.get(url);
      return response;
    } catch (error) {
      return {"error": error.toString()};
    }
  }

  Future<Map<String, dynamic>> getFolioChargeTaxesApi(int folioChargeId) async {
    try {
      final url =
          '${_appResources.baseUrl}${AppResources.getFolioChargeTaxes}/$folioChargeId';
      final response = await _dataAccess.get(url);
      return response;
    } catch (error) {
      return {"error": error.toString()};
    }
  }

  Future<Map<String, dynamic>> getFolioPaymentsApi(int folioId) async {
    try {
      final url =
          '${_appResources.baseUrl}${AppResources.getFolioPayments}/$folioId/false';
      final response = await _dataAccess.get(url);
      return response;
    } catch (error) {
      return {"error": error.toString()};
    }
  }

  Future<Map<String, dynamic>> getFolioChargesApi(int folioId) async {
    try {
      final url =
          '${_appResources.baseUrl}${AppResources.getFolioCharges}/$folioId/0';
      final response = await _dataAccess.get(url);
      return response;
    } catch (error) {
      return {"error": error.toString()};
    }
  }

  Future<Map<String, dynamic>> saveOtherInformationApi(
    Map<String, dynamic> body,
  ) async {
    try {
      final url =
          '${_appResources.baseUrl}${AppResources.saveOtherInformation}';
      final response = await _dataAccess.post(body, url);
      return response;
    } catch (error) {
      return {"error": error.toString()};
    }
  }

  Future<Map<String, dynamic>> saveReasonApi(Map<String, dynamic> body) async {
    try {
      final url = '${_appResources.baseUrl}${AppResources.saveReason}';
      final response = await _dataAccess.post(body, url);
      return response;
    } catch (error) {
      return {"error": error.toString()};
    }
  }

  Future<Map<String, dynamic>> updateGuestsApi(
    Map<String, dynamic> body,
    int guestId,
  ) async {
    try {
      final url =
          '${_appResources.baseUrl}${AppResources.updateGuests}/Update/$guestId';
      final response = await _dataAccess.put(body, url);
      return response;
    } catch (error) {
      return {"error": error.toString()};
    }
  }

  Future<Map<String, dynamic>> getAllNationalityApi() async {
    try {
      final url = '${_appResources.baseUrl}${AppResources.getAllNationality}';
      final response = await _dataAccess.get(url);
      return response;
    } catch (error) {
      return {"error": error.toString()};
    }
  }

  Future<Map<String, dynamic>> getAllIdentityTypesApi() async {
    try {
      final url = '${_appResources.baseUrl}${AppResources.getAllIdentityTypes}';
      final response = await _dataAccess.get(url);
      return response;
    } catch (error) {
      return {"error": error.toString()};
    }
  }

  Future<Map<String, dynamic>> getAllVipStatusApi() async {
    try {
      final url = '${_appResources.baseUrl}${AppResources.getAllVipStatus}';
      final response = await _dataAccess.get(url);
      return response;
    } catch (error) {
      return {"error": error.toString()};
    }
  }

  Future<Map<String, dynamic>> getAllCountriesApi() async {
    try {
      final url = '${_appResources.baseUrl}${AppResources.getAllCountries}';
      final response = await _dataAccess.get(url);
      return response;
    } catch (error) {
      return {"error": error.toString()};
    }
  }

  Future<Map<String, dynamic>> getAllTitleApi() async {
    try {
      final url = '${_appResources.baseUrl}${AppResources.getAllTitle}';
      final response = await _dataAccess.get(url);
      return response;
    } catch (error) {
      return {"error": error.toString()};
    }
  }

   Future<Map<String, dynamic>> getAllBookingRemarksApi(int bookingRoomId) async {
    try {
      final url = '${_appResources.baseUrl}${AppResources.getAllBookingRemarks}=${bookingRoomId}';
      final response = await _dataAccess.get(url);
      return response;
    } catch (error) {
      return {"error": error.toString()};
    }
  }

  Future<Map<String, dynamic>> getInhousedataApi(Map<String, dynamic> body) async {
    try {
      final config = await rootBundle.loadString('assets/config.json');
      final response = json.decode(config);
      return response["inhouseList"];
    } catch (error) {
      return {"error": error.toString()};
    }
  }

}
