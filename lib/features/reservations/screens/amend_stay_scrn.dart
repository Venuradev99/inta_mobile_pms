// lib/features/reservations/pages/amend_stay_page.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:inta_mobile_pms/core/config/responsive_config.dart';
import 'package:inta_mobile_pms/core/theme/app_colors.dart';
import 'package:inta_mobile_pms/core/theme/app_text_theme.dart';
import 'package:inta_mobile_pms/features/reservations/models/guest_item.dart';
import 'package:inta_mobile_pms/router/app_routes.dart';

class AmendStay extends StatefulWidget {
  final GuestItem? guestItem;

  const AmendStay({
    super.key,
    this.guestItem,
  });

  @override
  State<AmendStay> createState() => _AmendStayState();
}

class _AmendStayState extends State<AmendStay> {
  // Controllers
  late TextEditingController _arrivalController;
  late TextEditingController _departureController;
  
  // Form state
  bool _overrideRoomRate = false;
  DateTime? _selectedArrival;
  DateTime? _selectedDeparture;
  
  // Sample data - replace with actual data models
  final List<String> _roomTypes = [
    'Single Room',
    'Double Room',
    'Double Room new',
    'Suite',
    'Deluxe Room',
    'Executive Suite'
  ];
  
  final List<String> _rooms = [
    'Test',
    '101',
    '102',
    '201',
    '202',
    'Presidential Suite'
  ];
  
  String? _selectedRoomType;
  String? _selectedRoom;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  void _initializeData() {
    // Initialize with existing guest data if available
    if (widget.guestItem != null) {
      _selectedArrival = _parseDateString(widget.guestItem!.startDate);
      _selectedDeparture = _parseDateString(widget.guestItem!.endDate);
      _selectedRoomType = widget.guestItem!.roomType;
      _selectedRoom = 'Test'; 
    } else {
      // Default values
      _selectedArrival = DateTime.now();
      _selectedDeparture = DateTime.now().add(const Duration(days: 1));
      _selectedRoomType = _roomTypes.first;
      _selectedRoom = _rooms.first;
    }
    
    _arrivalController = TextEditingController(
      text: _formatDate(_selectedArrival!),
    );
    _departureController = TextEditingController(
      text: _formatDate(_selectedDeparture!),
    );
  }

  DateTime _parseDateString(String dateStr) {

    try {
      final parts = dateStr.split(' ');
      if (parts.length == 2) {
        final month = _monthNameToNumber(parts[0]);
        final day = int.parse(parts[1]);
        return DateTime(DateTime.now().year, month, day);
      }
    } catch (e) {
    
    }
    return DateTime.now();
  }

  int _monthNameToNumber(String monthName) {
    const months = {
      'Jan': 1, 'Feb': 2, 'Mar': 3, 'Apr': 4, 'May': 5, 'Jun': 6,
      'Jul': 7, 'Aug': 8, 'Sep': 9, 'Oct': 10, 'Nov': 11, 'Dec': 12,
    };
    return months[monthName] ?? 1;
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year}';
  }

  @override
  void dispose() {
    _arrivalController.dispose();
    _departureController.dispose();
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
        onPressed: () => context.go(AppRoutes.arrivalList),
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

  Widget _buildBody(BuildContext context) {
    return SingleChildScrollView(
      padding: ResponsiveConfig.horizontalPadding(context).add(
        ResponsiveConfig.verticalPadding(context),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildGuestInfoSection(context),
          SizedBox(height: ResponsiveConfig.listItemSpacing(context)),
          _buildDateSection(context),
          SizedBox(height: ResponsiveConfig.listItemSpacing(context)),
          _buildOverrideRateSection(context),
        ],
      ),
    );
  }

  Widget _buildGuestInfoSection(BuildContext context) {
    return _buildSection(
      context,
      child: Column(
        children: [
          _buildInfoRow(
            'Guest Name',
            widget.guestItem?.guestName ?? 'Mr. John Doe',
          ),
          _buildDivider(),
          _buildInfoRow(
            'Res #',
            widget.guestItem?.resId ?? 'BH3000',
          ),
          _buildDivider(),
          _buildDropdownRow(
            'Room Type',
            _selectedRoomType,
            _roomTypes,
            (value) => setState(() => _selectedRoomType = value),
          ),
          _buildDivider(),
          _buildDropdownRow(
            'Room',
            _selectedRoom,
            _rooms,
            (value) => setState(() => _selectedRoom = value),
          ),
        ],
      ),
    );
  }

  Widget _buildDateSection(BuildContext context) {
    return _buildSection(
      context,
      child: Column(
        children: [
          _buildDateRow(
            context,
            'Arrival',
            _arrivalController,
            _selectedArrival,
            (date) => setState(() {
              _selectedArrival = date;
              _arrivalController.text = _formatDate(date);
            }),
          ),
          SizedBox(height: ResponsiveConfig.listItemSpacing(context)),
          _buildDateRow(
            context,
            'Departure',
            _departureController,
            _selectedDeparture,
            (date) => setState(() {
              _selectedDeparture = date;
              _departureController.text = _formatDate(date);
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildOverrideRateSection(BuildContext context) {
    return _buildSection(
      context,
      child: _buildSwitchRow(
        'Override Room Rate',
        _overrideRoomRate,
        (value) => setState(() => _overrideRoomRate = value),
      ),
    );
  }

  Widget _buildSection(BuildContext context, {required Widget child}) {
    return Container(
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

  Widget _buildDropdownRow(
    String label,
    String? value,
    List<String> items,
    ValueChanged<String?> onChanged,
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
          Flexible(
            child: DropdownButton<String>(
              value: value,
              items: items.map((String item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Text(
                    item,
                    style: AppTextTheme.lightTextTheme.bodyMedium?.copyWith(
                      color: AppColors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              }).toList(),
              onChanged: onChanged,
              underline: const SizedBox.shrink(),
              icon: const Icon(Icons.keyboard_arrow_down, color: AppColors.lightgrey),
              isExpanded: false,
              alignment: Alignment.centerRight,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateRow(
    BuildContext context,
    String label,
    TextEditingController controller,
    DateTime? selectedDate,
    ValueChanged<DateTime> onDateChanged,
  ) {
    return Container(
      padding: EdgeInsets.all(ResponsiveConfig.defaultPadding(context)),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(ResponsiveConfig.cardRadius(context)),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextTheme.lightTextTheme.bodySmall?.copyWith(
              color: AppColors.darkgrey,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller,
                  readOnly: true,
                  style: AppTextTheme.lightTextTheme.bodyMedium?.copyWith(
                    color: AppColors.black,
                    fontWeight: FontWeight.w500,
                  ),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                  ),
                  onTap: () => _showDatePicker(context, selectedDate, onDateChanged),
                ),
              ),
              IconButton(
                onPressed: () => _showDatePicker(context, selectedDate, onDateChanged),
                icon: Icon(
                  Icons.calendar_month,
                  color: AppColors.lightgrey,
                  size: ResponsiveConfig.iconSize(context),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSwitchRow(String label, bool value, ValueChanged<bool> onChanged) {
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
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate ?? DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
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

  void _handleSave() {

    if (_selectedArrival != null && _selectedDeparture != null) {
      if (_selectedDeparture!.isBefore(_selectedArrival!)) {
        _showErrorSnackBar('Departure date must be after arrival date');
        return;
      }
    }


    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Stay amended successfully'),
        backgroundColor: AppColors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
    context.pop();
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}