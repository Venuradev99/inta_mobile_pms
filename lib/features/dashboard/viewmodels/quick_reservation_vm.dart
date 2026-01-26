import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inta_mobile_pms/data/models/checkin_checkout_data_model.dart';
import 'package:inta_mobile_pms/data/enums/wellknown_reservation_setting.dart';
import 'package:inta_mobile_pms/features/dashboard/models/dropdown_options.dart';
import 'package:inta_mobile_pms/features/reservations/models/available_rate_type_response.dart';
import 'package:inta_mobile_pms/features/reservations/models/business_source_category_response.dart';
import 'package:inta_mobile_pms/features/reservations/models/business_sources_response.dart';
import 'package:inta_mobile_pms/features/reservations/models/reservation_type_response.dart';
import 'package:inta_mobile_pms/features/reservations/models/room_type_response.dart';
import 'package:inta_mobile_pms/features/reservations/models/title_response.dart';
import 'package:inta_mobile_pms/features/stay_view/models/available_rooms.dart';
import 'package:inta_mobile_pms/services/apiServices/quick_reservation_service.dart';
import 'package:inta_mobile_pms/services/apiServices/reservation_service.dart';
import 'package:inta_mobile_pms/services/local_storage_manager.dart';
import 'package:inta_mobile_pms/services/message_service.dart';

class QuickReservationVm extends GetxController {
  final QuickReservationService _quickReservationService;
  final ReservationService _reservationService;

  var isInitialDataLoading = false.obs;
  var systemDate = Rxn<DateTime>();
  var checkinCheckoutSettingsList = <CheckinCheckoutDataModel>[].obs;
  var defaultDateTimesetting = Rxn<CheckinCheckoutDataModel>();

  var checkInDate = Rxn<DateTime>();
  var checkOutDate = Rxn<DateTime>();
  var checkinTime = Rxn<TimeOfDay>();
  var checkOutTime = Rxn<TimeOfDay>();

  var businessSourceCategories = <BusinessSourceCategory>[].obs;
  var businessSourceCategoriesDropDown = <DropdownOption>[].obs;

  var titles = <TitleResponse>[].obs;
  var titlesDropDown = <DropdownOption>[].obs;

  var reservationTypes = <ReservationTypeResponse>[].obs;
  var reservationTypesDropDown = <DropdownOption>[].obs;

  var businessSources = <BusinessSourcesResponse>[].obs;
  var businessSourcesDropDown = <DropdownOption>[].obs;

  var roomTypes = <RoomTypeResponse>[].obs;
  var roomTypesDropDown = <DropdownOption>[].obs;

  var rooms = <AvailableRooms>[].obs;
  var roomsDropDown = <DropdownOption>[].obs;

  var rateTypes = <AvailableRateTypeResponse>[].obs;
  var rateTypesDropDown = <DropdownOption>[].obs;

  QuickReservationVm(this._quickReservationService, this._reservationService);

  TimeOfDay parseTime(String timeString) {
    final parts = timeString.split(":");
    return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
  }

  Future<void> loadInitialData() async {
    try {
      isInitialDataLoading.value = true;
      await setCheckinAndCheckoutDateAndTime();
      await loadApiData();
    } catch (e) {
      throw Exception('Error Loading Initial Data: $e');
    } finally {
      isInitialDataLoading.value = false;
    }
  }

  Future<void> setCheckinAndCheckoutDateAndTime() async {
    try {
      final todaySystemDate = await LocalStorageManager.getSystemDate();
      systemDate.value = DateTime.parse(todaySystemDate);

      checkInDate.value = systemDate.value ?? DateTime.now();
      checkOutDate.value = (checkInDate.value ?? DateTime.now()).add(
        const Duration(days: 1),
      );

      DateTime now = DateTime.now();
      TimeOfDay currentTime = TimeOfDay(hour: now.hour, minute: now.minute);

      checkinCheckoutSettingsList.value =
          await LocalStorageManager.getCheckinCheckoutData();

      defaultDateTimesetting.value = checkinCheckoutSettingsList.firstWhere(
        (setting) =>
            setting.reservationSettingId ==
            WellknownReservationSetting.twentyFourHoursCheckOut.id,
      );

      if (defaultDateTimesetting.value!.isEnabled) {
        checkinTime.value = currentTime;
        checkOutTime.value = currentTime;
      } else {
        checkinTime.value = defaultDateTimesetting.value!.value1 == ""
            ? currentTime
            : parseTime(defaultDateTimesetting.value!.value1);

        checkOutTime.value = defaultDateTimesetting.value!.value2 == ""
            ? currentTime
            : parseTime(defaultDateTimesetting.value!.value2);
      }
    } catch (e) {
      throw Exception('Error Setting Checking and Checkout Date and Time: $e');
    }
  }

