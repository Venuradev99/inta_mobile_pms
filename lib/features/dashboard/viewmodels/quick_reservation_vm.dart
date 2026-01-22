import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inta_mobile_pms/data/models/checkin_checkout_data_model.dart';
import 'package:inta_mobile_pms/enums/wellknown_reservation_setting.dart';
import 'package:inta_mobile_pms/services/apiServices/quick_reservation_service.dart';
import 'package:inta_mobile_pms/services/local_storage_manager.dart';

class QuickReservationVm extends GetxController {
  final QuickReservationService _quickReservationService;

  var isInitialDataLoading = false.obs;
  var systemDate = Rxn<DateTime>();
  var checkinCheckoutSettingsList = <CheckinCheckoutDataModel>[].obs;
  var defaultDateTimesetting = Rxn<CheckinCheckoutDataModel>();

  var checkInDate = Rxn<DateTime>();
  var checkOutDate = Rxn<DateTime>();
  var checkinTime = Rxn<TimeOfDay>();
  var checkOutTime = Rxn<TimeOfDay>();

  QuickReservationVm(this._quickReservationService);

  TimeOfDay parseTime(String timeString) {
    final parts = timeString.split(":");
    return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
  }

  Future<void> loadInitialData() async {
    try {
      isInitialDataLoading.value = true;
      await setCheckinAndCheckoutDateAndTime();
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
}
