// lib/features/reservations/pages/amend_stay_page.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:go_router/go_router.dart';
import 'package:inta_mobile_pms/core/config/responsive_config.dart';
import 'package:inta_mobile_pms/core/theme/app_colors.dart';
import 'package:inta_mobile_pms/core/theme/app_text_theme.dart';
import 'package:inta_mobile_pms/features/reservations/models/amend_stay_save_data.dart';
import 'package:inta_mobile_pms/features/reservations/models/guest_item.dart';
import 'package:inta_mobile_pms/features/reservations/viewmodels/amend_stay_vm.dart';
import 'package:intl/intl.dart';

class AmendStay extends StatefulWidget {
  final GuestItem? guestItem;

  const AmendStay({super.key, this.guestItem});

  @override
  State<AmendStay> createState() => _AmendStayState();
}

class _AmendStayState extends State<AmendStay> {
  final _amendStayVm = Get.find<AmendStayVm>();

  bool isManualRate = false;
  bool isOverrideRate = false;
  bool isApplyToAll = false;
  bool isEnabledTaxInclusive = false;
  String currencyCode = '';
  // Controllers
  final TextEditingController _rateController = TextEditingController();
  late TextEditingController _arrivalController = TextEditingController();
  late TextEditingController _departureController = TextEditingController();
  final TextEditingController _arrivalTimeController = TextEditingController();
  final TextEditingController _departureTimeController =
      TextEditingController();

  TimeOfDay? _selectedArrivalTime;
  TimeOfDay? _selectedDepartureTime;

  // bool _overrideRoomRate = false;
  DateTime? _selectedArrival;
  DateTime? _selectedDeparture;

  // String? _selectedRoomType;
  // String? _selectedRoom;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (mounted) {
        String? _folioId = widget.guestItem?.folioId;
        int? folioId = int.tryParse(_folioId!);

        int? roomId = widget.guestItem?.roomId;
        String? _bookingRoomId = widget.guestItem?.bookingRoomId;

        int? bookingRoomId = int.tryParse(_bookingRoomId!);
        String? amendCheckinDate = widget.guestItem?.arrivalTime;

