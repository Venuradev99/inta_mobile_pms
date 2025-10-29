import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:inta_mobile_pms/features/stay_view/models/stay_view_status_color.dart';
import 'package:inta_mobile_pms/services/apiServices/stay_view_service.dart';
import 'package:inta_mobile_pms/services/local_storage_manager.dart';
import 'package:inta_mobile_pms/services/message_service.dart';

class StayViewVm extends GetxController {
  final StayViewService _stayViewService;

  final statusList = <StayViewStatusColor>[].obs;
  final today = Rxn<DateTime>();

  StayViewVm(this._stayViewService);

  Future<void> loadInitialData() async {
    try {
      final todaySystemDate = await LocalStorageManager.getSystemDate();
      today.value = DateTime.parse(todaySystemDate);
      
      final payload = {
        "numberOfDates": 3,
        "roomTypeId": 0,
        "startDate": todaySystemDate,
      };
      final response = await Future.wait([
        _stayViewService.getBookingStatics(payload),
        _stayViewService.getStatusColorForStayview(),
      ]);

      final bookingStatsResponse = response[0];
      final statusColorResponse = response[1];

      if (statusColorResponse["isSuccessful"] == true) {
        final result = statusColorResponse["result"] as List;
        statusList.value = result
            .map(
              (item) => StayViewStatusColor(
                id: item["roomStatusId"] ?? 0,
                label: item["name"] ?? '',
                color: hexToColor(item["colorCode"]),
              ),
            )
            .toList();
      } else {
        final msg =
            statusColorResponse["errors"][0] ?? 'Error Loading Status Colors!';
        MessageService().error(msg);
      }
    } catch (e) {
      throw Exception('Error loading initial data: $e');
    }
  }

  Color hexToColor(String hexCode) {
    if (hexCode == '' || hexCode.isEmpty) {
      return Colors.grey;
    }

    try {
      String hex = hexCode.replaceAll('#', '').trim();
      if (hex.length == 6) hex = 'FF$hex';
      if (hex.length != 8) {
        throw FormatException("Hex color must be 6 or 8 characters long.");
      }
      return Color(int.parse(hex, radix: 16));
    } catch (e) {
      return Colors.grey;
    }
  }
}