  Future<void> getBusinessSources(int categoryId) async {
    try {
      final businessSourcesResponse = await _reservationService
          .getBusinessSourcesByCategoryIdApi(categoryId, false);
      if (businessSourcesResponse["isSuccessful"] == true) {
        final result = businessSourcesResponse["result"];
        List<BusinessSourcesResponse> businessSourcesTemp = [];
        List<DropdownOption> businessSourcesDropdownTemp = [];
        for (final item in result) {
          businessSourcesTemp.add(BusinessSourcesResponse.fromJson(item));
          businessSourcesDropdownTemp.add(
            DropdownOption.fromJson({
              "id": item["businessSourceId"],
              "name": item["name"],
            }),
          );
        }
        businessSources.value = businessSourcesTemp;
        businessSourcesDropDown.value = businessSourcesDropdownTemp;
      } else {
        MessageService().error(
          businessSourcesResponse["errors"][0] ?? 'Error loading titles!',
        );
      }
    } catch (e) {
      throw Exception(
        'Error getting business sources by business source categoryId: $e',
      );
    }
  }

  String formatDateTime(DateTime dateTime) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');

    final year = dateTime.year;
    final month = twoDigits(dateTime.month);
    final day = twoDigits(dateTime.day);
    final hour = twoDigits(dateTime.hour);
    final minute = twoDigits(dateTime.minute);