        await _amendStayVm.loadAmendStayData(
          folioId!,
          roomId!,
          bookingRoomId!,
          amendCheckinDate!,
        );
        _initializeData();
      }
    });
  }

  void _initializeData() {
    final amendStayData = _amendStayVm.amendStayData.value;
    final folioDetails = _amendStayVm.folioDetails.value;
    if (amendStayData != null) {
      _selectedArrival = _parseDateString(amendStayData.arrivalDate);
      _selectedDeparture = _parseDateString(amendStayData.departureDate);
      _selectedArrivalTime = parseTimeOfDaySafe(amendStayData.arrivalTime);
      _selectedDepartureTime = parseTimeOfDaySafe(amendStayData.departureTime);

      _arrivalController.text = DateFormat(
        'MMM dd, yyyy',
      ).format(_selectedArrival!);
      _departureController.text = DateFormat(
        'MMM dd, yyyy',
      ).format(_selectedDeparture!);
      _arrivalTimeController.text = _formatTime(_selectedArrivalTime!);
      _departureTimeController.text = _formatTime(_selectedDepartureTime!);
    }

    if (folioDetails != null) {
      currencyCode = folioDetails.visibleCurrencyCode;
    }
  }

  DateTime _parseDateString(String? dateStr) {
    if (dateStr == null || dateStr.trim().isEmpty) {
      return DateTime.now();
    }
    try {
      final parts = dateStr.trim().split(RegExp(r'\s+'));
      if (parts.length == 2) {
        final month = _monthNameToNumber(parts[0]);
        final day = int.parse(parts[1]);
        return DateTime(DateTime.now().year, month, day);
      }
    } catch (e) {
      throw Exception('Error parse date string: $e');
    }
    return DateTime.now();
  }

  int _monthNameToNumber(String monthName) {
    const months = {
      'Jan': 1,
      'Feb': 2,
      'Mar': 3,
      'Apr': 4,
      'May': 5,
      'Jun': 6,
      'Jul': 7,
      'Aug': 8,
      'Sep': 9,
      'Oct': 10,
      'Nov': 11,
      'Dec': 12,
    };
    return months[monthName] ?? 1;
  }

  String _formatTime(TimeOfDay time) {
    final hour = time.hourOfPeriod.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return "$hour:$minute $period";
  }

  TimeOfDay parseTimeOfDaySafe(String? timeString) {
    if (timeString == null || timeString.trim().isEmpty) {
      return TimeOfDay.now();
    }

    final parts = timeString.split(RegExp(r'[:\s]'));
    if (parts.length < 3) {
      return TimeOfDay.now();
    }

    int hour = int.tryParse(parts[0]) ?? 0;
    int minute = int.tryParse(parts[1]) ?? 0;
    final period = parts[2].toUpperCase();

    if (period == "PM" && hour != 12) {
      hour += 12;
    } else if (period == "AM" && hour == 12) {
      hour = 0;
    }

    return TimeOfDay(hour: hour, minute: minute);
  }

  @override
  void dispose() {
    _arrivalController.dispose();
    _departureController.dispose();
    _arrivalController.dispose();
    _arrivalTimeController.dispose();
    _departureTimeController.dispose();
    _rateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(context),
      body: _buildBody(context),
      bottomNavigationBar: _buildBottomActions(context),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.surface,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.close, color: AppColors.black),
        onPressed: () => context.pop(),
      ),
      title: Text(
        'Amend Stay',
        style: AppTextTheme.lightTextTheme.titleMedium?.copyWith(
          color: AppColors.black,
          fontWeight: FontWeight.w600,
        ),
      ),
      centerTitle: false,
    );
  }

  Widget _buildOverrideRateSection(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(
          ResponsiveConfig.cardRadius(context),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          ResponsiveConfig.defaultPadding(context),
          ResponsiveConfig.defaultPadding(context),
          ResponsiveConfig.defaultPadding(context),
          8,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Is Override Rate',
              style: AppTextTheme.lightTextTheme.bodySmall?.copyWith(
                color: AppColors.darkgrey,
                fontWeight: FontWeight.w500,
              ),
            ),
            Switch(
              value: isOverrideRate,
              onChanged: (v) => setState(() => isOverrideRate = v),
              activeColor: AppColors.surface,
              activeTrackColor: AppColors.blue,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildApplyToAllSection(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(
          ResponsiveConfig.cardRadius(context),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          ResponsiveConfig.defaultPadding(context),
          ResponsiveConfig.defaultPadding(context),
          ResponsiveConfig.defaultPadding(context),
          8,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Apply To All',
              style: AppTextTheme.lightTextTheme.bodySmall?.copyWith(
                color: AppColors.darkgrey,
                fontWeight: FontWeight.w500,
              ),
            ),
            Switch(
              value: isApplyToAll,
              onChanged: (v) => setState(() => isApplyToAll = v),
              activeColor: AppColors.surface,
              activeTrackColor: AppColors.blue,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRateSection(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(ResponsiveConfig.defaultPadding(context)),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(
          ResponsiveConfig.cardRadius(context),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          /// --- Left Side: Switches + Labels ---
          Row(
            children: [
              // Main "Rate" switch
              Switch(
                value: isManualRate,
                onChanged: (v) => setState(() => isManualRate = v),
                activeColor: AppColors.surface,
                activeTrackColor: AppColors.blue,
              ),
              const SizedBox(width: 6),
              Text(
                'Rate',
                style: AppTextTheme.lightTextTheme.bodySmall?.copyWith(
                  color: AppColors.darkgrey,
                  fontWeight: FontWeight.w500,
                ),
              ),

              // Tax Inclusive toggle (only visible if Rate enabled)
              if (isManualRate) ...[
                const SizedBox(width: 20),
                Switch(
                  value: isEnabledTaxInclusive,
                  onChanged: (v) => setState(() => isEnabledTaxInclusive = v),
                  activeColor: AppColors.surface,
                  activeTrackColor: AppColors.blue,
                ),
                const SizedBox(width: 6),
                Text(
                  'Tax Inclusive',
                  style: AppTextTheme.lightTextTheme.bodySmall?.copyWith(
                    color: AppColors.darkgrey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ],
          ),

          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 100,
                child: TextField(
                  controller: _rateController,
                  enabled: isManualRate,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                      RegExp(r'^\d*\.?\d{0,2}'),
                    ),
                  ],
                  decoration: InputDecoration(
                    hintText: '0.00',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 8,
                    ),
                  ),
                  onChanged: (_) {},
                ),
              ),
              const SizedBox(width: 8),
              Text(
                currencyCode,
                style: AppTextTheme.lightTextTheme.bodySmall?.copyWith(
                  color: AppColors.darkgrey,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  double? _getRateValue() {
    final text = _rateController.text.trim();
    if (text.isEmpty) return null;
    return double.tryParse(text);
  }

  Widget _buildBody(BuildContext context) {
    return SingleChildScrollView(
      padding: ResponsiveConfig.horizontalPadding(
        context,
      ).add(ResponsiveConfig.verticalPadding(context)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildGuestInfoSection(context),
          SizedBox(height: ResponsiveConfig.listItemSpacing(context)),
          _buildDateSection(context),
          SizedBox(height: ResponsiveConfig.listItemSpacing(context)),
          _buildOverrideRateSection(context),
          SizedBox(height: ResponsiveConfig.listItemSpacing(context)),
          if (isOverrideRate == true) _buildRateSection(context),
          SizedBox(height: ResponsiveConfig.listItemSpacing(context)),
          if (isOverrideRate == true) _buildApplyToAllSection(context),
        ],
      ),
    );
  }

  Widget _buildGuestInfoSection(BuildContext context) {
    return _buildSection(
      context,
      child: Column(
        children: [
          _buildInfoRow('Guest Name', widget.guestItem?.guestName ?? ''),
          _buildDivider(),
          _buildInfoRow('Res #', widget.guestItem?.resId ?? ''),
        ],
      ),
    );
  }

  Widget _buildDateSection(BuildContext context) {
    return _buildSection(
      context,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16.0,
          vertical: 8.0,
        ), // 🌟 overall padding
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Arrival
            Padding(
              padding: const EdgeInsets.only(
                bottom: 12.0,
              ), // spacing below Arrival row
              child: Obx(() {
                final amendStayData = _amendStayVm.amendStayData.value;
                return _buildDateRow(
                  context,
                  'Arrival',
                  _arrivalController,
                  _arrivalTimeController,
                  DateTime.tryParse(amendStayData?.arrivalDate ?? ''),
                  parseTimeOfDaySafe(amendStayData?.arrivalTime ?? ''),
                  (date) => setState(() {
                    _selectedArrival = date;
                    _arrivalController.text = date.toString();
                  }),
                  (time) => setState(() {
                    _selectedArrivalTime = time;
                    _arrivalTimeController.text = time.toString();
                  }),
                );
              }),
            ),

            // Departure
            Obx(() {
              final amendStayData = _amendStayVm.amendStayData.value;
              return _buildDateRow(
                context,
                'Departure',
                _departureController,
                _departureTimeController,
                DateTime.tryParse(amendStayData?.departureDate ?? ''),
                parseTimeOfDaySafe(amendStayData?.departureTime ?? ''),
                (date) => setState(() {
                  _selectedDeparture = date;
                  _departureController.text = date.toString();
                }),
                (time) => setState(() {
                  _selectedDepartureTime = time;
                  _departureTimeController.text = time.toString();
                }),
              );
            }),
          ],
        ),
      ),
    );
  }

  // Widget _buildOverrideRateSection(BuildContext context) {
  //   return _buildSection(
  //     context,
  //     child: _buildSwitchRow(
  //       'Override Room Rate',
  //       _overrideRoomRate,
  //       (value) => setState(() => _overrideRoomRate = value),
  //     ),
  //   );
  // }

  Widget _buildSection(BuildContext context, {required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(
          ResponsiveConfig.cardRadius(context),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.all(ResponsiveConfig.defaultPadding(context)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppTextTheme.lightTextTheme.bodyMedium?.copyWith(
              color: AppColors.darkgrey,
              fontWeight: FontWeight.w500,
            ),
          ),
          Flexible(
            child: Text(
              value,
              style: AppTextTheme.lightTextTheme.bodyMedium?.copyWith(
                color: AppColors.black,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.end,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateRow(
    BuildContext context,
    String label,
    TextEditingController dateController,
    TextEditingController timeController,
    DateTime? selectedDate,
    TimeOfDay? selectedTime,
    ValueChanged<DateTime> onDatePicked,
    ValueChanged<TimeOfDay> onTimePicked,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextTheme.lightTextTheme.bodyMedium?.copyWith(
            color: AppColors.darkgrey,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            // Date picker
            Expanded(
              flex: 2,
              child: TextField(
                controller: dateController,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'Date',
                  suffixIcon: const Icon(Icons.calendar_today),
                  border: const OutlineInputBorder(),
                ),
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: selectedDate ?? DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (picked != null) {
                    onDatePicked(picked);
                    dateController.text = DateFormat(
                      'MMM dd, yyyy',
                    ).format(picked);
                  }
                },
              ),
            ),
            const SizedBox(width: 8),
            // Time picker
            Expanded(
              flex: 1,
              child: TextField(
                controller: timeController,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'Time',
                  suffixIcon: const Icon(Icons.access_time),
                  border: const OutlineInputBorder(),
                ),
                onTap: () async {
                  final picked = await showTimePicker(
                    context: context,
                    initialTime: selectedTime ?? TimeOfDay.now(),
                    initialEntryMode:
                        TimePickerEntryMode.input, // allow any minute
                  );
                  if (picked != null) {
                    onTimePicked(picked);
                    timeController.text = picked.format(context);
                  }
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSwitchRow(
    String label,
    bool value,
    ValueChanged<bool> onChanged,
  ) {
    return Padding(
      padding: EdgeInsets.all(ResponsiveConfig.defaultPadding(context)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppTextTheme.lightTextTheme.bodyMedium?.copyWith(
              color: AppColors.darkgrey,
              fontWeight: FontWeight.w500,
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppColors.primary,
            inactiveThumbColor: Colors.grey.shade400,
            inactiveTrackColor: Colors.grey.shade300,
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 1,
      color: Colors.grey.shade200,
      indent: ResponsiveConfig.defaultPadding(context),
      endIndent: ResponsiveConfig.defaultPadding(context),
    );
  }

  Widget _buildBottomActions(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(ResponsiveConfig.defaultPadding(context)),
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () => context.pop(),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppColors.lightgrey),
                padding: EdgeInsets.symmetric(
                  vertical: ResponsiveConfig.defaultPadding(context),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'Cancel',
                style: AppTextTheme.lightTextTheme.bodyMedium?.copyWith(
                  color: AppColors.lightgrey,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: ElevatedButton(
              onPressed: _handleSave,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: EdgeInsets.symmetric(
                  vertical: ResponsiveConfig.defaultPadding(context),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 0,
              ),
              child: Text(
                'Save',
                style: AppTextTheme.lightTextTheme.bodyMedium?.copyWith(
                  color: AppColors.onPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showDatePicker(
    BuildContext context,
    DateTime? initialDate,
    ValueChanged<DateTime> onDateSelected,
  ) async {
    final DateTime today = DateTime.now();
    final DateTime todayDate = DateTime(today.year, today.month, today.day);

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate ?? todayDate,
      firstDate: todayDate,
      lastDate: todayDate.add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: AppColors.primary,
              onPrimary: AppColors.onPrimary,
              surface: AppColors.surface,
              onSurface: AppColors.onSurface,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != initialDate) {
      onDateSelected(picked);
    }
  }

  void _handleSave() async {
    if (_selectedArrival != null && _selectedDeparture != null) {
      if (_selectedDeparture!.isBefore(_selectedArrival!)) {
        _showErrorSnackBar('Departure date must be after arrival date');
        return;
      }
    } else {
      _showErrorSnackBar('Please select valid arrival and departure dates');
      return;
    }
    final folioDetails = _amendStayVm.folioDetails.value;
    String arrivalDate =
        '${convertToYMDFormat(_arrivalController.text)} ${convertTo24HourFormat(_arrivalTimeController.text)}';
    String departureDate =
        '${convertToYMDFormat(_departureController.text)} ${convertTo24HourFormat(_departureTimeController.text)}';

    // final saveData = {
    //   "applyToWholeStay": isApplyToAll,
    //   "arrivalDate": arrivalDate,
    //   "bookingRoomId": widget.guestItem?.bookingRoomId,
    //   "currencyId": folioDetails?.visibleCurrencyId,
    //   "departureDate": departureDate,
    //   "isManualRate": isManualRate,
    //   "isOverrideRate": isOverrideRate,
    //   "isTaxInclusive": isEnabledTaxInclusive,
    //   "manualRate": _getRateValue(),
    // };

    final saveData = AmendStaySaveData(
      applyToWholeStay: isApplyToAll,
      arrivalDate: arrivalDate,
      bookingRoomId: int.tryParse(widget.guestItem?.bookingRoomId ?? '')!,
      currencyId: folioDetails?.visibleCurrencyId ?? 0,
      departureDate: departureDate,
      isManualRate: isManualRate,
      isOverrideRate: isOverrideRate,
      isTaxInclusive: isEnabledTaxInclusive,
      manualRate: _getRateValue() ?? 0.0,
    );
    await _amendStayVm.saveAmendStay(saveData);
    if (!mounted) return;
    context.pop();
  }

  String convertTo24HourFormat(String time12) {
    try {
      DateTime dateTime = DateFormat("hh:mm a").parse(time12);
      String time24 = DateFormat("HH:mm").format(dateTime);
      return time24;
    } catch (e) {
      throw Exception('Error convertTo24HourFormat: $e');
    }
  }

  String convertToYMDFormat(String dateString) {
    try {
      DateTime parsedDate = DateFormat('MMM dd, yyyy').parse(dateString);
      String formattedDate = DateFormat('yyyy-MM-dd').format(parsedDate);
      return formattedDate;
    } catch (e) {
      throw Exception('Error convertToYMDFormat: $e');
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}
