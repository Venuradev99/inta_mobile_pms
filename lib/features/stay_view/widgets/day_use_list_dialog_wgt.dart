import 'package:flutter/material.dart';
import 'package:inta_mobile_pms/core/theme/app_colors.dart';
import 'package:inta_mobile_pms/features/stay_view/models/dayuse_response.dart';
import 'package:intl/intl.dart';

class DayUseListDialog extends StatefulWidget {
  final List<DayUseResponse> dayUseList;
  final Function(DayUseResponse item) onViewReservation;

  const DayUseListDialog({
    super.key,
    required this.dayUseList,
    required this.onViewReservation,
  });

  @override
  State<DayUseListDialog> createState() => _DayUseListDialogState();
}

class _DayUseListDialogState extends State<DayUseListDialog> {
  final DateFormat dayFormat = DateFormat('dd');
  final DateFormat monthFormat = DateFormat('MMM');
  final DateFormat timeFormat = DateFormat('hh:mm a');

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
    final date = widget.dayUseList[0].checkInDate;
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: Text(
              'Day Use List (${dayFormat.format(date)} ${monthFormat.format(date)})',
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
    if (widget.dayUseList.isEmpty) {
      return const Center(child: Text('No day use reservations'));
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: widget.dayUseList.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final item = widget.dayUseList[index];
        return _buildCard(item);
      },
    );
  }

  Widget _buildCard(DayUseResponse item) {
    final checkIn = item.checkInDate;
    final checkOut = item.checkOutDate;

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
                  color: _hexToColor(item.colorCode).withOpacity(0.5),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          monthFormat.format(checkIn),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: AppColors.darkgrey,
                          ),
                        ),
                        Text(
                          dayFormat.format(checkIn),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: AppColors.darkgrey,
                          ),
                        ),
                      ],
                    ),
                    const Column(
                      children: [
                        SizedBox(height: 4),
                        Divider(height: 1, thickness: 2),
                        SizedBox(height: 4),
                      ],
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          monthFormat.format(checkOut),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: AppColors.darkgrey,
                          ),
                        ),
                        Text(
                          dayFormat.format(checkOut),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
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
                    _infoRowHeader('Room Type'),
                    _infoRow(Icons.hotel, '${item.roomTypeName}'),
                    _infoRowHeader('Room'),
                    _infoRow(Icons.hotel, '${item.roomName}'),
                    _infoRow(
                      Icons.schedule,
                      '${timeFormat.format(checkIn)} - ${timeFormat.format(checkOut)}',
                    ),
                    const SizedBox(height: 8),
                    Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: AppColors.onPrimary,
                        ),
                        onPressed: () => widget.onViewReservation(item),
                        child: const Text('View Reservation'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoRow(IconData? icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.grey.shade600),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w800,
                color: Colors.grey.shade600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoRowHeader(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Expanded(child: Text(text, style: const TextStyle(fontSize: 12))),
        ],
      ),
    );
  }

  Color _hexToColor(String hex) {
    hex = hex.replaceAll('#', '');
    return Color(int.parse('FF$hex', radix: 16));
  }
}
