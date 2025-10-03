// lib/features/reservations/widgets/assign_rooms_bottom_sheet.dart
import 'package:flutter/material.dart';
import 'package:inta_mobile_pms/core/theme/app_colors.dart';

class AssignRoomsBottomSheet extends StatefulWidget {
  final String guestName;
  final String reservationId;
  final String? initialRoomType;
  final String? initialRoom;

  const AssignRoomsBottomSheet({
    Key? key,
    required this.guestName,
    required this.reservationId,
    this.initialRoomType,
    this.initialRoom,
  }) : super(key: key);

  @override
  State<AssignRoomsBottomSheet> createState() => _AssignRoomsBottomSheetState();

  /// Static method to show the bottom sheet
  static Future<Map<String, String>?> show({
    required BuildContext context,
    required String guestName,
    required String reservationId,
    String? initialRoomType,
    String? initialRoom,
  }) {
    return showModalBottomSheet<Map<String, String>>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      enableDrag: true,
      isDismissible: true,
      builder: (context) => AssignRoomsBottomSheet(
        guestName: guestName,
        reservationId: reservationId,
        initialRoomType: initialRoomType,
        initialRoom: initialRoom,
      ),
    );
  }
}

class _AssignRoomsBottomSheetState extends State<AssignRoomsBottomSheet> {
  String? selectedRoomType;
  String? selectedRoom;
  bool isLoading = false;

  // Sample data - replace with your actual data source
  // Updated to include consistent room types matching GuestItem data
  final List<String> roomTypes = [
    'Double Room',
    'Single Room',
    'Suite',
    'Deluxe Room',
    'Family Room',
    'Bunk Bed',
  ];

  final Map<String, List<String>> availableRooms = {
    'Double Room': ['201', '202', '203', '204'],
    'Single Room': ['101', '102', '103'],
    'Suite': ['301', '302'],
    'Deluxe Room': ['401', '402', '403'],
    'Family Room': ['501', '502'],
    'Bunk Bed': ['601', '602'],
  };

  @override
  void initState() {
    super.initState();
    // Set initial values only if they exist in the data to avoid assertion errors
    if (widget.initialRoomType != null && roomTypes.contains(widget.initialRoomType)) {
      selectedRoomType = widget.initialRoomType;
    }
    if (selectedRoomType != null && widget.initialRoom != null &&
        availableRooms[selectedRoomType]?.contains(widget.initialRoom) == true) {
      selectedRoom = widget.initialRoom;
    }
  }

  List<String> get currentAvailableRooms {
    if (selectedRoomType == null) return [];
    return availableRooms[selectedRoomType!] ?? [];
  }

  void _handleSave() async {
    if (selectedRoomType == null || selectedRoom == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please select both room type and room'),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );
      return;
    }
    setState(() => isLoading = true);

    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 800));

    if (!mounted) return;

    // Return the selected values
    Navigator.pop(context, {
      'roomType': selectedRoomType!,
      'room': selectedRoom!,
    });
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final bottomPadding = mediaQuery.viewInsets.bottom;
    
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: Container(
        color: Colors.transparent,
        child: GestureDetector(
          onTap: () {}, // Prevent dismissal when tapping content
          child: DraggableScrollableSheet(
            initialChildSize: 0.65,
            minChildSize: 0.4,
            maxChildSize: 0.9,
            builder: (context, scrollController) {
              return Container(
                decoration: const BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(20),
                  ),
                ),
                child: Column(
                  children: [
                    // Drag Handle
                    Container(
                      margin: const EdgeInsets.only(top: 12),
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),

                    // Header
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Assign Rooms',
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: AppColors.black,
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: const Icon(Icons.close),
                            color: AppColors.darkgrey,
                            splashRadius: 20,
                          ),
                        ],
                      ),
                    ),

                    const Divider(height: 1),

                    // Content
                    Expanded(
                      child: ListView(
                        controller: scrollController,
                        padding: EdgeInsets.fromLTRB(
                          20,
                          16,
                          20,
                          bottomPadding + 16,
                        ),
                        children: [
                          // Guest Info Card
                          _buildInfoCard(),

                          const SizedBox(height: 24),

                          // Room Type Dropdown
                          _buildDropdownField(
                            label: 'Room Type',
                            value: selectedRoomType,
                            items: roomTypes,
                            onChanged: (value) {
                              setState(() {
                                selectedRoomType = value;
                                selectedRoom = null; // Reset room selection
                              });
                            },
                          ),

                          const SizedBox(height: 20),

                          // Room Dropdown
                          _buildDropdownField(
                            label: 'Room',
                            value: selectedRoom,
                            hint: selectedRoomType == null
                                ? 'Select room type first'
                                : 'Select',
                            items: currentAvailableRooms,
                            enabled: selectedRoomType != null,
                            onChanged: (value) {
                              setState(() {
                                selectedRoom = value;
                              });
                            },
                          ),

                          const SizedBox(height: 32),

                          // Action Buttons
                          Row(
                            children: [
                              Expanded(
                                child: OutlinedButton(
                                  onPressed: isLoading
                                      ? null
                                      : () => Navigator.pop(context),
                                  style: OutlinedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(vertical: 14),
                                    side: const BorderSide(color: AppColors.lightgrey),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  child: Text(
                                    'Cancel',
                                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.darkgrey,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: isLoading ? null : _handleSave,
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(vertical: 14),
                                    backgroundColor: AppColors.primary,
                                    foregroundColor: AppColors.onPrimary,
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  child: isLoading
                                      ? const SizedBox(
                                          height: 20,
                                          width: 20,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            valueColor: AlwaysStoppedAnimation<Color>(
                                              AppColors.onPrimary,
                                            ),
                                          ),
                                        )
                                      : Text(
                                          'Save',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyLarge
                                              ?.copyWith(
                                                fontWeight: FontWeight.w600,
                                                color: AppColors.onPrimary,
                                              ),
                                        ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          _buildInfoRow('Guest Name', widget.guestName),
          const SizedBox(height: 12),
          _buildInfoRow('Res #', widget.reservationId),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AppColors.lightgrey,
            fontWeight: FontWeight.w400,
          ),
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AppColors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String? value,
    String? hint,
    required List<String> items,
    required ValueChanged<String?> onChanged,
    bool enabled = true,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AppColors.darkgrey,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          decoration: BoxDecoration(
            color: enabled ? AppColors.surface : AppColors.background,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: enabled ? Colors.grey.shade300 : Colors.grey.shade200,
            ),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              hint: Text(
                hint ?? 'Select',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppColors.lightgrey,
                ),
              ),
              isExpanded: true,
              icon: Icon(
                Icons.keyboard_arrow_down,
                color: enabled ? AppColors.darkgrey : AppColors.lightgrey,
              ),
              items: items.map((item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Text(
                    item,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppColors.black,
                    ),
                  ),
                );
              }).toList(),
              onChanged: enabled ? onChanged : null,
            ),
          ),
        ),
      ],
    );
  }
}