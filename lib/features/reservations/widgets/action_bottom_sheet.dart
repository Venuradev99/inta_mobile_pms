// lib/widgets/common/action_bottom_sheet.dart
import 'package:flutter/material.dart';
import 'package:inta_mobile_pms/core/theme/app_colors.dart';

class ActionBottomSheet extends StatelessWidget {
  final String guestName;
  final List<ActionItem> actions;

  const ActionBottomSheet({
    super.key,
    required this.guestName,
    required this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.5,
      minChildSize: 0.25,
      maxChildSize: 0.95,
      builder: (context, scrollController) => Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: 8),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                controller: scrollController,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Actions for $guestName',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ...actions.map((action) => _buildActionItem(context, action)),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionItem(BuildContext context, ActionItem action) {
    return ListTile(
      leading: Icon(action.icon, color: Colors.grey[600]),
      title: Text(
        action.label,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class ActionItem {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  const ActionItem({
    required this.icon,
    required this.label,
  
    this.onTap,
  });
}