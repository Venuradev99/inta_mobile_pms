import 'package:flutter/material.dart';
import 'package:inta_mobile_pms/core/theme/app_colors.dart';
import 'package:inta_mobile_pms/features/dashboard/models/filter_dropdown_data.dart';
import 'package:inta_mobile_pms/features/reservations/models/reservation_filter_data_model.dart';
import 'package:intl/intl.dart';

class ReservationFilterBottomSheet extends StatefulWidget {
  final void Function(ReservationFilterDataModel selectedFilters) onApply;
  final Function() onPressReset;
  final ReservationFilterDataModel? editFilterData;
  final Future<List<FilterDropdownData>> Function(int roomTypeId)
  filterByRoomType;
  final List<FilterDropdownData> businessCategories; // initial categories
  final List<FilterDropdownData> roomTypes;
  final List<FilterDropdownData> rooms;
  final List<FilterDropdownData> status;
  final List<FilterDropdownData> resTypes;
  final DateTime initialFromDate;

  final Future<List<FilterDropdownData>> Function(int categoryId)
  getBusinessSourcesByCategory; // API callback
  final int activeIndex;

  const ReservationFilterBottomSheet({
    super.key,
    required this.onApply,
    required this.onPressReset,
    required this.editFilterData,
    required this.initialFromDate,
    required this.filterByRoomType,
    required this.businessCategories,
    required this.roomTypes,
    required this.rooms,
    required this.status,
    required this.resTypes,
    required this.getBusinessSourcesByCategory,
    this.activeIndex = 0,
  });

  @override
  State<ReservationFilterBottomSheet> createState() =>
      _ReservationFilterBottomSheetState();
}

