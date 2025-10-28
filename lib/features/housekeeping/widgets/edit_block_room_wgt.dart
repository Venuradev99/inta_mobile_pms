import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:inta_mobile_pms/core/config/responsive_config.dart';
import 'package:inta_mobile_pms/core/theme/app_colors.dart';
import 'package:inta_mobile_pms/features/housekeeping/viewmodels/maintenance_block_vm.dart';

class EditBlockRoomPage extends StatefulWidget {
  final dynamic block;

  const EditBlockRoomPage({super.key, required this.block});

  @override
  State<EditBlockRoomPage> createState() => _EditBlockRoomPageState();
}

class _EditBlockRoomPageState extends State<EditBlockRoomPage> {
  final _maintenanceBlockVm = Get.find<MaintenanceBlockVm>();

  late DateTime _startDate;
  late DateTime _endDate;
  late String _selectedReason;

  final List<String> _reasons = [
    'AC Not Working',
    'AC Repair',
    'aitken spence booking. pending confirmation',
    'awaiting',
    // Add more reasons if needed
  ];

  @override
  void initState() {
    super.initState();
    final dateFormat = DateFormat('dd-MM-yyyy');
    _startDate = dateFormat.parse(widget.block.startDate);
    _endDate = dateFormat.parse(widget.block.endDate);
    _selectedReason = widget.block.reason ?? _reasons.first;
  }

  Future<void> _pickStartDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _startDate,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: AppColors.onPrimary,
              onSurface: AppColors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (date != null && date.isBefore(_endDate) || date?.isAtSameMomentAs(_endDate) == true) {
      setState(() {
        _startDate = date!;
      });
    } else if (date != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Start date must be before or equal to end date')),
      );
    }
  }

  Future<void> _pickEndDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _endDate,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: AppColors.onPrimary,
              onSurface: AppColors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (date != null && date.isAfter(_startDate) || date?.isAtSameMomentAs(_startDate) == true) {
      setState(() {
        _endDate = date!;
      });
    } else if (date != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('End date must be after or equal to start date')),
      );
    }
  }

  String _formatDate(DateTime date) {
    return DateFormat('dd-MM-yyyy').format(date);
  }

  void _applyChanges() {
    final updatedBlock = widget.block; // Assuming mutable; use copyWith if immutable
    updatedBlock.startDate = _formatDate(_startDate);
    updatedBlock.endDate = _formatDate(_endDate);
    updatedBlock.reason = _selectedReason;

    // _maintenanceBlockVm.updateMaintenanceBlock(updatedBlock);
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background, // Adjust to light blue if needed, e.g., Colors.blue[50]
      appBar: AppBar(
        title: Text(
          'Edit Block Room',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: AppColors.black,
                fontWeight: FontWeight.w600,
              ),
        ),
        backgroundColor: AppColors.surface,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.close, color: AppColors.black),
            onPressed: () => context.pop(),
          ),
        ],
      ),
      body: Padding(
        padding: ResponsiveConfig.horizontalPadding(context)
            .add(ResponsiveConfig.verticalPadding(context)),
        child: ListView(
          children: [
            Text(
              'Date Range',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppColors.lightgrey,
                    fontWeight: FontWeight.w500,
                  ),
            ),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: _pickStartDate,
                    child: Text(
                      'Start Date\n${_formatDate(_startDate)}',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                   Icon(Icons.arrow_forward, color: AppColors.lightgrey),
                  InkWell(
                    onTap: _pickEndDate,
                    child: Text(
                      'End Date\n${_formatDate(_endDate)}',
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.right,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Reason',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppColors.lightgrey,
                    fontWeight: FontWeight.w500,
                  ),
            ),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: _reasons.map((reason) {
                  return RadioListTile<String>(
                    value: reason,
                    groupValue: _selectedReason,
                    onChanged: (value) {
                      setState(() {
                        _selectedReason = value!;
                      });
                    },
                    title: Text(
                      reason,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.black,
                          ),
                    ),
                    controlAffinity: ListTileControlAffinity.trailing,
                    activeColor: AppColors.primary,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                    visualDensity: const VisualDensity(horizontal: 0, vertical: -2),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: ResponsiveConfig.horizontalPadding(context)
              .add(const EdgeInsets.only(bottom: 16)),
          child: ElevatedButton(
            onPressed: _applyChanges,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.onPrimary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: const Text('Apply'),
          ),
        ),
      ),
    );
  }
}