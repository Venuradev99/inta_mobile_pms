import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:go_router/go_router.dart';
import 'package:inta_mobile_pms/core/config/responsive_config.dart';
import 'package:inta_mobile_pms/core/theme/app_colors.dart';
import 'package:inta_mobile_pms/features/reservations/viewmodels/no_show_reservation_vm.dart';

class NoShowReservationData {
  final List<Map<String, dynamic>> reasons;
  final String bookingRoomId;
  final String guestName;
  final String reservationNumber;
  final String folio;
  final String arrivalDate;
  final String departureDate;
  final String roomType;
  final String room;
  final double total;
  final double deposit;
  final double balance;
  final double? initialNoShowFee;

  const NoShowReservationData({
    required this.bookingRoomId,
    required this.reasons,
    required this.guestName,
    required this.reservationNumber,
    required this.folio,
    required this.arrivalDate,
    required this.departureDate,
    required this.roomType,
    required this.room,
    required this.total,
    required this.deposit,
    required this.balance,
    this.initialNoShowFee,
  });

  factory NoShowReservationData.fromJson(Map<String, dynamic> json) {
    return NoShowReservationData(
      reasons:
          (json['reasons'] as List<dynamic>?)
              ?.map((e) => Map<String, dynamic>.from(e as Map))
              .toList() ??
          [],
      guestName: json['guestName'] as String,
      bookingRoomId: json['bookingRoomId'] as String,
      reservationNumber: json['reservationNumber'] as String,
      folio: json['folio'] as String,
      arrivalDate: json['arrivalDate'] as String,
      departureDate: json['departureDate'] as String,
      roomType: json['roomType'] as String,
      room: json['room'] as String,
      total: (json['total'] as num).toDouble(),
      deposit: (json['deposit'] as num).toDouble(),
      balance: (json['balance'] as num).toDouble(),
      initialNoShowFee: json['initialNoShowFee'] != null
          ? (json['initialNoShowFee'] as num).toDouble()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'reasons': reasons,
      'guestName': guestName,
      'bookingRoomId': bookingRoomId,
      'reservationNumber': reservationNumber,
      'folio': folio,
      'arrivalDate': arrivalDate,
      'departureDate': departureDate,
      'roomType': roomType,
      'room': room,
      'total': total,
      'deposit': deposit,
      'balance': balance,
      'initialNoShowFee': initialNoShowFee,
    };
  }
}

class NoShowReservationPage extends StatefulWidget {
  final NoShowReservationData data;

  const NoShowReservationPage({Key? key, required this.data}) : super(key: key);

  @override
  State<NoShowReservationPage> createState() => _NoShowReservationPageState();
}

class _NoShowReservationPageState extends State<NoShowReservationPage> {
  final _noShowReservationVm = Get.find<NoShowReservationVm>();
  late final TextEditingController _noShowFeeController;
  final TextEditingController commentController = TextEditingController();
  bool _isRateInclusiveTax = false;
  String? _selectedOwner;
  String? _selectedReason;

  @override
  void initState() {
    super.initState();
    _noShowFeeController = TextEditingController(
      text: widget.data.initialNoShowFee?.toStringAsFixed(2) ?? '0.00',
    );
    commentController.text = '';
    _noShowFeeController.addListener(() {
      setState(() {});
    });
  }

  final List<String> _owners = [
    '142 - AZA Pabasara Dissanayake',
    '143 - John Smith',
    '144 - Jane Doe',
  ];

  @override
  void dispose() {
    _noShowFeeController.dispose();
    commentController.dispose();
    super.dispose();
  }

