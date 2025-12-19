import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:go_router/go_router.dart';
import 'package:inta_mobile_pms/core/theme/app_colors.dart';
import 'package:inta_mobile_pms/features/housekeeping/models/work_order.dart';
import 'package:inta_mobile_pms/features/housekeeping/viewmodels/work_order_list_vm.dart';
import 'package:inta_mobile_pms/services/local_storage_manager.dart';
import 'package:intl/intl.dart';

class AddWorkOrderDialog extends StatefulWidget {
  const AddWorkOrderDialog({super.key});

  @override
  State<AddWorkOrderDialog> createState() => _AddWorkOrderDialogState();
}

class _AddWorkOrderDialogState extends State<AddWorkOrderDialog> {
  final _workOrderListVm = Get.find<WorkOrderListVm>();

  final _formKey = GlobalKey<FormState>();
  final _orderNoController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _fromDateController = TextEditingController();
  final _toDateController = TextEditingController();
  final _dueDateController = TextEditingController();
  final _dueTimeController = TextEditingController();

  String _selectedCategory = '';
  String _selectedPriority = '';
  String _selectedStatus = '';
  String _selectedAssignTo = '';
  String _selectUnitRoom = '';
  String _selectedReason = '';
  DateTime _fromDate = DateTime.now();
  DateTime _toDate = DateTime.now();
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _getToday();
  }

  Future<String> _getToday() async {
    final today = await LocalStorageManager.getSystemDate();
    setState(() {
      _selectedDate = DateTime.parse(today);
      _fromDate = DateTime.parse(today);
    });
    return today;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: const EdgeInsets.all(20),
        constraints: const BoxConstraints(maxWidth: 500, maxHeight: 600),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Add New Work Order',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => context.pop(),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Form
            Expanded(
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Obx(() {
                    final categoryList = _workOrderListVm.categoryList;
                    final priorityList = _workOrderListVm.priorityList;
                    final statusList = _workOrderListVm.statusList;
                    final houseKeeperList = _workOrderListVm.houseKeeperList;
                    final unitRoomList = _workOrderListVm.unitRoomList;
                    final reasonList = _workOrderListVm.reasonList;

                    return Column(
                      children: [
                        const SizedBox(height: 16),
                        DropdownButtonFormField<String>(
                          value:
                              categoryList.any(
                                (c) => c.id.toString() == _selectedCategory,
                              )
                              ? _selectedCategory
                              : null,
                          hint: const Text('Select category'),
                          decoration: const InputDecoration(
                            labelText: 'Category',
                            border: OutlineInputBorder(),
                          ),
                          items: categoryList.map((category) {
                            return DropdownMenuItem(
                              value: category.id.toString(),
                              child: Text(category.description),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedCategory = value!;
                            });
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please select a category';
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 16),
                        //Reason Dropdown
                        DropdownButtonFormField<String>(
                          initialValue: _selectedReason.isNotEmpty
                              ? _selectedReason
                              : null,
                          hint: const Text('Select Reason'),
                          decoration: const InputDecoration(
                            labelText: 'Reason',
                            border: OutlineInputBorder(),
                          ),
                          items: reasonList.map((reason) {
                            return DropdownMenuItem(
                              value: reason.id.toString(),
                              child: Text(reason.description),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedReason = value!;
                            });
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please select a reason';
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 16),

                        // Unit/Room Dropdown
                        DropdownButtonFormField<String>(
                          initialValue: _selectUnitRoom.isNotEmpty
                              ? _selectUnitRoom
                              : null,
                          hint: const Text('Select Unit/Room'),
                          decoration: const InputDecoration(
                            labelText: 'Unit/Room',
                            border: OutlineInputBorder(),
                          ),
                          items: unitRoomList.map((unitRoom) {
                            return DropdownMenuItem(
                              value: unitRoom.id.toString(),
                              child: Text(unitRoom.description),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectUnitRoom = value!;
                            });
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please select a unit/room';
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 16),

                        Row(
                          children: [
                            Expanded(
                              child: _buildDateField(
                                'From Date',
                                _fromDate,
                                true,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _buildDateField('To Date', _toDate, false),
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),

                        // Priority Dropdown
                        DropdownButtonFormField<String>(
                          initialValue: _selectedPriority.isNotEmpty
                              ? _selectedPriority
                              : null,
                          hint: const Text('Select Priority'),
                          decoration: const InputDecoration(
                            labelText: 'Priority',
                            border: OutlineInputBorder(),
                          ),
                          items: priorityList.map((priority) {
                            return DropdownMenuItem(
                              value: priority.id.toString(),
                              child: Text(priority.description),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedPriority = value!;
                            });
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please select a priority';
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 16),

                        // Assign To Dropdown
                        DropdownButtonFormField<String>(
                          initialValue: _selectedAssignTo.isNotEmpty
                              ? _selectedAssignTo
                              : null,
                          hint: const Text('Select Assign To'),
                          decoration: const InputDecoration(
                            labelText: 'Assign To',
                            border: OutlineInputBorder(),
                          ),
                          items: houseKeeperList.map((houseKeeper) {
                            return DropdownMenuItem(
                              value: houseKeeper.id.toString(),
                              child: Text(houseKeeper.description),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedAssignTo = value!;
                            });
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please select a assignee';
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 16),

                        // Status Dropdown
                        DropdownButtonFormField<String>(
                          initialValue: _selectedStatus.isNotEmpty
                              ? _selectedStatus
                              : null,
                          hint: const Text('Select status'),
                          decoration: const InputDecoration(
                            labelText: 'Status',
                            border: OutlineInputBorder(),
                          ),
                          items: statusList.map((status) {
                            return DropdownMenuItem(
                              value: status.id.toString(),
                              child: Text(status.description),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedStatus = value!;
                            });
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please select a status';
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 16),

                        // Due Date and Time
                        Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () async {
                                  final date = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.parse(
                                      await _getToday(),
                                    ),
                                    firstDate: DateTime.parse(
                                      await _getToday(),
                                    ),
                                    lastDate: DateTime.now().add(
                                      const Duration(days: 365),
                                    ),
                                  );
                                  if (date != null) {
                                    setState(() {
                                      _selectedDate = date;
                                      _dueDateController.text = DateFormat(
                                        'MMM dd, yyyy',
                                      ).format(_selectedDate);
                                    });
                                  }
                                },
                                child: AbsorbPointer(
                                  child: TextFormField(
                                    controller: _dueDateController,
                                    decoration: const InputDecoration(
                                      labelText: 'Due Date',
                                      border: OutlineInputBorder(),
                                      suffixIcon: Icon(Icons.calendar_today),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please select a due date';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(width: 16),

                            Expanded(
                              child: GestureDetector(
                                onTap: () async {
                                  final time = await showTimePicker(
                                    context: context,
                                    initialTime: TimeOfDay.now(),
                                  );
                                  if (time != null) {
                                    setState(() {
                                      _dueTimeController.text =
                                          DateFormat('h:mm a').format(
                                            DateTime(
                                              0,
                                              0,
                                              0,
                                              time.hour,
                                              time.minute,
                                            ),
                                          );
                                    });
                                  }
                                },
                                child: AbsorbPointer(
                                  child: TextFormField(
                                    controller: _dueTimeController,
                                    decoration: const InputDecoration(
                                      labelText: 'Due Time',
                                      border: OutlineInputBorder(),
                                      suffixIcon: Icon(Icons.access_time),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please select a due time';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),

                        // Description
                        TextFormField(
                          controller: _descriptionController,
                          maxLines: 3,
                          decoration: const InputDecoration(
                            labelText: 'Description',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter description';
                            }
                            return null;
                          },
                        ),
                      ],
                    );
                  }),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => context.pop(),
                  child: const Text('Cancel'),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: _saveWorkOrder,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.surface,
                  ),
                  child: const Text('Save'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context, bool isStart) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.parse(await _getToday()),
      firstDate: DateTime.parse(await _getToday()),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          _fromDate = picked;
          if (_toDate.isBefore(_fromDate)) {
            _toDate = _fromDate;
          }
          _fromDateController.text = DateFormat(
            'MMM dd, yyyy',
          ).format(_fromDate);
        } else {
          _toDate = picked;
          _toDateController.text = DateFormat('MMM dd, yyyy').format(_toDate);
        }
      });
    }
  }

  Widget _buildDateField(String label, DateTime? date, bool isStart) {
    final controller = isStart ? _fromDateController : _toDateController;
    return GestureDetector(
      onTap: () => _selectDate(context, isStart),
      child: AbsorbPointer(
        child: TextFormField(
          controller: controller,
          decoration: InputDecoration(
            labelText: label,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            suffixIcon: const Icon(Icons.calendar_today),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please select $label';
            }
            return null;
          },
        ),
      ),
    );
  }

  DateTime _getStandardDateTime(String date, String time) {
    try {
      String dateTimeString = "$date $time";
      DateTime parsedDate = DateFormat(
        "MMM dd, yyyy h:mm a",
      ).parse(dateTimeString);
      return parsedDate;
    } catch (e) {
      throw Exception('Error getting standard date and time: $e');
    }
  }

  DateTime _getStandardDate(String date) {
    try {
      return DateFormat('MMM dd, yyyy').parse(date);
    } catch (e) {
      throw Exception('Error converting standard date: $e');
    }
  }

  void _saveWorkOrder() async {
    if (_formKey.currentState!.validate()) {
      DateTime dueDate = _getStandardDateTime(
        _dueDateController.text,
        _dueTimeController.text,
      );
      final newWorkOrder = WorkOrder(
        orderNo: _orderNoController.text,
        category: _selectedCategory,
        unitRoom: _selectUnitRoom,
        blockFrom: _getStandardDate(_fromDateController.text),
        blockTo: _getStandardDate(_toDateController.text),
        priority: _selectedPriority,
        assignedTo: _selectedAssignTo,
        status: _selectedStatus,
        dueDate: dueDate,
        description: _descriptionController.text,
        reason: _selectedReason,
      );
      await _workOrderListVm.saveWorkOrder(newWorkOrder);
    }
  }

  @override
  void dispose() {
    _orderNoController.dispose();
    _dueDateController.dispose();
    _toDateController.dispose();
    _fromDateController.dispose();
    _descriptionController.dispose();
    _dueTimeController.dispose();
    super.dispose();
  }
}
