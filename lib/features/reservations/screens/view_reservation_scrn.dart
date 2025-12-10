import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:inta_mobile_pms/core/theme/app_colors.dart';
import 'package:inta_mobile_pms/core/widgets/custom_appbar.dart';
import 'package:inta_mobile_pms/features/reservations/models/guest_item.dart';

class ViewReservation extends StatefulWidget {
  final GuestItem? item;
  const ViewReservation({super.key, this.item});
  @override
   State<ViewReservation> createState() => _ViewReservation();
}

class _ViewReservation extends State<ViewReservation>{
  GuestItem? item;

   @override
  void initState() {
    super.initState();
    item = widget.item;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.item == null) {
      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: CustomAppBar(title: 'View Reservation'),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.receipt_long_outlined,
                    color: Colors.red.shade400,
                    size: 64,
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Reservation Not Found',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'We couldn\'t load this reservation.\nPlease try again or contact support.',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade600,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                ElevatedButton.icon(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.arrow_back),
                  label: const Text('Go Back'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return DefaultTabController(
      length: 5,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: CustomAppBar(
          title: 'Reservation Details',
        ),
        body: Column(
          children: [
            // Enhanced Guest Header Card
            _buildGuestHeaderCard(),
            
            // Modern TabBar
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TabBar(
                isScrollable: true,
                labelColor: AppColors.primary,
                unselectedLabelColor: Colors.grey.shade600,
                indicatorColor: AppColors.primary,
                indicatorWeight: 3,
                labelStyle: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.3,
                ),
                unselectedLabelStyle: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
                tabs: const [
                  Tab(text: 'Overview'),
                  Tab(text: 'Guest Details'),
                  Tab(text: 'Charges'),
                  Tab(text: 'Folio'),
                  Tab(text: 'Remarks'),
                ],
              ),
            ),
            
            Expanded(
              child: TabBarView(
                children: [
                  _buildGeneralInfoTab(),
                  _buildGuestInfoTab(),
                  _buildRoomChargesTab(),
                  _buildFolioDetailsTab(),
                  _buildRemarksTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Enhanced Guest Header Card
  Widget _buildGuestHeaderCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.primary.withOpacity(0.8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.person_outline, color: Colors.white, size: 28),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item!.guestName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.3,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.25),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            'Booking #${item!.folioId}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        if (item!.roomNumber != null) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.25),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              'Room ${item!.roomNumber}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Enhanced General Info Tab with Modern Cards
  Widget _buildGeneralInfoTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Stay Duration Card with Visual Appeal
          _buildModernCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildCardHeader('Stay Information', Icons.calendar_month),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _buildDateColumn('Check-In', item!.startDate, Icons.login),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        children: [
                          Icon(Icons.arrow_forward, color: Colors.grey.shade400),
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              '${item!.nights} nights',
                              style: TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: _buildDateColumn('Check-Out', item!.endDate, Icons.logout),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Divider(),
                const SizedBox(height: 12),
                _buildEnhancedInfoRow('Room Type', item!.roomType ?? '-', Icons.meeting_room),
                _buildEnhancedInfoRow('Rate Plan', item!.reservationType ?? '-', Icons.label),
                _buildEnhancedInfoRow('Daily Rate', '\$${item!.avgDailyRate?.toStringAsFixed(2) ?? 'N/A'}', Icons.payments),
              ],
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Financial Summary Card
          _buildModernCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildCardHeader('Financial Summary', Icons.account_balance_wallet),
                const SizedBox(height: 16),
                _buildFinancialRow('Total Charges', item!.totalAmount, isPositive: false),
                _buildFinancialRow('Payments', item!.totalCredits ?? 0, isPositive: true),
                const Divider(height: 24, thickness: 1.5),
                _buildFinancialRow(
                  'Balance Due',
                  item!.balanceAmount,
                  isBalance: true,
                  isPositive: item!.balanceAmount <= 0,
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Action Buttons with Enhanced Design
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.payment, size: 20),
                  label: const Text('Add Payment'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.add_circle_outline, size: 20),
                  label: const Text('Add Charges'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    side: BorderSide(color: AppColors.primary, width: 1.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Enhanced Guest Info Tab with Sectioned Cards
  Widget _buildGuestInfoTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Contact Information Card
          _buildModernCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildCardHeader('Contact Information', Icons.contact_phone),
                const SizedBox(height: 16),
                _buildEnhancedInfoRow('Phone', item!.phone ?? '-', Icons.phone),
                _buildEnhancedInfoRow('Mobile', item!.mobile ?? '-', Icons.smartphone),
                _buildEnhancedInfoRow('Email', item!.email ?? '-', Icons.email),
              ],
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Identity Information Card
          _buildModernCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildCardHeader('Identity & Documents', Icons.badge),
                const SizedBox(height: 16),
                _buildEnhancedInfoRow('ID Type', item!.idType ?? 'Passport', Icons.credit_card),
                _buildEnhancedInfoRow('ID Number', item!.idNumber ?? '-', Icons.numbers),
                _buildEnhancedInfoRow('Expiry Date', item!.expiryDate ?? '-', Icons.event),
                _buildEnhancedInfoRow('Date of Birth', item!.dob ?? '-', Icons.cake),
                _buildEnhancedInfoRow('Nationality', item!.nationality ?? 'Sri Lanka', Icons.flag),
              ],
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Transport Information Card
          _buildModernCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildCardHeader('Transport Details', Icons.directions_car),
                const SizedBox(height: 16),
                _buildEnhancedInfoRow('Arrival By', item!.arrivalBy ?? '-', Icons.flight_land),
                _buildEnhancedInfoRow('Departure By', item!.departureBy ?? '-', Icons.flight_takeoff),
              ],
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Additional Information Card
          _buildModernCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildCardHeader('Booking Details', Icons.info_outline),
                const SizedBox(height: 16),
                _buildEnhancedInfoRow('Guests', '${item!.adults} Adults, ${item!.children ?? 0} Children', Icons.people),
                _buildEnhancedInfoRow('Business Source', item!.businessSource ?? '-', Icons.business),
                _buildEnhancedInfoRow('Company', item!.company ?? '-', Icons.corporate_fare),
                _buildEnhancedInfoRow('Travel Agent', item!.travelAgent ?? '-', Icons.travel_explore),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Enhanced Room Charges Tab
  Widget _buildRoomChargesTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildModernCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildCardHeader('Daily Breakdown', Icons.receipt_long),
                const SizedBox(height: 16),
                _buildEnhancedInfoRow('Room', item!.roomNumber ?? 'AZA-139', Icons.meeting_room),
                _buildEnhancedInfoRow('Rate Type', item!.reservationType ?? 'Dinner Only', Icons.label),
                _buildEnhancedInfoRow('Occupancy', '${item!.adults} Adults, ${item!.children ?? 0} Children', Icons.people),
                if (item!.childAge != null)
                  _buildEnhancedInfoRow('Child Age', item!.childAge!, Icons.child_care),
              ],
            ),
          ),
          
          const SizedBox(height: 16),
          
          _buildModernCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildCardHeader('Charge Breakdown', Icons.calculate),
                const SizedBox(height: 16),
                _buildChargeRow('Room Charges', item!.roomCharges ?? 3125.00),
                _buildChargeRow('Discount', -(item!.discount ?? 0), isDiscount: true),
                _buildChargeRow('Tax', item!.tax ?? 531.25, isTax: true),
                _buildChargeRow('Adjustment', item!.adjustment ?? 3.75),
                const Divider(height: 24, thickness: 1.5),
                _buildChargeRow('Net Amount', item!.netAmount ?? 3660.00, isTotal: true),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Enhanced Folio Details Tab
  Widget _buildFolioDetailsTab() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Folio #${item!.folioId}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  _buildLegendItem(Colors.blue.shade400, 'Pending'),
                  const SizedBox(width: 16),
                  _buildLegendItem(Colors.green.shade400, 'Posted'),
                ],
              ),
            ],
          ),
        ),
        Expanded(
          child: item!.folioCharges != null && item!.folioCharges!.isNotEmpty
              ? ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: item!.folioCharges!.length,
                  itemBuilder: (context, index) {
                    final charge = item!.folioCharges![index];
                    return _buildEnhancedFolioItem(
                      charge.title,
                      charge.date,
                      charge.room,
                      charge.amount,
                      isPosted: charge.isPosted,
                    );
                  },
                )
              : Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.receipt_outlined, size: 64, color: Colors.grey.shade300),
                      const SizedBox(height: 16),
                      Text(
                        'No charges recorded yet',
                        style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                ),
        ),
      ],
    );
  }

  // Enhanced Remarks Tab
  Widget _buildRemarksTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: _buildModernCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCardHeader('Remarks', Icons.note_alt),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Text(
                item!.remarks ?? 'No remarks available.',
                style: TextStyle(
                  fontSize: 15,
                  height: 1.6,
                  color: item!.remarks != null ? Colors.black87 : Colors.grey.shade500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==================== Enhanced Reusable Widgets ====================

  Widget _buildModernCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildCardHeader(String title, IconData icon) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: AppColors.primary, size: 20),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
            letterSpacing: 0.2,
          ),
        ),
      ],
    );
  }

  Widget _buildEnhancedInfoRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.grey.shade400),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey.shade700,
              ),
            ),
          ),
          Flexible(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateColumn(String label, String date, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: AppColors.primary, size: 28),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            color: Colors.grey.shade600,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          date,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildFinancialRow(String label, double amount, {bool isBalance = false, bool isPositive = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isBalance ? 16 : 15,
              fontWeight: isBalance ? FontWeight.bold : FontWeight.w500,
              color: isBalance ? Colors.black87 : Colors.grey.shade700,
            ),
          ),
          Text(
            '\$${amount.toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: isBalance ? 18 : 15,
              fontWeight: FontWeight.bold,
              color: isBalance
                  ? (isPositive ? Colors.green.shade600 : Colors.red.shade600)
                  : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChargeRow(String label, double amount, {bool isDiscount = false, bool isTax = false, bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isTotal ? 16 : 15,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
              color: isTotal ? Colors.black87 : Colors.grey.shade700,
            ),
          ),
          Text(
            '${amount >= 0 ? '\$' : '-\$'}${amount.abs().toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: isTotal ? 18 : 15,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.w600,
              color: isTotal
                  ? AppColors.primary
                  : (isDiscount ? Colors.green.shade600 : Colors.black87),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(Color color, String label) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey.shade700,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildEnhancedFolioItem(String title, String date, String room, double amount, {bool isPosted = false}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isPosted ? Colors.green.shade200 : Colors.blue.shade200,
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: isPosted ? Colors.green.shade50 : Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  isPosted ? 'Posted' : 'Pending',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: isPosted ? Colors.green.shade700 : Colors.blue.shade700,
                  ),
                ),
              ),
              const Spacer(),
              Text(
                '\$${amount.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isPosted ? Colors.green.shade600 : Colors.blue.shade600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.calendar_today, size: 14, color: Colors.grey.shade500),
              const SizedBox(width: 6),
              Text(
                date,
                style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
              ),
              const SizedBox(width: 16),
              Icon(Icons.meeting_room, size: 14, color: Colors.grey.shade500),
              const SizedBox(width: 6),
              Text(
                room,
                style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
              ),
            ],
          ),
        ],
      ),
    );
  }
}