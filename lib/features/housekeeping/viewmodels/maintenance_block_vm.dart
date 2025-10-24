import 'package:get/get.dart';
import 'package:inta_mobile_pms/core/widgets/message_helper.dart';
import 'package:inta_mobile_pms/features/housekeeping/models/block_room_reason_response.dart';
import 'package:inta_mobile_pms/features/housekeeping/models/maintenance_block_item.dart';
import 'package:inta_mobile_pms/features/housekeeping/models/maintenance_block_payload.dart';
import 'package:inta_mobile_pms/features/housekeeping/models/maintenanceblock_save_payload.dart';
import 'package:inta_mobile_pms/features/housekeeping/models/room_response.dart';
import 'package:inta_mobile_pms/services/apiServices/house_keeping_service.dart';
import 'package:inta_mobile_pms/services/local_storage_manager.dart';

class MaintenanceBlockVm extends GetxController {
  final HouseKeepingService _houseKeepingService;

  final isLoading = true.obs;
  RxList<MaintenanceBlockItem> maintenanceBlockList =
      <MaintenanceBlockItem>[].obs;
  RxList<MaintenanceBlockItem> maintenanceBlockListFiltered =
      <MaintenanceBlockItem>[].obs;
  final roomsList = <RoomResponse>[].obs;
  final blockRoomReasonList = <BlockRoomReasonResponse>[].obs;

  MaintenanceBlockVm(this._houseKeepingService);

  Future<void> loadAllMaintenanceBlocks() async {
    try {
      String systemWorkingDate = await LocalStorageManager.getSystemDate();
      DateTime sysDate = DateTime.parse(systemWorkingDate);
      DateTime nextMonthDate = DateTime(
        sysDate.year,
        sysDate.month + 1,
        sysDate.day,
      );
      String nextMonthSysDate = nextMonthDate.toString();
      final payload = MaintenanceBlockPayload(
        from: systemWorkingDate,
        to: nextMonthSysDate,
        isBlock: true,
        pageSize: 50,
        roomId: 0,
        roomTypeId: 0,
        startIndex: 0,
      ).toJson();
      final response = await Future.wait([
        _houseKeepingService.getAllMaintenanceblock(payload),
        _houseKeepingService.getAllRooms(),
        _houseKeepingService.getAllBlockRoomReasons(),
      ]);
      final maintenanceblockResponse = response[0];
      final roomResponse = response[1];
      final reasonResponse = response[2];

      if (maintenanceblockResponse["isSuccessful"] == true) {
        final result =
            (maintenanceblockResponse["result"]["recordSet"] as List?) ?? [];
        maintenanceBlockList.value = result
            .map(
              (item) => MaintenanceBlockItem(
                maintenanceBlockId: item["maintenanceBlockId"] ?? 0,
                roomId: item["roomId"] ?? 0,
                roomTypeId: item["roomTypeId"] ?? 0,
                roomName: item["roomName"] ?? '',
                roomTypeName: item["roomTypeName"] ?? '',
                fromDate: item["fromDate"].substring(0, 10) ?? '',
                toDate: item["toDate"].substring(0, 10) ?? '',
                reasonId: item["reasonId"] ?? 0,
                reasonName: item["reasonName"] ?? '',
                blockedBy: item["blockedBy"] ?? '',
                blockedOn: item["blockedOn"].substring(0, 10) ?? '',
                status: item["status"] ?? 0,
                hotelId: item["hotelId"] ?? 0,
              ),
            )
            .toList();
        maintenanceBlockListFiltered.value = maintenanceBlockList;
      } else {
        MessageHelper.error(
          maintenanceblockResponse["errors"][0] ??
              'Error getting maintenance blocks!',
        );
      }
      if (roomResponse["isSuccessful"] == true) {
        final result = roomResponse["result"]["recordSet"] as List;
        roomsList.value = result
            .map(
              (item) =>
                  RoomResponse(roomId: item["roomId"], name: item["name"]),
            )
            .toList();
      } else {
        MessageHelper.error(
          roomResponse["errors"][0] ?? 'Error getting rooms!',
        );
      }

      if (reasonResponse["isSuccessful"] == true) {
        final result = reasonResponse["result"] as List;
        blockRoomReasonList.value = result
            .map(
              (item) => BlockRoomReasonResponse(
                reasonId: item["reasonId"],
                name: item["name"],
              ),
            )
            .toList();
      } else {
        MessageHelper.error(
          reasonResponse["errors"][0] ?? 'Error getting reasons!',
        );
      }
    } catch (e) {
      MessageHelper.error('Error in loading maintenance blocks: $e');
      throw Exception('Error in loading maintenance blocks: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<Map<String, dynamic>> saveMaintenanceblock(
    DateTime? fromDate,
    DateTime? toDate,
    BlockRoomReasonResponse? reason,
    List<RoomResponse> roomList,
  ) async {
    try {
      isLoading.value = true;
      List<int> roomIdList = roomList.map((item) => item.roomId).toList();
      final payload = MaintenanceblockSavePayload(
        fromDate: fromDate.toString().substring(0, 10),
        toDate: toDate.toString().substring(0, 10),
        reason: reason?.reasonId ?? 0,
        roomIdList: roomIdList,
      ).toJson();
      final response = await _houseKeepingService.saveMaintenanceblock(payload);
      return response;
    } catch (e) {
      throw Exception('Error while saving maintenance block: $e');
    }
  }

  filteredMaintenanceBlocks(searchQuery) {
    try {
      // if (_selectedFilter != 'All') {
      //   filtered = filtered
      //       .where((block) => block.status == _selectedFilter)
      //       .toList();
      // }

      if (searchQuery.isNotEmpty) {
        maintenanceBlockListFiltered.value = maintenanceBlockList
            .where(
              (block) =>
                  block.reasonName.toLowerCase().contains(
                    searchQuery.toLowerCase(),
                  ) ||
                  block.roomName.toLowerCase().contains(
                    searchQuery.toLowerCase(),
                  ) ||
                  block.blockedOn.toLowerCase().contains(
                    searchQuery.toLowerCase(),
                  ),
            )
            .toList();
      }
    } catch (e) {
      throw Exception('Error filter searching : $e');
    }
  }
}
