import 'package:get/get.dart';
import 'package:inta_mobile_pms/features/reservations/models/country_response.dart';
import 'package:inta_mobile_pms/features/reservations/models/guest_item.dart';
import 'package:inta_mobile_pms/features/reservations/models/identity_type_response.dart';
import 'package:inta_mobile_pms/features/reservations/models/nationality_response.dart';
import 'package:inta_mobile_pms/features/reservations/models/title_response.dart';
import 'package:inta_mobile_pms/features/reservations/models/update_guest_payload.dart';
import 'package:inta_mobile_pms/features/reservations/models/vip_status_response.dart';
import 'package:inta_mobile_pms/services/apiServices/reservation_service.dart';
import 'package:inta_mobile_pms/services/message_service.dart';
import 'package:inta_mobile_pms/services/navigation_service.dart';
import 'package:intl/intl.dart';

class EditGuestDetailsVm extends GetxController {
  final ReservationService _reservationListService;

  var nationalityList = <NationalityResponse>[].obs;
  var identityTypeList = <IdentityTypeResponse>[].obs;
  var countryWithCityList = <CountryResponse>[].obs;
  var vipStatusList = <VipStatusResponse>[].obs;
  var titleList = <TitleResponse>[].obs;
  

  var purposes = <String>[].obs;
  var vipStatuses = <String>[].obs;
  var idTypes = <String>[].obs;
  var countries = <String>[].obs;
  var titles = <String>[].obs;
  var allCities = <CityResponse>[];
  var cityNames = <String>[].obs;

  var nationalityNames = <String>[].obs;

  EditGuestDetailsVm(this._reservationListService);

