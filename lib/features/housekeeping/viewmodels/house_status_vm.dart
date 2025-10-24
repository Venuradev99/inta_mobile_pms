import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inta_mobile_pms/core/theme/app_colors.dart';
import 'package:inta_mobile_pms/core/widgets/message_helper.dart';
import 'package:inta_mobile_pms/features/housekeeping/models/room_item_model.dart';
import 'package:inta_mobile_pms/services/apiServices/house_keeping_service.dart';

class HouseStatusVm extends GetxController {
  final HouseKeepingService _houseKeepingServices;

  final roomList = <RoomItem>[].obs;
  final groupedRooms = <String, List<RoomItem>>{}.obs;
  final houseKeepingStatusList = [].obs;
  final houseKeepersList = [];
  final isLoading = true.obs;

  HouseStatusVm(this._houseKeepingServices);

  void groupRoomsBySection(List<RoomItem> rooms) {
    final Map<String, List<RoomItem>> groupedBySection = {};
    for (final room in rooms) {
      groupedBySection.putIfAbsent(room.section, () => []).add(room);
    }
    groupedRooms.value = groupedBySection;
  }

  Future<void> loadRooms() async {
    try {
      isLoading.value = true;

      final response = await Future.wait([
        _houseKeepingServices.getAllHouseKeepingStatus(),
        _houseKeepingServices.getHouseKeepers(),
      ]);

      final houseKeepingStatus = response[0];
      final houseKeepers = response[1];

      if (houseKeepingStatus["isSuccessful"] == true) {
        final result = houseKeepingStatus["result"]["recordSet"];
        for (final item in result) {
          houseKeepingStatusList.add({
            "id": item["houseKeepingStatusId"],
            "name": item["name"],
            "description": item["description"],
            "colorCode": hexToColor(item["colorCode"].toString()),
          });
        }
      } else {
        MessageHelper.error(
          houseKeepingStatus["errors"][0] ??
              'Error getting House Keeping Status!',
        );
      }

      if (houseKeepers["isSuccessful"] == true) {
        final result = houseKeepers["result"];
        for (final item in result) {
          houseKeepersList.add({
            "id": item["userId"],
            "name": "${item["firstName"]} ${item["lastName"]}",
          });
        }
      } else {
        MessageHelper.error(
          houseKeepers["errors"][0] ?? 'Error getting House Keepers!',
        );
      }

      final roomResult = await _houseKeepingServices
          .getAllRoomsForHouseStatus();
      if (roomResult["isSuccessful"] == true) {
        final result = roomResult["result"]["recordSet"];
        for (final item in result) {
          final data = RoomItem(
            section: getHouseKeeperName(item["houseKeeper"]),
            roomName: item["name"] ?? '',
            availability: item["availability"] ?? '',
            housekeepingStatus: item["houseKeepingStatusName"] ?? '',
            roomType: item["roomTypeName"] ?? '',
          );
          roomList.add(data);
        }
      } else {
        MessageHelper.error(roomResult["errors"][0] ?? 'Error getting rooms!');
      }
      groupRoomsBySection(roomList);
    } catch (e) {
      MessageHelper.error('Error loading rooms: $e');
      throw Exception('Error loading rooms: $e');
    } finally {
      isLoading.value = false;
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

  String getHouseKeeperName(int id) {
    try {
      if (id == 0) {
        return '';
      }
      final selectedHouseKeeper = houseKeepersList.firstWhere(
        (item) => item["id"] == id,
      );
      return selectedHouseKeeper["name"];
    } catch (e) {
      throw Exception('Error while getting House keeper name: $e');
    }
  }

  Color getHousekeepingColor(String status) {
    try {
      final selectedStatus = houseKeepingStatusList.firstWhere(
        (item) =>
            item["name"].toString().toLowerCase() ==
            status.toString().toLowerCase(),
      );
      return selectedStatus["colorCode"];
    } catch (e) {
      return Colors.grey;
    }
  }

  Color getBackgroundColor(String status) {
    try {
      final selectedStatus = houseKeepingStatusList.firstWhere(
        (item) =>
            item["name"].toString().toLowerCase() ==
            status.toString().toLowerCase(),
      );
      return selectedStatus["colorCode"].withOpacity(0.2);
    } catch (e) {
      return Colors.blueGrey.withOpacity(0.2);
    }
  }

  Color getTextColor(String status) {
    try {
      final selectedStatus = houseKeepingStatusList.firstWhere(
        (item) =>
            item["name"].toString().toLowerCase() ==
            status.toString().toLowerCase(),
      );
      return selectedStatus["colorCode"];
    } catch (e) {
      return Colors.grey;
    }
  }

  Color getStatusColor(String status) {
    try {
      final selectedStatus = houseKeepingStatusList.firstWhere(
        (item) =>
            item["name"].toString().toLowerCase() ==
            status.toString().toLowerCase(),
      );
      return selectedStatus["colorCode"];
    } catch (e) {
      return Colors.grey;
    }
  }
}
