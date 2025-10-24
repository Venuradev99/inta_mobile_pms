import 'package:flutter/material.dart';
import 'package:inta_mobile_pms/core/config/responsive_config.dart';
import 'package:inta_mobile_pms/core/theme/app_colors.dart';
import 'package:inta_mobile_pms/features/housekeeping/models/maintenance_block_item.dart';
import 'package:shimmer/shimmer.dart';

class MaintenanceBlockCard extends StatelessWidget {
  final MaintenanceBlockItem block;
  final VoidCallback onTap;

  const MaintenanceBlockCard({
    required this.block,
    required this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.surface,
      margin: EdgeInsets.only(
        bottom: ResponsiveConfig.listItemSpacing(context),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          ResponsiveConfig.cardRadius(context),
        ),
      ),
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(
          ResponsiveConfig.cardRadius(context),
        ),
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
                      Icons.security,
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
                          block.roomName,
                          style: Theme.of(context).textTheme.titleSmall
                              ?.copyWith(fontWeight: FontWeight.w600),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          'From ${block.fromDate} To ${block.toDate}',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(color: AppColors.lightgrey),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Reason text
              Text(
                block.reasonName,
                style: Theme.of(context).textTheme.bodyMedium,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),

              const SizedBox(height: 12),

              // Footer Row (aligned to bottom right)
              Align(
                alignment: Alignment.bottomRight,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.person_outline,
                      color: AppColors.lightgrey,
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${block.blockedBy} on ${block.blockedOn}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.lightgrey,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MaintenanceBlockCardShimmer extends StatelessWidget {
  const MaintenanceBlockCardShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final baseColor = AppColors.lightgrey.withOpacity(0.3);
    final highlightColor = AppColors.lightgrey.withOpacity(0.1);

    return Shimmer.fromColors(
      baseColor: baseColor,
      highlightColor: highlightColor,
      child: Card(
        color: AppColors.surface,
        margin: EdgeInsets.only(
          bottom: ResponsiveConfig.listItemSpacing(context),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            ResponsiveConfig.cardRadius(context),
          ),
        ),
        elevation: 2,
        child: Padding(
          padding: EdgeInsets.all(ResponsiveConfig.defaultPadding(context)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Row
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: baseColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: double.infinity,
                          height: 14,
                          color: baseColor,
                        ),
                        const SizedBox(height: 6),
                        Container(width: 120, height: 12, color: baseColor),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Reason text
              Container(width: double.infinity, height: 14, color: baseColor),
              const SizedBox(height: 8),
              Container(
                width: MediaQuery.of(context).size.width * 0.6,
                height: 14,
                color: baseColor,
              ),

              const SizedBox(height: 12),

              // Footer
              Align(
                alignment: Alignment.bottomRight,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(width: 16, height: 16, color: baseColor),
                    const SizedBox(width: 8),
                    Container(width: 100, height: 12, color: baseColor),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
