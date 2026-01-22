import 'package:flutter/material.dart';
import 'package:get/Get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:go_router/go_router.dart';
import 'package:inta_mobile_pms/core/theme/app_colors.dart';
import 'package:inta_mobile_pms/features/housekeeping/models/maintenance_block_audit_trail.dart';
import 'package:inta_mobile_pms/features/housekeeping/models/maintenance_block_item.dart';
import 'package:inta_mobile_pms/features/housekeeping/viewmodels/maintenance_block_vm.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

class BlockRoomAuditTrail extends StatefulWidget {
  final MaintenanceBlockItem? block;
  const BlockRoomAuditTrail({super.key, this.block});

  @override
  State<BlockRoomAuditTrail> createState() => _BlockRoomAuditTrailState();
}

class _BlockRoomAuditTrailState extends State<BlockRoomAuditTrail> {
  final _maintenanceBlockVm = Get.find<MaintenanceBlockVm>();
  bool isLoading = true;
  List<MaintenanceBlockAuditTrail> auditTrails = [];

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (mounted) {
        await _maintenanceBlockVm.loadAuditTrails(widget.block!);
        setState(() {
          auditTrails = _maintenanceBlockVm.audiTrailList.toList();
          isLoading =
              _maintenanceBlockVm.isBlockAuditTrailLoading.value == true;
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
            Container(height: 16, width: 120, color: Colors.grey),
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
          'Block Room - Audit Trail',
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
                itemCount: 4,
                itemBuilder: (_, __) => _buildShimmerCard(),
              )
            : ListView.builder(
                itemCount: auditTrails.length,
                itemBuilder: (context, index) {
                  final auditTrail = auditTrails[index];

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
                          /// Title (Transaction Type)
                          Text(
                            auditTrail.transactionTypeName,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(fontWeight: FontWeight.w600),
                          ),

                          const SizedBox(height: 8),

                          /// Description
                          Text(
                            auditTrail.description.isNotEmpty
                                ? auditTrail.description
                                : '-',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),

                          const SizedBox(height: 8),

                          /// User + Date Row
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  const Icon(
                                    Icons.person,
                                    size: 14,
                                    color: Colors.grey,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    auditTrail.userName,
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.calendar_today,
                                    size: 14,
                                    color: Colors.grey,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    DateFormat(
                                      'yyyy-MM-dd - kk:mm a',
                                    ).format(auditTrail.sysDateCreated),
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
