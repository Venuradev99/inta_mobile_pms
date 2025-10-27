import 'package:flutter/material.dart';
import 'package:inta_mobile_pms/core/config/responsive_config.dart';
import 'package:inta_mobile_pms/core/theme/app_colors.dart';
import 'package:inta_mobile_pms/core/widgets/custom_appbar.dart';

class QuickReservation extends StatefulWidget {
  const QuickReservation({super.key});

  @override
  State<QuickReservation> createState() => _QuickReservationState();
}

class _QuickReservationState extends State<QuickReservation> {
  int selectedIndex = 0;
  DateTime checkInDate = DateTime.now();
  DateTime checkOutDate = DateTime.now().add(const Duration(days: 1));
  TimeOfDay checkInTime = const TimeOfDay(hour: 13, minute: 0); // Updated to ~1 PM as per screenshot
  TimeOfDay checkOutTime = const TimeOfDay(hour: 13, minute: 0);
  int nights = 1;
  String? selectedBusinessSource;
  String? selectedOta;
  String? selectedTravelAgent;
  String reservationType = 'Confirm';
  int roomCount = 1;
  String? selectedRoomType;
  String? selectedRateType;
  String? selectedRoom;
  int adultCount = 1;
  int childCount = 0;
  double rate = 0.00;
  bool rateOverride = false;
  bool returningGuest = false;
  String? selectedSalutation;
  TextEditingController guestNameController = TextEditingController();
  TextEditingController mobileNumberController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  // Dynamic totals
  double roomCharges = 0.0;
  double tax = 0.0;
  double total = 0.0;

  final List<String> options = [
    'Walk In',
    'Booking Engine',
    'OTA',
    'Travel Agent',
  ];

  final List<String> otas = [
    'Booking.com',
    'Expedia',
    'Agoda',
    'Hotels.com',
  ];

  final List<String> travelAgents = [
    'Agent A',
    'Agent B',
    'Corporate Travel Inc.',
    'Global Agents',
  ];

  final List<String> businessSources = [
    'Direct Booking',
    'Online Travel Agency',
    'Corporate Contract',
    'Group Booking',
  ];

  final List<String> reservationTypes = [
    'Confirm',
    'Tentative',
    'Waitlist',
  ];

  final List<String> roomTypes = [
    'Standard Room',
    'Deluxe Room',
    'Suite',
    'Executive Room',
  ];

  final List<String> rateTypes = [
    'Standard Rate',
    'Corporate Rate',
    'Group Rate',
    'Package Rate',
  ];

  final List<String> rooms = [
    'Room 101',
    'Room 102',
    'Room 201',
    'Room 202',
  ];

  @override
  void initState() {
    super.initState();
    _calculateNights();
    _updateTotals();
  }

  @override
  void dispose() {
    guestNameController.dispose();
    mobileNumberController.dispose();
    emailController.dispose();
    super.dispose();
  }

  void _calculateNights() {
    nights = checkOutDate.difference(checkInDate).inDays;
    if (nights <= 0) nights = 1;
    _updateTotals();
    setState(() {});
  }

  void _updateTotals() {
    roomCharges = rate * nights * roomCount;
    tax = roomCharges * 0.1; // 10% tax; adjust as needed
    total = roomCharges + tax;
  }

