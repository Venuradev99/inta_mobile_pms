import 'package:flutter/material.dart';
import 'package:inta_mobile_pms/core/config/responsive_config.dart';
import 'package:inta_mobile_pms/core/theme/app_colors.dart';
import 'package:inta_mobile_pms/features/housekeeping/models/maintenance_block_item.dart';


class MaintenanceBlockCard extends StatelessWidget {
  final MaintenanceBlockItem block;
  final VoidCallback onTap;

  const MaintenanceBlockCard({
    required this.block,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.surface,
      margin: EdgeInsets.only(bottom: ResponsiveConfig.listItemSpacing(context)),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(ResponsiveConfig.cardRadius(context)),
      ),
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(ResponsiveConfig.cardRadius(context)),
        child: Padding(
          padding: EdgeInsets.all(ResponsiveConfig.defaultPadding(context)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Row
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      _getCategoryIcon(block.category),
                      color: AppColors.primary,
                      size: ResponsiveConfig.iconSize(context),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          block.title,
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          'ID: ${block.id}',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: AppColors.lightgrey,
                              ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getStatusColor(block.status).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      block.status,
                      style: TextStyle(
                        color: _getStatusColor(block.status),
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Description
              Text(
                block.description,
                style: Theme.of(context).textTheme.bodyMedium,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),
              // Tags
              if (block.tags.isNotEmpty)
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: block.tags
                      .take(3)
                      .map((tag) => Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.secondary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              tag,
                              style: const TextStyle(
                                color: AppColors.secondary,
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ))
                      .toList(),
                ),
              if (block.tags.isNotEmpty) const SizedBox(height: 12),
              // Footer Row
              Row(
                children: [
                  Icon(
                    Icons.person_outline,
                    color: AppColors.lightgrey,
                    size: 16,
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      block.assignedTo,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.lightgrey,
                          ),
                    ),
                  ),
                  if (block.estimatedCost != null) ...[
                    Icon(
                      Icons.attach_money,
                      color: AppColors.lightgrey,
                      size: 16,
                    ),
                    Text(
                      '\$${block.estimatedCost!.toStringAsFixed(0)}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.lightgrey,
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                  ],
                  const SizedBox(width: 8),
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: _getPriorityColor(block.priority),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    block.priority,
                    style: TextStyle(
                      color: _getPriorityColor(block.priority),
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getPriorityColor(String priority) {
    switch (priority) {
      case 'High':
        return AppColors.red;
      case 'Medium':
        return AppColors.yellow;
      case 'Low':
        return AppColors.green;
      default:
        return AppColors.lightgrey;
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Completed':
        return AppColors.green;
      case 'In Progress':
        return AppColors.yellow;
      case 'Pending':
        return AppColors.red;
      case 'Scheduled':
        return AppColors.secondary;
      default:
        return AppColors.lightgrey;
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'HVAC':
        return Icons.air;
      case 'Plumbing':
        return Icons.plumbing;
      case 'Elevator':
        return Icons.elevator;
      case 'Safety':
        return Icons.security;
      case 'Landscaping':
        return Icons.grass;
      default:
        return Icons.build;
    }
  }
}
