import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:go_router/go_router.dart';
import 'package:inta_mobile_pms/core/theme/app_colors.dart';
import 'package:inta_mobile_pms/features/housekeeping/models/maintenance_block_audit_trail.dart';
import 'package:inta_mobile_pms/features/housekeeping/models/maintenance_block_item.dart';
import 'package:inta_mobile_pms/features/housekeeping/models/work_order.dart';
import 'package:inta_mobile_pms/features/housekeeping/models/work_order_audit_trail_item.dart';
import 'package:inta_mobile_pms/features/housekeeping/viewmodels/maintenance_block_vm.dart';
import 'package:inta_mobile_pms/features/housekeeping/viewmodels/work_order_list_vm.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

class WorkOrderAuditTrail extends StatefulWidget {
  final WorkOrder? workOrder;
  const WorkOrderAuditTrail({super.key, this.workOrder});

  @override
  State<WorkOrderAuditTrail> createState() => WorkOrderAuditTrailState();
}

class WorkOrderAuditTrailState extends State<WorkOrderAuditTrail> {
  final workOrderListVm = Get.find<WorkOrderListVm>();
  bool isLoading = true;
  List<WorkOrderAuditTrailItem> auditTrails = [];

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (mounted) {
        await workOrderListVm.loadAuditTrails(widget.workOrder!);
        setState(() {
          auditTrails = workOrderListVm.audiTrailList.toList();
          if (workOrderListVm.isWorkOrderLoading.value == false) {
            isLoading = false;
          }
        });
      }
    });
  }

  Widget _buildShimmerCard() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(height: 16, width: 100, color: Colors.grey),
            const SizedBox(height: 8),
            Container(height: 14, width: double.infinity, color: Colors.grey),
            const SizedBox(height: 8),
            Row(
              children: [
                Container(height: 14, width: 80, color: Colors.grey),
                const SizedBox(width: 16),
                Container(height: 14, width: 60, color: Colors.grey),
              ],
            ),
            const SizedBox(height: 8),
            Container(height: 12, width: 120, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Work Order - Audit Trail',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: AppColors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: AppColors.surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: AppColors.black),
          onPressed: () => context.pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: isLoading
            ? ListView.builder(
                itemCount: 4, // number of shimmer cards
                itemBuilder: (context, index) => _buildShimmerCard(),
              )
            : ListView.builder(
                itemCount: auditTrails.length,
                itemBuilder: (context, index) {
                  final autitTrail = auditTrails[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Name
                          Text(
                            autitTrail.name,
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 8),

                          // Description
                          Text(
                            autitTrail.description.isNotEmpty
                                ? autitTrail.description
                                : '-',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),

                          const SizedBox(height: 16),

                          // Transaction type above bottom row
                          Text(
                            'Transaction: ${autitTrail.transactionTypeName}',
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(color: Colors.grey[700]),
                          ),

                          const SizedBox(height: 8),

                          // Bottom Row: User left, Date right
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // User
                              Row(
                                children: [
                                  Icon(
                                    Icons.person,
                                    size: 14,
                                    color: Colors.grey,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    autitTrail.userName,
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),

                              // Date
                              Row(
                                children: [
                                  Icon(
                                    Icons.calendar_today,
                                    size: 14,
                                    color: Colors.grey,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    DateFormat(
                                      'yyyy-MM-dd – kk:mm',
                                    ).format(autitTrail.sysDateCreated),
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
