import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inta_mobile_pms/core/config/responsive_config.dart';
import 'package:inta_mobile_pms/core/theme/app_colors.dart';
import 'package:inta_mobile_pms/features/reservations/models/guest_item.dart';
import 'package:inta_mobile_pms/features/reservations/viewmodels/change_reservation_type_vm.dart';

class ChangeReservationType extends StatefulWidget {
  final GuestItem? guestItem;

  const ChangeReservationType({super.key, this.guestItem});

  @override
  _ChangeReservationTypeDialogState createState() =>
      _ChangeReservationTypeDialogState();

  static Future<String?> showChangeReservationTypeDialog(
    BuildContext context, {
    GuestItem? guestItem,
  }) {
    return showDialog<String>(
      context: context,
      barrierDismissible: true,
      builder: (_) => _ChangeReservationTypeDialog(guestItem: guestItem),
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
  final _vm = Get.find<ChangeReservationTypeVm>();

  String? _selectedType;
  String? _currentType;
  int? _selectedTypeId;

  @override
  void initState() {
    super.initState();
    _currentType = widget.guestItem?.reservationType ?? '';

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _vm.loadAllReservationTypes();
    });
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

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
          color: Theme.of(context).colorScheme.surface,
          borderRadius:
              BorderRadius.circular(ResponsiveConfig.cardRadius(context)),
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
            _buildHeader(context, textTheme),
            _buildCurrentTypeInfo(context, textTheme),
            Flexible(child: _buildReservationList(context, textTheme)),
            _buildActions(context, textTheme),
          ],
        ),
      ),
    );
  }

  // ───────────────── HEADER ─────────────────

  Widget _buildHeader(BuildContext context, TextTheme textTheme) {
    return Container(
      padding: EdgeInsets.all(ResponsiveConfig.defaultPadding(context)),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
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
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  // ───────────────── CURRENT TYPE INFO ─────────────────

  Widget _buildCurrentTypeInfo(BuildContext context, TextTheme textTheme) {
    if (widget.guestItem == null) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      margin: EdgeInsets.all(ResponsiveConfig.defaultPadding(context)),
      padding: EdgeInsets.all(ResponsiveConfig.defaultPadding(context)),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.primary.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Guest: ${widget.guestItem!.guestName}',
            style: textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Res #: ${widget.guestItem!.resId}',
            style: textTheme.bodySmall,
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.info_outline, size: 16),
              const SizedBox(width: 4),
              Text(
                'Current: $_currentType',
                style: textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ───────────────── LIST ─────────────────

  Widget _buildReservationList(BuildContext context, TextTheme textTheme) {
    return Obx(() {
      final items = _vm.reservationTypes;

      return ListView.separated(
        padding: EdgeInsets.symmetric(
          horizontal: ResponsiveConfig.defaultPadding(context),
        ),
        itemCount: items.length,
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (_, index) {
          final item = items[index];
          final isCurrent = item.type == _currentType;
          final isSelected = item.type == _selectedType;

          return InkWell(
            onTap: isCurrent
                ? null
                : () {
                    setState(() {
                      _selectedType = item.type;
                      _selectedTypeId = item.id;
                    });
                  },
            child: Padding(
              padding: EdgeInsets.symmetric(
                vertical: ResponsiveConfig.defaultPadding(context),
              ),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: item.color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(item.icon, color: item.color),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.type,
                          style: textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: isCurrent
                                ? Colors.grey
                                : textTheme.bodyMedium?.color,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          item.description,
                          style: textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  if (!isCurrent)
                    Icon(
                      isSelected
                          ? Icons.radio_button_checked
                          : Icons.radio_button_unchecked,
                      color:
                          isSelected ? AppColors.primary : Colors.grey.shade400,
                    )
                  else
                    const Icon(Icons.check, color: Colors.grey),
                ],
              ),
            ),
          );
        },
      );
    });
  }

  // ───────────────── ACTIONS ─────────────────

  Widget _buildActions(BuildContext context, TextTheme textTheme) {
    final canSave =
        _selectedType != null && _selectedType != _currentType;

    return Padding(
      padding: EdgeInsets.all(ResponsiveConfig.defaultPadding(context)),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel', style: textTheme.labelLarge),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton(
              onPressed: canSave ? _handleSave : null,
              child: Text('Change Type', style: textTheme.labelLarge),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleSave() async {
    await _vm.saveChangeReservationType(
      _selectedTypeId!,
      widget.guestItem!,
    );
    if (mounted) Navigator.pop(context);
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
