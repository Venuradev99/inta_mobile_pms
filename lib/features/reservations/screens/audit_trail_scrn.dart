import 'package:flutter/material.dart';
import 'package:inta_mobile_pms/core/config/responsive_config.dart';

import 'package:inta_mobile_pms/core/theme/app_colors.dart'; // Adjust path if needed
import 'package:inta_mobile_pms/core/theme/app_text_theme.dart'; // Adjust path if needed

import 'package:go_router/go_router.dart';

class AuditTrail extends StatelessWidget {
  const AuditTrail({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> auditItems = [
      {
        'title': 'Package Removed',
        'description': 'Name :',
        'user': 'demo',
        'time': '03-10-2025 11:41:13 AM',
        'ip': '112.134.246.155',
      },
      {
        'title': 'Reservation',
        'description': 'Reservation No : BH2863, Reservation Type : Booking\nCurrency, Rate Mode : Manual, Tax Type : Tax Inclusive ,\nManual Rate : 8,500.00, Complimentary Room : No',
        'user': 'demo',
        'time': '03-10-2025 11:41:13 AM',
        'ip': '112.134.246.155',
      },
      {
        'title': 'Add Meal Plan',
        'description': 'Meal Plan : East Indian, Brunch, ABC [ Walk In/New\nReservation ]',
        'user': 'demo',
        'time': '03-10-2025 11:41:13 AM',
        'ip': '112.134.246.155',
      },
      {
        'title': 'Insert Inclusion',
        'description': 'Extra Charge : Airport Transfer, Folio : 2336, Rate : 1.00\n%, Posting : CHECKINANDCHECKOUT, Charge Rule : Per\nBooking, Qty : 0, Adult : 1, Child : 0, Valid From : 2019-09-19,\nValid To : 2025-04-21, Posting Type : FLATPERCENTAGE,\nOffered Rate : NETRATE, Rate : 0',
        'user': 'demo',
        'time': '03-10-2025 11:41:13 AM',
        'ip': '112.134.246.155',
      },
      {
        'title': 'Bill to',
        'description': 'Bill To - Guest, Payment method -',
        'user': 'demo',
        'time': '03-10-2025 11:41:13 AM',
        'ip': '112.134.246.155',
      },
      {
        'title': 'Apply Tax On Room Type',
        'description': 'Room Type : Double Room new, From : 12-09-2022, To :\n13-09-2022, Applicable Tax : NBT, Service Charge, TDL, TEST,\nVAT @ 5%',
        'user': 'demo',
        'time': '03-10-2025 11:41:13 AM',
        'ip': '112.134.246.155',
      },
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: AppColors.black),
       onPressed: () => context.pop(),
        ),
        title: Text(
          'Audit Trail',
          style: AppTextTheme.lightTextTheme.titleMedium?.copyWith(
            color: AppColors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: false,
      ),
      body: ListView.builder(
        padding: ResponsiveConfig.verticalPadding(context).add(ResponsiveConfig.horizontalPadding(context)),
        itemCount: auditItems.length,
        itemBuilder: (context, index) {
          final item = auditItems[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(ResponsiveConfig.cardRadius(context)),
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
                            item['title']!,
                            style: AppTextTheme.lightTextTheme.titleMedium?.copyWith(color: AppColors.black),
                          ),
                        ),
                        const Icon(Icons.desktop_windows, color: AppColors.lightgrey),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      item['description']!,
                      style: AppTextTheme.lightTextTheme.bodyMedium?.copyWith(color: AppColors.darkgrey),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        const Icon(Icons.account_circle, color: AppColors.primary, size: 24),
                        const SizedBox(width: 8),
                        Text(
                          item['user']!,
                          style: AppTextTheme.lightTextTheme.bodySmall?.copyWith(color: AppColors.black),
                        ),
                        const SizedBox(width: 16),
                        const Icon(Icons.access_time, color: AppColors.lightgrey, size: 20),
                        const SizedBox(width: 4),
                        Text(
                          item['time']!,
                          style: AppTextTheme.lightTextTheme.bodySmall?.copyWith(color: AppColors.lightgrey),
                        ),
                        const Spacer(),
                        const Icon(Icons.computer, color: AppColors.lightgrey, size: 20),
                        const SizedBox(width: 4),
                        Text(
                          item['ip']!,
                          style: AppTextTheme.lightTextTheme.bodySmall?.copyWith(color: AppColors.lightgrey),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}