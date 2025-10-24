// lib/features/reservations/pages/change_reservation_type.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:inta_mobile_pms/core/config/responsive_config.dart';
import 'package:inta_mobile_pms/core/theme/app_colors.dart';
import 'package:inta_mobile_pms/core/theme/app_text_theme.dart';
import 'package:inta_mobile_pms/features/reservations/models/guest_item.dart';
import 'package:inta_mobile_pms/features/reservations/viewmodels/change_reservation_type_vm.dart';

class ChangeReservationType extends StatefulWidget {
  final GuestItem? guestItem;

  const ChangeReservationType({super.key, this.guestItem});

  @override
  _ChangeReservationTypeDialogState createState() =>
      _ChangeReservationTypeDialogState();

  // Static method to show the dialog
  static Future<String?> showChangeReservationTypeDialog(
    BuildContext context, {
    GuestItem? guestItem,
  }) async {
    return await showDialog<String>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext dialogContext) =>
          _ChangeReservationTypeDialog(guestItem: guestItem),
    );
  }
}

class _ChangeReservationTypeDialog extends StatefulWidget {
  final GuestItem? guestItem;

  const _ChangeReservationTypeDialog({this.guestItem});

  @override
  State<_ChangeReservationTypeDialog> createState() =>
      _ChangeReservationTypeDialogState();
}

class _ChangeReservationTypeDialogState
    extends State<_ChangeReservationTypeDialog> {
  final _changeReservationTypeVm = Get.find<ChangeReservationTypeVm>();

  String? _selectedReservationType;
  String? _currentReservationType;
  int? _selectedReservationTypeId;

  @override
  void initState() {
    super.initState();
    _currentReservationType = _determineCurrentReservationType();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (mounted) {
        await _changeReservationTypeVm.loadAllReservationTypes();
      }
    });
  }

  String _determineCurrentReservationType() {
    return widget.guestItem?.reservationType ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: ResponsiveConfig.isMobile(context)
              ? MediaQuery.of(context).size.width * 0.9
              : 400,
          maxHeight: MediaQuery.of(context).size.height * 0.8,
        ),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(
            ResponsiveConfig.cardRadius(context),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildHeader(context),
            _buildCurrentTypeInfo(context),
            Flexible(child: _buildReservationTypesList(context)),
            _buildActions(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(ResponsiveConfig.defaultPadding(context)),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade200, width: 1),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.swap_horiz,
            color: AppColors.primary,
            size: ResponsiveConfig.iconSize(context),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Change Reservation Type',
              style: AppTextTheme.lightTextTheme.titleMedium?.copyWith(
                color: AppColors.black,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          IconButton(
            onPressed: () => Get.back(),
            icon: const Icon(Icons.close, color: AppColors.lightgrey),
            iconSize: ResponsiveConfig.iconSize(context),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentTypeInfo(BuildContext context) {
    if (widget.guestItem == null) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(ResponsiveConfig.defaultPadding(context)),
      margin: EdgeInsets.all(ResponsiveConfig.defaultPadding(context)),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.primary.withOpacity(0.2), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Guest: ${widget.guestItem!.guestName}',
            style: AppTextTheme.lightTextTheme.bodyMedium?.copyWith(
              color: AppColors.black,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Res #: ${widget.guestItem!.resId}',
            style: AppTextTheme.lightTextTheme.bodySmall?.copyWith(
              color: AppColors.darkgrey,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.info_outline, color: AppColors.primary, size: 16),
              const SizedBox(width: 4),
              Text(
                'Current: $_currentReservationType',
                style: AppTextTheme.lightTextTheme.bodySmall?.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildReservationTypesList(BuildContext context) {
    return Obx(() {
      final reservationTypes = _changeReservationTypeVm.reservationTypes;
      return Container(
        padding: EdgeInsets.symmetric(
          horizontal: ResponsiveConfig.defaultPadding(context),
        ),
        child: ListView.separated(
          shrinkWrap: true,
          itemCount: reservationTypes.length,
          separatorBuilder: (context, index) => const Divider(height: 1),
          itemBuilder: (context, index) {
            final reservationType = reservationTypes[index];
            final isSelected = _selectedReservationType == reservationType.type;
            final isCurrent = _currentReservationType == reservationType.type;

            return Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: isCurrent
                    ? null
                    : () {
                        setState(() {
                          _selectedReservationType = reservationType.type;
                          _selectedReservationTypeId = reservationType.id ?? 0;
                        });
                      },
                child: Container(
                  padding: EdgeInsets.symmetric(
                    vertical: ResponsiveConfig.defaultPadding(context),
                    horizontal: 8,
                  ),
                  child: Row(
                    children: [
                      // Icon
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: reservationType.color.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          reservationType.icon,
                          color: reservationType.color,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Content
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    reservationType.type,
                                    style: AppTextTheme
                                        .lightTextTheme
                                        .bodyMedium
                                        ?.copyWith(
                                          color: isCurrent
                                              ? AppColors.lightgrey
                                              : AppColors.black,
                                          fontWeight: FontWeight.w600,
                                        ),
                                  ),
                                ),
                                if (isCurrent)
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.primary.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: AppColors.primary.withOpacity(
                                          0.3,
                                        ),
                                        width: 1,
                                      ),
                                    ),
                                    child: Text(
                                      'Current',
                                      style: AppTextTheme
                                          .lightTextTheme
                                          .bodySmall
                                          ?.copyWith(
                                            color: AppColors.primary,
                                            fontSize: 10,
                                            fontWeight: FontWeight.w600,
                                          ),
                                    ),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 2),
                            Text(
                              reservationType.description,
                              style: AppTextTheme.lightTextTheme.bodySmall
                                  ?.copyWith(
                                    color: isCurrent
                                        ? AppColors.lightgrey
                                        : AppColors.darkgrey,
                                  ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Radio button
                      if (!isCurrent)
                        Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isSelected
                                  ? AppColors.primary
                                  : Colors.grey.shade400,
                              width: isSelected ? 6 : 2,
                            ),
                            color: isSelected
                                ? AppColors.primary
                                : Colors.transparent,
                          ),
                        )
                      else
                        Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.grey.shade300,
                          ),
                          child: Icon(
                            Icons.check,
                            size: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      );
    });
  }

  Widget _buildActions(BuildContext context) {
    final bool canSave =
        _selectedReservationType != null &&
        _selectedReservationType != _currentReservationType;

    return Container(
      padding: EdgeInsets.all(ResponsiveConfig.defaultPadding(context)),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Colors.grey.shade200, width: 1)),
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () => Get.back(),
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
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton(
              onPressed: canSave ? _handleSave : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: canSave
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
                'Change Type',
                style: AppTextTheme.lightTextTheme.bodyMedium?.copyWith(
                  color: canSave ? AppColors.onPrimary : Colors.grey.shade600,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _handleSave() async {
    if (_selectedReservationType != null) {
     
      await _changeReservationTypeVm.saveChangeReservationType(
        _selectedReservationTypeId!,
        widget.guestItem!,
      );
      if (!mounted) return;
      
    }
  }
}

// Model class for reservation type items
class ReservationTypeItem {
  final int? id;
  final String type;
  final String description;
  final IconData icon;
  final Color color;

  const ReservationTypeItem({
     this.id,
    required this.type,
    required this.description,
    required this.icon,
    required this.color,
  });
}

// Extension method for easy access
extension ChangeReservationTypeExtension on BuildContext {
  Future<String?> showChangeReservationTypeDialog({GuestItem? guestItem}) {
    return ChangeReservationType.showChangeReservationTypeDialog(
      this,
      guestItem: guestItem,
    );
  }
}
