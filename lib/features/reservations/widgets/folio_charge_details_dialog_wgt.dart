import 'package:flutter/material.dart';
import 'package:inta_mobile_pms/core/theme/app_colors.dart';
import 'package:inta_mobile_pms/features/reservations/models/folio_charges_response.dart';
import 'package:inta_mobile_pms/features/reservations/models/folio_tax_item.dart';
import 'package:intl/intl.dart';

class FolioChargeDetailsDialog extends StatefulWidget {
  final FolioChargesResponse charge;
  final List<FolioTaxItem> taxes;
  final String baseCurrencySymbol;

  const FolioChargeDetailsDialog({
    super.key,
    required this.charge,
    required this.taxes,
    required this.baseCurrencySymbol,
  });

  @override
  State<FolioChargeDetailsDialog> createState() =>
      _FolioChargeDetailsDialogState();
}

class _FolioChargeDetailsDialogState extends State<FolioChargeDetailsDialog> {
  final DateFormat dateFormat = DateFormat('dd MMM yyyy');

  double get totalTax => widget.taxes.fold(0.0, (sum, tax) => sum + tax.amount);

  String formatCurrency(double? value) {
    final symbol = widget.baseCurrencySymbol;
    if (value == null) return '$symbol 0.00';

    final formatted = value
        .toStringAsFixed(2)
        .replaceAllMapped(
          RegExp(r'(\d)(?=(\d{3})+\.)'),
          (Match m) => '${m[1]},',
        );

    return '$symbol $formatted';
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.7,
          maxWidth: MediaQuery.of(context).size.width * 0.8,
        ),
        child: Column(
          children: [
            _buildHeader(),
            const Divider(height: 1),
            Expanded(child: _buildContent()),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: Text(
              widget.charge.chargeName,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoRow(
            'Gross Amount',
            formatCurrency(widget.charge.grossAmount),
          ),
          _buildInfoRow('Discount', formatCurrency(widget.charge.discount)),
          _buildInfoRow(
            'Line Discount',
            formatCurrency(widget.charge.lineDiscount),
          ),
          _buildInfoRow(
            'Auto Adjustment',
            formatCurrency(widget.charge.roundOffAmount),
          ),
          _buildInfoRow('Tax Amount', formatCurrency(totalTax)),
          const SizedBox(height: 12),

          if (widget.taxes.isNotEmpty && widget.charge.chargeTypeId != 3)
            Text(
              'Tax Breakdown',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),

          const SizedBox(height: 8),
          ...widget.taxes.map((tax) => _buildTaxRow(tax)),

          const SizedBox(height: 8),

          if (widget.charge.chargeTypeId == 3 &&
              widget.charge.transferedToFolioId == 0) ...[
            Text(
              'Source',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 8),
            _buildTransferRow(
              'Folio',
              widget.charge.transferedFromFolioName ?? '',
            ),
            _buildTransferRow('Room', widget.charge.transferedFromRoomNo ?? ''),
            _buildTransferRow(
              'Reservation No',
              widget.charge.transferedFromReservationNo ?? '',
            ),
          ],
          if (widget.charge.chargeTypeId == 3 &&
              widget.charge.transferedToFolioId > 0) ...[
            Text(
              'Destination',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 8),
            _buildTransferRow(
              'Folio',
              widget.charge.transferedToFolioName ?? '',
            ),
            _buildTransferRow('Room', widget.charge.transferedToRoomNo ?? ''),
            _buildTransferRow(
              'Reservation No',
              widget.charge.transferedToReservationNo ?? '',
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              '$label:',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14,
                color: Colors.grey.shade700,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: const TextStyle(fontSize: 14),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTaxRow(FolioTaxItem tax) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Expanded(
            child: Text(tax.taxName, style: const TextStyle(fontSize: 14)),
          ),
          SizedBox(
            width: 100,
            child: Text(
              formatCurrency(tax.amount),
              style: const TextStyle(fontSize: 14),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransferRow(String name, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Expanded(child: Text(name, style: const TextStyle(fontSize: 14))),
          SizedBox(
            width: 150,
            child: Text(
              value,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.right,
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}
