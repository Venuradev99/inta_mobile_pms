import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:inta_mobile_pms/core/theme/app_colors.dart';

class FilterBottomSheet extends StatefulWidget {
  final String type; // 'arrival', 'departure', 'reservation'
  final Function(Map<String, dynamic>) onApply; // Callback to apply filters
  final ScrollController scrollController;  // Required for DraggableScrollableSheet integration

  const FilterBottomSheet({
    super.key,
    required this.type,
    required this.onApply,
    required this.scrollController,
  });

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  // Common controllers and states
  DateTime? startDate;
  DateTime? endDate;
  String? selectedRoomType;
  String? selectedReservationType;
  bool guestCheckedInToday = false; // For arrival
  bool guestCheckedOutToday = false; // For departure

  // Reservation specific
  String dateFilterType = 'reserved'; // 'reserved' or 'arrival'
  String? selectedStatus;
  String? selectedBusinessSource;
  bool showUnassignedRooms = false;
  bool showFailedBookings = false;
  final TextEditingController guestNameController = TextEditingController();
  final TextEditingController reservationNumberController = TextEditingController();
  final TextEditingController cancellationNumberController = TextEditingController();
  final TextEditingController voucherNumberController = TextEditingController();

  // Mock options
  final List<String> roomTypes = ['All', 'Single', 'Double', 'Suite', 'Bunk Bed', 'Beach House', 'Garden Villa'];
  final List<String> reservationTypes = ['All', 'Standard', 'Day Use', 'Group', 'Corporate'];
  final List<String> statuses = ['All', 'Confirmed', 'Pending', 'Checked In', 'Checked Out', 'Cancelled', 'Completed'];
  final List<String> businessSources = ['All', 'Direct', 'OTA', 'Agent', 'Corporate', 'Walk-in'];

  @override
  void dispose() {
    guestNameController.dispose();
    reservationNumberController.dispose();
    cancellationNumberController.dispose();
    voucherNumberController.dispose();
    super.dispose();
  }

  void _resetFilters() {
    setState(() {
      startDate = null;
      endDate = null;
      selectedRoomType = null;
      selectedReservationType = null;
      guestCheckedInToday = false;
      guestCheckedOutToday = false;
      dateFilterType = 'reserved';
      selectedStatus = null;
      selectedBusinessSource = null;
      showUnassignedRooms = false;
      showFailedBookings = false;
      guestNameController.clear();
      reservationNumberController.clear();
      cancellationNumberController.clear();
      voucherNumberController.clear();
    });
  }

  void _applyFilters() {
    final filters = <String, dynamic>{
      'startDate': startDate,
      'endDate': endDate,
      'roomType': selectedRoomType,
      'reservationType': selectedReservationType,
    };

    if (widget.type == 'arrival') {
      filters['guestCheckedInToday'] = guestCheckedInToday;
    } else if (widget.type == 'departure') {
      filters['guestCheckedOutToday'] = guestCheckedOutToday;
    } else if (widget.type == 'reservation') {
      filters['dateFilterType'] = dateFilterType;
      filters['status'] = selectedStatus;
      filters['businessSource'] = selectedBusinessSource;
      filters['showUnassignedRooms'] = showUnassignedRooms;
      filters['showFailedBookings'] = showFailedBookings;
      filters['guestName'] = guestNameController.text;
      filters['reservationNumber'] = reservationNumberController.text;
      filters['cancellationNumber'] = cancellationNumberController.text;
      filters['voucherNumber'] = voucherNumberController.text;
    }

    widget.onApply(filters);
    Navigator.pop(context);
  }

