// lib/widgets/common/action_bottom_sheet.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
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
            // Handle bar for better UX
            Container(
              margin: const EdgeInsets.symmetric(vertical: 8),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            // Header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Actions for $guestName',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close),
                    tooltip: 'Close',
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            // Scrollable action list
            Expanded(
              child: ListView.separated(
                controller: scrollController,
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemCount: actions.length,
                separatorBuilder: (context, index) => const Divider(
                  height: 1,
                  indent: 56, // Align with icon
                ),
                itemBuilder: (context, index) =>
                    _buildActionItem(context, actions[index]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionItem(BuildContext context, ActionItem action) {
    return ListTile(
      leading: Icon(action.icon, color: Colors.grey[600], size: 24),
      title: Text(
        action.label,
        style: Theme.of(
          context,
        ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
      ),
      onTap: action.onTap, // This was missing!
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      // Add visual feedback
      hoverColor: Colors.grey[100],
      splashColor: Theme.of(context).primaryColor.withOpacity(0.1),
      // Improve accessibility
      dense: false,
      visualDensity: VisualDensity.comfortable,
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
    this.onTap, // Made it required since it's essential for navigation
  });
}
