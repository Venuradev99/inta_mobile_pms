import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:inta_mobile_pms/core/config/responsive_config.dart';
import 'package:inta_mobile_pms/core/theme/app_colors.dart';
import 'package:inta_mobile_pms/core/theme/app_text_theme.dart';
import 'package:inta_mobile_pms/core/widgets/custom_appbar.dart';
import 'package:inta_mobile_pms/features/reports/viewmodels/night_audit_report_vm.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

class NightAuditReport extends StatefulWidget {
  const NightAuditReport({super.key});
  @override
  State<NightAuditReport> createState() => _NightAuditReportState();
}

class _NightAuditReportState extends State<NightAuditReport> {
 final _nightAuditReportVm = Get.find<NightAuditReportVm>();

  @override
  void initState() {
    super.initState();
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await _nightAuditReportVm.loadAuditTrails();
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        title: 'Night Audit'
        )
      ,
      body: Obx(() {
        // Loading shimmer
        if (_nightAuditReportVm.isLoading.value) {
          return ListView.builder(
            padding: ResponsiveConfig.verticalPadding(context)
                .add(ResponsiveConfig.horizontalPadding(context)),
            itemCount: 6,
            itemBuilder: (_, __) => _buildShimmerCard(context),
          );
        }

        final list = _nightAuditReportVm.nightAuditList.toList();
        if (list.isEmpty) {
          return const Center(child: Text('No audit trails found.'));
        }

        // Show actual list
        return ListView.builder(
          padding: ResponsiveConfig.verticalPadding(context)
              .add(ResponsiveConfig.horizontalPadding(context)),
          itemCount: list.length,
          itemBuilder: (context, index) =>
              _buildAuditCard(list[index], context, key: ValueKey(list[index].sysDateCreated)),
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
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   children: [
              //     Expanded(
              //       child: Text(
              //         item.transactionTypeName ?? '',
              //         style: AppTextTheme.lightTextTheme.titleMedium
              //             ?.copyWith(color: AppColors.black),
              //       ),
              //     ),
              //     const Icon(
              //       Icons.desktop_windows,
              //       color: AppColors.lightgrey,
              //     ),
              //   ],
              // ),
              const SizedBox(height: 8),
              Text(
                item.description ?? '',
                style: AppTextTheme.lightTextTheme.bodyMedium
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
                    style: AppTextTheme.lightTextTheme.bodySmall
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
