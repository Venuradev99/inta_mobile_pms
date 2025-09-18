import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:inta_mobile_pms/core/theme/app_colors.dart';
import 'package:inta_mobile_pms/features/housekeeping/models/work_order.dart';
import 'package:inta_mobile_pms/features/housekeeping/widgets/add_work_order_dialog.dart';
import 'package:inta_mobile_pms/router/app_routes.dart';



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
            color: AppColors.black,
          ),
        ),
        backgroundColor: AppColors.surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color:AppColors.black),
          onPressed: () => context.go(AppRoutes.dashboard),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: AppColors.black),
            onPressed: () {
              // Implement search functionality
            },
          ),
          IconButton(
            icon: const Icon(Icons.filter_list, color: AppColors.black),
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
