import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:inta_mobile_pms/services/data_access_service.dart';
import 'package:inta_mobile_pms/services/resource.dart';

class ReservationService {
  final DataAccessService _dataAccess;
  final AppResources _appResources;

  ReservationService(this._dataAccess, this._appResources);

  Future<Map<String, dynamic>> getAllReservationList(
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

  Future<Map<String, dynamic>> getAllRoomTypes() async {
    try {
      final url = '${_appResources.baseUrl}${AppResources.getAllRoomTypes}';
      final response = await _dataAccess.get(url);
      return response;
    } catch (error) {
      return {"error": error.toString()};
    }
  }

  Future<Map<String, dynamic>> transportationModes() async {
    try {
      final url = '${_appResources.baseUrl}${AppResources.transportationModes}';
      final response = await _dataAccess.get(url);
      return response;
    } catch (error) {
      return {"error": error.toString()};
    }
  }

  Future<Map<String, dynamic>> getAllBusinessCategory() async {
    try {
      final url =
          '${_appResources.baseUrl}${AppResources.getAllBusinessCategory}';
      final response = await _dataAccess.get(url);
      return response;
    } catch (error) {
      return {"error": error.toString()};
    }
  }

  Future<Map<String, dynamic>> getAvailableRooms(
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

  Future<Map<String, dynamic>> getAllreservationTypes() async {
    try {
      final url =
          '${_appResources.baseUrl}${AppResources.getAllreservationTypes}';
      final response = await _dataAccess.get(url);
      return response;
    } catch (error) {
      return {"error": error.toString()};
    }
  }

  Future<Map<String, dynamic>> getAllroomstatus() async {
    try {
      final url = '${_appResources.baseUrl}${AppResources.getAllroomstatus}';
      final response = await _dataAccess.get(url);
      return response;
    } catch (error) {
      return {"error": error.toString()};
    }
  }

  Future<Map<String, dynamic>> getAllbusinessSources() async {
    try {
      final url =
          '${_appResources.baseUrl}${AppResources.getAllbusinessSources}';
      final response = await _dataAccess.get(url);
      return response;
    } catch (error) {
      return {"error": error.toString()};
    }
  }

  Future<Map<String, dynamic>> getByBookingRoomId(int bookingRoomId) async {
    try {
      final url =
          '${_appResources.baseUrl}${AppResources.getByBookingRoomId}/$bookingRoomId';
      final response = await _dataAccess.get(url);
      return response;
    } catch (error) {
      return {"error": error.toString()};
    }
  }

  Future<Map<String, dynamic>> getCancellationReasons() async {
    try {
      final url =
          '${_appResources.baseUrl}${AppResources.getCancellationReasons}';
      final response = await _dataAccess.get(url);
      return response;
    } catch (error) {
      return {"error": error.toString()};
    }
  }

  Future<Map<String, dynamic>> getNoShowReasons() async {
    try {
      final url = '${_appResources.baseUrl}${AppResources.getNoShowReasons}';
      final response = await _dataAccess.get(url);
      return response;
    } catch (error) {
      return {"error": error.toString()};
    }
  }

  Future<Map<String, dynamic>> getVoidReasons() async {
    try {
      final url = '${_appResources.baseUrl}${AppResources.getVoidReasons}';
      final response = await _dataAccess.get(url);
      return response;
    } catch (error) {
      return {"error": error.toString()};
    }
  }

  Future<Map<String, dynamic>> getStopRoomMoveReasons() async {
    try {
      final url =
          '${_appResources.baseUrl}${AppResources.getStopRoomMoveReasons}';
      final response = await _dataAccess.get(url);
      return response;
    } catch (error) {
      return {"error": error.toString()};
    }
  }

  Future<Map<String, dynamic>> getAuditTrial(
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

  Future<Map<String, dynamic>> getAmendStayData(
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

  Future<Map<String, dynamic>> updateBooking(Map<String, dynamic> body) async {
    try {
      final url = '${_appResources.baseUrl}${AppResources.updateBooking}';
      final response = await _dataAccess.post(body, url);
      return response;
    } catch (error) {
      return {"error": error.toString()};
    }
  }

  Future<Map<String, dynamic>> getFolios(int bookingId) async {
    try {
      final url =
          '${_appResources.baseUrl}${AppResources.getFolios}/$bookingId';
      final response = await _dataAccess.get(url);
      return response;
    } catch (error) {
      return {"error": error.toString()};
    }
  }

  Future<Map<String, dynamic>> getFolioChargeTaxes(int folioChargeId) async {
    try {
      final url =
          '${_appResources.baseUrl}${AppResources.getFolioChargeTaxes}/$folioChargeId';
      final response = await _dataAccess.get(url);
      return response;
    } catch (error) {
      return {"error": error.toString()};
    }
  }

  Future<Map<String, dynamic>> getFolioPayments(int folioId) async {
    try {
      final url =
          '${_appResources.baseUrl}${AppResources.getFolioPayments}/$folioId/false';
      final response = await _dataAccess.get(url);
      return response;
    } catch (error) {
      return {"error": error.toString()};
    }
  }

  Future<Map<String, dynamic>> getFolioCharges(int folioId) async {
    try {
      final url =
          '${_appResources.baseUrl}${AppResources.getFolioCharges}/$folioId/0';
      final response = await _dataAccess.get(url);
      return response;
    } catch (error) {
      return {"error": error.toString()};
    }
  }

  Future<Map<String, dynamic>> saveOtherInformation(
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

  Future<Map<String, dynamic>> saveReason(Map<String, dynamic> body) async {
    try {
      final url = '${_appResources.baseUrl}${AppResources.saveReason}';
      final response = await _dataAccess.post(body, url);
      return response;
    } catch (error) {
      return {"error": error.toString()};
    }
  }

  Future<Map<String, dynamic>> updateGuests(
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

  Future<Map<String, dynamic>> getAllNationality() async {
    try {
      final url = '${_appResources.baseUrl}${AppResources.getAllNationality}';
      final response = await _dataAccess.get(url);
      return response;
    } catch (error) {
      return {"error": error.toString()};
    }
  }

  Future<Map<String, dynamic>> getAllIdentityTypes() async {
    try {
      final url = '${_appResources.baseUrl}${AppResources.getAllIdentityTypes}';
      final response = await _dataAccess.get(url);
      return response;
    } catch (error) {
      return {"error": error.toString()};
    }
  }

  Future<Map<String, dynamic>> getAllVipStatus() async {
    try {
      final url = '${_appResources.baseUrl}${AppResources.getAllVipStatus}';
      final response = await _dataAccess.get(url);
      return response;
    } catch (error) {
      return {"error": error.toString()};
    }
  }

  Future<Map<String, dynamic>> getAllCountries() async {
    try {
      final url = '${_appResources.baseUrl}${AppResources.getAllCountries}';
      final response = await _dataAccess.get(url);
      return response;
    } catch (error) {
      return {"error": error.toString()};
    }
  }

  Future<Map<String, dynamic>> getAllTitle() async {
    try {
      final url = '${_appResources.baseUrl}${AppResources.getAllTitle}';
      final response = await _dataAccess.get(url);
      return response;
    } catch (error) {
      return {"error": error.toString()};
    }
  }

   Future<Map<String, dynamic>> getAllBookingRemarks(int bookingRoomId) async {
    try {
      final url = '${_appResources.baseUrl}${AppResources.getAllBookingRemarks}=${bookingRoomId}';
      final response = await _dataAccess.get(url);
      return response;
    } catch (error) {
      return {"error": error.toString()};
    }
  }

  Future<Map<String, dynamic>> getInhousedata(Map<String, dynamic> body) async {
    try {
      final config = await rootBundle.loadString('assets/config.json');
      final response = json.decode(config);
      return response["inhouseList"];
    } catch (error) {
      return {"error": error.toString()};
    }
  }

}
