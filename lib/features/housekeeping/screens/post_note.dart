import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:inta_mobile_pms/features/housekeeping/models/dropdown_data.dart';
import 'package:inta_mobile_pms/features/housekeeping/models/post_note_payload.dart';
import 'package:inta_mobile_pms/features/housekeeping/viewmodels/work_order_list_vm.dart';
import 'package:shimmer/shimmer.dart';
import 'package:inta_mobile_pms/core/theme/app_colors.dart';
import 'package:inta_mobile_pms/features/housekeeping/models/work_order.dart';
import 'package:go_router/go_router.dart';

class PostNote extends StatefulWidget {
  final WorkOrder? workOrder;
  const PostNote({super.key, this.workOrder});

  @override
  State<PostNote> createState() => _PostNoteState();
}

class _PostNoteState extends State<PostNote> {
  final _workOrderListVm = Get.find<WorkOrderListVm>();
  final _formKey = GlobalKey<FormState>();

  final TextEditingController unitController = TextEditingController();
  final TextEditingController orderController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController noteController = TextEditingController();

  String? selectedUnit;
  int? selectedAssignTo;
  int? selectedStatus;

  late List<DropdownData> assignTo = [];
  late List<DropdownData> status = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (mounted) {
        await _workOrderListVm.loadPostNoteData(widget.workOrder!);
        setState(() {
          orderController.text = widget.workOrder!.orderNo;
          noteController.text = widget.workOrder!.postNote ?? '';
          descriptionController.text = widget.workOrder!.description;

          unitController.text = widget.workOrder!.unitRoom.isNotEmpty
              ? widget.workOrder!.unitRoom
              : widget.workOrder!.roomName;
          assignTo = _workOrderListVm.houseKeeperList.toList();
          status = _workOrderListVm.statusList.toList();

          int receivedAssignToId = widget.workOrder!.assingToId ?? 0;
          int receivedStatusId = widget.workOrder!.statusId ?? 0;

          if (assignTo.isNotEmpty && receivedAssignToId > 0) {
            if (assignTo.any((item) => item.id == receivedAssignToId)) {
              selectedAssignTo = receivedAssignToId;
            }
          }

          if (status.isNotEmpty && receivedStatusId > 0) {
            if (status.any((item) => item.id == receivedStatusId)) {
              selectedStatus = receivedStatusId;
            }
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Post Note',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: AppColors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: AppColors.surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: AppColors.black),
          onPressed: () => context.pop(),
        ),
      ),
      body: _workOrderListVm.isPostNoteDataLoading.value
          ? _buildShimmerForm()
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: _buildTextField(
                            enabled: false,
                            controller: orderController,
                            label: 'Order No',
                            requiredField: true,
                            hint: 'Order No',
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildTextField(
                            enabled: false,
                            controller: unitController,
                            label: 'Unit/Room',
                            requiredField: false,
                            hint: 'Unit/Room',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    Row(
                      children: [
                        Expanded(
                          child: _buildDropdownField(
                            label: 'Assign To',
                            requiredField: true,
                            value: selectedAssignTo,
                            items: assignTo,
                            onChanged: (val) =>
                                setState(() => selectedAssignTo = val),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildDropdownField(
                            label: 'Status',
                            requiredField: false,
                            value: selectedStatus,
                            items: status,
                            onChanged: (val) =>
                                setState(() => selectedStatus = val),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    _buildTextArea(
                      controller: descriptionController,
                      label: 'Description',
                      requiredField: true,
                      maxLength: 500,
                    ),
                    const SizedBox(height: 16),

                    _buildTextArea(
                      controller: noteController,
                      label: 'Note',
                      requiredField: true,
                      maxLength: 500,
                    ),

                    const SizedBox(height: 24),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: AppColors.onPrimary,
                          ),
                          onPressed: () async {
                            _onSave();
                          },
                          child: const Text('SAVE'),
                        ),
                        const SizedBox(width: 16),
                        OutlinedButton.icon(
                          onPressed: _onReset,
                          label: const Text('RESET'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildShimmerForm() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: Column(
          children: [
            // First row: Order No & Unit
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 56,
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Container(
                    height: 56,
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Second row: Assign To & Status
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 56,
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Container(
                    height: 56,
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Description textarea
            Container(
              height: 80,
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(height: 16),

            // Note textarea
            Container(
              height: 80,
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(height: 24),

            // Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(height: 40, width: 100, color: Colors.grey),
                const SizedBox(width: 16),
                Container(height: 40, width: 100, color: Colors.grey),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ================== TEXT FIELD ==================
  Widget _buildTextField({
    enabled,
    required TextEditingController controller,
    required String label,
    bool requiredField = false,
    String? hint,
  }) {
    return TextFormField(
      controller: controller,
      enabled: enabled,
      decoration: InputDecoration(
        labelText: requiredField ? '$label *' : label,
        hintText: hint,
        border: const OutlineInputBorder(),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      validator: requiredField
          ? (value) {
              if (value == null || value.isEmpty) {
                return '$label is required';
              }
              return null;
            }
          : null,
    );
  }

  // ================== DROPDOWN FIELD ==================
  Widget _buildDropdownField({
    required String label,
    bool requiredField = false,
    required int? value,
    required List<DropdownData> items,
    required ValueChanged<int?> onChanged,
  }) {
    return DropdownButtonFormField<int>(
      value: value,
      decoration: InputDecoration(
        labelText: requiredField ? '$label *' : label,
        border: const OutlineInputBorder(),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      ),
      items: items.map((item) {
        return DropdownMenuItem<int>(
          value: item.id,
          child: Text(item.description),
        );
      }).toList(),
      onChanged: onChanged,
      validator: requiredField
          ? (val) {
              if (val == null) {
                return '$label is required';
              }
              return null;
            }
          : null,
    );
  }

  // ================== TEXT AREA ==================
  Widget _buildTextArea({
    required TextEditingController controller,
    required String label,
    bool requiredField = false,
    int maxLength = 500,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: controller,
          maxLines: 3,
          maxLength: maxLength,
          decoration: InputDecoration(
            labelText: requiredField ? '$label *' : label,
            border: const OutlineInputBorder(),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 8,
            ),
          ),
          validator: requiredField
              ? (value) {
                  if (value == null || value.isEmpty) {
                    return '$label is required';
                  }
                  return null;
                }
              : null,
        ),
        Align(
          alignment: Alignment.centerRight,
          child: Text(
            '${controller.text.length} / $maxLength',
            style: const TextStyle(color: Colors.grey, fontSize: 12),
          ),
        ),
      ],
    );
  }

  void _onSave() async {
    if (_formKey.currentState!.validate()) {
      final payload = PostNotePayload(
        workOrderId: widget.workOrder!.workOrderId!,
        unitId: widget.workOrder!.unitId!,
        roomId: widget.workOrder!.roomId!,
        isRoom: widget.workOrder!.isRoom!,
        assingTo: selectedAssignTo!,
        status: selectedStatus!,
        priority: widget.workOrder!.priorityId!,
        description: descriptionController.text,
        note: noteController.text,
      );

      await _workOrderListVm.updatePostNote(payload);
    }
  }

  void _onReset() {
    _formKey.currentState!.reset();
    orderController.clear();
    descriptionController.clear();
    noteController.clear();
    unitController.clear();
    setState(() {
      selectedUnit = null;
      selectedAssignTo = null;
      selectedStatus = null;
    });
  }
}
