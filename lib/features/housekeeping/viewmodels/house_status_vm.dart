import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inta_mobile_pms/features/housekeeping/models/room_item_model.dart';
import 'package:inta_mobile_pms/features/housekeeping/models/update_house_status_payload.dart';
import 'package:inta_mobile_pms/services/apiServices/house_keeping_service.dart';
import 'package:inta_mobile_pms/services/message_service.dart';

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

      final houseKeepingStatus = await _houseKeepingServices
          .getAllHouseKeepingStatus();

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
        MessageService().error(
          houseKeepingStatus["errors"][0] ??
              'Error getting House Keeping Status!',
        );
      }

      final roomResult = await _houseKeepingServices
          .getAllRoomsForHouseStatus();
      if (roomResult["isSuccessful"] == true) {
        final result = roomResult["result"]["recordSet"];
        for (final item in result) {
          final data = RoomItem(
            id: item["id"] ?? 0,
            houseKeeper: item["houseKeeper"] ?? 0,
            houseKeeperName: item["houseKeeperName"] ?? '',
            section: item["houseKeeperName"] ?? '',
            roomName: item["name"] ?? '',
            availability: item["availability"] ?? '',
            housekeepingStatus: item["houseKeepingStatusName"] ?? '',
            houseKeepingStatusId: item["houseKeepingStatus"] ?? 0,
            roomType: item["roomTypeName"] ?? '',
            hasIssue: item["isDirty"] ?? false,
            remark: item["houseKeepingRemark"] ?? '',
            isRoom: item["isRoom"] ?? true,
          );
          roomList.add(data);
        }
      } else {
        MessageService().error(
          roomResult["errors"][0] ?? 'Error getting rooms!',
        );
      }
      groupRoomsBySection(roomList);
    } catch (e) {
      MessageService().error('Error loading rooms: $e');
      throw Exception('Error loading rooms: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> clearRemark(RoomItem room) async {
    try {
      final payload = UpdateHouseStatusPayload(
        id: room.id!,
        houseKeeper: room.houseKeeper!,
        houseKeepingRemark: room.remark ?? '',
        houseKeepingStatus: room.houseKeepingStatusId!,
        isRoom: room.isRoom ?? true,
        operationType: 6,
      ).toJson();

      final response = await _houseKeepingServices.updateHouseStatus(payload);

      if (response["isSuccessful"] == true) {
        MessageService().success('Remark cleared successfully.');
        await loadRooms();
      } else {
        MessageService().error(
          response["errors"][0] ?? 'Error clearing remark!',
        );
      }
    } catch (e) {
      MessageService().error('Error clearing remark: $e');
      throw Exception('Error clearing remark: $e');
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
