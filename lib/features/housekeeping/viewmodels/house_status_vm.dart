import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inta_mobile_pms/features/housekeeping/models/houseKeeper_response.dart';
import 'package:inta_mobile_pms/features/housekeeping/models/room_item_model.dart';
import 'package:inta_mobile_pms/features/housekeeping/models/update_house_status_payload.dart';
import 'package:inta_mobile_pms/services/apiServices/house_keeping_service.dart';
import 'package:inta_mobile_pms/services/message_service.dart';
import 'package:inta_mobile_pms/services/navigation_service.dart';
import 'dart:ui';

class HouseStatusVm extends GetxController {
  final HouseKeepingService _houseKeepingServices;

  final roomList = <RoomItem>[].obs;
  final groupedRooms = <String, List<RoomItem>>{}.obs;
  final houseKeepingStatusList = [].obs;
  final houseKeepersList = <HouseKeeper>[];
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
      houseKeepingStatusList.clear();
      final responses = await Future.wait([
        _houseKeepingServices.getAllHouseKeepingStatus(),
        _houseKeepingServices.getHouseKeepers(),
      ]);
      final houseKeepingStatus = responses[0];
      final houseKeepingers = responses[1];

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

      if (houseKeepingers["isSuccessful"] == true) {
        final result = houseKeepingers["result"];
        for (final item in result) {
          houseKeepersList.add(
            HouseKeeper.fromJson({
              "userId": item["userId"] ?? 0,
              "firstName": item["firstName"] ?? '',
              "lastName": item["lastName"] ?? '',
              "houseKeeperName": '${item["userId"]} ${item["lastName"]}',
            }),
          );
        }
      } else {
        MessageService().error(
          houseKeepingers["errors"][0] ?? 'Error getting HouseKeepers!',
        );
      }

      roomList.clear();
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
  Future<void> updateRoomHousekeeper(RoomItem room, HouseKeeper houseKeeper) async {
    try {
      final payload = UpdateHouseStatusPayload(
        id: houseKeeper.userId,
        houseKeeper: room.houseKeeper!,
        houseKeepingRemark: room.remark ?? '',
        houseKeepingStatus: room.houseKeepingStatusId!,
        isRoom: room.isRoom ?? true,
        operationType: 7,
      ).toJson();

      final response = await _houseKeepingServices.updateHouseStatus(payload);

      if (response["isSuccessful"] == true) {
        NavigationService().back();
        MessageService().success(
          response["message"] ?? 'Remark updated successfully.',
        );
        await loadRooms();
      } else {
        NavigationService().back();
        MessageService().error(
          response["errors"][0] ?? 'Error updating remark!',
        );
      }
    } catch (e) {
      MessageService().error('Error updating remark: $e');
      throw Exception('Error updating remark: $e');
    }
  }

  Future<void> updateRemark(RoomItem room, String remark) async {
    try {
      final payload = UpdateHouseStatusPayload(
        id: room.id!,
        houseKeeper: room.houseKeeper!,
        houseKeepingRemark: remark,
        houseKeepingStatus: room.houseKeepingStatusId!,
        isRoom: room.isRoom ?? true,
        operationType: 6,
      ).toJson();

      final response = await _houseKeepingServices.updateHouseStatus(payload);

      if (response["isSuccessful"] == true) {
        NavigationService().back();
        MessageService().success(
          response["message"] ?? 'Remark updated successfully.',
        );
        await loadRooms();
      } else {
        NavigationService().back();
        MessageService().error(
          response["errors"][0] ?? 'Error updating remark!',
        );
      }
    } catch (e) {
      MessageService().error('Error updating remark: $e');
      throw Exception('Error updating remark: $e');
    }
  }

  Future<void> clearRemark(RoomItem room) async {
    try {
      final payload = UpdateHouseStatusPayload(
        id: room.id!,
        houseKeeper: room.houseKeeper!,
        houseKeepingRemark: '',
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

  Future<void> unassignHouseKeeper(RoomItem room) async {
    try {
      final payload = UpdateHouseStatusPayload(
        id: room.id!,
        houseKeeper: 0,
        houseKeepingRemark: '',
        houseKeepingStatus: room.houseKeepingStatusId ?? 0,
        isRoom: room.isRoom ?? true,
        operationType: 7,
      ).toJson();

      final response = await _houseKeepingServices.updateHouseStatus(payload);

      if (response["isSuccessful"] == true) {
        MessageService().success(
          response["message"] ?? 'Housekeeper unassigned successfully.',
        );
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

  Future<void> clearStatus(RoomItem room) async {
    try {
      final payload = UpdateHouseStatusPayload(
        id: room.id!,
        houseKeeper: room.houseKeeper!,
        houseKeepingRemark: room.remark ?? '',
        houseKeepingStatus: 0,
        isRoom: room.isRoom ?? true,
        operationType: 6,
      ).toJson();

      final response = await _houseKeepingServices.updateHouseStatus(payload);

      if (response["isSuccessful"] == true) {
        MessageService().success(
          response["message"] ?? 'Status cleared successfully.',
        );
        await loadRooms();
      } else {
        MessageService().error(
          response["errors"][0] ?? 'Error clearing status!',
        );
      }
    } catch (e) {
      MessageService().error('Error clearing status: $e');
      throw Exception('Error clearing status: $e');
    }
  }

  Future<void> updateStatus(RoomItem room, int newStatusId) async {
    try {
      final payload = UpdateHouseStatusPayload(
        id: room.id!,
        houseKeeper: room.houseKeeper!,
        houseKeepingRemark: room.remark ?? '',
        houseKeepingStatus: newStatusId,
        isRoom: room.isRoom ?? true,
        operationType: 5,
      ).toJson();

      final response = await _houseKeepingServices.updateHouseStatus(payload);

      if (response["isSuccessful"] == true) {
        MessageService().success('Status updated successfully.');
        await loadRooms();
      } else {
        MessageService().error(
          response["errors"][0] ?? 'Error updating status!',
        );
      }
    } catch (e) {
      MessageService().error('Error updating status: $e');
    }
  }

  Future<void> bulkUpdateStatus(List<RoomItem> rooms, int newStatusId) async {
    for (final r in rooms) {
      await updateStatus(r, newStatusId);
    }
  }

  Future<void> bulkClearStatus(Set<RoomItem> rooms) async {
    // try {
    //   for (final room in rooms) {
    //     final payload = UpdateHouseStatusPayload(
    //       id: room.id!,
    //       houseKeeper: room.houseKeeper!,
    //       houseKeepingRemark: room.remark ?? '',
    //       houseKeepingStatus: 0,
    //       isRoom: room.isRoom ?? true,
    //       operationType: 6,
    //     ).toJson();
    //     final response = await _houseKeepingServices.updateHouseStatus(payload);

    //     if (response["isSuccessful"] == true) {
    //       MessageService().success(
    //         response["message"] ?? 'Status cleared successfully.',
    //       );
    //       await loadRooms();
    //     } else {
    //       MessageService().error(
    //         response["errors"][0] ?? 'Error clearing status!',
    //       );
    //     }
    //   }
    // } catch (e) {
    //   MessageService().error('Error clearing status: $e');
    //   throw Exception('Error clearing status: $e');
    // }
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
