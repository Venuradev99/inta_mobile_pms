import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import 'package:inta_mobile_pms/core/theme/app_colors.dart';
import 'package:inta_mobile_pms/features/housekeeping/models/work_order.dart';

class ViewWorkOrder extends StatelessWidget {
  final WorkOrder workOrder;

  const ViewWorkOrder({super.key, required this.workOrder});

  String _formatDate(DateTime? date) {
    if (date == null) return '-';
    return DateFormat('yyyy-MM-dd • HH:mm').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'View Work Order',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: AppColors.black,
                fontWeight: FontWeight.w600,
              ),
        ),
        backgroundColor: AppColors.surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.black),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _section(
              children: [
                _row('Order No', workOrder.orderNo),
                _row('Category', workOrder.category),
                _row(
                  'Unit / Room',
                  workOrder.unitRoom.isNotEmpty
                      ? workOrder.unitRoom
                      : workOrder.roomName,
                ),
              ],
            ),

            const SizedBox(height: 16),

            _section(
              children: [
                _row('Priority', workOrder.priority),
                _row('Assigned To', workOrder.assignedTo),
                _row('Status', workOrder.status),
              ],
            ),

            const SizedBox(height: 16),

            _section(
              children: [
                _row('Block From', _formatDate(workOrder.blockFrom)),
                _row('Block To', _formatDate(workOrder.blockTo)),
                _row('Due Date', _formatDate(workOrder.dueDate)),
              ],
            ),

            const SizedBox(height: 16),

            _section(
              children: [
                _row('Entered On', _formatDate(workOrder.enteredOn)),
                _row('Updated On', _formatDate(workOrder.updatedOn)),
              ],
            ),

            const SizedBox(height: 16),

            _textSection(
              title: 'Description',
              value: workOrder.description,
            ),

            const SizedBox(height: 16),

            _textSection(
              title: 'Post Note',
              value: workOrder.postNote ?? '-',
            ),

            const SizedBox(height: 16),

            _textSection(
              title: 'Reason',
              value: workOrder.reason,
            ),
          ],
        ),
      ),
    );
  }

  // ================== UI HELPERS ==================

  Widget _section({required List<Widget> children}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }

  Widget _row(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 4,
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            flex: 6,
            child: Text(
              value.isNotEmpty ? value : '-',
              style: const TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _textSection({
    required String title,
    required String value,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value.isNotEmpty ? value : '-',
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
