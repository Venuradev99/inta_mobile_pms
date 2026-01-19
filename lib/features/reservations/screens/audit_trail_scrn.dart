import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:inta_mobile_pms/core/config/responsive_config.dart';
import 'package:inta_mobile_pms/core/theme/app_colors.dart';
import 'package:inta_mobile_pms/core/theme/app_text_theme.dart';
import 'package:inta_mobile_pms/features/reservations/models/guest_item.dart';
import 'package:inta_mobile_pms/features/reservations/viewmodels/audit_trail_vm.dart';
import 'package:intl/intl.dart';

class AuditTrail extends StatefulWidget {
  final GuestItem? guestItem;
  const AuditTrail({super.key, required this.guestItem});

  @override
  State<AuditTrail> createState() => _AuditTrailState();
}

class _AuditTrailState extends State<AuditTrail> {
  final _auditTrailVm = Get.find<AuditTrailVm>();

  @override
  void initState() {
    super.initState();
    if (widget.guestItem != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await _auditTrailVm.loadAuditTrails(widget.guestItem!);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: AppColors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Audit Trail',
          style: TextTheme.of(context).titleMedium?.copyWith(
            color: AppColors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: false,
      ),
      body: Obx(() {
        // Loading shimmer
        if (_auditTrailVm.isLoading.value) {
          return ListView.builder(
            padding: ResponsiveConfig.verticalPadding(context)
                .add(ResponsiveConfig.horizontalPadding(context)),
            itemCount: 6,
            itemBuilder: (_, __) => _buildShimmerCard(context),
          );
        }

        final list = _auditTrailVm.auditTrailList.toList();
        if (list.isEmpty) {
          return const Center(child: Text('No audit trails found.'));
        }

        // Show actual list
        return ListView.builder(
          padding: ResponsiveConfig.verticalPadding(context)
              .add(ResponsiveConfig.horizontalPadding(context)),
          itemCount: list.length,
          itemBuilder: (context, index) =>
              _buildAuditCard(list[index], context, key: ValueKey(list[index].transactionLog)),
        );
      }),
    );
  }

  Widget _buildAuditCard(item, BuildContext context, {Key? key}) {
    return Padding(
      key: key,
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(
            ResponsiveConfig.cardRadius(context),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      item.transactionTypeName ?? '',
                      style:  TextTheme.of(context).titleMedium
                          ?.copyWith(color: AppColors.black),
                    ),
                  ),
                  const Icon(
                    Icons.desktop_windows,
                    color: AppColors.lightgrey,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                item.description ?? '',
                style:  TextTheme.of(context).bodyMedium
                    ?.copyWith(color: AppColors.darkgrey),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Icon(
                    Icons.account_circle,
                    color: AppColors.primary,
                    size: 24,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    item.userName ?? '',
                    style:  TextTheme.of(context).bodySmall
                        ?.copyWith(color: AppColors.black),
                  ),
                  const SizedBox(width: 16),
                  const Spacer(),
                  const Icon(
                    Icons.access_time,
                    color: AppColors.lightgrey,
                    size: 20,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${_formatDate(item.sysDateCreated)} ${_formatTime(item.sysDateCreated)}',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildShimmerCard(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: Container(
          height: 120,
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(
              ResponsiveConfig.cardRadius(context),
            ),
          ),
        ),
      ),
    );
  }

  String _formatDate(String? dateTimeString) {
    if (dateTimeString == null) return '';
    try {
      return dateTimeString.split('T')[0];
    } catch (e) {
      return '';
    }
  }

  String _formatTime(String? dateTimeString) {
    if (dateTimeString == null) return '';
    try {
      final parts = dateTimeString.split('T');
      if (parts.length != 2) return '';
      final timePart = parts[1].split('.').first;
      final dateTime = DateTime.parse('${parts[0]}T$timePart');
      return DateFormat('hh:mm a').format(dateTime);
    } catch (e) {
      return '';
    }
  }
}
