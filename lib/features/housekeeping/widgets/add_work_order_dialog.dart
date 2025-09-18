
import 'package:flutter/material.dart';
import 'package:inta_mobile_pms/core/theme/app_colors.dart';
import 'package:inta_mobile_pms/features/housekeeping/models/work_order.dart';

class AddWorkOrderDialog extends StatefulWidget {
  const AddWorkOrderDialog({super.key});

  @override
  State<AddWorkOrderDialog> createState() => _AddWorkOrderDialogState();
}

class _AddWorkOrderDialogState extends State<AddWorkOrderDialog> {
  final _formKey = GlobalKey<FormState>();
  final _orderNoController = TextEditingController();
  final _unitRoomController = TextEditingController();
  final _blockFromController = TextEditingController();
  final _blockToController = TextEditingController();
  final _assignedToController = TextEditingController();
  final _descriptionController = TextEditingController();
  
  String _selectedCategory = 'Electrical';
  String _selectedPriority = 'Medium';
  String _selectedStatus = 'Pending';
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 7));

  final List<String> _categories = ['Electrical', 'Plumbing', 'Maintenance', 'HVAC', 'Security', 'Cleaning'];
  final List<String> _priorities = ['Low', 'Medium', 'High'];
  final List<String> _statuses = ['Pending', 'In Progress', 'Completed'];

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
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            
            const SizedBox(height: 20),
            
            // Form
            Expanded(
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // Order No
                      TextFormField(
                        controller: _orderNoController,
                        decoration: const InputDecoration(
                          labelText: 'Order No',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter order number';
                          }
                          return null;
                        },
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Category Dropdown
                      DropdownButtonFormField<String>(
                        value: _selectedCategory,
                        decoration: const InputDecoration(
                          labelText: 'Category',
                          border: OutlineInputBorder(),
                        ),
                        items: _categories.map((category) {
                          return DropdownMenuItem(
                            value: category,
                            child: Text(category),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedCategory = value!;
                          });
                        },
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Unit/Room
                      TextFormField(
                        controller: _unitRoomController,
                        decoration: const InputDecoration(
                          labelText: 'Unit/Room',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter unit/room';
                          }
                          return null;
                        },
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Block From and To
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _blockFromController,
                              decoration: const InputDecoration(
                                labelText: 'Block From',
                                border: OutlineInputBorder(),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Required';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: TextFormField(
                              controller: _blockToController,
                              decoration: const InputDecoration(
                                labelText: 'Block To',
                                border: OutlineInputBorder(),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Required';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Priority Dropdown
                      DropdownButtonFormField<String>(
                        value: _selectedPriority,
                        decoration: const InputDecoration(
                          labelText: 'Priority',
                          border: OutlineInputBorder(),
                        ),
                        items: _priorities.map((priority) {
                          return DropdownMenuItem(
                            value: priority,
                            child: Text(priority),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedPriority = value!;
                          });
                        },
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Assigned To
                      TextFormField(
                        controller: _assignedToController,
                        decoration: const InputDecoration(
                          labelText: 'Assigned To',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter assigned person';
                          }
                          return null;
                        },
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Status Dropdown
                      DropdownButtonFormField<String>(
                        value: _selectedStatus,
                        decoration: const InputDecoration(
                          labelText: 'Status',
                          border: OutlineInputBorder(),
                        ),
                        items: _statuses.map((status) {
                          return DropdownMenuItem(
                            value: status,
                            child: Text(status),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedStatus = value!;
                          });
                        },
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Due Date
                      ListTile(
                        title: const Text('Due Date'),
                        subtitle: Text(
                          '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                        ),
                        trailing: const Icon(Icons.calendar_today),
                        onTap: () async {
                          final date = await showDatePicker(
                            context: context,
                            initialDate: _selectedDate,
                            firstDate: DateTime.now(),
                            lastDate: DateTime.now().add(const Duration(days: 365)),
                          );
                          if (date != null) {
                            setState(() {
                              _selectedDate = date;
                            });
                          }
                        },
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
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel'),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: _saveWorkOrder,
                  style: ElevatedButton.styleFrom(
                    backgroundColor:  AppColors.primary,
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

  void _saveWorkOrder() {
    if (_formKey.currentState!.validate()) {
      final newWorkOrder = WorkOrder(
        orderNo: _orderNoController.text,
        category: _selectedCategory,
        unitRoom: _unitRoomController.text,
        blockFrom: _blockFromController.text,
        blockTo: _blockToController.text,
        priority: _selectedPriority,
        assignedTo: _assignedToController.text,
        status: _selectedStatus,
        dueDate: _selectedDate,
        description: _descriptionController.text,
      );
      
      Navigator.of(context).pop(newWorkOrder);
    }
  }

  @override
  void dispose() {
    _orderNoController.dispose();
    _unitRoomController.dispose();
    _blockFromController.dispose();
    _blockToController.dispose();
    _assignedToController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}