import 'package:get/get.dart';
import 'package:inta_mobile_pms/features/housekeeping/models/dropdown_data.dart';
import 'package:inta_mobile_pms/features/housekeeping/models/post_note_payload.dart';
import 'package:inta_mobile_pms/features/housekeeping/models/save_work_order_request.dart';
import 'package:inta_mobile_pms/features/housekeeping/models/work_order.dart';
import 'package:inta_mobile_pms/features/housekeeping/models/work_order_audit_trail_item.dart';
import 'package:inta_mobile_pms/features/housekeeping/models/work_orders_search_request.dart';
import 'package:inta_mobile_pms/services/apiServices/house_keeping_service.dart';
import 'package:inta_mobile_pms/services/message_service.dart';
import 'package:inta_mobile_pms/services/navigation_service.dart';
import 'package:intl/intl.dart';

class WorkOrderListVm extends GetxController {
  final HouseKeepingService _houseKeepingServices;
  final workOrders = <WorkOrder>[].obs;
  final workOrdersFiltered = <WorkOrder>[].obs;
  final statusList = <DropdownData>[].obs;
  final priorityList = <DropdownData>[].obs;
  final categoryList = <DropdownData>[].obs;
  final houseKeeperList = <DropdownData>[].obs;
  final unitRoomList = <DropdownData>[].obs;
  final reasonList = <DropdownData>[].obs;
  final audiTrailList = <WorkOrderAuditTrailItem>[].obs;
  final isLoading = true.obs;
  final isWorkOrderLoading = true.obs;
  final isPostNoteDataLoading = true.obs;

  final filterStartDate = Rxn<DateTime>();
  final filterEndDate = Rxn<DateTime>();
  final filterOrderNo = Rxn<String>();
  final filterCategoryId = Rxn<int>();
  final filterPriorityId = Rxn<int>();
  final filterRoomId = Rxn<int>();
  final filterStatusId = Rxn<int>();
  final filterAssignToId = Rxn<int>();
  final filterIsCompleted = Rxn<bool>();

  WorkOrderListVm(this._houseKeepingServices);