  Future<void> _selectDate(BuildContext context, bool isStart) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          startDate = picked;
          if (endDate != null && endDate!.isBefore(startDate!)) {
            endDate = null;
          }
        } else {
          endDate = picked;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        // Add subtle shadow for better visual separation
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Scrollable content (drag handle + filters)
          ListView(
            controller: widget.scrollController,
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 80),  // Bottom padding for fixed buttons
            children: [
              // Drag handle (centered at top)
              const SizedBox(height: 8),
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Filter fields
              ..._buildFilterFields(),
            ],
          ),
          // Fixed bottom buttons
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              // Add gradient overlay for better button visibility
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.surface.withOpacity(0.0),
                    AppColors.surface.withOpacity(0.8),
                    AppColors.surface,
                  ],
                  stops: const [0.0, 0.3, 1.0],
                ),
              ),
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _resetFilters,
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: AppColors.primary),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: Text(
                        'Reset',
                        style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _applyFilters,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: const Text(
                        'Search',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildFilterFields() {
    List<Widget> fields = [
      Text(
        '${widget.type.capitalize()} Filters',
        style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
      ),
      const SizedBox(height: 16),
      // Date range
      Row(
        children: [
          Expanded(
            child: _buildDateField('Start Date', startDate, true),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _buildDateField('End Date', endDate, false),
          ),
        ],
      ),
      const SizedBox(height: 16),
      // Room type dropdown
      _buildDropdown('Room Type', roomTypes, selectedRoomType, (value) => selectedRoomType = value),
      if (widget.type != 'departure') ...[
        const SizedBox(height: 16),
        // Reservation type dropdown
        _buildDropdown('Reservation Type', reservationTypes, selectedReservationType, (value) => selectedReservationType = value),
      ],
    ];

    if (widget.type == 'arrival') {
      fields.addAll([
        const SizedBox(height: 16),
        _buildToggle('Guest Checked In Today', guestCheckedInToday, (value) => guestCheckedInToday = value!),
      ]);
    } else if (widget.type == 'departure') {
      fields.addAll([
        const SizedBox(height: 16),
        _buildToggle('Guest Checked Out Today', guestCheckedOutToday, (value) => guestCheckedOutToday = value!),
      ]);
    } else if (widget.type == 'reservation') {
      fields.addAll([
        const SizedBox(height: 16),
        Text(
          'Date Filter Type',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
        ),
        RadioListTile<String>(
          title: const Text('Reserved Date'),
          value: 'reserved',
          groupValue: dateFilterType,
          onChanged: (value) => setState(() => dateFilterType = value!),
          contentPadding: EdgeInsets.zero,
        ),
        RadioListTile<String>(
          title: const Text('Arrival Date'),
          value: 'arrival',
          groupValue: dateFilterType,
          onChanged: (value) => setState(() => dateFilterType = value!),
          contentPadding: EdgeInsets.zero,
        ),
        const SizedBox(height: 16),
        _buildDropdown('Status', statuses, selectedStatus, (value) => selectedStatus = value),
        const SizedBox(height: 16),
        _buildDropdown('Business Source', businessSources, selectedBusinessSource, (value) => selectedBusinessSource = value),
        const SizedBox(height: 16),
        _buildToggle('Show Unassigned Rooms', showUnassignedRooms, (value) => showUnassignedRooms = value!),
        const SizedBox(height: 8),
        _buildToggle('Show Failed/Incomplete Bookings', showFailedBookings, (value) => showFailedBookings = value!),
        const SizedBox(height: 16),
        _buildTextField('Guest Name', guestNameController),
        const SizedBox(height: 16),
        _buildTextField('Reservation Number', reservationNumberController),
        const SizedBox(height: 16),
        _buildTextField('Cancellation Number', cancellationNumberController),
        const SizedBox(height: 16),
        _buildTextField('Voucher Number', voucherNumberController),
      ]);
    }

    return fields;
  }

  Widget _buildDateField(String label, DateTime? date, bool isStart) {
    return GestureDetector(
      onTap: () => _selectDate(context, isStart),
      child: AbsorbPointer(
        child: TextField(
          decoration: InputDecoration(
            labelText: label,
            hintText: date != null ? DateFormat('MMM dd, yyyy').format(date) : 'Select date',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            suffixIcon: const Icon(Icons.calendar_today),
          ),
        ),
      ),
    );
  }

  Widget _buildDropdown(String label, List<String> items, String? value, Function(String?) onChanged) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
      value: value ?? items.first,
      items: items.map((String item) {
        return DropdownMenuItem<String>(
          value: item,
          child: Text(item),
        );
      }).toList(),
      onChanged: (newValue) => setState(() => onChanged(newValue)),
    );
  }

  Widget _buildToggle(String label, bool value, Function(bool?) onChanged) {
    return SwitchListTile(
      title: Text(label),
      value: value,
      onChanged: (newValue) => setState(() => onChanged(newValue)),
      contentPadding: EdgeInsets.zero,
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}