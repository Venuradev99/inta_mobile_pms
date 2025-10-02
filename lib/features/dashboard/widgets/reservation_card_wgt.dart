import 'package:flutter/material.dart';
import 'package:inta_mobile_pms/core/theme/app_colors.dart';
import 'package:inta_mobile_pms/features/reservations/screens/reservation_list_scrn.dart';
import 'package:inta_mobile_pms/features/dashboard/widgets/date_info_wgt.dart';
import 'package:inta_mobile_pms/features/reservations/widgets/status_chip_wgt.dart';


class ReservationCard extends StatelessWidget {
  final ReservationItem reservation;
  final GestureTapCallback? onTap;

  const ReservationCard({
    super.key,
    required this.reservation,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[200]!, width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: AppColors.primary.withOpacity(0.1),
                  child: Text(
                    reservation.guestName.substring(0, 1).toUpperCase(),
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        reservation.guestName,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        '${reservation.propertyName} • ${reservation.bookingId}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                StatusChip(status: reservation.status),
              ],
            ),
            const SizedBox(height: 16),
            // Dates
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.05),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue.withOpacity(0.1)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: DateInfo(
                      label: 'Check-in',
                      date: reservation.checkInDate,
                      icon: Icons.login,
                      color: Colors.green[600]!,
                    ),
                  ),
                  Container(width: 1, height: 30, color: Colors.grey[300]),
                  Expanded(
                    child: DateInfo(
                      label: 'Check-out',
                      date: reservation.checkOutDate,
                      icon: Icons.logout,
                      color: Colors.red[600]!,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            // Stay details + Quick action
            Row(
              children: [
                _buildStayChip(context, Icons.night_shelter, Colors.purple[700]!, '${reservation.nights} Night${reservation.nights > 1 ? 's' : ''}'),
                const SizedBox(width: 8),
                _buildStayChip(context, Icons.people, Colors.orange[700]!, '${reservation.guests} Guest${reservation.guests > 1 ? 's' : ''}'),
                const Spacer(),
                _buildQuickActionButton(context),
              ],
            ),
            const SizedBox(height: 12),
            // Total
            Row(
              children: [
                Text('Total Amount: ', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey[600])),
                Text('\$${reservation.totalAmount.toStringAsFixed(2)}', style: Theme.of(context).textTheme.titleSmall?.copyWith(color: AppColors.primary, fontWeight: FontWeight.w700)),
                const Spacer(),
                if (reservation.balanceAmount > 0) ...[
                  Text('Balance: ', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey[600])),
                  Text('\$${reservation.balanceAmount.toStringAsFixed(2)}', style: Theme.of(context).textTheme.titleSmall?.copyWith(color: Colors.red[600], fontWeight: FontWeight.w600)),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStayChip(BuildContext context, IconData icon, Color color, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(6)),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 4),
        Text(text, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: color, fontWeight: FontWeight.w500)),
      ]),
    );
  }

  Widget _buildQuickActionButton(BuildContext context) {
    String buttonText;
    Color buttonColor;
    IconData buttonIcon;

    switch (reservation.status.toLowerCase()) {
      case 'confirmed':
        buttonText = 'Check In'; buttonColor = Colors.blue; buttonIcon = Icons.login; break;
      case 'checked in':
        buttonText = 'Check Out'; buttonColor = Colors.green; buttonIcon = Icons.logout; break;
      case 'pending':
        buttonText = 'Confirm'; buttonColor = Colors.orange; buttonIcon = Icons.check; break;
      default:
        buttonText = 'View'; buttonColor = Colors.grey; buttonIcon = Icons.visibility;
    }

    return SizedBox(
      height: 32,
      child: ElevatedButton.icon(
        onPressed: () {}, // Wire to handler
        icon: Icon(buttonIcon, size: 16),
        label: Text(buttonText),
        style: ElevatedButton.styleFrom(
          backgroundColor: buttonColor,
          foregroundColor: AppColors.surface,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
          padding: const EdgeInsets.symmetric(horizontal: 12),
        ),
      ),
    );
  }
}

class ReservationItem {
  final String guestName;
  final String propertyName;
  final String bookingId;
  final String status;
  final String checkInDate;
  final String checkOutDate;
  final int nights;
  final int guests;
  final double totalAmount;
  final double balanceAmount;
  final String? reservedDate;
  final String? reservationType;
  final String? businessSource;
  final String? roomNumber;
  final String? cancellationNumber;
  final String? voucherNumber;

  ReservationItem({
    required this.guestName,
    required this.propertyName,
    required this.bookingId,
    required this.status,
    required this.checkInDate,
    required this.checkOutDate,
    required this.nights,
    required this.guests,
    required this.totalAmount,
    required this.balanceAmount,
    this.reservedDate,
    this.reservationType,
    this.businessSource,
    this.roomNumber,
    this.cancellationNumber,
    this.voucherNumber,
  });
}