  Future<void> loadGuestDetails(GuestItem guestItem) async {
    try {
      final response = await Future.wait([
        _reservationListService.getAllNationality(),
        _reservationListService.getAllCountries(),
        _reservationListService.getAllTitle(),
        _reservationListService.getAllIdentityTypes(),
        _reservationListService.getAllVipStatus(),
      ]);

      final nationalityResponse = response[0];
      final countryResponse = response[1];
      final titleResponse = response[2];
      final identityTypeResponse = response[3];
      final vipStatusResponse = response[4];

      if (nationalityResponse["isSuccessful"] == true) {
        final result = nationalityResponse["result"]["recordSet"] as List;
        nationalityList.value = result
            .map(
              (item) => NationalityResponse(
                nationalityId: item["nationalityId"] ?? 0,
                name: item["name"] ?? '',
                description: item["description"] ?? '',
                indexId: item["indexId"] ?? 0,
                shortCode: item["shortCode"] ?? '',
                ipAddress: item["ipAddress"] ?? '',
                deviceId: item["deviceId"] ?? '',
                sysDateCreated: item["sys_DateCreated"] ?? '',
                sysDateLastModified: item["sys_DateLastModified"] ?? '',
                sysVersion: item["sys_Version"] ?? 0,
                rowVersion: item["rowVersion"] ?? '',
                createdBy: item["createdBy"] ?? 0,
                lastModifiedBy: item["lastModifiedBy"] ?? 0,
                status: item["status"] ?? 0,
              ),
            )
            .toList();
        nationalityNames.value = nationalityList
            .map((item) => item.name)
            .toList();
      } else {}

      if (countryResponse["isSuccessful"] == true) {
        final result = countryResponse["result"] as List;
        countryWithCityList.value = result.map((item) {
          final citiesJson = item["cities"] as List<dynamic>? ?? [];
          final cities = citiesJson
              .map(
                (city) => CityResponse(
                  cityId: city["cityId"] ?? 0,
                  countryId: city["countryId"] ?? 0,
                  cityName: city["cityName"] ?? '',
                  userId: city["userId"] ?? 0,
                  status: city["status"] ?? 0,
                ),
              )
              .toList();

          return CountryResponse(
            countryId: item["countryId"] ?? 0,
            regionId: item["regionId"] ?? 0,
            countryName: item["countryName"] ?? '',
            userId: item["userId"] ?? 0,
            deviceId: item["deviceId"] ?? '',
            cities: cities,
          );
        }).toList();

        allCities = countryWithCityList
            .expand((country) => country.cities)
            .toList();
        cityNames.value = allCities.map((city) => city.cityName).toList();

        countries.value = countryWithCityList
            .map((item) => item.countryName)
            .toList();
      } else {
          MessageService().error(
          countryResponse["errors"][0] ?? 'Error getting countries and cities!',
        );
      }

      if (titleResponse["isSuccessful"] == true) {
        final result = titleResponse["result"]["recordSet"] as List;
        titleList.value = result
            .map(
              (item) => TitleResponse(
                titleId: item["titleId"] ?? 0,
                name: item["name"] ?? '',
                gender: item["gender"] ?? '',
                indexId: item["indexId"] ?? '',
                deviceId: item["deviceId"] ?? '',
                dtVersion: item["dt_Version"] ?? 0,
                sysDateCreated: item["sys_DateCreated"] ?? '',
                sysDateLastModified: item["sys_DateLastModified"] ?? '',
                sysVersion: item["sys_Version"] ?? 0,
                rowVersion: item["rowVersion"] ?? '',
                createdBy: item["createdBy"] ?? 0,
                lastModifiedBy: item["lastModifiedBy"] ?? 0,
                status: item["status"] ?? 0,
              ),
            )
            .toList();

        titles.value = titleList.map((item) => item.name).toList();
      } else {
          MessageService().error(
          titleResponse["errors"][0] ?? 'Error getting titles!',
        );
      }
      if (identityTypeResponse["isSuccessful"] == true) {
        final result = identityTypeResponse["result"]["recordSet"] as List;
        identityTypeList.value = result
            .map(
              (item) => IdentityTypeResponse(
                identityTypeId: item["identityTypeId"] ?? 0,
                name: item["name"],
                description: item["description"],
                indexId: item["indexId"] ?? 0,
                shortCode: item["shortCode"],
                ipAddress: item["ipAddress"],
                deviceId: item["deviceId"],
                createdBy: item["createdBy"] ?? 0,
                lastModifiedBy: item["lastModifiedBy"] ?? 0,
                status: item["status"] ?? 0,
                createdByUserName: item["createdByUserName"],
                lastModifiedByUserName: item["lastModifiedByUserName"],
                statusName: item["statusName"],
              ),
            )
            .toList();

        idTypes.value = identityTypeList.map((item) => item.name).toList();
      } else {
          MessageService().error(
          identityTypeResponse["errors"][0] ?? 'Error getting identity types!',
        );
      }

      if (vipStatusResponse["isSuccessful"] == true) {
        final result = vipStatusResponse["result"]["recordSet"] as List;
        vipStatusList.value = result
            .map(
              (item) => VipStatusResponse(
                vipStatusId: item["vipStatusId"],
                name: item["name"],
                description: item["description"],
                createdBy: item["createdBy"],
                lastModifiedBy: item["lastModifiedBy"],
                status: item["status"],
                createdByUserName: item["createdByUserName"],
                lastModifiedByUserName: item["lastModifiedByUserName"],
                statusName: item["statusName"],
                hotelId: item["hotelId"],
              ),
            )
            .toList();

        vipStatuses.value = vipStatusList.map((item) => item.name).toList();
      } else {
          MessageService().error(
          vipStatusResponse["errors"][0] ?? 'Error getting vip status!',
        );
      }
    } catch (e) {
      throw Exception('Error loading initial data : $e');
    }
  }

  Future<void> updateGuestDetails(UpdateGuestPayload payload) async {
    try {
      final saveData = payload.toJson();
      final response = await _reservationListService.updateGuests(
        saveData,
        payload.guestId!,
      );
      if (response["isSuccessful"] == true) {
        MessageService().success(
          response["message"] ?? 'Successfully updated!',
        );
        NavigationService().back();
      } else {
        MessageService().error(
          response["errors"][0] ?? 'Error updating guest!',
        );
      }
    } catch (e) {
      MessageService().error('Error in updateGuestDetails: $e');
      throw Exception('Error in updateGuestDetails: $e');
    }
  }

  int getCityId(String? cityName) {
    try {
      if (cityName == null || cityName.isEmpty) {
        return 0;
      } else {
        final selected = allCities.firstWhere(
          (item) => item.cityName == cityName,
        );
        return selected.cityId;
      }
    } catch (e) {
      throw Exception('Error in getCityId : $e');
    }
  }

