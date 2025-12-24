import 'package:flutter/material.dart';
import 'package:inta_mobile_pms/core/theme/app_colors.dart';
import 'package:inta_mobile_pms/features/stay_view/models/available_rooms.dart';
import 'package:inta_mobile_pms/features/stay_view/models/unassign_booking_item.dart';
import 'package:intl/intl.dart';

class UnassignRoomDialog extends StatefulWidget {
  final List<UnassignBookingItem> unassignBookingList;
  final Function(UnassignBookingItem item) onViewReservation;
  final Function(UnassignBookingItem item, AvailableRooms? selectedRoom)
      onAssignRoom;

  const UnassignRoomDialog({
    super.key,
    required this.unassignBookingList,
    required this.onViewReservation,
    required this.onAssignRoom,
  });

  @override
  State<UnassignRoomDialog> createState() => _UnassignRoomDialogState();
}

class _UnassignRoomDialogState extends State<UnassignRoomDialog> {
  final DateFormat dayFormat = DateFormat('dd');
  final DateFormat monthFormat = DateFormat('MMM');
  final DateFormat timeFormat = DateFormat('hh:mm a');

  final Map<int, AvailableRooms?> selectedRooms = {}; // bookingRoomId -> room

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.7,
        child: Column(
          children: [
            _buildHeader(),
            const Divider(height: 1),
            Expanded(child: _buildList()),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          const Expanded(
            child: Text(
              'Unassigned Rooms',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  Widget _buildList() {
    if (widget.unassignBookingList.isEmpty) {
      return const Center(child: Text('No unassigned bookings'));
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: widget.unassignBookingList.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final item = widget.unassignBookingList[index];
        return _buildCard(item);
      },
    );
  }

  Widget _buildCard(UnassignBookingItem item) {
    final checkIn = item.checkInDate;
    final checkOut = item.checkOutDate;
    final screenWidth = MediaQuery.of(context).size.width;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              /// LEFT DATE COLUMN
              Container(
                width: 70,
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          dayFormat.format(checkIn),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: AppColors.darkgrey,
                          ),
                        ),
                        Text(
                          monthFormat.format(checkIn),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                            color: AppColors.darkgrey,
                          ),
                        ),
                      ],
                    ),
                    const Column(
                      children: [
                        SizedBox(height: 4),
                        Divider(height: 1, thickness: 1),
                        SizedBox(height: 4),
                      ],
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          dayFormat.format(checkOut),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: AppColors.darkgrey,
                          ),
                        ),
                        Text(
                          monthFormat.format(checkOut),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                            color: AppColors.darkgrey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 12),

              /// RIGHT DETAILS
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _infoRow(Icons.person, item.bookingRoomOwnerName),
                    _infoRow(Icons.hotel, '${item.roomTypeName}'),
                    _infoRow(Icons.schedule,
                        '${timeFormat.format(checkIn)} - ${timeFormat.format(checkOut)}'),
                    const SizedBox(height: 8),

                    /// ROOM DROPDOWN
                    DropdownButtonFormField<AvailableRooms>(
                      value: selectedRooms[item.bookingRoomId],
                      hint: Text(
                        'Select Room',
                        style: const TextStyle(fontSize: 12), // smaller hint
                      ),
                      items: item.availableRooms
                              ?.map((room) => DropdownMenuItem(
                                    value: room,
                                    child: Text(
                                      room.name,
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                  ))
                              .toList() ??
                          [],
                      onChanged: (val) {
                        setState(() {
                          selectedRooms[item.bookingRoomId] = val;
                        });
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                      ),
                    ),

                    const SizedBox(height: 8),

                    /// BUTTONS
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: AppColors.onPrimary,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            textStyle: const TextStyle(fontSize: 12),
                          ),
                          onPressed: () => widget.onViewReservation(item),
                          label: const Text('View'),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.green,
                            foregroundColor: AppColors.onPrimary,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            textStyle: const TextStyle(fontSize: 12),
                          ),
                          onPressed: selectedRooms[item.bookingRoomId] != null
                              ? () => widget.onAssignRoom(
                                  item, selectedRooms[item.bookingRoomId])
                              : null,
                          child: const Text('Assign Room'),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.grey.shade600),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}