  Future<void> loadWorkOrders() async {
    try {
      isLoading.value = true;
      workOrdersFiltered.clear();
      workOrders.clear();
      final request = WorkOrdersSearchRequest(
        assignerId: 0,
        categoryId: 0,
        isCompleted: false,
        priorityId: 0,
        roomId: 0,
        status: 0,
        unitId: 0,
        workOrderNumber: '',
        pageSize: 0,
        pageIndex: 0,
        startIndex: 0,
      ).toJson();

      final response = await _houseKeepingServices.getAllWorkOrdersApi(request);
      final workOrderStatusResponse = await _houseKeepingServices
          .getWorkOrderStatusApi();

      if (workOrderStatusResponse["isSuccessful"] == true) {
        statusList.clear();
        for (final item in workOrderStatusResponse["result"]) {
          statusList.add(
            DropdownData(
              id: item["workOrderStatusModelId"],
              description: item["description"],
            ),
          );
        }
      } else {
        MessageService().error(
          workOrderStatusResponse["errors"][0] ??
              'Error getting work order status!',
        );
      }

      if (response["isSuccessful"] == true) {
        final result = response["result"]["recordSet"];
        for (final item in result) {
          final data = WorkOrder(
            workOrderId: item["workOrderId"],
            orderNo: item["workOrderNumber"],
            category: item["categoryName"],
            unitRoom: item["unitName"],
            roomName: item["roomName"],
            blockFrom: getDateForDDMMYYYY(item["from"]),
            blockTo: getDateForDDMMYYYY(item["to"]),
            enteredOn: getDateFromIsoString(item["entered"]),
            updatedOn: getDateFromIsoString(item["updated"]),
            priority: item["priorityName"],
            assignedTo: item["assingToName"],
            assingToId: item["assingTo"],
            statusId: item["status"],
            status: getStatus(item["status"]),
            dueDate: getDate(item["deadLineDate"]),
            description: item["description"],
            postNote: item["postNote"],
            reason: '',
            isRoom: item["isRoom"],
            unitId: item["unitId"],
            roomId: item["roomId"],
            priorityId: item["priority"],
          );
          workOrders.add(data);
          workOrdersFiltered.add(data);
        }
      } else {
        MessageService().error(
          response["errors"][0] ?? 'Error getting work orders!',
        );
      }
    } catch (e) {
      MessageService().error('Work order loading error: $e');
      throw Exception('Work order loading error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadAuditTrails(WorkOrder workOrder) async {
    try {
      isWorkOrderLoading.value = true;

      final id = workOrder.workOrderId;
      final type = 3;
      final isRoom = workOrder.isRoom;
      final date = DateTime.now();

      final response = await _houseKeepingServices.getAllHouseKeepingAuditTrailApi(
        id!,
        type,
        isRoom!,
        date,
      );

      if (response["isSuccessful"] == true) {
        final result = (response["result"] as List?) ?? [];
        audiTrailList.value = result
            .map((item) => WorkOrderAuditTrailItem.fromJson(item))
            .toList();
        workOrdersFiltered.value = workOrders;
      } else {
        MessageService().error(
          response["errors"][0] ?? 'Error getting Work Order audit trails!',
        );
      }
    } catch (e) {
      MessageService().error('Error in loading Work Order audit trails: $e');
      throw Exception('Error in loading Work Order audit trails: $e');
    } finally {
      isWorkOrderLoading.value = false;
    }
  }

  Future<void> loadPostNoteData(WorkOrder workOrder) async {
    try {
      isPostNoteDataLoading.value = true;
      final response = await Future.wait([
        _houseKeepingServices.getHouseKeepersApi(),
      ]);

      final houseKeepers = response[0];

      if (houseKeepers["isSuccessful"] == true) {
        houseKeeperList.clear();
        for (final item in houseKeepers["result"]) {
          houseKeeperList.add(
            DropdownData(
              id: item["userId"],
              description: "${item["firstName"]} ${item["lastName"]}",
            ),
          );
        }
      } else {
        MessageService().error(
          houseKeepers["errors"][0] ?? 'Error getting House Keepers!',
        );
      }
    } catch (e) {
      MessageService().error('Post Note data loading error: $e');
      throw Exception('Post Note data loading error: $e');
    } finally {
      isPostNoteDataLoading.value = false;
    }
  }

  Future<void> updatePostNote(PostNotePayload payload) async {
    try {
      final response = await _houseKeepingServices.updatePostNoteApi(
        payload.toJson(),
        payload.workOrderId,
      );

      if (response["isSuccessful"] == true) {
        NavigationService().back();
        loadWorkOrders();
        MessageService().success(response["message"] ?? 'Successful!');
      } else {
        NavigationService().back();
        MessageService().error(
          response["errors"][0] ?? 'Error updating Post Note!',
        );
      }
    } catch (e) {
      MessageService().error('Post Note data loading error: $e');
      throw Exception('Post Note data loading error: $e');
    } finally {
      isPostNoteDataLoading.value = false;
    }
  }

  Future<void> loadDataForAddWorkOrder() async {
    try {
      final response = await Future.wait([
        _houseKeepingServices.getWellKnownPrioritiesApi(),
        _houseKeepingServices.getWorkOrderCategoriesApi(),
        _houseKeepingServices.getHouseKeepersApi(),
        _houseKeepingServices.getAllRoomsForHouseStatusApi(),
        _houseKeepingServices.getReasonsApi(),
      ]);

      final priorityResponse = response[0];
      final workOrderCategories = response[1];
      final houseKeepers = response[2];
      final unitRooms = response[3];
      final reasons = response[4];

      if (priorityResponse["isSuccessful"] == true) {
        priorityList.clear();
        for (final item in priorityResponse["result"]) {
          priorityList.add(
            DropdownData(
              id: item["wellKnownPriorityId"],
              description: item["name"],
            ),
          );
        }
      } else {
        MessageService().error(
          priorityResponse["errors"][0] ?? 'Error getting priorities!',
        );
      }

      if (workOrderCategories["isSuccessful"] == true) {
        categoryList.clear();
        for (final item in workOrderCategories["result"]) {
          categoryList.add(
            DropdownData(
              id: item["workOrderCategoryId"],
              description: item["name"],
            ),
          );
        }
      } else {
        MessageService().error(
          workOrderCategories["errors"][0] ?? 'Error getting categories!',
        );
      }

      if (houseKeepers["isSuccessful"] == true) {
        houseKeeperList.clear();
        for (final item in houseKeepers["result"]) {
          houseKeeperList.add(
            DropdownData(
              id: item["userId"],
              description: "${item["firstName"]} ${item["lastName"]}",
            ),
          );
        }
      } else {
        MessageService().error(
          houseKeepers["errors"][0] ?? 'Error getting House Keepers!',
        );
      }
      if (unitRooms["isSuccessful"] == true) {
        unitRoomList.clear();
        for (final item in unitRooms["result"]["recordSet"]) {
          unitRoomList.add(
            DropdownData(id: item["id"], description: item["name"]),
          );
        }
      } else {
        MessageService().error(
          unitRooms["errors"][0] ?? 'Error getting unit rooms!',
        );
      }
      if (reasons["isSuccessful"] == true) {
        reasonList.clear();
        for (final item in reasons["result"]) {
          reasonList.add(
            DropdownData(id: item["reasonId"], description: item["name"]),
          );
        }
      } else {
        MessageService().error(
          reasons["errors"][0] ?? 'Error getting reasons!',
        );
      }
    } catch (e) {
      MessageService().error('Work order loading error: $e');
      throw Exception('Error loading data for add work order: $e');
    }
  }

  String getStatus(int status) {
    final item = statusList.firstWhere((item) => item.id == status);
    return item.description;
  }

  DateTime getDate(String date) {
    try {
      return DateTime.parse(date);
    } catch (e) {
      throw Exception('error parsing date: $e');
    }
  }

  DateTime getDateForDDMMYYYY(String date) {
    try {
      return DateFormat('dd/MM/yyyy').parse(date);
    } catch (e) {
      throw Exception('error parsing date for format dd/mm/yyyy: $e');
    }
  }

  DateTime getDateFromIsoString(String isoString) {
    try {
      return DateTime.parse(isoString);
    } catch (e) {
      throw Exception('Error parsing ISO date string: $e');
    }
  }

  String getDateFromDateTime(DateTime date) {
    try {
      final dateToString = date.toString();
      final yyyyMMdd = dateToString.split(' ')[0];
      return yyyyMMdd;
    } catch (e) {
      throw Exception('Error get date from DateTime: $e');
    }
  }

  String getTimeFromDateTime(DateTime date) {
    try {
      final timeToString = date.toString().split(' ')[1];
      DateTime tweleveHourFormat = DateFormat(
        'HH:mm:ss.SSS',
      ).parse(timeToString);
      return DateFormat('hh:mm a').format(tweleveHourFormat);
    } catch (e) {
      throw Exception('Error convert Time format from DateTime: $e');
    }
  }

  Future<void> saveWorkOrder(WorkOrder newWorkOrder) async {
    try {
      final saveRequest = SaveWorkOrderRequest(
        assigningTo: int.parse(newWorkOrder.assignedTo),
        blockFrom: getDateFromDateTime(newWorkOrder.blockFrom),
        blockTo: getDateFromDateTime(newWorkOrder.blockTo),
        categoryId: int.parse(newWorkOrder.category),
        deadLineDate: getDateFromDateTime(newWorkOrder.dueDate),
        deadLineTime: getTimeFromDateTime(newWorkOrder.dueDate),
        description: newWorkOrder.description,
        from: "",
        isRoom: true,
        itemId: 1,
        priority: int.parse(newWorkOrder.priority),
        reasonId: int.parse(newWorkOrder.reason),
        roomId: int.parse(newWorkOrder.unitRoom),
        status: int.parse(newWorkOrder.status),
        to: "",
        unitId: 0,
        workOrderId: 0,
        workOrderIdNew: "New",
      ).toJson();
      final response = await _houseKeepingServices.saveNewWorkOrderApi(
        saveRequest,
      );
      if (response["isSuccessful"] == true) {
        NavigationService().back();
        MessageService().success(
          response["message"] ?? 'Work order saved Successfully!',
        );
        loadWorkOrders();
      } else {
        NavigationService().back();
        MessageService().error(
          response["errors"][0] ?? 'Error saving work orders!',
        );
      }
    } catch (e) {
      MessageService().error('Error Saving new work order: $e');
      throw Exception('Error Saving new work order: $e');
    }
  }

  searchWorkOrders(String searchQuery) {
    try {
      if (searchQuery.isNotEmpty) {
        workOrdersFiltered.value = workOrders
            .where(
              (WorkOrder workOrder) =>
                  workOrder.orderNo.toLowerCase().contains(
                    searchQuery.toLowerCase(),
                  ) ||
                  workOrder.unitRoom.toLowerCase().contains(
                    searchQuery.toLowerCase(),
                  ) ||
                  workOrder.blockTo.toString().toLowerCase().contains(
                    searchQuery.toLowerCase(),
                  ) ||
                  workOrder.blockFrom.toString().toLowerCase().contains(
                    searchQuery.toLowerCase(),
                  ) ||
                  workOrder.reason.toLowerCase().contains(
                    searchQuery.toLowerCase(),
                  ) ||
                  workOrder.description.toLowerCase().contains(
                    searchQuery.toLowerCase(),
                  ) ||
                  workOrder.dueDate.toString().toLowerCase().contains(
                    searchQuery.toLowerCase(),
                  ) ||
                  workOrder.assignedTo.toLowerCase().contains(
                    searchQuery.toLowerCase(),
                  ) ||
                  workOrder.status.toLowerCase().contains(
                    searchQuery.toLowerCase(),
                  ) ||
                  workOrder.description.toLowerCase().contains(
                    searchQuery.toLowerCase(),
                  ),
            )
            .toList();
      } else {
        workOrdersFiltered.value = workOrders.toList();
      }
    } catch (e) {
      throw Exception('Error filter searching : $e');
    }
  }

  void filterByFilterBottomSheet({bool? isReset}) {
    try {
      List<WorkOrder> listToFilter = workOrders.toList();
      if (isReset == true) {
        workOrdersFiltered.value = workOrders.toList();
        filterOrderNo.value = null;
        filterStartDate.value = null;
        filterEndDate.value = null;
        filterCategoryId.value = null;
        filterPriorityId.value = null;
        filterStatusId.value = null;
        filterAssignToId.value = null;
        filterRoomId.value = null;
        filterIsCompleted.value = false;
        return;
      }
      if (filterStartDate.value != null) {
        listToFilter = listToFilter.where((workOrder) {
          DateTime blockFromDate = DateTime.parse(
            workOrder.blockFrom.toString(),
          );
          return blockFromDate.isAfter(filterStartDate.value!) ||
              blockFromDate.isAtSameMomentAs(filterStartDate.value!);
        }).toList();
      }
      if (filterEndDate.value != null) {
        listToFilter = listToFilter.where((workOrder) {
          DateTime blockToDate = DateTime.parse(workOrder.blockTo.toString());
          return blockToDate.isBefore(filterEndDate.value!) ||
              blockToDate.isAtSameMomentAs(filterEndDate.value!);
        }).toList();
      }
      if (filterOrderNo.value != null && filterOrderNo.value!.isNotEmpty) {
        listToFilter = listToFilter
            .where(
              (item) => item.orderNo.toLowerCase().contains(
                filterOrderNo.value!.toLowerCase(),
              ),
            )
            .toList();
      }
      if (filterCategoryId.value != null) {
        listToFilter = listToFilter
            .where(
              (item) =>
                  item.category ==
                  categoryList
                      .firstWhere(
                        (element) => element.id == filterCategoryId.value,
                      )
                      .description,
            )
            .toList();
      }
      if (filterPriorityId.value != null) {
        listToFilter = listToFilter
            .where(
              (item) =>
                  item.priority ==
                  priorityList
                      .firstWhere(
                        (element) => element.id == filterPriorityId.value,
                      )
                      .description,
            )
            .toList();
      }
      if (filterRoomId.value != null) {
        listToFilter = listToFilter
            .where(
              (item) =>
                  item.unitRoom ==
                  unitRoomList
                      .firstWhere((element) => element.id == filterRoomId.value)
                      .description,
            )
            .toList();
      }
      if (filterStatusId.value != null) {
        listToFilter = listToFilter
            .where(
              (item) =>
                  item.status ==
                  statusList
                      .firstWhere(
                        (element) => element.id == filterStatusId.value,
                      )
                      .description,
            )
            .toList();
      }
      if (filterAssignToId.value != null) {
        listToFilter = listToFilter
            .where(
              (item) =>
                  item.assignedTo ==
                  houseKeeperList
                      .firstWhere(
                        (element) => element.id == filterAssignToId.value,
                      )
                      .description,
            )
            .toList();
      }
      if (filterIsCompleted.value == true) {
        listToFilter = listToFilter
            .where(
              (item) =>
                  item.status.toLowerCase() ==
                  statusList
                      .firstWhere((element) => element.id == 2)
                      .description
                      .toLowerCase(),
            )
            .toList();
      }

      workOrdersFiltered.value = listToFilter;
    } catch (e) {
      throw Exception('Error filter maintenance blocks : $e');
    }
  }
}