  int getCountryId(String? countryName) {
    try {
      if (countryName == null || countryName.isEmpty) {
        return 0;
      } else {
        final selected = countryWithCityList.firstWhere(
          (item) => item.countryName == countryName,
        );

        return selected.countryId;
      }
    } catch (e) {
      throw Exception('Error in getCountryId : $e');
    }
  }

  int getIdentidyTypeId(String? idName) {
    try {
      if (idName == null || idName.isEmpty) {
        return 0;
      } else {
        final selected = identityTypeList.firstWhere(
          (item) => item.name == idName,
        );
        return selected.identityTypeId;
      }
    } catch (e) {
      throw Exception('Error in getIdentidyTypeId : $e');
    }
  }

  int getTitleId(String? titleName) {
    try {
      if (titleName == null || titleName.isEmpty) {
        return 0;
      } else {
        final selected = titleList.firstWhere((item) => item.name == titleName);
        return selected.titleId;
      }
    } catch (e) {
      throw Exception('Error in getTitleId : $e');
    }
  }

  int getVipStatusId(String? vipStatusName) {
    try {
      if (vipStatusName == null || vipStatusName.isEmpty) {
        return 0;
      } else {
        final selected = vipStatusList.firstWhere(
          (item) => item.name == vipStatusName,
        );
        return selected.vipStatusId;
      }
    } catch (e) {
      throw Exception('Error in getVipStatusId : $e');
    }
  }

  int getNationalityId(String? nationalityName) {
    try {
      if (nationalityName == null || nationalityName.isEmpty) {
        return 0;
      } else {
        final selected = nationalityList.firstWhere(
          (item) => item.name == nationalityName,
        );

        return selected.nationalityId;
      }
    } catch (e) {
      throw Exception('Error in getNationalityId : $e');
    }
  }

  String getCity(int? cityId) {
    try {
      if (cityId == null || cityId == 0) {
        return '';
      } else {
        final selected = allCities.firstWhere((item) => item.cityId == cityId);
        return selected.cityName.toString();
      }
    } catch (e) {
      throw Exception('Error in getCity : $e');
    }
  }

  String getTitle(int? titleId) {
    try {
      if (titleId == null || titleId == 0) {
        return '';
      } else {
        final selected = titleList.firstWhere(
          (item) => item.titleId == titleId,
        );
        return selected.name.toString();
      }
    } catch (e) {
      throw Exception('Error in getTitle : $e');
    }
  }

  String getCountry(int? countryId) {
    try {
      if (countryId == null || countryId == 0) {
        return '';
      } else {
        final selected = countryWithCityList.firstWhere(
          (item) => item.countryId == countryId,
        );
        return selected.countryName.toString();
      }
    } catch (e) {
      throw Exception('Error in getCountry : $e');
    }
  }

  String getVipStatus(int? vipStatusId) {
    try {
      if (vipStatusId == null || vipStatusId == 0) {
        return '';
      } else {
        final selected = vipStatusList.firstWhere(
          (item) => item.vipStatusId == vipStatusId,
        );
        return selected.name.toString();
      }
    } catch (e) {
      throw Exception('Error in getVipStatus : $e');
    }
  }

  String getNationality(int? nationalityId) {
    try {
      if (nationalityId == null || nationalityId == 0) {
        return '';
      } else {
        final selected = nationalityList.firstWhere(
          (item) => item.nationalityId == nationalityId,
        );
        return selected.name.toString();
      }
    } catch (e) {
      throw Exception('Error in getNationality : $e');
    }
  }

  DateTime getDateTime(String? date) {
    try {
      if (date == null || date.isEmpty) {
        throw Exception('Date is null or empty');
      }
      String dateExtract = date.substring(0, 10);
      DateTime dateTime = DateFormat('yyyy-MM-dd').parse(dateExtract);
      return dateTime;
    } catch (e) {
      throw Exception('Error in getDateTime : $e');
    }
  }

  String getIdType(int? id) {
    try {
      if (id == null || id == 0) {
        return '';
      } else {
        final selected = identityTypeList.firstWhere(
          (item) => item.identityTypeId == id,
        );
        return selected.name.toString();
      }
    } catch (e) {
      throw Exception('Error in getIdType : $e');
    }
  }
}