import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:inta_mobile_pms/core/theme/app_colors.dart';
import 'package:inta_mobile_pms/router/app_routes.dart';

// Work Order Model
class WorkOrder {
  final String orderNo;
  final String category;
  final String unitRoom;
  final String blockFrom;
  final String blockTo;
  final String priority;
  final String assignedTo;
  final String status;
  final DateTime dueDate;
  final String description;

  WorkOrder({
    required this.orderNo,
    required this.category,
    required this.unitRoom,
    required this.blockFrom,
    required this.blockTo,
    required this.priority,
    required this.assignedTo,
    required this.status,
    required this.dueDate,
    required this.description,
  });
}

class WorkOrderList extends StatefulWidget {
  const WorkOrderList({super.key});

  @override
  State<WorkOrderList> createState() => _WorkOrderListState();
}

class _WorkOrderListState extends State<WorkOrderList> {
  List<WorkOrder> workOrders = [
    WorkOrder(
      orderNo: 'WO-2024-001',
      category: 'Electrical',
      unitRoom: 'Room 101',
      blockFrom: 'A',
      blockTo: 'B',
      priority: 'High',
      assignedTo: 'John Smith',
      status: 'In Progress',
      dueDate: DateTime.now().add(const Duration(days: 2)),
      description: 'Fix lighting issues in corridor',
    ),
    WorkOrder(
      orderNo: 'WO-2024-002',
      category: 'Plumbing',
      unitRoom: 'Room 205',
      blockFrom: 'B',
      blockTo: 'C',
      priority: 'Medium',
      assignedTo: 'Sarah Johnson',
      status: 'Pending',
      dueDate: DateTime.now().add(const Duration(days: 5)),
      description: 'Repair water leak in bathroom',
    ),
    WorkOrder(
      orderNo: 'WO-2024-003',
      category: 'Maintenance',
      unitRoom: 'Room 310',
      blockFrom: 'C',
      blockTo: 'D',
      priority: 'Low',
      assignedTo: 'Mike Wilson',
      status: 'Completed',
      dueDate: DateTime.now().subtract(const Duration(days: 1)),
      description: 'Regular maintenance check',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background, 
      appBar: AppBar(
        title: const Text(
          'Work Orders',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: AppColors.surface,
          ),
        ),
        backgroundColor: AppColors.primary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color:AppColors.surface),
          onPressed: () => context.go(AppRoutes.dashboard),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: AppColors.surface),
            onPressed: () {
              // Implement search functionality
            },
          ),
          IconButton(
            icon: const Icon(Icons.filter_list, color: AppColors.surface),
            onPressed: () {
              // Implement filter functionality
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Header with count
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: AppColors.surface,
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total Work Orders: ${workOrders.length}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: AppColors.primary,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.secondary,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'Active',
                    style: TextStyle(
                      color: AppColors.surface,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Work Order List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: workOrders.length,
              itemBuilder: (context, index) {
                final workOrder = workOrders[index];
                return _buildWorkOrderCard(workOrder);
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddWorkOrderDialog(context),
        backgroundColor: AppColors.primary, 
        child: const Icon(Icons.add, color: AppColors.surface),
      ),
    );
  }

  Widget _buildWorkOrderCard(WorkOrder workOrder) {
    Color statusColor = _getStatusColor(workOrder.status);
    Color priorityColor = _getPriorityColor(workOrder.priority);
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  workOrder.orderNo,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: statusColor, width: 1),
                  ),
                  child: Text(
                    workOrder.status,
                    style: TextStyle(
                      color: statusColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 8),
            
            // Category and Priority Row
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color:  AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    workOrder.category,
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: priorityColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    workOrder.priority,
                    style: TextStyle(
                      color: priorityColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 12),
            
            // Details Grid
            Row(
              children: [
                Expanded(
                  child: _buildDetailItem('Unit/Room', workOrder.unitRoom),
                ),
                Expanded(
                  child: _buildDetailItem('Block', '${workOrder.blockFrom} → ${workOrder.blockTo}'),
                ),
              ],
            ),
            
            const SizedBox(height: 8),
            
            Row(
              children: [
                Expanded(
                  child: _buildDetailItem('Assigned to', workOrder.assignedTo),
                ),
                Expanded(
                  child: _buildDetailItem('Due Date', 
                    '${workOrder.dueDate.day}/${workOrder.dueDate.month}/${workOrder.dueDate.year}'),
                ),
              ],
            ),
            
            const SizedBox(height: 12),
            
            // Description
            Text(
              'Description:',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.lightgrey,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              workOrder.description,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: AppColors.darkgrey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: AppColors.lightgrey,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: AppColors.darkgrey,
          ),
        ),
      ],
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return AppColors.green;
      case 'in progress':
        return AppColors.yellow;
      case 'pending':
        return AppColors.red;
      default:
        return AppColors.lightgrey;
    }
  }

  Color _getPriorityColor(String priority) {
    switch (priority.toLowerCase()) {
      case 'high':
        return AppColors.red;
      case 'medium':
        return AppColors.yellow;;
      case 'low':
        return AppColors.green;
      default:
        return AppColors.lightgrey;
    }
  }

  void _showAddWorkOrderDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const AddWorkOrderDialog();
      },
    ).then((newWorkOrder) {
      if (newWorkOrder != null) {
        setState(() {
          workOrders.add(newWorkOrder);
        });
      }
    });
  }
}

// Add Work Order Dialog
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