class _ReservationFilterBottomSheetState
    extends State<ReservationFilterBottomSheet> {
  final _formKey = GlobalKey<FormState>();

  // Form fields
  bool arrivalCheck = false;
  bool createdCheck = false;

  DateTime? fromDate;
  DateTime? toDate;

  FilterDropdownData? selectedBusinessCategory;
  FilterDropdownData? selectedBusinessSource;
  List<FilterDropdownData> businessSourcesByCategory = [];

  FilterDropdownData? selectedRoomType;
  FilterDropdownData? selectedRoom;
  FilterDropdownData? selectedStatus;
  FilterDropdownData? selectedResType;
  List<FilterDropdownData> filteredRooms = [];

  final TextEditingController customerController = TextEditingController();

  @override
  void initState() {
    super.initState();

    final today = DateTime.now();
    fromDate = widget.initialFromDate;
    toDate = today;
    arrivalCheck = true;

    if (widget.editFilterData != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setData();
      });
    }
  }

  Future<void> setData() async {
    final data = widget.editFilterData;

    if(data?.arrivalCheck != null){
      arrivalCheck = data?.arrivalCheck ?? true;
      createdCheck = !arrivalCheck;
    }

    if (data?.fromDate != null) {
      fromDate = DateTime.tryParse(data!.fromDate!) ?? widget.initialFromDate;
    }

    if (data?.toDate != null) {
      toDate = DateTime.tryParse(data!.toDate!) ?? DateTime.now();
    }
    if (data?.customerName != null) {
      customerController.text = data?.customerName ?? '';
    }

    if (data?.businessCategory != null) {
      selectedBusinessCategory = widget.businessCategories.firstWhere(
        (x) => x.id == data?.businessCategory,
      );
    }

    if (selectedBusinessCategory != null) {
      final sources = await widget.getBusinessSourcesByCategory(
        selectedBusinessCategory!.id,
      );

      if (mounted) {
        setState(() {
          businessSourcesByCategory = sources;
          if (data?.businessSource != null) {
            selectedBusinessSource = sources.firstWhere(
              (x) => x.id == data?.businessSource,
            );
          }
        });
      }
    }
    if (data?.roomType != null) {
      selectedRoomType = widget.roomTypes.firstWhere(
        (x) => x.id == data?.roomType,
      );
      filteredRooms = [];
    }

    if (selectedRoomType != null) {
      final rooms = await widget.filterByRoomType(selectedRoomType!.id);

      if (mounted) {
        setState(() {
          filteredRooms = rooms;
          if (data?.room != null) {
            selectedRoom = rooms.firstWhere((x) => x.id == data?.room);
          }
        });
      }
    }

    if (data?.status != null) {
      selectedStatus = widget.status.firstWhere((x) => x.id == data?.status);
    }
    if (data?.resType != null) {
      selectedResType = widget.resTypes.firstWhere(
        (x) => x.id == data?.resType,
      );
    }

    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Checkboxes for activeIndex 0
                if (widget.activeIndex == 0)
                  Row(
                    children: [
                      Expanded(
                        child: CheckboxListTile(
                          value: arrivalCheck,
                          title: const Text('Arrival'),
                          onChanged: (val) {
                            setState(() {
                              arrivalCheck = val ?? false;
                              createdCheck = !arrivalCheck;
                            });
                          },
                        ),
                      ),
                      Expanded(
                        child: CheckboxListTile(
                          value: createdCheck,
                          title: const Text('Created'),
                          onChanged: (val) {
                            setState(() {
                              createdCheck = val ?? false;
                              arrivalCheck = !createdCheck;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                const SizedBox(height: 8),

                // From / To Date
                Row(
                  children: [
                    Expanded(
                      child: buildDatePicker(
                        label: widget.activeIndex == 0
                            ? "From Date"
                            : widget.activeIndex == 1
                            ? "Departure From"
                            : "Arrival From",
                        selectedDate: fromDate,
                        onDateSelected: (val) => setState(() => fromDate = val),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: buildDatePicker(
                        label: widget.activeIndex == 0
                            ? "To Date"
                            : widget.activeIndex == 1
                            ? "Departure To"
                            : "Arrival To",
                        selectedDate: toDate,
                        onDateSelected: (val) => setState(() => toDate = val),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),
                TextFormField(
                  controller: customerController,
                  decoration: const InputDecoration(
                    labelText: "Guest Name / Reservation Number",
                  ),
                ),
                const SizedBox(height: 12),

                // Business Category
                buildDropdown(
                  label: "Business Category",
                  options: widget.businessCategories,
                  value: selectedBusinessCategory,
                  onChanged: (val) async {
                    setState(() {
                      selectedBusinessCategory = val;
                      selectedBusinessSource = null;
                      businessSourcesByCategory = [];
                    });

                    if (val != null) {
                      final sources = await widget.getBusinessSourcesByCategory(
                        val.id,
                      );
                      setState(() {
                        businessSourcesByCategory = sources;
                      });
                    }
                  },
                ),
                const SizedBox(height: 12),

                // Business Source (depends on selected category)
                buildDropdown(
                  label: "Business Source",
                  options: businessSourcesByCategory,
                  value: selectedBusinessSource,
                  onChanged: (val) =>
                      setState(() => selectedBusinessSource = val),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: buildDropdown(
                        label: "Room Type",
                        options: widget.roomTypes,
                        value: selectedRoomType,
                        onChanged: (val) async {
                          setState(() {
                            selectedRoomType = val;
                            selectedRoom = null;
                            filteredRooms = [];
                          });

                          if (val != null) {
                            final rooms = await widget.filterByRoomType(val.id);
                            setState(() {
                              filteredRooms = rooms;
                            });
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: buildDropdown(
                        label: "Room",
                        options: filteredRooms,
                        value: selectedRoom,
                        onChanged: (val) => setState(() => selectedRoom = val),
                      ),
                    ),
                  ],
                ),

                if (widget.activeIndex != 2 && widget.activeIndex != 1)
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: buildDropdown(
                      label: "Status",
                      options: widget.status,
                      value: selectedStatus,
                      onChanged: (val) => setState(() => selectedStatus = val),
                    ),
                  ),
                if (widget.activeIndex != 1)
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: buildDropdown(
                      label: "Reservation Type",
                      options: widget.resTypes,
                      value: selectedResType,
                      onChanged: (val) => setState(() => selectedResType = val),
                    ),
                  ),

                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () async {
                        await widget.onPressReset();
                        Navigator.of(context).pop();
                      },
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: AppColors.primary),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: Text(
                        'Reset',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      onPressed: () {
                        widget.onApply(
                          ReservationFilterDataModel(
                            arrivalCheck: arrivalCheck,
                            createdCheck: createdCheck,
                            fromDate: fromDate != null
                                ? DateFormat('yyyy-MM-dd').format(fromDate!)
                                : '',
                            toDate: toDate != null
                                ? DateFormat('yyyy-MM-dd').format(toDate!)
                                : '',
                            customerName: customerController.text,
                            businessCategory: selectedBusinessCategory?.id,
                            businessSource: selectedBusinessSource?.id,
                            roomType: selectedRoomType?.id,
                            room: selectedRoom?.id,
                            status: selectedStatus?.id,
                            resType: selectedResType?.id,
                          ),
                        );
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: const Text(
                        'Search',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper: Dropdown
  Widget buildDropdown({
    required String label,
    required List<FilterDropdownData> options,
    FilterDropdownData? value,
    required void Function(FilterDropdownData?) onChanged,
  }) {
    return DropdownButtonFormField<FilterDropdownData>(
      value: value,
      isExpanded: true,
      decoration: InputDecoration(labelText: label),
      items: options
          .map((e) => DropdownMenuItem(value: e, child: Text(e.name)))
          .toList(),
      onChanged: onChanged,
      hint: Text("Select $label"),
    );
  }

  // Helper: Date picker
  Widget buildDatePicker({
    required String label,
    required DateTime? selectedDate,
    required void Function(DateTime) onDateSelected,
  }) {
    return TextFormField(
      controller: TextEditingController(
        text: selectedDate != null
            ? "${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}"
            : '',
      ),
      readOnly: true,
      decoration: InputDecoration(labelText: label),
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: selectedDate ?? DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(2100),
        );
        if (picked != null) onDateSelected(picked);
      },
    );
  }
}