  Future<void> _selectDate(BuildContext context, bool isCheckIn) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isCheckIn ? checkInDate : checkOutDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() {
        if (isCheckIn) {
          checkInDate = picked;
          if (checkOutDate.isBefore(checkInDate.add(const Duration(days: 1)))) {
            checkOutDate = checkInDate.add(const Duration(days: 1));
          }
        } else {
          checkOutDate = picked;
        }
        _calculateNights();
      });
    }
  }

  Future<void> _selectTime(BuildContext context, bool isCheckIn) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: isCheckIn ? checkInTime : checkOutTime,
    );
    if (picked != null) {
      setState(() {
        if (isCheckIn) {
          checkInTime = picked;
        } else {
          checkOutTime = picked;
        }
      });
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year}';
  }

  String _formatTime(TimeOfDay time) {
    final hour = time.hourOfPeriod.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }

  bool _validateForm() {
    // Basic validation for required fields
    if (selectedRoomType == null || selectedRateType == null || adultCount < 1) {
      return false;
    }
    if (selectedIndex == 2 && selectedOta == null) return false;
    if (selectedIndex == 3 && selectedTravelAgent == null) return false;
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isMobile = ResponsiveConfig.isMobile(context);
    final defaultPadding = ResponsiveConfig.defaultPadding(context);
    final horizontalPadding = ResponsiveConfig.horizontalPadding(context);
    final cardRadius = ResponsiveConfig.cardRadius(context);
    final iconSize = ResponsiveConfig.iconSize(context);
    final listItemSpacing = ResponsiveConfig.listItemSpacing(context);
    final fontScale = ResponsiveConfig.fontScale(context);

    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(fontScale)),
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: CustomAppBar(
          title: 'Quick Reservation',
          onRefreshTap: () {},
        ),
        bottomNavigationBar: _buildBottomBar(theme, fontScale, defaultPadding, cardRadius, isMobile),
        body: SingleChildScrollView(
          padding: horizontalPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: defaultPadding),
              // Toggle Bar (Segmented Buttons)
              Container(
                padding: EdgeInsets.all(defaultPadding / 4),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(cardRadius),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(options.length, (index) {
                    final bool isSelected = selectedIndex == index;
                    return Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedIndex = index;
                            // Reset conditional fields on tab change
                            selectedOta = null;
                            selectedTravelAgent = null;
                            selectedBusinessSource = null;
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: defaultPadding),
                          margin: EdgeInsets.symmetric(horizontal: defaultPadding / 4),
                          decoration: BoxDecoration(
                            color: isSelected ? AppColors.primary : AppColors.surface,
                            borderRadius: BorderRadius.circular(cardRadius / 1.5),
                            border: Border.all(
                              color: isSelected ? AppColors.primary : Colors.transparent,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              options[index],
                              textAlign: TextAlign.center,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontSize: 14 * fontScale,
                                fontWeight: FontWeight.w600,
                                color: isSelected ? AppColors.onPrimary : AppColors.darkgrey,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
              SizedBox(height: listItemSpacing * 1.25),

              // Check-in/Check-out Section
              _buildCheckInOutSection(
                theme: theme,
                isMobile: isMobile,
                defaultPadding: defaultPadding,
                iconSize: iconSize,
                fontScale: fontScale,
                listItemSpacing: listItemSpacing,
              ),
              SizedBox(height: listItemSpacing * 1.25),

              // Conditional Extra Dropdowns based on selected tab
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: (selectedIndex == 2)
                    ? _buildDropdownField(
                        key: const ValueKey('ota'),
                        label: 'OTA *',
                        value: selectedOta,
                        hint: 'Select OTA',
                        items: otas,
                        onChanged: (value) => setState(() => selectedOta = value),
                        theme: theme,
                        fontScale: fontScale,
                        cardRadius: cardRadius,
                      )
                    : (selectedIndex == 3)
                        ? _buildDropdownField(
                            key: const ValueKey('travel_agent'),
                            label: 'Travel Agent *',
                            value: selectedTravelAgent,
                            hint: 'Select Travel Agent',
                            items: travelAgents,
                            onChanged: (value) => setState(() => selectedTravelAgent = value),
                            theme: theme,
                            fontScale: fontScale,
                            cardRadius: cardRadius,
                          )
                        : const SizedBox.shrink(key: ValueKey('none')),
              ),
              if (selectedIndex == 2 || selectedIndex == 3) SizedBox(height: listItemSpacing),

              // Business Source (always shown)
              _buildDropdownField(
                label: 'Business Source',
                value: selectedBusinessSource,
                hint: 'Select Business Source',
                items: businessSources,
                onChanged: (value) => setState(() => selectedBusinessSource = value),
                theme: theme,
                fontScale: fontScale,
                cardRadius: cardRadius,
              ),
              SizedBox(height: listItemSpacing),

              // Reservation Type and Rooms
              if (isMobile)
                Column(
                  children: [
                    _buildDropdownField(
                      label: 'Reservation Type *',
                      value: reservationType,
                      hint: 'Select Type',
                      items: reservationTypes,
                      onChanged: (value) => setState(() => reservationType = value ?? 'Confirm'),
                      theme: theme,
                      fontScale: fontScale,
                      cardRadius: cardRadius,
                    ),
                    SizedBox(height: listItemSpacing),
                    _buildStepperField(
                      label: 'Rooms *',
                      value: roomCount,
                      onChanged: (value) {
                        setState(() {
                          roomCount = value;
                          _updateTotals();
                        });
                      },
                      theme: theme,
                      fontScale: fontScale,
                      cardRadius: cardRadius,
                      minValue: 1,
                    ),
                  ],
                )
              else
                Row(
                  children: [
                    Expanded(
                      child: _buildDropdownField(
                        label: 'Reservation Type *',
                        value: reservationType,
                        hint: 'Select Type',
                        items: reservationTypes,
                        onChanged: (value) => setState(() => reservationType = value ?? 'Confirm'),
                        theme: theme,
                        fontScale: fontScale,
                        cardRadius: cardRadius,
                      ),
                    ),
                    SizedBox(width: defaultPadding),
                    Expanded(
                      child: _buildStepperField(
                        label: 'Rooms *',
                        value: roomCount,
                        onChanged: (value) {
                          setState(() {
                            roomCount = value;
                            _updateTotals();
                          });
                        },
                        theme: theme,
                        fontScale: fontScale,
                        cardRadius: cardRadius,
                        minValue: 1,
                      ),
                    ),
                  ],
                ),
              SizedBox(height: listItemSpacing * 1.5),

              // Room Details Card
              Card(
                color: AppColors.surface,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(cardRadius)),
                elevation: 2,
                child: Padding(
                  padding: EdgeInsets.all(defaultPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Room Details',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontSize: 18 * fontScale,
                              fontWeight: FontWeight.w600,
                              color: AppColors.darkgrey,
                            ),
                          ),
                          Tooltip(
                            message: 'Override the default rate',
                            child: Row(
                              children: [
                                Text(
                                  'Rate Override',
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    fontSize: 14 * fontScale,
                                    color: AppColors.lightgrey,
                                  ),
                                ),
                                SizedBox(width: 8),
                                Switch(
                                  value: rateOverride,
                                  onChanged: (value) => setState(() => rateOverride = value),
                                  activeColor: AppColors.primary,
                                  inactiveThumbColor: AppColors.lightgrey,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: listItemSpacing),
                      if (isMobile)
                        Column(
                          children: [
                            _buildDropdownField(
                              label: 'Room Type *',
                              value: selectedRoomType,
                              hint: 'Select Room Type',
                              items: roomTypes,
                              onChanged: (value) => setState(() => selectedRoomType = value),
                              theme: theme,
                              fontScale: fontScale,
                              cardRadius: cardRadius,
                            ),
                            SizedBox(height: listItemSpacing),
                            _buildDropdownField(
                              label: 'Rate Type *',
                              value: selectedRateType,
                              hint: 'Select Rate Type',
                              items: rateTypes,
                              onChanged: (value) => setState(() => selectedRateType = value),
                              theme: theme,
                              fontScale: fontScale,
                              cardRadius: cardRadius,
                            ),
                          ],
                        )
                      else
                        Row(
                          children: [
                            Expanded(
                              child: _buildDropdownField(
                                label: 'Room Type *',
                                value: selectedRoomType,
                                hint: 'Select Room Type',
                                items: roomTypes,
                                onChanged: (value) => setState(() => selectedRoomType = value),
                                theme: theme,
                                fontScale: fontScale,
                                cardRadius: cardRadius,
                              ),
                            ),
                            SizedBox(width: defaultPadding),
                            Expanded(
                              child: _buildDropdownField(
                                label: 'Rate Type *',
                                value: selectedRateType,
                                hint: 'Select Rate Type',
                                items: rateTypes,
                                onChanged: (value) => setState(() => selectedRateType = value),
                                theme: theme,
                                fontScale: fontScale,
                                cardRadius: cardRadius,
                              ),
                            ),
                          ],
                        ),
                      SizedBox(height: listItemSpacing),
                      _buildDropdownField(
                        label: 'Room',
                        value: selectedRoom,
                        hint: 'Select Room',
                        items: rooms,
                        onChanged: (value) => setState(() => selectedRoom = value),
                        theme: theme,
                        fontScale: fontScale,
                        cardRadius: cardRadius,
                      ),
                      SizedBox(height: listItemSpacing),
                      if (isMobile)
                        Column(
                          children: [
                            _buildStepperField(
                              label: 'Adult *',
                              value: adultCount,
                              onChanged: (value) => setState(() => adultCount = value),
                              theme: theme,
                              fontScale: fontScale,
                              cardRadius: cardRadius,
                              minValue: 1,
                            ),
                            SizedBox(height: listItemSpacing),
                            _buildStepperField(
                              label: 'Child *',
                              value: childCount,
                              onChanged: (value) => setState(() => childCount = value),
                              theme: theme,
                              fontScale: fontScale,
                              cardRadius: cardRadius,
                            ),
                            SizedBox(height: listItemSpacing),
                            _buildRateField(
                              theme: theme,
                              fontScale: fontScale,
                              cardRadius: cardRadius,
                            ),
                          ],
                        )
                      else
                        Row(
                          children: [
                            Expanded(
                              child: _buildStepperField(
                                label: 'Adult *',
                                value: adultCount,
                                onChanged: (value) => setState(() => adultCount = value),
                                theme: theme,
                                fontScale: fontScale,
                                cardRadius: cardRadius,
                                minValue: 1,
                              ),
                            ),
                            SizedBox(width: defaultPadding),
                            Expanded(
                              child: _buildStepperField(
                                label: 'Child *',
                                value: childCount,
                                onChanged: (value) => setState(() => childCount = value),
                                theme: theme,
                                fontScale: fontScale,
                                cardRadius: cardRadius,
                              ),
                            ),
                            SizedBox(width: defaultPadding),
                            Expanded(
                              child: _buildRateField(
                                theme: theme,
                                fontScale: fontScale,
                                cardRadius: cardRadius,
                              ),
                            ),
                          ],
                        ),
                      SizedBox(height: listItemSpacing * 1.5),
                      Container(
                        padding: EdgeInsets.all(defaultPadding),
                        decoration: BoxDecoration(
                          color: AppColors.background,
                          borderRadius: BorderRadius.circular(cardRadius / 1.5),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildRateSummaryItem('Room Charges', '\$${roomCharges.toStringAsFixed(2)}', theme, fontScale),
                            _buildRateSummaryItem('Tax', '\$${tax.toStringAsFixed(2)}', theme, fontScale),
                            _buildRateSummaryItem('Total Rate', '\$${total.toStringAsFixed(2)}', theme, fontScale),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: listItemSpacing * 1.5),

              // Guest Information Card (removed total/confirm; moved to bottom bar)
              Card(
                color: AppColors.surface,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(cardRadius)),
                elevation: 2,
                child: Padding(
                  padding: EdgeInsets.all(defaultPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Guest Information',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontSize: 18 * fontScale,
                              fontWeight: FontWeight.w600,
                              color: AppColors.darkgrey,
                            ),
                          ),
                          Tooltip(
                            message: 'Mark if guest has stayed before',
                            child: Row(
                              children: [
                                Text(
                                  'Returning Guest',
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    fontSize: 14 * fontScale,
                                    color: AppColors.lightgrey,
                                  ),
                                ),
                                SizedBox(width: 8),
                                Switch(
                                  value: returningGuest,
                                  onChanged: (value) => setState(() => returningGuest = value),
                                  activeColor: AppColors.primary,
                                  inactiveThumbColor: AppColors.lightgrey,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: listItemSpacing * 1.5),
                      if (isMobile) ...[
                        // Mobile: Salutation and Guest Name in Row
                        Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: _buildDropdownField(
                                label: 'Salutation',
                                value: selectedSalutation,
                                hint: 'Select',
                                items: ['Mr.', 'Mrs.', 'Ms.', 'Dr.'],
                                onChanged: (value) => setState(() => selectedSalutation = value),
                                theme: theme,
                                fontScale: fontScale,
                                cardRadius: cardRadius,
                              ),
                            ),
                            SizedBox(width: defaultPadding),
                            Expanded(
                              flex: 2,
                              child: TextFormField(
                                controller: guestNameController,
                                decoration: InputDecoration(
                                  labelText: 'Guest Name',
                                  labelStyle: TextStyle(
                                    fontSize: 14 * fontScale,
                                    color: AppColors.lightgrey,
                                  ),
                                  hintText: 'Guest Name',
                                  hintStyle: TextStyle(
                                    fontSize: 14 * fontScale,
                                    color: AppColors.lightgrey.withOpacity(0.6),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(color: AppColors.lightgrey),
                                  ),
                                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                  filled: true,
                                  fillColor: AppColors.surface,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: listItemSpacing),
                        TextFormField(
                          controller: mobileNumberController,
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                            labelText: 'Mobile Number',
                            labelStyle: TextStyle(
                              fontSize: 14 * fontScale,
                              color: AppColors.lightgrey,
                            ),
                            hintText: 'Mobile Number',
                            hintStyle: TextStyle(
                              fontSize: 14 * fontScale,
                              color: AppColors.lightgrey.withOpacity(0.6),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: AppColors.lightgrey),
                            ),
                            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            filled: true,
                            fillColor: AppColors.surface,
                          ),
                        ),
                        SizedBox(height: listItemSpacing),
                        TextFormField(
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            labelText: 'Email ID',
                            labelStyle: TextStyle(
                              fontSize: 14 * fontScale,
                              color: AppColors.lightgrey,
                            ),
                            hintText: 'Email ID',
                            hintStyle: TextStyle(
                              fontSize: 14 * fontScale,
                              color: AppColors.lightgrey.withOpacity(0.6),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: AppColors.lightgrey),
                            ),
                            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            filled: true,
                            fillColor: AppColors.surface,
                          ),
                        ),
                      ] else ...[
                        // Desktop layout
                        Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: _buildDropdownField(
                                label: 'Salutation',
                                value: selectedSalutation,
                                hint: 'Select',
                                items: ['Mr.', 'Mrs.', 'Ms.', 'Dr.'],
                                onChanged: (value) => setState(() => selectedSalutation = value),
                                theme: theme,
                                fontScale: fontScale,
                                cardRadius: cardRadius,
                              ),
                            ),
                            SizedBox(width: defaultPadding),
                            Expanded(
                              flex: 2,
                              child: TextFormField(
                                controller: guestNameController,
                                decoration: InputDecoration(
                                  labelText: 'Guest Name',
                                  labelStyle: TextStyle(
                                    fontSize: 14 * fontScale,
                                    color: AppColors.lightgrey,
                                  ),
                                  hintText: 'Guest Name',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(color: AppColors.lightgrey),
                                  ),
                                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                  filled: true,
                                  fillColor: AppColors.surface,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: listItemSpacing),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: mobileNumberController,
                                keyboardType: TextInputType.phone,
                                decoration: InputDecoration(
                                  labelText: 'Mobile Number',
                                  labelStyle: TextStyle(
                                    fontSize: 14 * fontScale,
                                    color: AppColors.lightgrey,
                                  ),
                                  hintText: 'Mobile Number',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(color: AppColors.lightgrey),
                                  ),
                                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                  filled: true,
                                  fillColor: AppColors.surface,
                                ),
                              ),
                            ),
                            SizedBox(width: defaultPadding),
                            Expanded(
                              child: TextFormField(
                                controller: emailController,
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                  labelText: 'Email ID',
                                  labelStyle: TextStyle(
                                    fontSize: 14 * fontScale,
                                    color: AppColors.lightgrey,
                                  ),
                                  hintText: 'Email ID',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(color: AppColors.lightgrey),
                                  ),
                                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                  filled: true,
                                  fillColor: AppColors.surface,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              SizedBox(height: defaultPadding * 2),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomBar(ThemeData theme, double fontScale, double defaultPadding, double cardRadius, bool isMobile) {
    return Container(
      padding: EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Total Amount',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontSize: 16 * fontScale,
                  fontWeight: FontWeight.w600,
                  color: AppColors.darkgrey,
                ),
              ),
              Text(
                '\$${total.toStringAsFixed(2)}',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontSize: 20 * fontScale,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          ElevatedButton(
            onPressed: () {
              if (_validateForm()) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Reservation confirmed!'),
                    backgroundColor: AppColors.green,
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Please fill all required fields.'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.onPrimary,
              padding: EdgeInsets.symmetric(
                horizontal: defaultPadding * 2,
                vertical: defaultPadding * 1.2,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(cardRadius / 1.5),
              ),
            ),
            child: Text(
              'Confirm',
              style: TextStyle(
                fontSize: 16 * fontScale,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCheckInOutSection({
    required ThemeData theme,
    required bool isMobile,
    required double defaultPadding,
    required double iconSize,
    required double fontScale,
    required double listItemSpacing,
  }) {
    return Row(
      children: [
        if (isMobile) ...[
          _buildDateTimeField(
            label: 'Check In *',
            date: checkInDate,
            time: checkInTime,
            onDateTap: () => _selectDate(context, true),
            onTimeTap: () => _selectTime(context, true),
            theme: theme,
            iconSize: iconSize,
            fontScale: fontScale,
          ),
          SizedBox(width: listItemSpacing * 1.5),
          Center(
            child: _buildNightsIndicator(
              theme: theme,
              defaultPadding: defaultPadding,
              fontScale: fontScale,
            ),
          ),
          SizedBox(width: listItemSpacing * 1.5),
          _buildDateTimeField(
            label: 'Check Out *',
            date: checkOutDate,
            time: checkOutTime,
            onDateTap: () => _selectDate(context, false),
            onTimeTap: () => _selectTime(context, false),
            theme: theme,
            iconSize: iconSize,
            fontScale: fontScale,
          ),
        ] else ...[
          Row(
            children: [
              Expanded(
                child: _buildDateTimeField(
                  label: 'Check In *',
                  date: checkInDate,
                  time: checkInTime,
                  onDateTap: () => _selectDate(context, true),
                  onTimeTap: () => _selectTime(context, true),
                  theme: theme,
                  iconSize: iconSize,
                  fontScale: fontScale,
                ),
              ),
              SizedBox(width: defaultPadding),
              _buildNightsIndicator(
                theme: theme,
                defaultPadding: defaultPadding,
                fontScale: fontScale,
              ),
              SizedBox(width: defaultPadding),
              Expanded(
                child: _buildDateTimeField(
                  label: 'Check Out *',
                  date: checkOutDate,
                  time: checkOutTime,
                  onDateTap: () => _selectDate(context, false),
                  onTimeTap: () => _selectTime(context, false),
                  theme: theme,
                  iconSize: iconSize,
                  fontScale: fontScale,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildNightsIndicator({
    required ThemeData theme,
    required double defaultPadding,
    required double fontScale,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: defaultPadding,
        vertical: defaultPadding / 2,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            nights.toString(),
            style: theme.textTheme.titleLarge?.copyWith(
              fontSize: 22 * fontScale,
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            'Nights',
            style: theme.textTheme.bodySmall?.copyWith(
              fontSize: 12 * fontScale,
              color: AppColors.lightgrey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateTimeField({
    required String label,
    required DateTime date,
    required TimeOfDay time,
    required VoidCallback onDateTap,
    required VoidCallback onTimeTap,
    required ThemeData theme,
    required double iconSize,
    required double fontScale,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontSize: 14 * fontScale,
            color: AppColors.lightgrey,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 4),
        GestureDetector(
          onTap: onDateTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _formatDate(date),
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontSize: 14 * fontScale,
                    fontWeight: FontWeight.w500,
                    color: AppColors.darkgrey,
                  ),
                ),
                SizedBox(width:0.5),
                Icon(
                  Icons.calendar_today_outlined,
                  size: iconSize,
                  color: AppColors.lightgrey,
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 8),
        GestureDetector(
          onTap: onTimeTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Text(
              _formatTime(time),
              style: theme.textTheme.bodyMedium?.copyWith(
                fontSize: 14 * fontScale,
                fontWeight: FontWeight.w500,
                color: AppColors.darkgrey,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField({
    ValueKey? key,
    required String label,
    required String? value,
    required String hint,
    required List<String> items,
    required void Function(String?) onChanged,
    required ThemeData theme,
    required double fontScale,
    required double cardRadius,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontSize: 14 * fontScale,
            color: AppColors.lightgrey,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 4),
        DropdownButtonFormField<String>(
          value: value,
          hint: Text(
            hint,
            style: TextStyle(
              fontSize: 14 * fontScale,
              color: AppColors.lightgrey,
            ),
          ),
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
      
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
          
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: AppColors.primary, width: 2),
            ),
            filled: true,
            fillColor: AppColors.surface,
          ),
          icon: Icon(Icons.arrow_drop_down, color: AppColors.lightgrey),
          style: TextStyle(
            fontSize: 14 * fontScale,
            color: AppColors.darkgrey,
          ),
          items: items.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(item),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _buildStepperField({
    required String label,
    required int value,
    required void Function(int) onChanged,
    required ThemeData theme,
    required double fontScale,
    required double cardRadius,
    int minValue = 0,
    int maxValue = 99,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontSize: 14 * fontScale,
            color: AppColors.lightgrey,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 4),
        Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Row(
            children: [
              IconButton(
                icon: Icon(Icons.remove, color: value > minValue ? AppColors.primary : AppColors.lightgrey),
                onPressed: value > minValue ? () => onChanged(value - 1) : null,
              ),
              Expanded(
                child: Center(
                  child: Text(
                    value.toString(),
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontSize: 14 * fontScale,
                      fontWeight: FontWeight.w500,
                      color: AppColors.darkgrey,
                    ),
                  ),
                ),
              ),
              IconButton(
                icon: Icon(Icons.add, color: value < maxValue ? AppColors.primary : AppColors.lightgrey),
                onPressed: value < maxValue ? () => onChanged(value + 1) : null,
              ),
            ],
          ),
        ),
      ],
    );
  }

 Widget _buildRateField({
    required ThemeData theme,
    required double fontScale,
    required double cardRadius,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Rate *',
          style: theme.textTheme.bodyMedium?.copyWith(
            fontSize: 14 * fontScale,
            color: AppColors.lightgrey,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 4),
        TextFormField(
          initialValue: rate.toStringAsFixed(2),
          enabled: rateOverride,
          keyboardType: TextInputType.numberWithOptions(decimal: true),
          onChanged: (value) {
            rate = double.tryParse(value) ?? 0.0;
            _updateTotals();
            setState(() {});
          },
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: AppColors.primary, width: 2),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            filled: true,
            fillColor: rateOverride ? AppColors.surface : Colors.grey.shade100,
          ),
          style: TextStyle(
            fontSize: 14 * fontScale,
            color: rateOverride ? AppColors.darkgrey : AppColors.lightgrey,
          ),
        ),
      ],
    );
  }
  Widget _buildRateSummaryItem(String label, String amount, ThemeData theme, double fontScale) {
    return Column(
      children: [
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            fontSize: 12 * fontScale,
            color: AppColors.lightgrey,
          ),
        ),
        SizedBox(height: 4),
        Text(
          amount,
          style: theme.textTheme.titleSmall?.copyWith(
            fontSize: 16 * fontScale,
            color: AppColors.primary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}