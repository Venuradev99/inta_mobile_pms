import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:inta_mobile_pms/core/theme/app_colors.dart';
import 'package:inta_mobile_pms/features/reservations/models/guest_item.dart';
import 'package:inta_mobile_pms/features/reservations/viewmodels/assign_rooms_vm.dart';

class AssignRoomsBottomSheet extends StatefulWidget {
  final GuestItem guestItem;

  const AssignRoomsBottomSheet({Key? key, required this.guestItem})
    : super(key: key);

  @override
  State<AssignRoomsBottomSheet> createState() => _AssignRoomsBottomSheetState();

  /// Static method to show the bottom sheet
  static Future<Map<String, String>?> show({
    required BuildContext context,
    required GuestItem guestItem,
  }) {
    return showModalBottomSheet<Map<String, String>>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      enableDrag: true,
      isDismissible: true,
      builder: (context) => AssignRoomsBottomSheet(guestItem: guestItem),
    );
  }
}

class _AssignRoomsBottomSheetState extends State<AssignRoomsBottomSheet> {
  final _assignRoomsVm = Get.find<AssignRoomsVm>();
  String? selectedRoomType;
  String? selectedRoom;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (mounted) {
        await _assignRoomsVm.loadInitialData(widget.guestItem);
        selectedRoomType = widget.guestItem.roomType;
      }
    });
  }

  void _handleSave() async {
    try {
      if (selectedRoomType == null || selectedRoom == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Please select both room type and room'),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        );
        return;
      }
      setState(() => isLoading = true);

      Map<String, dynamic> saveData = {
        "BookingRoomId": widget.guestItem.bookingRoomId,
        "RoomId": selectedRoom,
        "arrivalDate": widget.guestItem.startDate,
        "departureDate": widget.guestItem.endDate,
      };
      await _assignRoomsVm.assignRoom(saveData);
      if (!mounted) return;
    } catch (e) {
      throw Exception('Error while saving: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final bottomPadding = mediaQuery.viewInsets.bottom;

    return GestureDetector(
      onTap: () => Navigator.of(context).pop(),
      child: Container(
        color: Colors.transparent,
        child: GestureDetector(
          onTap: () {}, 
          child: DraggableScrollableSheet(
            initialChildSize: 0.65,
            minChildSize: 0.4,
            maxChildSize: 0.9,
            builder: (context, scrollController) {
              return Container(
                decoration: const BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
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
                              style: Theme.of(context).textTheme.titleLarge
                                  ?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.black,
                                  ),
                            ),
                          ),
                          IconButton(
                            onPressed: () => Navigator.of(context).pop(),
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
                          // Obx(() {
                          //   return _buildDropdownField(
                          //     label: 'Room Type',
                          //     value: selectedRoomType,
                          //     items: _assignRoomsVm.roomTypes,
                          //     onChanged: (value) {
                          //       setState(() {
                          //         selectedRoomType = value;
                          //         selectedRoom = null;
                          //       });

                          //       _assignRoomsVm.availableRooms.clear();
                          //       _assignRoomsVm.loadAvailableRooms(value!);
                          //     },
                          //   );
                          // }),
                          const SizedBox(height: 20),

                          // Room Dropdown
                          Obx(() {
                            return _buildDropdownField(
                              label: 'Room',
                              value: selectedRoom,
                              hint: _assignRoomsVm.availableRooms.isEmpty
                                  ? 'No Available Rooms'
                                  : 'Select',
                              items: _assignRoomsVm.availableRooms,
                              enabled: selectedRoomType != null,
                              onChanged: (value) {
                                setState(() {
                                  selectedRoom = value;
                                });
                              },
                            );
                          }),

                          const SizedBox(height: 32),

                          // Action Buttons
                          Row(
                            children: [
                              Expanded(
                                child: OutlinedButton(
                                  onPressed: isLoading
                                      ? null
                                      : () => Navigator.of(context).pop(),
                                  style: OutlinedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 14,
                                    ),
                                    side: const BorderSide(
                                      color: AppColors.lightgrey,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  child: Text(
                                    'Cancel',
                                    style: Theme.of(context).textTheme.bodyLarge
                                        ?.copyWith(
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
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 14,
                                    ),
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
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
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
          _buildInfoRow('Guest Name', widget.guestItem.guestName!),
          const SizedBox(height: 12),
          _buildInfoRow('Res #', widget.guestItem.bookingRoomId!),
          const SizedBox(height: 12),
          _buildInfoRow('Room Type', widget.guestItem.roomType!),
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
    required List<Map<String, dynamic>> items,
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
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(color: AppColors.lightgrey),
              ),
              isExpanded: true,
              icon: Icon(
                Icons.keyboard_arrow_down,
                color: enabled ? AppColors.darkgrey : AppColors.lightgrey,
              ),
              items: items.map((item) {
                return DropdownMenuItem<String>(
                  value: item["id"].toString(),
                  child: Text(
                    item["name"],
                    style: Theme.of(
                      context,
                    ).textTheme.bodyLarge?.copyWith(color: AppColors.black),
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
