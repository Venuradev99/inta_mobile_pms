
// Separate widget file content (e.g., remark_dialog.dart)

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inta_mobile_pms/core/theme/app_colors.dart';
import 'package:inta_mobile_pms/features/housekeeping/models/room_item_model.dart';
import 'package:inta_mobile_pms/features/housekeeping/viewmodels/house_status_vm.dart';

class RemarkDialog extends StatefulWidget {
  final RoomItem room;
  final bool startInEdit;

  const RemarkDialog({
    super.key,
    required this.room,
    this.startInEdit = false,
  });

  @override
  State<RemarkDialog> createState() => _RemarkDialogState();
}

class _RemarkDialogState extends State<RemarkDialog> {
  final _houseStatusVm = Get.find<HouseStatusVm>();
  bool _isEditMode = false;
  late TextEditingController _remarkController;
  String? _initialRemark;

  @override
  void initState() {
    super.initState();
    _initialRemark = widget.room.remark;
    _isEditMode = widget.startInEdit || (_initialRemark == null || _initialRemark!.isEmpty);
    _remarkController = TextEditingController(text: _initialRemark);
  }

  @override
  void dispose() {
    _remarkController.dispose();
    super.dispose();
  }

  void _toggleEditMode() {
    setState(() {
      _isEditMode = !_isEditMode;
    });
  }

  void _saveRemark() async {
    final newRemark = _remarkController.text.trim();
    if (newRemark != _initialRemark) {
      // Assuming VM has a method to update remark, e.g., updateRemark
      await _houseStatusVm.updateRemark(widget.room, newRemark); // Update this line with actual VM method if different
      setState(() {
        _initialRemark = newRemark;
        _isEditMode = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Remark updated for ${widget.room.roomName}')),
      );
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final hasRemark = _initialRemark != null && _initialRemark!.isNotEmpty;
    final title = _isEditMode 
        ? (hasRemark ? 'Edit Remark' : 'Add Remark') 
        : 'View Remark';
    return Material(
      color: Colors.transparent,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 400, maxHeight: 600),
        margin: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header with drag handle effect
            Container(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 12),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.05),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.note_outlined,
                    color: AppColors.primary,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppColors.black,
                          ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: Icon(Icons.close, color: Colors.grey[600], size: 24),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      widget.room.roomName,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w500,
                            color: Colors.grey[700],
                          ),
                    ),
                    const SizedBox(height: 16),
                    if (_isEditMode) ...[
                      TextField(
                        controller: _remarkController,
                        autofocus: true,
                        maxLines: null,
                        minLines: 5,
                        decoration: InputDecoration(
                          hintText: 'Enter remark here...',
                          hintStyle: TextStyle(color: Colors.grey[500]),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.grey[300]!),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: AppColors.primary, width: 2),
                          ),
                          filled: true,
                          fillColor: AppColors.background,
                          contentPadding: const EdgeInsets.all(16),
                        ),
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.black),
                      ),
                    ] else ...[
                      Text(
                        _initialRemark ?? 'No remark available',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppColors.black,
                              height: 1.5,
                            ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (hasRemark && !_isEditMode)
                    TextButton(
                      onPressed: _toggleEditMode,
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors.primary,
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      ),
                      child: const Text('Edit'),
                    ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: _isEditMode ? _saveRemark : () => Navigator.of(context).pop(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: AppColors.onPrimary,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: Text(_isEditMode ? 'Save' : 'Close'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}