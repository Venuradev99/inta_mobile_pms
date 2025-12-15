import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inta_mobile_pms/core/theme/app_colors.dart';
import 'package:inta_mobile_pms/features/stay_view/models/available_rooms.dart';
import 'package:inta_mobile_pms/features/stay_view/viewmodels/stay_view_vm.dart';

class BookingRoomDialog extends StatefulWidget {
  final List<Map<String, dynamic>> bookingRooms;
  final Function(Map<String, dynamic> booking, AvailableRooms? selectedRoom)
      onAssign;
  final VoidCallback onCancel;

  const BookingRoomDialog({
    required this.bookingRooms,
    required this.onAssign,
    required this.onCancel,
    super.key,
  });

  @override
  State<BookingRoomDialog> createState() => _BookingRoomDialogState();
}

class _BookingRoomDialogState extends State<BookingRoomDialog> {
  final StayViewVm _stayViewVm = Get.find<StayViewVm>();

  /// Map of bookingRoomId -> selected AvailableRooms
  final Map<int, AvailableRooms?> selectedRooms = {};

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 40, vertical: 60),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 500),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Assign Rooms',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Flexible(
                child: SingleChildScrollView(
                  child: Column(
                    children: widget.bookingRooms.map((booking) {
                      int bookingRoomId = booking['bookingRoomId'];
                      int roomTypeId = booking['roomTypeId'];

                      return FutureBuilder<List<AvailableRooms>>(
                        future: _stayViewVm.loadAvailableRooms(roomTypeId),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return Card(
                              elevation: 2,
                              margin:
                                  const EdgeInsets.symmetric(vertical: 8),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Padding(
                                padding: EdgeInsets.all(16),
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              ),
                            );
                          }

                          final rooms = snapshot.data!;
                          final Map<int, AvailableRooms> roomById = {
                            for (var room in rooms) room.roomId: room
                          };

                          return Card(
                            elevation: 2,
                            margin:
                                const EdgeInsets.symmetric(vertical: 8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Guest: ${booking['bookingRoomOwnerName']}',
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Booking Date: ${booking['bookingDate'].toString().split("T")[0]}',
                                        style:
                                            const TextStyle(fontSize: 14),
                                      ),
                                      Text(
                                        'Room Type: ${booking['roomTypeName']}',
                                        style:
                                            const TextStyle(fontSize: 14),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  DropdownButtonFormField<int>(
                                    decoration: const InputDecoration(
                                      labelText: 'Select Room',
                                      border: OutlineInputBorder(),
                                      contentPadding: EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 4),
                                    ),
                                    value: selectedRooms[bookingRoomId]?.roomId,
                                    items: [
                                      const DropdownMenuItem<int>(
                                        value: null,
                                        child: Text('Select a room'),
                                      ),
                                      ...rooms.map(
                                        (room) => DropdownMenuItem<int>(
                                          value: room.roomId,
                                          child: Text(room.name),
                                        ),
                                      ),
                                    ],
                                    onChanged: (roomId) {
                                      setState(() {
                                        selectedRooms[bookingRoomId] =
                                            roomId != null
                                                ? roomById[roomId]
                                                : null;
                                      });
                                    },
                                  ),
                                  const SizedBox(height: 12),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.end,
                                    children: [
                                      TextButton(
                                        onPressed: widget.onCancel,
                                        child: const Text('Cancel'),
                                      ),
                                      const SizedBox(width: 8),
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: AppColors.primary,
                                          foregroundColor:
                                              AppColors.onPrimary,
                                        ),
                                        onPressed: () {
                                          widget.onAssign(
                                            booking,
                                            selectedRooms[bookingRoomId],
                                          );
                                        },
                                        child: const Text('Assign'),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    }).toList(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