    return '$year-$month-$day $hour:$minute';
  }

  Future<void> loadAvailableRooms(
    DateTime arrivalDate,
    DateTime departureDate,
    int roomTypeId,
  ) async {
    try {
      final payload = {
        "RoomList": [],
        "adults": 0,
        "childs": 0,
        "arrivalDate": formatDateTime(arrivalDate),
        "departureDate": formatDateTime(departureDate),
        "roomType": roomTypeId,
      };

      final response = await _reservationService.getAvailableRoomsApi(payload);

      if (response["isSuccessful"] == true) {
        //available rooms
        final availableRooms = response["result"]["availableRooms"];
        List<AvailableRooms> roomsTemp = [];
        List<DropdownOption> roomsDropdownTemp = [];
        for (final item in availableRooms) {
          roomsTemp.add(AvailableRooms.fromJson(item));
          roomsDropdownTemp.add(
            DropdownOption.fromJson({
              "id": item["roomId"],
              "name": item["name"],
            }),
          );
        }
        rooms.value = roomsTemp;
        roomsDropDown.value = roomsDropdownTemp;

        //available rates
        final availableRateTypes = response["result"]["availableRateTypes"];
        List<AvailableRateTypeResponse> ratesTemp = [];
        List<DropdownOption> ratesDropdownTemp = [];
        for (final item in availableRateTypes) {
          ratesTemp.add(AvailableRateTypeResponse.fromJson(item));
          ratesDropdownTemp.add(
            DropdownOption.fromJson({
              "id": item["rateTypeId"],
              "name": item["name"],
            }),
          );
        }
        rateTypes.value = ratesTemp;
        rateTypesDropDown.value = ratesDropdownTemp;
      } else {
        final msg = response["errors"][0] ?? 'Error Loading Available Rooms!';
        MessageService().error(msg);
      }
    } catch (e) {
      throw Exception('Error loading available rooms: $e');
    }
  }

  Future<void> getReservationPrice() async {
    try {
      final payload = {
        "AdvancePaymentData": {
          "paymentMode": 0,
          "amount": 0,
          "voucherNumber": "",
          "currencyId": 0,
        },
        "BillingInformation": {
          "ApplyingRateType": 1,
          "BillingInstructionId": 1,
          "BusinessCategoryId": 4,
          "IsComplementory": false,
          "IsTaxExempted": false,
          "IsToBeReleased": false,
          "PaymentMode": 2,
          "PaymentModeCategory": 1,
          "RateSourceId": 0,
          "ReleaseChargeAmountPercentage": 0,
          "ReleaseDate": null,
          "TaxIDArray": [],
          "TaxNo": "",
          "TaxRegistrationDate": "",
        },
        "BookedBy": 0,
        "BookingAction": 1,
        "BookingDate": "2026-01-26 08:06",
        "BookingNo": "",
        "BookingRooms": [
          {
            "ArrivalDate": "2026-01-19 13:00",
            "ArrivalTime": "13:00",
            "BookingDate": "2026-01-26 08:06",
            "BookingId": 0,
            "BookingRoomId": 0,
            "ChildAges": [],
            "CurrencyId": 1,
            "DepartureDate": "2026-01-19 17:00",
            "DepartureTime": "17:00",
            "DiscountPlanId": 0,
            "DiscountPlanValue": 0,
            "DropOffDateTime": "",
            "DropOffDescription": "",
            "DropOffModeId": 0,
            "DropOffVehiceleNo": "",
            "InclustionDataList": [],
            "IpAddress": "112.134.195.75",
            "IsManualRate": false,
            "IsTaxInclusiveRate": false,
            "ManualRate": 0,
            "MyProperty": 0,
            "NoOfAdults": 2,
            "NoOfChildren": 2,
            "NoOfNights": 0,
            "PickUpDateTime": "",
            "PickUpDescription": "",
            "PickUpModeId": 0,
            "PickUpVehiceleNo": "",
            "RateTypeId": 2,
            "RemarksList": [],
            "RoomId": 1,
            "RoomTypeId": 2,
            "Sharers": [],
            "StartingMealType": 0,
            "UserId": 0,
          },
        ],
        "BookingStatus": 0,
        "BookingStatusReasonId": 0,
        "BusinessSourceId": 4,
        "CancellationData": {
          "CancellDate": "",
          "IsCancelled": false,
          "CancellationNo": "",
          "CancelledBy": 0,
        },
        "CharterId": 0,
        "CheckingRemark": "",
        "CheckoutRemark": "",
        "CompanyOther": {
          "CompanyId": 0,
          "MarketId": 0,
          "BusinessCategoryId": 4,
          "BusinessSourceId": 0,
          "TravelAgent": "",
        },
        "CreatedBy": 0,
        "CreditCardData": {
          "CardNumber": "",
          "CardType": "",
          "ExpiryMonth": "",
          "ExpiryYear": "",
          "CVVCode": "",
          "CardHoldersName": "",
        },
        "Discount": {
          "DiscountType": 0,
          "DiscountRule": 0,
          "DiscountRuleOccurance": 0,
          "DiscountPlanValue": 0,
        },
        "DropOffData": {
          "dropOffDescription": "",
          "dropOffVehiceleNo": "",
          "dropOffDateTime": "",
          "dropOffModeId": 0,
        },
        "GeneralRemark": "",
        "GroupColor": "",
        "GroupId": 0,
        "Guest": null,
        "GuideId": 0,
        "InclustionData": [],
        "IpAddress": "112.134.195.75",
        "IsPastTransaction": false,
        "LastModifiedBy": 0,
        "LoyaltyCardNo": "",
        "MasterFolioBookingTransId": 0,
        "NoOfPrint": 0,
        "PaymentData": {
          "PaymentType": 0,
          "PaymentCurrencyId": 0,
          "PaymentAmount": 0,
          "VoucherNo": "",
        },
        "PickUpData": {
          "pickUpDescription": "",
          "pickUpVehiceleNo": "",
          "pickUpDateTime": "",
          "pickUpModeId": 0,
        },
        "RowVersion": "",
        "ShouldPrintFolio": true,
        "ShouldPrintGRCard": true,
        "ShouldPrintReceipt": true,
        "ShouldSendEmailAtCheckOut": "false",
        "ShouldSuppressRateInGRCard": false,
        "StayData": {"NoOfRooms": 1, "ReservationType": 2},
        "TravelAgentInformation": {
          "AgentId": 0,
          "CommissionPlanId": 0,
          "Value": 0,
          "VoucherNumber": "",
          "IsSourceRateApplied": false,
        },
        "VoidReason": "",
        "WebReservationId": "",
        "exemptedTaxes": {"taxIDArray": []},
      };

      final response = await _reservationService.getPriceApi(payload);

      if (response["isSuccessful"] == true) {
      } else {
        final msg = response["errors"][0] ?? 'Error getting reservation price!';
        MessageService().error(msg);
      }
    } catch (e) {
      throw Exception('Error getting reservation price: $e');
    }
  }

  Future<void> loadApiData() async {
    try {
      final responses = await Future.wait([
        _reservationService.getAllBusinessCategoryApi(),
        _reservationService.getAllTitleApi(),
        _reservationService.getAllreservationTypesApi(),
        _reservationService.getAllRoomTypesApi(),
      ]);

      final businessSourceCategoryResponse = responses[0];
      final titleResponse = responses[1];
      final reservationTypeResponse = responses[2];
      final roomTypeResponse = responses[3];

      if (businessSourceCategoryResponse["isSuccessful"] == true) {
        final result = businessSourceCategoryResponse["result"];
        List<BusinessSourceCategory> businessCategoryTemp = [];
        List<DropdownOption> businessCategoryDropdownTemp = [];
        for (final item in result) {
          businessCategoryTemp.add(BusinessSourceCategory.fromJson(item));
          businessCategoryDropdownTemp.add(
            DropdownOption.fromJson({
              "id": item["categoryId"],
              "name": item["description"],
            }),
          );
        }
        businessSourceCategories.value = businessCategoryTemp;
        businessSourceCategoriesDropDown.value = businessCategoryDropdownTemp;
      } else {
        MessageService().error(
          businessSourceCategoryResponse["errors"][0] ??
              'Error loading business categories!',
        );
      }

      if (titleResponse["isSuccessful"] == true) {
        final result = titleResponse["result"]["recordSet"];
        List<TitleResponse> titlesTemp = [];
        List<DropdownOption> titlesDropdownTemp = [];
        for (final item in result) {
          titlesTemp.add(TitleResponse.fromJson(item));
          titlesDropdownTemp.add(
            DropdownOption.fromJson({
              "id": item["titleId"],
              "name": item["name"],
            }),
          );
        }
        titles.value = titlesTemp;
        titlesDropDown.value = titlesDropdownTemp;
      } else {
        MessageService().error(
          titleResponse["errors"][0] ?? 'Error loading titles!',
        );
      }

      if (reservationTypeResponse["isSuccessful"] == true) {
        final result = reservationTypeResponse["result"]["recordSet"];
        List<ReservationTypeResponse> resTypesTemp = [];
        List<DropdownOption> resTypesDropdownTemp = [];
        for (final item in result) {
          resTypesTemp.add(ReservationTypeResponse.fromJson(item));
          resTypesDropdownTemp.add(
            DropdownOption.fromJson({
              "id": item["reservationTypeId"],
              "name": item["name"],
            }),
          );
        }
        reservationTypes.value = resTypesTemp;
        reservationTypesDropDown.value = resTypesDropdownTemp;
      } else {
        MessageService().error(
          reservationTypeResponse["errors"][0] ?? 'Error loading titles!',
        );
      }

      if (roomTypeResponse["isSuccessful"] == true) {
        final result = roomTypeResponse["result"]["recordSet"];
        List<RoomTypeResponse> roomTypesTemp = [];
        List<DropdownOption> roomTypesDropdownTemp = [];
        for (final item in result) {
          roomTypesTemp.add(RoomTypeResponse.fromJson(item));
          roomTypesDropdownTemp.add(
            DropdownOption.fromJson({
              "id": item["roomTypeId"],
              "name": item["name"],
            }),
          );
        }
        roomTypes.value = roomTypesTemp;
        roomTypesDropDown.value = roomTypesDropdownTemp;
      } else {
        MessageService().error(
          roomTypeResponse["errors"][0] ?? 'Error loading titles!',
        );
      }
    } catch (e) {
      throw Exception('Error Loading api data: $e');
    }
  }
}
