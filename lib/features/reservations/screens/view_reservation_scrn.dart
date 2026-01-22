import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:inta_mobile_pms/core/theme/app_colors.dart';
import 'package:inta_mobile_pms/core/widgets/custom_appbar.dart';
import 'package:inta_mobile_pms/features/reservations/models/guest_item.dart';
import 'package:inta_mobile_pms/features/reservations/models/sharer_info.dart';
import 'package:inta_mobile_pms/features/reservations/viewmodels/reservation_vm.dart';
import 'package:inta_mobile_pms/features/reservations/widgets/folio_charge_details_dialog_wgt.dart';
import 'package:inta_mobile_pms/features/stay_view/viewmodels/stay_view_vm.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

class ViewReservation extends StatefulWidget {
  final GuestItem? item;
  const ViewReservation({super.key, this.item});
  @override
  State<ViewReservation> createState() => _ViewReservation();
}

class _ViewReservation extends State<ViewReservation>
    with TickerProviderStateMixin {
  final _reservationVm = Get.find<ReservationVm>();
  final _stayViewVm = Get.find<StayViewVm>();
  late int? _bookingRoomId;
  late final TabController _tabController;
  late String _baseCurrencyCode = '';
  GuestItem? item;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    item = widget.item;

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (item != null) {
        int? bookingRoomId = int.tryParse(widget.item?.bookingRoomId ?? '');
        await _reservationVm.loadAllAuditTrails(item!);
        if (!mounted) return;
        setState(() {
          _bookingRoomId = bookingRoomId;
          _baseCurrencyCode = _reservationVm.baseCurrencyCode.value;
        });
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  String formatCurrency(double? value, String? currencyCode) {
    if (value == null) return '${currencyCode} 0.00';

    final formatted = value
        .toStringAsFixed(2)
        .replaceAllMapped(
          RegExp(r'(\d)(?=(\d{3})+\.)'),
          (Match m) => '${m[1]},',
        );

    return '${currencyCode} ${formatted}';
  }

  String formatDateTime(String dateTimeStr) {
    DateTime date = DateTime.parse(dateTimeStr);

    DateFormat formatter = DateFormat('yyyy-MMM-dd hh:mm a');
    return formatter.format(date);
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
                Text(
                  'Reservation Not Found',
                  style: TextTheme.of(
                    context,
                  ).headlineSmall?.copyWith(color: Colors.black87),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  'We couldn\'t load this reservation.\nPlease try again or contact support.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey.shade600,
                    height: 1.5, // line height
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
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 16,
                    ),
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
      length: 6,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: CustomAppBar(title: 'Reservation Details'),
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
                  Tab(text: 'Room Charges'),
                  Tab(text: 'Folio Details'),
                  Tab(text: 'Remarks'),
                  Tab(text: 'Audit Trail'),
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
                  _buildAuditTrailTab(),
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
                child: const Icon(
                  Icons.person_outline,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item!.fullNameWithTitle!,
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold, // override if needed
                            letterSpacing: 0.3,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.25),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            'Res No: ${item!.reservationNumber}',
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                        ),
                        if (item!.roomNumber != null) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.25),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              'Room ${item!.roomNumber}',
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(
                                    color: Colors.white,
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
                _buildCardHeader(
                  context,
                  'Stay Information',
                  Icons.calendar_month,
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: item!.colorCode!.withOpacity(0.4),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${item!.statusName}',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 13, // optional override if needed
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _buildDateColumn(
                        context,
                        'Check-In',
                        item!.arrivalTime!,
                        Icons.login,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        children: [
                          Icon(
                            Icons.arrow_forward,
                            color: Colors.grey.shade400,
                          ),
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              '${item!.nights} nights',
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.bold,
                                    fontSize:
                                        13, // optional, only if you want to override
                                  ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: _buildDateColumn(
                        context,
                        'Check-Out',
                        item!.departureTime!,
                        Icons.logout,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Divider(),
                const SizedBox(height: 12),
                _buildEnhancedInfoRow(
                  context,
                  'Room Type',
                  item!.roomType ?? '-',
                  Icons.meeting_room,
                ),
                _buildEnhancedInfoRow(
                  context,
                  'Rate Type',
                  item!.rateType ?? '-',
                  Icons.rate_review,
                ),

                _buildEnhancedInfoRow(
                  context,
                  'Guests',
                  '${item!.adults} Adults, ${item!.children ?? 0} Children',
                  Icons.people,
                ),
                // _buildEnhancedInfoRow(
                //   'Daily Rate',
                //   formatCurrency(item!.avgDailyRate),
                //   Icons.payments,
                // ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          _buildModernCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildCardHeader(
                  context,
                  'Booking Information',
                  Icons.info_outline,
                ),
                const SizedBox(height: 16),

                _buildEnhancedInfoRow(
                  context,
                  'Reservation Type',
                  item!.reservationType ?? '-',
                  Icons.beach_access,
                ),
                _buildEnhancedInfoRow(
                  context,
                  'Business Category',
                  item!.businessCategoryName ?? '',
                  Icons.business,
                ),
                if (item!.businessCategoryId == 1)
                  _buildEnhancedInfoRow(
                    context,
                    'Online Travel Agent',
                    item!.businessSourceName ?? '',
                    Icons.business,
                  ),
                if (item!.businessCategoryId == 2)
                  _buildEnhancedInfoRow(
                    context,
                    'Agent',
                    item!.businessSourceName ?? '',
                    Icons.business,
                  ),
                if (item!.businessCategoryId == 5)
                  _buildEnhancedInfoRow(
                    context,
                    'Company',
                    item!.businessSourceName ?? '',
                    Icons.business,
                  ),
                _buildEnhancedInfoRow(
                  context,
                  'Market',
                  item!.marketCode ?? '-',
                  Icons.shop,
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          Obx(
            () => _buildModernCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildCardHeader(
                    context,
                    'Folio Summary',
                    Icons.receipt_long,
                  ),
                  const SizedBox(height: 16),
                  _buildFinancialRow(
                    context,
                    _baseCurrencyCode,
                    'Total Charges',
                    _reservationVm.paymentSummary.value!.totalPrice,
                    isPositive: false,
                  ),
                  if (item!.visibleCurrencyCode! != _baseCurrencyCode)
                    _buildFinancialRow(
                      context,
                      item!.visibleCurrencyCode!,
                      '',
                      item!.conversionRate != 0
                          ? _reservationVm.paymentSummary.value!.totalPrice /
                                item!.conversionRate!
                          : 0,
                      isPositive: false,
                    ),
                  _buildFinancialRow(
                    context,
                    _baseCurrencyCode,
                    'Payments',
                    _reservationVm.paymentSummary.value!.totalGrossAmount,
                    isPositive: true,
                  ),
                  if (item!.visibleCurrencyCode! != _baseCurrencyCode)
                    _buildFinancialRow(
                      context,
                      item!.visibleCurrencyCode!,
                      '',
                      item!.conversionRate != 0
                          ? _reservationVm
                                    .paymentSummary
                                    .value!
                                    .totalGrossAmount /
                                item!.conversionRate!
                          : 0,
                      isPositive: true,
                    ),
                  const Divider(height: 24, thickness: 1.5),
                  _buildFinancialRow(
                    context,
                    _baseCurrencyCode,
                    'Balance Due',
                    _reservationVm.paymentSummary.value!.balance,
                    isBalance: true,
                    isPositive:
                        _reservationVm.paymentSummary.value!.balance <= 0,
                  ),
                  if (item!.visibleCurrencyCode! != _baseCurrencyCode)
                    _buildFinancialRow(
                      context,
                      item!.visibleCurrencyCode!,
                      '',
                      item!.conversionRate != 0
                          ? _reservationVm.paymentSummary.value!.balance /
                                item!.conversionRate!
                          : 0,
                      isBalance: true,
                      isPositive:
                          _reservationVm.paymentSummary.value!.balance <= 0,
                    ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          _buildModernCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildCardHeader(context, 'Folio Details', Icons.payment),
                const SizedBox(height: 16),
                _buildFolioDropdown(),
                const SizedBox(height: 16),
                Obx(() {
                  final item = _reservationVm.folioSummary.value;
                  if (item == null) {
                    return const SizedBox.shrink();
                  }

                  return Column(
                    children: [
                      _buildFinancialRow(
                        context,
                        item.visibleCurrencyCode,
                        'Room Charges',
                        item.conversionRate > 0
                            ? item.roomCharges / item.conversionRate
                            : 0,
                      ),
                      _buildFinancialRow(
                        context,
                        item.visibleCurrencyCode,
                        'Extra Charges',
                        item.conversionRate > 0
                            ? item.extraCharges / item.conversionRate
                            : 0,
                      ),
                      _buildFinancialRow(
                        context,
                        item.visibleCurrencyCode,
                        'Gross Amount',
                        item.conversionRate > 0
                            ? item.grossAmount / item.conversionRate
                            : 0,
                      ),
                      _buildFinancialRow(
                        context,
                        item.visibleCurrencyCode,
                        'Full Discount',
                        item.conversionRate > 0
                            ? item.discountAmount / item.conversionRate
                            : 0,
                      ),
                      _buildFinancialRow(
                        context,
                        item.visibleCurrencyCode,
                        'Line Discount',
                        item.conversionRate > 0
                            ? item.lineDiscountAmount / item.conversionRate
                            : 0,
                      ),
                      _buildFinancialRow(
                        context,
                        item.visibleCurrencyCode,
                        'Tax Amount',
                        item.conversionRate > 0
                            ? item.taxAmount / item.conversionRate
                            : 0,
                      ),
                      if (item.roundOffAmount != 0)
                        _buildFinancialRow(
                          context,
                          item.visibleCurrencyCode,
                          'Auto Adjustment',
                          item.conversionRate > 0
                              ? item.roundOffAmount / item.conversionRate
                              : 0,
                        ),
                      _buildFinancialRow(
                        context,
                        item.visibleCurrencyCode,
                        'Total Amount',
                        item.conversionRate > 0
                            ? item.totalAmount / item.conversionRate
                            : 0,
                      ),
                      _buildFinancialRow(
                        context,
                        item.visibleCurrencyCode,
                        'Paid Amount',
                        item.conversionRate > 0
                            ? item.paidAmount / item.conversionRate
                            : 0,
                      ),
                      _buildFinancialRow(
                        context,
                        item.visibleCurrencyCode,
                        'Balance Amount',
                        item.conversionRate > 0
                            ? item.balanceAmount / item.conversionRate
                            : 0,
                      ),
                    ],
                  );
                }),
                // const SizedBox(height: 16),
                // _buildFinancialRow(
                //   'Total Charges',
                //   item!.totalAmount!,
                //   isPositive: false,
                // ),
                // _buildFinancialRow(
                //   'Payments',
                //   item!.totalCredits ?? 0,
                //   isPositive: true,
                // ),
                // const Divider(height: 24, thickness: 1.5),
                // _buildFinancialRow(
                //   'Balance Due',
                //   item!.balanceAmount!,
                //   isBalance: true,
                //   isPositive: item!.balanceAmount! <= 0,
                // ),
              ],
            ),
          ),
          const SizedBox(height: 24),
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

  Widget _buildSectionTitle(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AppColors.primary),
        const SizedBox(width: 8),
        Text(
          title,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildSharerInfoCard(SharerInfo sharer) {
    final dateFormat = DateFormat('dd MMM yyyy');
    final timeFormat = DateFormat('hh:mm a');
    return Card(
      elevation: 4,
      shadowColor: Colors.grey.withOpacity(0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ExpansionTile(
        leading: Icon(Icons.person, color: AppColors.primary),
        title: Text(
          sharer.fullNameWithTitle,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
          ),
        ),

        iconColor: AppColors.primary,
        collapsedIconColor: Colors.grey.shade600,
        childrenPadding: const EdgeInsets.all(16),
        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        expandedCrossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: _backgroundCardDecoration(),
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionTitle('Guest Information', Icons.info_outline),
                const SizedBox(height: 12),

                _buildInfoRowSharer(
                  'Name',
                  sharer.fullNameWithTitle,
                  Icons.person,
                ),
                _buildInfoRowSharer(
                  'Gender',
                  sharer.gender == 'M' ? 'Male' : 'Female',
                  sharer.gender == 'M' ? Icons.male : Icons.female,
                ),
                _buildInfoRowSharer('Mobile', sharer.mobile, Icons.phone),
                _buildInfoRowSharer('Email', sharer.email, Icons.email),
              ],
            ),
          ),
          const SizedBox(height: 24),
          _buildSectionTitle('Transport Information', Icons.directions),
          const SizedBox(height: 12),

          Container(
            decoration: _backgroundCardDecoration(),
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Pickup',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),

                if (sharer.pickUpDropOffDataModel.pickUpDateTime != null)
                  _buildInfoRowSharer(
                    'Date',
                    dateFormat.format(
                      sharer.pickUpDropOffDataModel.pickUpDateTime!,
                    ),
                    Icons.calendar_today,
                  ),
                if (sharer.pickUpDropOffDataModel.pickUpDateTime != null)
                  _buildInfoRowSharer(
                    'Time',
                    timeFormat.format(
                      sharer.pickUpDropOffDataModel.pickUpDateTime!,
                    ),
                    Icons.alarm,
                  ),
                _buildInfoRowSharer(
                  'Mode',
                  _reservationVm.getPickupDropOffModeName(
                    sharer.pickUpDropOffDataModel.pickUpModeId,
                  ),
                  Icons.directions_car,
                ),
                _buildInfoRowSharer(
                  'Vehicle No',
                  sharer.pickUpDropOffDataModel.pickUpVehicleNo,
                  Icons.local_taxi,
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),
          Container(
            decoration: _backgroundCardDecoration(),
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Dropoff',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),

                if (sharer.pickUpDropOffDataModel.dropOffDateTime != null)
                  _buildInfoRowSharer(
                    'Date',
                    dateFormat.format(
                      sharer.pickUpDropOffDataModel.dropOffDateTime!,
                    ),
                    Icons.calendar_today,
                  ),
                if (sharer.pickUpDropOffDataModel.dropOffDateTime != null)
                  _buildInfoRowSharer(
                    'Time',
                    timeFormat.format(
                      sharer.pickUpDropOffDataModel.dropOffDateTime!,
                    ),
                    Icons.alarm,
                  ),
                _buildInfoRowSharer(
                  'Mode',
                  _reservationVm.getPickupDropOffModeName(
                    sharer.pickUpDropOffDataModel.dropOffModeId,
                  ),
                  Icons.directions_car,
                ),
                _buildInfoRowSharer(
                  'Vehicle No',
                  sharer.pickUpDropOffDataModel.dropOffVehicleNo,
                  Icons.local_taxi,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  BoxDecoration _backgroundCardDecoration() {
    return BoxDecoration(
      color: AppColors.primary.withOpacity(0.08),
      borderRadius: BorderRadius.circular(8),
      border: Border.all(color: AppColors.primary.withOpacity(0.25), width: 1),
    );
  }

  Widget _buildInfoRowSharer(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon, size: 20, color: Colors.grey.shade600),
          const SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: Text(
              '$label:',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey.shade700,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value.isEmpty ? '-' : value,
              style: Theme.of(context).textTheme.bodySmall,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFolioDropdown() {
    return Row(
      children: [
        const SizedBox(width: 8),
        Expanded(
          child: Obx(
            () => DropdownButtonFormField<String>(
              value: _reservationVm.selectedFolio.value.isNotEmpty
                  ? _reservationVm.selectedFolio.value
                  : null,
              onChanged: (value) {
                if (value != null) {
                  _reservationVm.selectedFolio.value = value;
                  final folioId = _reservationVm.allFolios
                      .firstWhere((f) => f.folioNo == value)
                      .folioId;
                  _reservationVm.loadFolioData(folioId);
                }
              },
              items: _reservationVm.allFolios.map((folio) {
                return DropdownMenuItem<String>(
                  value: folio.folioNo,
                  child: Text(
                    '${folio.folioNo} - ${folio.name}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                );
              }).toList(),
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: AppColors.primary, width: 1.5),
                ),
              ),
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Colors.black87),
              dropdownColor: Colors.white,
              icon: Icon(Icons.arrow_drop_down, color: Colors.grey.shade600),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGuestInfoTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildModernCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildCardHeader(
                  context,
                  'Contact Information',
                  Icons.contact_phone,
                ),
                const SizedBox(height: 16),
                _buildEnhancedInfoRow(
                  context,
                  'Phone',
                  item!.phone ?? '-',
                  Icons.phone,
                ),
                _buildEnhancedInfoRow(
                  context,
                  'Mobile',
                  item!.mobile ?? '-',
                  Icons.smartphone,
                ),
                _buildEnhancedInfoRow(
                  context,
                  'Email',
                  item!.email ?? '-',
                  Icons.email,
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),
          _buildModernCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildCardHeader(context, 'Identity Information', Icons.badge),
                const SizedBox(height: 16),
                _buildEnhancedInfoRow(
                  context,
                  'ID Type',
                  item!.idType ?? 'Passport',
                  Icons.credit_card,
                ),
                _buildEnhancedInfoRow(
                  context,
                  'ID Number',
                  item!.idNumber ?? '-',
                  Icons.numbers,
                ),
                _buildEnhancedInfoRow(
                  context,
                  'Expiry Date',
                  item!.expiryDate ?? '-',
                  Icons.event,
                ),
                _buildEnhancedInfoRow(
                  context,
                  'Date of Birth',
                  item!.dob ?? '-',
                  Icons.cake,
                ),
                _buildEnhancedInfoRow(
                  context,
                  'Nationality',
                  item!.nationalityName ?? '',
                  Icons.flag,
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          _buildModernCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildCardHeader(context, 'Sharer Information', Icons.share),
                ...item!.sharerInfo!.map(
                  (sharer) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _buildSharerInfoCard(sharer),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRoomChargesTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...item!.roomChargesList!.map(
            (roomCharge) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _buildModernCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildCardHeader(
                      context,
                      DateFormat(
                        'dd MMM yyyy',
                      ).format(DateTime.parse(roomCharge.dateOfStay)),
                      Icons.receipt_long,
                    ),
                    const SizedBox(height: 16),
                    _buildEnhancedInfoRow(
                      context,
                      'Room',
                      roomCharge.roomName,
                      Icons.meeting_room,
                    ),
                    _buildEnhancedInfoRow(
                      context,
                      'Rate Type',
                      roomCharge.rateTypeName,
                      Icons.label,
                    ),
                    _buildEnhancedInfoRow(
                      context,
                      'Occupancy',
                      '${roomCharge.noOfAdults} Adults, ${roomCharge.noOfChildren} Children',
                      Icons.people,
                    ),
                    const SizedBox(height: 16),
                    _buildCardHeader(
                      context,
                      'Charge Details',
                      Icons.receipt_long,
                    ),
                    const SizedBox(height: 16),
                    _buildChargeRow(
                      'Room Charge',
                      item!.visibleCurrencyCode!,
                      item!.conversionRate! > 0
                          ? roomCharge.grossAmount / item!.conversionRate!
                          : 0,
                    ),
                    _buildChargeRow(
                      'Discount',
                      item!.visibleCurrencyCode!,
                      item!.conversionRate! > 0
                          ? roomCharge.discount / item!.conversionRate!
                          : 0,
                    ),
                    _buildChargeRow(
                      'Tax Amount',
                      item!.visibleCurrencyCode!,
                      item!.conversionRate! > 0
                          ? roomCharge.taxAmount / item!.conversionRate!
                          : 0,
                    ),
                    _buildChargeRow(
                      'Auto Adjustment',
                      item!.visibleCurrencyCode!,
                      item!.conversionRate! > 0
                          ? roomCharge.roundOffAmount / item!.conversionRate!
                          : 0,
                    ),
                    const Divider(height: 24, thickness: 1.5),
                    _buildChargeRow(
                      'Net Amount',
                      item!.visibleCurrencyCode!,
                      item!.conversionRate! > 0
                          ? roomCharge.totalAmount / item!.conversionRate!
                          : 0,
                      isTotal: true,
                    ),
                    const Divider(height: 24, thickness: 1.5),
                    _buildChargeRowText(
                      context,
                      'Modified By',
                      roomCharge.modifiedUserName,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFolioDetailsTab() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Icon(
                Icons.account_balance_wallet,
                color: AppColors.primary,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Folio:',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.black87,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Obx(
                  () => DropdownButtonFormField<String>(
                    value: _reservationVm.selectedFolio.value,
                    onChanged: (value) {
                      if (value != null) {
                        _reservationVm.selectedFolio.value = value;
                        final folioId = _reservationVm.allFolios
                            .firstWhere((f) => f.folioNo == value)
                            .folioId;
                        _reservationVm.loadFolioData(folioId);
                      }
                    },
                    items: _reservationVm.allFolios.map((folio) {
                      return DropdownMenuItem<String>(
                        value: folio.folioNo,
                        child: Text('${folio.folioNo} - ${folio.name}'),
                      );
                    }).toList(),
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          color: Colors.grey.shade300,
                          width: 1,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          color: Colors.grey.shade300,
                          width: 1,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          color: AppColors.primary,
                          width: 1.5,
                        ),
                      ),
                    ),
                    style: const TextStyle(color: Colors.black87, fontSize: 15),
                    dropdownColor: Colors.white,
                    icon: Icon(
                      Icons.arrow_drop_down,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        TabBar(
          controller: _tabController,
          labelColor: AppColors.primary,
          unselectedLabelColor: Colors.grey,
          indicatorColor: AppColors.primary,
          tabs: const [
            Tab(text: 'Charges'),
            Tab(text: 'Payments'),
          ],
        ),

        Obx(
          () => Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _reservationVm.folioCharges.isEmpty
                    ? Center(
                        child: Text(
                          'No charges found',
                          style: TextStyle(color: Colors.grey.shade600),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: _reservationVm.folioCharges.length,
                        itemBuilder: (context, index) {
                          final charge = _reservationVm.folioCharges[index];

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: _buildModernCard(
                              onTap: () async {
                                await _reservationVm.loadTaxDetails(
                                  charge.folioChargeId,
                                );

                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return FolioChargeDetailsDialog(
                                      charge: charge,
                                      taxes: _reservationVm.folioTaxList,
                                      baseCurrencySymbol:
                                          item!.visibleCurrencyCode!,
                                    );
                                  },
                                );
                              },
                              child: Container(
                                margin: const EdgeInsets.only(bottom: 12),
                                child: Padding(
                                  padding: const EdgeInsets.all(5),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Text(
                                              charge.chargeName,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleMedium
                                                  ?.copyWith(
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors
                                                        .black87, // optional, adjust as needed
                                                  ),
                                            ),
                                          ),
                                          Text(
                                            formatCurrency(
                                              charge.amount,
                                              _baseCurrencyCode,
                                            ),
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleMedium
                                                ?.copyWith(
                                                  fontWeight: FontWeight.bold,
                                                  color: AppColors.primary,
                                                ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.calendar_today,
                                            size: 14,
                                            color: Colors.grey.shade600,
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            DateFormat(
                                              'yyyy-MM-dd',
                                            ).format(charge.date),
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium
                                                ?.copyWith(
                                                  color: Colors.grey.shade600,
                                                ),
                                          ),

                                          const SizedBox(width: 16),
                                          Icon(
                                            Icons.person,
                                            size: 14,
                                            color: Colors.grey.shade600,
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            charge.user,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium
                                                ?.copyWith(
                                                  color: Colors.grey.shade600,
                                                ),
                                          ),

                                          const SizedBox(width: 16),
                                          Text(
                                            'Ref #${charge.referenceNo}',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium
                                                ?.copyWith(
                                                  color: Colors.grey.shade600,
                                                ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                _reservationVm.folioPayments.isEmpty
                    ? Center(
                        child: Text(
                          'No payments found',
                          style: TextStyle(color: Colors.grey.shade600),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: _reservationVm.folioPayments.length,
                        itemBuilder: (context, index) {
                          final payment = _reservationVm.folioPayments[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: _buildModernCard(
                              onTap: () {},
                              child: Container(
                                margin: const EdgeInsets.only(bottom: 12),
                                child: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Text(
                                              payment.paymentMode,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyLarge
                                                  ?.copyWith(
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                            ),
                                          ),
                                          Text(
                                            formatCurrency(
                                              payment.totalAmount,
                                              _baseCurrencyCode,
                                            ),
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyLarge
                                                ?.copyWith(
                                                  fontWeight: FontWeight.bold,
                                                  color: AppColors.primary,
                                                ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.calendar_today,
                                            size: 14,
                                            color: Colors.grey.shade600,
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            DateFormat(
                                              'yyyy-MM-dd',
                                            ).format(payment.dateOfStay),
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium
                                                ?.copyWith(
                                                  color: Colors.grey.shade600,
                                                ),
                                          ),
                                          const SizedBox(width: 16),
                                          Icon(
                                            Icons.meeting_room,
                                            size: 14,
                                            color: Colors.grey.shade600,
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            'Room: ${payment.roomName}',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium
                                                ?.copyWith(
                                                  color: Colors.grey.shade600,
                                                ),
                                          ),
                                          const SizedBox(width: 16),
                                          Icon(
                                            Icons.person,
                                            size: 14,
                                            color: Colors.grey.shade600,
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            'User: ${payment.user}',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium
                                                ?.copyWith(
                                                  color: Colors.grey.shade600,
                                                ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAuditTrailShimmer() {
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: 6,
      itemBuilder: (_, __) {
        return Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(height: 14, width: 120, color: Colors.white),
                const SizedBox(height: 6),
                Container(height: 16, width: 180, color: Colors.white),
                const SizedBox(height: 6),
                Container(
                  height: 14,
                  width: double.infinity,
                  color: Colors.white,
                ),
                const SizedBox(height: 6),
                Container(height: 12, width: 80, color: Colors.white),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildAuditTrailTab() {
    return Obx(() {
      if (_reservationVm.isAuditTrailsLoading.value) {
        return _buildAuditTrailShimmer();
      }

      if (_reservationVm.auditTrailList.isEmpty) {
        return Center(
          child: Text(
            'No audit trails available',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: Colors.grey.shade600),
          ),
        );
      }

      return ListView.separated(
        padding: const EdgeInsets.all(12),
        itemCount: _reservationVm.auditTrailList.length,
        separatorBuilder: (_, __) => const Divider(height: 24),
        itemBuilder: (context, index) {
          final item = _reservationVm.auditTrailList[index];

          final dateTime = DateTime.tryParse(item.sysDateCreated);
          final dateTimeText = dateTime != null
              ? DateFormat('dd/MM/yyyy  •  hh:mm a').format(dateTime)
              : '';

          final textTheme = Theme.of(context).textTheme;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Transaction Type
              Text(
                item.transactionTypeName,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.darkgrey,
                ),
              ),

              const SizedBox(height: 6),

              /// Description (highlighted)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: AppColors.primary.withOpacity(0.25),
                    width: 1,
                  ),
                ),
                child: RichText(
                  text: TextSpan(
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: Colors.black87),
                    children: [
                      TextSpan(
                        text: 'Description: ',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      TextSpan(text: item.description),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 10),

              /// Footer: User (left) | DateTime (right)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  /// User
                  // User row
                  Row(
                    children: [
                      Icon(
                        Icons.person_outline,
                        size: 16,
                        color: Colors.grey.shade600,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        item.userName,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ],
                  ),

                  // Date & Time row with clock icon
                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        size: 14,
                        color: Colors.grey.shade600,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        dateTimeText,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          );
        },
      );
    });
  }

  Widget _buildRemarksTab() {
    return Obx(() {
      if (_reservationVm.isBookingRemarksLoading.value) {
        return _buildAuditTrailShimmer();
      }

      if (_reservationVm.bookingRemarksList.isEmpty) {
        return Center(
          child: Text(
            'No remarks available',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: Colors.grey),
          ),
        );
      }

      return ListView.separated(
        padding: const EdgeInsets.all(12),
        itemCount: _reservationVm.bookingRemarksList.length,
        separatorBuilder: (_, __) => const Divider(height: 24),
        itemBuilder: (context, index) {
          final remark = _reservationVm.bookingRemarksList[index];

          final dateTime = DateTime.tryParse(
            remark.sysDateCreated.toIso8601String(),
          );

          final dateTimeText = dateTime != null
              ? DateFormat('dd/MM/yyyy  •  hh:mm a').format(dateTime)
              : '';

          final textTheme = Theme.of(context).textTheme;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                remark.remarkTypeName,
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.darkgrey,
                ),
              ),

              const SizedBox(height: 6),
              Text(
                remark.remarkName,
                style: textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: AppColors.primary.withOpacity(0.25),
                    width: 1,
                  ),
                ),
                child: RichText(
                  text: TextSpan(
                    style: textTheme.bodyMedium?.copyWith(
                      color: AppColors.darkgrey,
                    ),
                    children: [
                      const TextSpan(
                        text: 'Description: ',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(text: remark.description),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 10),

              /// Footer: User (left) | DateTime (right)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  /// Created By
                  Row(
                    children: [
                      Icon(
                        Icons.person_outline,
                        size: 16,
                        color: Colors.grey.shade600,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        remark.createdByUserName,
                        style: textTheme.bodySmall?.copyWith(
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ],
                  ),

                  /// Date & Time with clock icon
                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        size: 14,
                        color: Colors.grey.shade600,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        dateTimeText,
                        style: textTheme.bodySmall?.copyWith(
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          );
        },
      );
    });
  }

  Widget _buildModernCard({required Widget child, VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
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
      ),
    );
  }

  Widget _buildCardHeader(BuildContext context, String title, IconData icon) {
    final textTheme = Theme.of(context).textTheme;

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
          style: textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.black87,
            letterSpacing: 0.2,
          ),
        ),
      ],
    );
  }

  Widget _buildEnhancedInfoRow(
    BuildContext context,
    String label,
    String value,
    IconData icon,
  ) {
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.grey.shade400),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              '$label:',
              style: textTheme.bodyMedium?.copyWith(
                color: Colors.grey.shade700,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Flexible(
            child: Text(
              value.isEmpty ? '-' : value,
              style: textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
              textAlign: TextAlign.left,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateColumn(
    BuildContext context,
    String label,
    String dateTimeStr,
    IconData icon,
  ) {
    final textTheme = Theme.of(context).textTheme;

    DateTime date;
    try {
      date = DateTime.parse(dateTimeStr);
    } catch (e) {
      date = DateTime.now(); // fallback if parsing fails
    }

    final formattedDate = DateFormat(
      'yyyy-MMM-dd',
    ).format(date); // e.g., 2025-Dec-13
    final formattedTime = DateFormat('hh:mm a').format(date); // e.g., 03:40 PM

    return Column(
      children: [
        Icon(icon, color: AppColors.primary, size: 28),
        const SizedBox(height: 8),
        Text(
          label,
          style: textTheme.bodyMedium?.copyWith(
            color: Colors.grey.shade600,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Column(
          children: [
            Text(
              formattedDate,
              style: textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            Text(
              formattedTime,
              style: textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade700,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFinancialRow(
    BuildContext context,
    String currencyCode,
    String label,
    double amount, {
    bool isBalance = false,
    bool isPositive = false,
  }) {
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: (textTheme.bodyMedium)?.copyWith(
              fontWeight: isBalance ? FontWeight.bold : FontWeight.w500,
              color: isBalance ? Colors.black87 : Colors.grey.shade700,
            ),
          ),
          Text(
            formatCurrency(amount, currencyCode),
            style: (textTheme.bodyMedium)?.copyWith(
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

  Widget _buildChargeRow(
    String label,
    String currencyCode,
    double amount, {
    bool isDiscount = false,
    bool isTax = false,
    bool isTotal = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextTheme.of(context).bodyMedium?.copyWith(
              fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
              color: isTotal ? Colors.black87 : Colors.grey.shade700,
            ),
          ),
          Text(
            '${amount < 0 ? '-' : ''}${formatCurrency(amount.abs(), currencyCode)}',
            style: TextTheme.of(context).bodyMedium?.copyWith(
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

  Widget _buildChargeRowText(BuildContext context, String label, String text) {
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: textTheme.bodyMedium?.copyWith(
              color: Colors.grey.shade700,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            text.isEmpty ? '-' : text,
            style: textTheme.bodyMedium?.copyWith(
              color: Colors.grey.shade700,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
