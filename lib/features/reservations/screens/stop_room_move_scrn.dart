// lib/features/reservations/pages/stop_room_move_page.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:inta_mobile_pms/core/config/responsive_config.dart';
import 'package:inta_mobile_pms/core/theme/app_colors.dart';
import 'package:inta_mobile_pms/core/theme/app_text_theme.dart';
import 'package:inta_mobile_pms/router/app_routes.dart';


class StopRoomMoveScreen extends StatefulWidget {
  const StopRoomMoveScreen({super.key});

  @override
  State<StopRoomMoveScreen> createState() => _StopRoomMoveScreenState();
}

class _StopRoomMoveScreenState extends State<StopRoomMoveScreen> {
  String? _selectedReason;
  final List<String> _predefinedReasons = [
    'Anniversary couple',
    'check',
    'Customer has already already Seen',
    'customer specifically asked for this',
    'Special guest',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(context),
      body: _buildBody(context),
      bottomNavigationBar: _buildBottomActions(context),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.surface,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.close, color: AppColors.black),
        onPressed: () => context.pop(),
      ),
      title: Text(
        'Stop Room Move',
        style: AppTextTheme.lightTextTheme.titleMedium?.copyWith(
          color: AppColors.black,
          fontWeight: FontWeight.w600,
        ),
      ),
      centerTitle: false,
    );
  }

  Widget _buildBody(BuildContext context) {
    return SingleChildScrollView(
      padding: ResponsiveConfig.horizontalPadding(context).add(
        ResponsiveConfig.verticalPadding(context),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildAddNewReasonButton(context),
          SizedBox(height: ResponsiveConfig.listItemSpacing(context)),
          _buildReasonSelection(context),
        ],
      ),
    );
  }

  Widget _buildAddNewReasonButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: _showAddNewReasonDialog,
        icon: Icon(
          Icons.add,
          color: AppColors.primary,
          size: ResponsiveConfig.iconSize(context),
        ),
        label: Text(
          'Add New Reason',
          style: AppTextTheme.lightTextTheme.bodyMedium?.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.w600,
          ),
        ),
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: AppColors.primary, width: 1.5),
          padding: EdgeInsets.symmetric(
            vertical: ResponsiveConfig.defaultPadding(context),
            horizontal: ResponsiveConfig.defaultPadding(context),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(ResponsiveConfig.cardRadius(context)),
          ),
        ),
      ),
    );
  }

  Widget _buildReasonSelection(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(ResponsiveConfig.cardRadius(context)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Header
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(ResponsiveConfig.defaultPadding(context)),
            decoration: BoxDecoration(
              color: const Color(0xFFF5F5F5), // Light grey background
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(ResponsiveConfig.cardRadius(context)),
                topRight: Radius.circular(ResponsiveConfig.cardRadius(context)),
              ),
            ),
            child: Text(
              'Select Reason',
              style: AppTextTheme.lightTextTheme.bodyMedium?.copyWith(
                color: AppColors.darkgrey,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          // Reason List
          ...List.generate(_predefinedReasons.length, (index) {
            final reason = _predefinedReasons[index];
            final isLast = index == _predefinedReasons.length - 1;
            
            return Column(
              children: [
                _buildReasonItem(context, reason),
                if (!isLast)
                  Divider(
                    height: 1,
                    color: Colors.grey.shade200,
                    indent: ResponsiveConfig.defaultPadding(context),
                    endIndent: ResponsiveConfig.defaultPadding(context),
                  ),
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _buildReasonItem(BuildContext context, String reason) {
    final isSelected = _selectedReason == reason;
    
    return InkWell(
      onTap: () => setState(() => _selectedReason = reason),
      child: Container(
        padding: EdgeInsets.all(ResponsiveConfig.defaultPadding(context)),
        child: Row(
          children: [
            Expanded(
              child: Text(
                reason,
                style: AppTextTheme.lightTextTheme.bodyMedium?.copyWith(
                  color: AppColors.black,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? AppColors.primary : Colors.grey.shade400,
                  width: isSelected ? 6 : 2,
                ),
                color: isSelected ? AppColors.primary : Colors.transparent,
              ),
              child: isSelected
                  ? const Icon(
                      Icons.circle,
                      size: 12,
                      color: AppColors.surface,
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomActions(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(ResponsiveConfig.defaultPadding(context)),
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () => context.pop(),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppColors.lightgrey),
                padding: EdgeInsets.symmetric(
                  vertical: ResponsiveConfig.defaultPadding(context),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'Cancel',
                style: AppTextTheme.lightTextTheme.bodyMedium?.copyWith(
                  color: AppColors.lightgrey,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: ElevatedButton(
              onPressed: _selectedReason != null ? _handleSave : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: _selectedReason != null 
                    ? AppColors.primary 
                    : Colors.grey.shade300,
                padding: EdgeInsets.symmetric(
                  vertical: ResponsiveConfig.defaultPadding(context),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 0,
              ),
              child: Text(
                'Save',
                style: AppTextTheme.lightTextTheme.bodyMedium?.copyWith(
                  color: _selectedReason != null 
                      ? AppColors.onPrimary 
                      : Colors.grey.shade600,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showAddNewReasonDialog() {
    final TextEditingController reasonController = TextEditingController();
    
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: AppColors.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(ResponsiveConfig.cardRadius(context)),
          ),
          title: Text(
            'Add New Reason',
            style: AppTextTheme.lightTextTheme.titleMedium?.copyWith(
              color: AppColors.black,
              fontWeight: FontWeight.w600,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: reasonController,
                autofocus: true,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'Enter reason for stopping room move...',
                  hintStyle: TextStyle(color: Colors.grey.shade500),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: AppColors.primary),
                  ),
                  contentPadding: const EdgeInsets.all(12),
                ),
                style: AppTextTheme.lightTextTheme.bodyMedium?.copyWith(
                  color: AppColors.black,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text(
                'Cancel',
                style: AppTextTheme.lightTextTheme.bodyMedium?.copyWith(
                  color: AppColors.lightgrey,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                final newReason = reasonController.text.trim();
                if (newReason.isNotEmpty) {
                  setState(() {
                    _predefinedReasons.add(newReason);
                    _selectedReason = newReason;
                  });
                  Navigator.of(dialogContext).pop();
                  
                  // Show success message
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('New reason added successfully'),
                      backgroundColor: AppColors.green,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'Add',
                style: AppTextTheme.lightTextTheme.bodyMedium?.copyWith(
                  color: AppColors.onPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _handleSave() {
    if (_selectedReason == null) {
      _showErrorSnackBar('Please select a reason');
      return;
    }

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Room move stopped. Reason: $_selectedReason'),
        backgroundColor: AppColors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );

    // Navigate back
    context.pop();
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}