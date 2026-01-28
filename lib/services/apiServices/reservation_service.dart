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
          '${AppResources.searchReservationList}';
      final response = await _dataAccess.post(body, url);
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

  Future<Map<String, dynamic>> transportationModesApi() async {
    try {
      final url = '${AppResources.transportationModes}';
      final response = await _dataAccess.get(url);
      return response;
    } catch (error) {
      return {"error": error.toString()};
    }
  }

  Future<Map<String, dynamic>> getBusinessSourcesByCategoryIdApi(
    int categoryId,
    bool withInactive,
  ) async {
    try {
      final url =
          '${AppResources.getBusinessSourcesByCategoryId}/${categoryId}?withInactive=${withInactive}';
      final response = await _dataAccess.get(url);
      return response;
    } catch (error) {
      return {"error": error.toString()};
    }
  }

  Future<Map<String, dynamic>> getAllBusinessCategoryApi() async {
    try {
      final url =
          '${AppResources.getAllBusinessCategory}';
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
      final url = '${AppResources.getAvailableRooms}';
      final response = await _dataAccess.post(body, url);
      return response;
    } catch (error) {
      return {"error": error.toString()};
    }
  }

  Future<Map<String, dynamic>> getAllreservationTypesApi() async {
    try {
      final url =
          '${AppResources.getAllreservationTypes}';
      final response = await _dataAccess.get(url);
      return response;
    } catch (error) {
      return {"error": error.toString()};
    }
  }

  Future<Map<String, dynamic>> getAllroomstatusApi() async {
    try {
      final url = '${AppResources.getAllroomstatus}';
      final response = await _dataAccess.get(url);
      return response;
    } catch (error) {
      return {"error": error.toString()};
    }
  }

  Future<Map<String, dynamic>> getAllbusinessSourcesApi() async {
    try {
      final url =
          '${AppResources.getAllbusinessSources}';
      final response = await _dataAccess.get(url);
      return response;
    } catch (error) {
      return {"error": error.toString()};
    }
  }

  Future<Map<String, dynamic>> getByBookingRoomIdApi(int bookingRoomId) async {
    try {
      final url =
          '${AppResources.getByBookingRoomId}/$bookingRoomId';
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

  Future<Map<String, dynamic>> getCancellationReasonsApi() async {
    try {
      final url =
          '${AppResources.getCancellationReasons}';
      final response = await _dataAccess.get(url);
      return response;
    } catch (error) {
      return {"error": error.toString()};
    }
  }

  Future<Map<String, dynamic>> getNoShowReasonsApi() async {
    try {
      final url = '${AppResources.getNoShowReasons}';
      final response = await _dataAccess.get(url);
      return response;
    } catch (error) {
      return {"error": error.toString()};
    }
  }

  Future<Map<String, dynamic>> getVoidReasonsApi() async {
    try {
      final url = '${AppResources.getVoidReasons}';
      final response = await _dataAccess.get(url);
      return response;
    } catch (error) {
      return {"error": error.toString()};
    }
  }

  Future<Map<String, dynamic>> getStopRoomMoveReasonsApi() async {
    try {
      final url =
          '${AppResources.getStopRoomMoveReasons}';
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
          '${AppResources.getAuditTrial}$bookingId/$bookingRoomId/$masterFolioBookingTransId/$roomId';
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
          '${AppResources.getAmendStayData}/$roomId?bookingRoomId=$bookingRoomId&amendCheckinDate=$amendCheckinDate';
      final response = await _dataAccess.get(url);
      return response;
    } catch (error) {
      return {"error": error.toString()};
    }
  }

  Future<Map<String, dynamic>> updateBookingApi(
    Map<String, dynamic> body,
  ) async {
    try {
      final url = '${AppResources.updateBooking}';
      final response = await _dataAccess.post(body, url);
      return response;
    } catch (error) {
      return {"error": error.toString()};
    }
  }

  Future<Map<String, dynamic>> getFoliosApi(int bookingId) async {
    try {
      final url =
          '${AppResources.getFolios}/$bookingId';
      final response = await _dataAccess.get(url);
      return response;
    } catch (error) {
      return {"error": error.toString()};
    }
  }

  Future<Map<String, dynamic>> getFolioChargeTaxesApi(int folioChargeId) async {
    try {
      final url =
          '${AppResources.getFolioChargeTaxes}/$folioChargeId';
      final response = await _dataAccess.get(url);
      return response;
    } catch (error) {
      return {"error": error.toString()};
    }
  }

  Future<Map<String, dynamic>> getFolioPaymentsApi(int folioId) async {
    try {
      final url =
          '${AppResources.getFolioPayments}/$folioId/false';
      final response = await _dataAccess.get(url);
      return response;
    } catch (error) {
      return {"error": error.toString()};
    }
  }

  Future<Map<String, dynamic>> getTotalBalanceByBookingRoomIdApi(
    int bookingRoomId,
  ) async {
    try {
      final url =
          '${AppResources.getTotalBalanceByBookingRoomId}/$bookingRoomId';
      final response = await _dataAccess.get(url);
      return response;
    } catch (error) {
      return {"error": error.toString()};
    }
  }

  Future<Map<String, dynamic>> getFolioChargesApi(int folioId) async {
    try {
      final url =
          '${AppResources.getFolioCharges}/$folioId/0';
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
          '${AppResources.saveOtherInformation}';
      final response = await _dataAccess.post(body, url);
      return response;
    } catch (error) {
      return {"error": error.toString()};
    }
  }

  Future<Map<String, dynamic>> saveReasonApi(Map<String, dynamic> body) async {
    try {
      final url = '${AppResources.saveReason}';
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
          '${AppResources.updateGuests}/Update/$guestId';
      final response = await _dataAccess.put(body, url);
      return response;
    } catch (error) {
      return {"error": error.toString()};
    }
  }

  Future<Map<String, dynamic>> getAllNationalityApi() async {
    try {
      final url = '${AppResources.getAllNationality}';
      final response = await _dataAccess.get(url);
      return response;
    } catch (error) {
      return {"error": error.toString()};
    }
  }

  Future<Map<String, dynamic>> getAllIdentityTypesApi() async {
    try {
      final url = '${AppResources.getAllIdentityTypes}';
      final response = await _dataAccess.get(url);
      return response;
    } catch (error) {
      return {"error": error.toString()};
    }
  }

  Future<Map<String, dynamic>> getAllVipStatusApi() async {
    try {
      final url = '${AppResources.getAllVipStatus}';
      final response = await _dataAccess.get(url);
      return response;
    } catch (error) {
      return {"error": error.toString()};
    }
  }

  Future<Map<String, dynamic>> getAllCountriesApi() async {
    try {
      final url = '${AppResources.getAllCountries}';
      final response = await _dataAccess.get(url);
      return response;
    } catch (error) {
      return {"error": error.toString()};
    }
  }

  Future<Map<String, dynamic>> getAllTitleApi() async {
    try {
      final url = '${AppResources.getAllTitle}';
      final response = await _dataAccess.get(url);
      return response;
    } catch (error) {
      return {"error": error.toString()};
    }
  }

  Future<Map<String, dynamic>> getAllBookingRemarksApi(
    int bookingRoomId,
  ) async {
    try {
      final url =
          '${AppResources.getAllBookingRemarks}=${bookingRoomId}';
      final response = await _dataAccess.get(url);
      return response;
    } catch (error) {
      return {"error": error.toString()};
    }
  }

  Future<Map<String, dynamic>> getPriceApi(Map<String, dynamic> body) async {
    try {
      final url = '${AppResources.getPrice}';
      final response = await _dataAccess.post(body, url);
      return response;
    } catch (error) {
      return {"error": error.toString()};
    }
  }

  Future<Map<String, dynamic>> getInhousedataApi(
    Map<String, dynamic> body,
  ) async {
    try {
      final config = await rootBundle.loadString('assets/config.json');
      final response = json.decode(config);
      return response["inhouseList"];
    } catch (error) {
      return {"error": error.toString()};
    }
  }
}
