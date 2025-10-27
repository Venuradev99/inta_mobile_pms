import 'package:get/get.dart';
import 'package:inta_mobile_pms/core/widgets/message_helper.dart';
import 'package:inta_mobile_pms/features/housekeeping/models/save_work_order_request.dart';
import 'package:inta_mobile_pms/features/housekeeping/models/work_order.dart';
import 'package:inta_mobile_pms/features/housekeeping/models/work_orders_search_request.dart';
import 'package:inta_mobile_pms/services/apiServices/house_keeping_service.dart';
import 'package:inta_mobile_pms/services/message_service.dart';
import 'package:intl/intl.dart';

class WorkOrderListVm extends GetxController {
  final HouseKeepingService _houseKeepingServices;
  final workOrders = <WorkOrder>[].obs;
  final statusList = <Map<String, dynamic>>[].obs;
  final priorityList = <Map<String, dynamic>>[].obs;
  final categoryList = <Map<String, dynamic>>[].obs;
  final houseKeeperList = <Map<String, dynamic>>[].obs;
  final unitRoomList = <Map<String, dynamic>>[].obs;
  final reasonList = <Map<String, dynamic>>[].obs;
  final isLoading = true.obs;

  WorkOrderListVm(this._houseKeepingServices);

  Future<void> loadWorkOrders() async {
    try {
      isLoading.value = true;
      final request = WorkOrdersSearchRequest(
        assignerId: 0,
        categoryId: 0,
        isCompleted: false,
        priorityId: 0,
        roomId: 0,
        status: 0,
        unitId: 0,
        workOrderNumber: '',
        pageSize: 50,
        pageIndex: 0,
        startIndex: 0,
      ).toJson();

      final response = await _houseKeepingServices.getAllWorkOrders(request);
      final workOrderStatusResponse = await _houseKeepingServices
          .getWorkOrderStatus();

      if (workOrderStatusResponse["isSuccessful"] == true) {
        for (final item in workOrderStatusResponse["result"]) {
          statusList.add({
            "id": item["workOrderStatusModelId"],
            "description": item["description"],
          });
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
            orderNo: item["workOrderNumber"],
            category: item["categoryName"],
            unitRoom: item["roomName"],
            blockFrom: getDateForDDMMYYYY(item["from"]),
            blockTo: getDateForDDMMYYYY(item["to"]),
            priority: item["priorityName"],
            assignedTo: item["assingToName"],
            status: getStatus(item["status"]),
            dueDate: getDate(item["deadLineDate"]),
            description: item["description"],
            reason: '',
          );
          workOrders.add(data);
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

  Future<void> loadDataForAddWorkOrder() async {
    try {
      final response = await Future.wait([
        _houseKeepingServices.getWellKnownPriorities(),
        _houseKeepingServices.getWorkOrderCategories(),
        _houseKeepingServices.getHouseKeepers(),
        _houseKeepingServices.getAllRoomsForHouseStatus(),
        _houseKeepingServices.getReasons(),
      ]);

      final priorityResponse = response[0];
      final workOrderCategories = response[1];
      final houseKeepers = response[2];
      final unitRooms = response[3];
      final reasons = response[4];

      if (priorityResponse["isSuccessful"] == true) {
        for (final item in priorityResponse["result"]) {
          priorityList.add({
            "id": item["wellKnownPriorityId"],
            "description": item["name"],
          });
        }
      } else {
        MessageService().error(
          priorityResponse["errors"][0] ?? 'Error getting priorities!',
        );
      }

      if (workOrderCategories["isSuccessful"] == true) {
        for (final item in workOrderCategories["result"]) {
          categoryList.add({
            "id": item["workOrderCategoryId"],
            "description": item["name"],
          });
        }
      } else {
        MessageService().error(
          workOrderCategories["errors"][0] ?? 'Error getting categories!',
        );
      }

      if (houseKeepers["isSuccessful"] == true) {
        for (final item in houseKeepers["result"]) {
          houseKeeperList.add({
            "id": item["userId"],
            "description": "${item["firstName"]} ${item["lastName"]}",
          });
        }
      } else {
        MessageService().error(
          houseKeepers["errors"][0] ?? 'Error getting House Keepers!',
        );
      }
      if (unitRooms["isSuccessful"] == true) {
        for (final item in unitRooms["result"]["recordSet"]) {
          unitRoomList.add({"id": item["id"], "description": item["name"]});
        }
      } else {
        MessageService().error(
          unitRooms["errors"][0] ?? 'Error getting unit rooms!',
        );
      }
      if (reasons["isSuccessful"] == true) {
        for (final item in reasons["result"]) {
          reasonList.add({"id": item["reasonId"], "description": item["name"]});
        }
      } else {
        MessageService().error(reasons["errors"][0] ?? 'Error getting reasons!');
      }
    } catch (e) {
      MessageService().error('Work order loading error: $e');
      throw Exception('Error loading data for add work order: $e');
    }
  }

  String getStatus(int status) {
    final item = statusList.firstWhere((item) => item["id"] == status);
    return item["description"];
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
      final response = await _houseKeepingServices.saveNewWorkOrder(
        saveRequest,
      );
      if (response["isSuccessful"] == true) {
        MessageService().success(
          response["message"] ?? 'Work order saved Successfully!',
        );
      } else {
        MessageService().error(
          response["errors"][0] ?? 'Error saving work orders!',
        );
      }
    } catch (e) {
      MessageService().error('Error Saving new work order: $e');
      throw Exception('Error Saving new work order: $e');
    }
  }
}
