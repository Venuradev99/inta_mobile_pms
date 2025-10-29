import 'package:get/get.dart';
import 'package:inta_mobile_pms/core/widgets/message_helper.dart';
import 'package:inta_mobile_pms/features/housekeeping/models/block_room_reason_response.dart';
import 'package:inta_mobile_pms/features/housekeeping/models/maintenance_block_item.dart';
import 'package:inta_mobile_pms/features/housekeeping/models/maintenance_block_payload.dart';
import 'package:inta_mobile_pms/features/housekeeping/models/maintenanceblock_save_payload.dart';
import 'package:inta_mobile_pms/features/housekeeping/models/room_response.dart';
import 'package:inta_mobile_pms/features/housekeeping/models/unblock_maintenance_block_payload.dart';
import 'package:inta_mobile_pms/services/apiServices/house_keeping_service.dart';
import 'package:inta_mobile_pms/services/local_storage_manager.dart';
import 'package:inta_mobile_pms/services/message_service.dart';
import 'package:inta_mobile_pms/services/navigation_service.dart';

class RoomTypeResponse {
  final int roomTypeId;
  final String name;

  RoomTypeResponse({
    required this.roomTypeId,
    required this.name,
  });
}

class MaintenanceBlockVm extends GetxController {
  final HouseKeepingService _houseKeepingService;

  final isLoading = true.obs;
  RxList<MaintenanceBlockItem> maintenanceBlockList =
      <MaintenanceBlockItem>[].obs;
  RxList<MaintenanceBlockItem> maintenanceBlockListFiltered =
      <MaintenanceBlockItem>[].obs;
  final roomsList = <RoomResponse>[].obs;
  final roomTypesList = <RoomTypeResponse>[].obs;
  final blockRoomReasonList = <BlockRoomReasonResponse>[].obs;

  final filterStartDate = Rxn<DateTime>();
  final filterEndDate = Rxn<DateTime>();
  final filterRoomTypeId = Rxn<int>();
  final filterRoomId = Rxn<int>();
  final filterIsUnblock = false.obs;

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
      String nextMonthSysDate = nextMonthDate.toString().substring(0, 10);

      final payload = MaintenanceBlockPayload(
        from: filterStartDate.value?.toString().substring(0, 10) ?? systemWorkingDate,
        to: filterEndDate.value?.toString().substring(0, 10) ?? nextMonthSysDate,
        isBlock: !filterIsUnblock.value,
        pageSize: 50,
        roomId: filterRoomId.value ?? 0,
        roomTypeId: filterRoomTypeId.value ?? 0,
        startIndex: 0,
      ).toJson();
      final response = await Future.wait([
        _houseKeepingService.getAllMaintenanceblock(payload),
        _houseKeepingService.getAllRooms(),
        _houseKeepingService.getAllBlockRoomReasons(),
        _houseKeepingService.getAllRoomTypes(), // Assuming this method exists in your service; implement it similarly to getAllRooms
      ]);
      final maintenanceblockResponse = response[0];
      final roomResponse = response[1];
      final reasonResponse = response[2];
      final roomTypeResponse = response[3];

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
                blockedOn: item["blockedOn"] ?? '',
                status: item["status"] ?? 0,
                hotelId: item["hotelId"] ?? 0,
              ),
            )
            .toList();
        maintenanceBlockListFiltered.value = maintenanceBlockList;
      } else {
        MessageService().error(
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
        MessageService().error(
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
        MessageService().error(
          reasonResponse["errors"][0] ?? 'Error getting reasons!',
        );
      }

      if (roomTypeResponse["isSuccessful"] == true) {
        final result = roomTypeResponse["result"]["recordSet"] as List; // Adjust based on your API response structure
        roomTypesList.value = result
            .map(
              (item) => RoomTypeResponse(
                roomTypeId: item["roomTypeId"],
                name: item["name"],
              ),
            )
            .toList();
      } else {
        MessageService().error(
          roomTypeResponse["errors"][0] ?? 'Error getting room types!',
        );
      }
    } catch (e) {
      MessageService().error('Error in loading maintenance blocks: $e');
      throw Exception('Error in loading maintenance blocks: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> unblockRoom(
    MaintenanceBlockItem block,
    DateTime fromDate,
    DateTime toDate,
  ) async {
    try {
      final payload = UnblockMaintenanceBlockPayload(
        maintenanceBlockId: block.maintenanceBlockId,
        hotelId: block.hotelId,
        roomId: block.roomId,
        roomTypeId: block.roomTypeId,
        reasonId: block.reasonId,
        blockedBy: block.blockedBy,
        blockedOn: block.blockedOn,
        fromDate: fromDate.toString().substring(0, 10),
        toDate: toDate.toString().substring(0, 10),
        reasonName: block.reasonName,
        roomName: block.roomName,
        roomTypeName: block.roomTypeName,
        name: [block.roomName],
        status: 0,
        unblockDateRanges: [
          UnblockDateRange(
            fromDate: fromDate.toString().substring(0, 10),
            toDate: toDate.toString().substring(0, 10),
            index: 1,
            isMain: true,
            isOverlap: false,
            minDate: '${fromDate.toString().substring(0, 10)}T00:00:00',
            maxDate: '${toDate.toString().substring(0, 10)}T00:00:00',
          ),
        ],
      ).toJson();
      final response = await _houseKeepingService.unblockRoom(
        payload,
        block.maintenanceBlockId,
      );
      if (response["isSuccessful"] == true) {
        NavigationService().back();
        await loadAllMaintenanceBlocks();
        MessageService().success('Room unblocked successfully.');
      } else {
        MessageService().error(
          response["errors"][0] ?? 'Error in unblocking room!',
        );
      }
    } catch (e) {
      throw Exception('Error in unblocking room: $e');
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
      }else{
        maintenanceBlockListFiltered.value = maintenanceBlockList;
      }
    } catch (e) {
      throw Exception('Error filter searching : $e');
    }
  }
}