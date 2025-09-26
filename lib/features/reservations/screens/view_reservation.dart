import 'package:flutter/material.dart';
import 'package:inta_mobile_pms/core/theme/app_colors.dart';
import 'package:inta_mobile_pms/core/widgets/custom_appbar.dart';
import 'package:inta_mobile_pms/features/reservations/models/guest_item.dart';

class ViewReservation extends StatelessWidget {
  final GuestItem item;

  const ViewReservation({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        title: 'View Reservation',
       
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Guest Info Section
            _buildSectionTitle('Guest Information'),
            _buildInfoRow('Guest Name', item.guestName),
            _buildInfoRow('Adults', item.adults.toString()),
            if (item.roomNumber != null) _buildInfoRow('Room Number', item.roomNumber!),

            const SizedBox(height: 16),

            // Reservation Details Section
            _buildSectionTitle('Reservation Details'),
            _buildInfoRow('Reservation ID', item.resId),
            _buildInfoRow('Folio ID', item.folioId),
            _buildInfoRow('Start Date', item.startDate),
            _buildInfoRow('End Date', item.endDate),
            _buildInfoRow('Nights Stay', item.nights.toString()),
            if (item.remainingNights != null)
              _buildInfoRow('Remaining Nights', item.remainingNights.toString()),
            if (item.roomType != null) _buildInfoRow('Room Type', item.roomType!),
            if (item.reservationType != null)
              _buildInfoRow('Reservation Type', item.reservationType!),
            if (item.status != null) _buildInfoRow('Status', item.status!),
            if (item.businessSource != null)
              _buildInfoRow('Business Source', item.businessSource!),
            if (item.reservedDate != null) _buildInfoRow('Reserved Date', item.reservedDate!),
            if (item.cancellationNumber != null)
              _buildInfoRow('Cancellation Number', item.cancellationNumber!),
            if (item.voucherNumber != null)
              _buildInfoRow('Voucher Number', item.voucherNumber!),

            const SizedBox(height: 16),

            // Financials Section
            _buildSectionTitle('Financials'),
            _buildInfoRow('Total Amount', '\$${item.totalAmount.toStringAsFixed(2)}'),
            _buildInfoRow('Balance Amount', '\$${item.balanceAmount.toStringAsFixed(2)}'),

            const SizedBox(height: 24),

            
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: AppColors.primary,
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 16, color: AppColors.secondary),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}