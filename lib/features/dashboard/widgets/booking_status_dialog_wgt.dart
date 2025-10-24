import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:inta_mobile_pms/core/theme/app_colors.dart';

class BookingStatusDialog extends StatelessWidget {
  const BookingStatusDialog({super.key});

  static void show(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) => const BookingStatusDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 400),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.info_outline,
                  color: AppColors.primary,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Text(
                  'Booking Status',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.black,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () =>Get.back(),
                  icon: Icon(
                    Icons.close,
                    color: Colors.grey[600],
                    size: 20,
                  ),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            _buildStatusItem(
              context,
              'Confirmed',
              'Booking has been confirmed and payment received',
              AppColors.secondary,
              Icons.check_circle_outline,
            ),
            const SizedBox(height: 12),
            _buildStatusItem(
              context,
              'Pending',
              'Booking is awaiting confirmation or payment',
              Colors.orange[700]!,
              Icons.schedule,
            ),
            const SizedBox(height: 12),
            _buildStatusItem(
              context,
              'Checked In',
              'Guest has arrived and checked into the property',
              Colors.blue[700]!,
              Icons.login,
            ),
            const SizedBox(height: 12),
            _buildStatusItem(
              context,
              'Completed',
              'Guest has checked out and booking is complete',
              Colors.green[700]!,
              Icons.task_alt,
            ),
            const SizedBox(height: 12),
            _buildStatusItem(
              context,
              'Cancelled',
              'Booking has been cancelled by guest or host',
              AppColors.error,
              Icons.cancel_outlined,
            ),
            const SizedBox(height: 12),
            _buildStatusItem(
              context,
              'Extended',
              'Guest has extended their stay beyond original dates',
              Colors.purple[700]!,
              Icons.update,
            ),
            const SizedBox(height: 12),
            _buildStatusItem(
              context,
              'No Show',
              'Guest did not arrive for their scheduled booking',
              Colors.red[800]!,
              Icons.person_off_outlined,
            ),
            
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () =>Get.back(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.onPrimary,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  'Got it',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.onPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusItem(
    BuildContext context,
    String status,
    String description,
    Color color,
    IconData icon,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(
            icon,
            size: 16,
            color: color,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  status,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: color,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey[600],
                  height: 1.3,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}