  void _handleSave() async {
    if (_selectedReason == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a reason for no-show'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    Map<String, dynamic> result = {
      "reason": _selectedReason ?? '',
      "bookingRoomId": widget.data.bookingRoomId,
      "rate": _noShowFeeController.text,
      "isTaxInclusive": _isRateInclusiveTax,
    };

    await _noShowReservationVm.noShowReservation(result);
    if (!mounted) return;
    Get.back();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final padding = ResponsiveConfig.defaultPadding(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.close,
            color: AppColors.black,
            size: ResponsiveConfig.iconSize(context),
          ),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'No Show Reservation',
          style: theme.textTheme.titleMedium?.copyWith(
            color: AppColors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: false,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(padding),
              child: Column(
                children: [
                  _buildReservationCard(context, theme, padding),
                  SizedBox(height: padding),
                  _buildNoShowFeeCard(context, theme, padding),
                  // SizedBox(height: padding),
                  // _buildChangeOwnerCard(context, theme, padding),
                  SizedBox(height: padding),
                  _buildReasonCard(context, theme, padding),
                  SizedBox(height: padding),
                  _buildTextField(context, commentController),
                ],
              ),
            ),
          ),
          _buildBottomActions(context, theme, padding),
        ],
      ),
    );
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _showSuccessMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  Widget _buildReservationCard(
    BuildContext context,
    ThemeData theme,
    double padding,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(
          ResponsiveConfig.cardRadius(context),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildInfoRow('Guest Name', widget.data.guestName, theme),
          _buildDivider(),
          _buildInfoRow('Res #', widget.data.reservationNumber, theme),
          _buildDivider(),
          _buildInfoRow('Folio', widget.data.folio, theme),
          _buildDivider(),
          _buildInfoRow('Arrival Date', widget.data.arrivalDate, theme),
          _buildDivider(),
          _buildInfoRow('Departure Date', widget.data.departureDate, theme),
          _buildDivider(),
          _buildInfoRow('Room Type', widget.data.roomType, theme),
          _buildDivider(),
          _buildInfoRow('Room', widget.data.room, theme),
          _buildDivider(),
          _buildInfoRow(
            'Total',
            '\$ ${widget.data.total.toStringAsFixed(2)}',
            theme,
          ),
          _buildDivider(),
          _buildInfoRow(
            'Deposit',
            '\$ ${widget.data.deposit.toStringAsFixed(2)}',
            theme,
          ),
          _buildDivider(),
          _buildInfoRow(
            'Balance',
            '\$ ${widget.data.balance.toStringAsFixed(2)}',
            theme,
            isLast: true,
          ),
        ],
      ),
    );
  }

  Widget _buildNoShowFeeCard(
    BuildContext context,
    ThemeData theme,
    double padding,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(
          ResponsiveConfig.cardRadius(context),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: EdgeInsets.all(padding),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'No Show Fee',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: AppColors.darkgrey,
                ),
              ),
              SizedBox(
                width: 120,
                child: TextField(
                  controller: _noShowFeeController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  textAlign: TextAlign.right,
                  style: theme.textTheme.bodyMedium,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: AppColors.lightgrey),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: AppColors.lightgrey.withOpacity(0.3),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(
                        color: AppColors.primary,
                        width: 1.5,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: padding),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Rate Inclusive Tax',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: AppColors.darkgrey,
                ),
              ),
              Switch(
                value: _isRateInclusiveTax,
                onChanged: (value) {
                  setState(() {
                    _isRateInclusiveTax = value;
                  });
                },
                activeColor: AppColors.primary,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildChangeOwnerCard(
    BuildContext context,
    ThemeData theme,
    double padding,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(
          ResponsiveConfig.cardRadius(context),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(
              padding,
              padding * 0.75,
              padding,
              padding * 0.5,
            ),
            child: Text(
              'Change Owner',
              style: theme.textTheme.bodySmall?.copyWith(
                color: AppColors.lightgrey,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _owners.length,
            separatorBuilder: (context, index) => _buildDivider(),
            itemBuilder: (context, index) {
              final owner = _owners[index];
              return RadioListTile<String>(
                value: owner,
                groupValue: _selectedOwner,
                onChanged: (value) {
                  setState(() {
                    _selectedOwner = value;
                  });
                },
                title: Text(
                  owner,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: AppColors.darkgrey,
                  ),
                ),
                activeColor: AppColors.primary,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: padding,
                  vertical: 0,
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildReasonCard(
    BuildContext context,
    ThemeData theme,
    double padding,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(
          ResponsiveConfig.cardRadius(context),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(
              padding,
              padding * 0.75,
              padding,
              padding * 0.5,
            ),
            child: Text(
              'Reason',
              style: theme.textTheme.bodySmall?.copyWith(
                color: AppColors.lightgrey,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: widget.data.reasons.length,
            separatorBuilder: (context, index) => _buildDivider(),
            itemBuilder: (context, index) {
              final selected = widget.data.reasons[index];
              final reason = selected["name"];
              return RadioListTile<String>(
                value: reason,
                groupValue: _selectedReason,
                onChanged: (value) {
                  setState(() {
                    _selectedReason = value;
                  });
                },
                title: Text(
                  reason,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: AppColors.darkgrey,
                  ),
                ),
                activeColor: AppColors.primary,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: padding,
                  vertical: 0,
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(
    BuildContext context,
    TextEditingController controller,
  ) {
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: 'Comments',
          labelStyle: textTheme.bodyMedium?.copyWith(color: Colors.grey[700]),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 10,
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(
    String label,
    String value,
    ThemeData theme, {
    bool isLast = false,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveConfig.defaultPadding(context),
        vertical: 12,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: AppColors.darkgrey,
            ),
          ),
          Text(
            value,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: AppColors.black,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 1,
      thickness: 1,
      color: AppColors.lightgrey.withOpacity(0.2),
    );
  }

  Widget _buildBottomActions(
    BuildContext context,
    ThemeData theme,
    double padding,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      padding: EdgeInsets.all(padding),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () => Get.back(),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  side: const BorderSide(color: AppColors.lightgrey),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  'Cancel',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: AppColors.darkgrey,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            SizedBox(width: padding),
            Expanded(
              child: ElevatedButton(
                onPressed: _handleSave,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  'Save',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: AppColors.surface,
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
}
