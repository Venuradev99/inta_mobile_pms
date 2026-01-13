// remark_dialog.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inta_mobile_pms/core/theme/app_colors.dart';
import 'package:inta_mobile_pms/features/housekeeping/models/room_item_model.dart';
import 'package:inta_mobile_pms/features/housekeeping/viewmodels/house_status_vm.dart';
import 'package:inta_mobile_pms/services/navigation_service.dart';

class RemarkDialog extends StatefulWidget {
  final RoomItem room;
  final bool startInEdit;

  const RemarkDialog({super.key, required this.room, this.startInEdit = false});

  @override
  State<RemarkDialog> createState() => _RemarkDialogState();
}

class _RemarkDialogState extends State<RemarkDialog> {
  final _houseStatusVm = Get.find<HouseStatusVm>();
  bool _isEditMode = false;
  late TextEditingController _remarkController;
  String? _initialRemarkHK;
  String? _initialRemarkFD;

  @override
  void initState() {
    super.initState();
    _initialRemarkHK = widget.room.houseKeepingRemark;
    _initialRemarkFD = widget.room.fdRemark;
    _isEditMode =
        widget.startInEdit ||
        (_initialRemarkHK == null || _initialRemarkHK!.isEmpty);
    _remarkController = TextEditingController(text: _initialRemarkHK);
  }

  @override
  void dispose() {
    _remarkController.dispose();
    super.dispose();
  }

  void _toggleEditMode() {
    setState(() {
      _isEditMode = true;
    });
  }

  void _saveRemark() async {
    final newRemark = _remarkController.text.trim();
    await _houseStatusVm.updateRemark(widget.room, newRemark);
    if (!mounted) return;
    setState(() {
      _initialRemarkHK = newRemark;
      _isEditMode = false;
    });

    // if (newRemark != _initialRemarkHK) {
    //   await _houseStatusVm.updateRemark(widget.room, newRemark);
    //   setState(() {
    //     _initialRemarkHK = newRemark;
    //     _isEditMode = false;
    //   });
    // } else {
    //   setState(() {
    //     _isEditMode = false;
    //   });
    // }
  }

  void _cancelEdit() {
    setState(() {
      _remarkController.text = _initialRemarkHK ?? '';
      _isEditMode = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final hasRemark = _initialRemarkHK != null && _initialRemarkHK!.isNotEmpty;
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
            // Header
            Container(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 12),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.05),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
              ),
              child: Row(
                children: [
                  Icon(Icons.note_outlined, color: AppColors.primary, size: 24),
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

            // Body
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Enhanced room name with light background
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.background.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.meeting_room_outlined,
                            color: AppColors.primary,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              widget.room.roomName,
                              style: Theme.of(context).textTheme.titleSmall
                                  ?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey[800],
                                  ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Edit mode
                    if (_isEditMode)
                      TextField(
                        controller: _remarkController,
                        autofocus: true,
                        maxLines: null,
                        minLines: 5,
                        decoration: InputDecoration(
                          hintText: 'Enter HK remarks here...',
                          hintStyle: TextStyle(color: Colors.grey[500]),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.grey[300]!),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: AppColors.primary,
                              width: 2,
                            ),
                          ),
                          filled: true,
                          fillColor: AppColors.background.withOpacity(0.5),
                          contentPadding: const EdgeInsets.all(16),
                        ),
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.black,
                        ),
                      )
                    else
                      // View mode with enhanced remarks in light backgrounds
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'HK Remark',
                            style: Theme.of(context).textTheme.labelMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey[700],
                                ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: AppColors.background.withOpacity(0.8),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.grey[300]!),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Text(
                              _initialRemarkHK?.isNotEmpty == true
                                  ? _initialRemarkHK!
                                  : 'No HK Remarks',
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(
                                    color: _initialRemarkHK?.isNotEmpty == true
                                        ? AppColors.black
                                        : Colors.grey[500],
                                    height: 1.5,
                                  ),
                            ),
                          ),
                          const SizedBox(height: 24),
                          Text(
                            'FD Remark',
                            style: Theme.of(context).textTheme.labelMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey[700],
                                ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: AppColors.background.withOpacity(0.8),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.grey[300]!),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Text(
                              _initialRemarkFD?.isNotEmpty == true
                                  ? _initialRemarkFD!
                                  : 'No FD Remarks',
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(
                                    color: _initialRemarkFD?.isNotEmpty == true
                                        ? AppColors.black
                                        : Colors.grey[500],
                                    height: 1.5,
                                  ),
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
            const Divider(height: 1),

            // Buttons with enhanced styling
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (_isEditMode) ...[
                    TextButton(
                      onPressed: _cancelEdit,
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.grey[700],
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('Cancel'),
                    ),
                    const SizedBox(width: 12),
                    Obx(() {
                      final isLoading = _houseStatusVm.isUpdatingRemark.value;

                      return ElevatedButton(
                        onPressed: isLoading ? null : _saveRemark,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: AppColors.onPrimary,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          elevation: 2,
                        ),
                        child: isLoading
                            ? const SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.5,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                ),
                              )
                            : const Text('Save'),
                      );
                    }),
                  ] else ...[
                    if (hasRemark)
                      ElevatedButton(
                        onPressed: _toggleEditMode,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: AppColors.onPrimary,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          elevation: 2,
                        ),
                        child: const Text('Edit'),
                      ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
