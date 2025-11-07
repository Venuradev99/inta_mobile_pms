
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inta_mobile_pms/features/housekeeping/models/room_item_model.dart';
import 'package:inta_mobile_pms/features/housekeeping/viewmodels/house_status_vm.dart';

class SetStatusDialog extends StatelessWidget {
  final RoomItem room;
  final bool isBulk;
  final List<RoomItem>? bulkRooms;

  const SetStatusDialog({
    super.key,
    required this.room,
    this.isBulk = false,
    this.bulkRooms,
  });

  @override
  Widget build(BuildContext context) {
    final vm = Get.find<HouseStatusVm>();

    return AlertDialog(
      backgroundColor: Theme.of(context).cardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      title: Text(
        isBulk
            ? 'Set status for ${bulkRooms!.length} rooms'
            : 'Set status – ${room.roomName}',
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      content: Obx(() {
        final statuses = vm.houseKeepingStatusList;
        if (statuses.isEmpty) {
          return const SizedBox(
            height: 80,
            child: Center(child: CircularProgressIndicator()),
          );
        }

        return SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: statuses.length,
            itemBuilder: (_, i) {
              final status = statuses[i];
              final name = status['name'] as String;
              final id = status['id'] as int;
              final color = status['colorCode'] as Color;

              return RadioListTile<int>(
                value: id,
                groupValue: null, // we don't pre-select, user must choose
                title: Row(
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      decoration:
                          BoxDecoration(color: color, shape: BoxShape.circle),
                    ),
                    const SizedBox(width: 8),
                    Text(name),
                  ],
                ),
                onChanged: (val) async {
                  Navigator.of(context).pop(val); // return chosen id
                },
                activeColor: color,
              );
            },
          ),
        );
      }),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
      ],
    );
  }
}