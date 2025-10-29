import 'package:flutter/material.dart';
import 'package:inta_mobile_pms/core/config/responsive_config.dart';
import 'package:inta_mobile_pms/core/theme/app_colors.dart';
import 'package:inta_mobile_pms/core/widgets/custom_appbar.dart';

class EditReservationScreen extends StatefulWidget {
  const EditReservationScreen({super.key});

  @override
  State<EditReservationScreen> createState() => _EditReservationScreenState();
}

class _EditReservationScreenState extends State<EditReservationScreen> with SingleTickerProviderStateMixin {
  late AnimationController _shimmerController;
  bool _isLoading = true;
  DateTime checkInDate = DateTime.now();
  DateTime checkOutDate = DateTime.now().add(const Duration(days: 1));
  TimeOfDay checkInTime = const TimeOfDay(hour: 13, minute: 0); // ~1 PM as per screenshot
  TimeOfDay checkOutTime = const TimeOfDay(hour: 13, minute: 0);
  int nights = 1;
  String? selectedBusinessSource;
  String? selectedOta;
  String? selectedTravelAgent;
  String? selectedCompany;
  String reservationType = 'Confirm';
  int roomCount = 1;
  String? selectedRoomType;
  String? selectedRateType;
  bool differentRoomTypes = false;
  List<String?> selectedRoomTypes = [];
  List<String?> selectedRateTypes = [];
  List<String?> selectedRooms = [];
  List<int> adultCounts = [];
  List<int> childCounts = [];
  List<double> rates = [];
  bool rateOverride = false;
  bool returningGuest = false;
  String? selectedSalutation;
  TextEditingController guestNameController = TextEditingController();
  TextEditingController mobileNumberController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController voucherController = TextEditingController();
  // Dynamic totals
  double roomCharges = 0.0;
  double tax = 0.0;
  double total = 0.0;
  final Map<String, double> defaultRates = {
    'Standard Room': 100.00,
    'Deluxe Room': 150.00,
    'Suite': 200.00,
    'Executive Room': 250.00,
  };
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
  final List<String> companies = [
    'Company A',
    'Company B',
    'Company C',
    'Enterprise Solutions',
  ];
  final List<String> businessSources = [
    'Web',
    'Online Travel Agent',
    'Travel Agent',
    'Corporate',
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
    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
    // Initialize per-room lists
    _initializeRoomLists();
    // Prefill with example existing reservation data (simulate loading existing data)
    // In a real app, this would come from API or passed params
    checkInDate = DateTime.now().add(const Duration(days: 2));
    checkOutDate = DateTime.now().add(const Duration(days: 5));
    checkInTime = const TimeOfDay(hour: 14, minute: 0);
    checkOutTime = const TimeOfDay(hour: 11, minute: 0);
    selectedBusinessSource = 'Online Travel Agent';
    selectedOta = 'Booking.com';
    reservationType = 'Confirm';
    roomCount = 2;
    selectedRoomType = 'Deluxe Room';
    selectedRateType = 'Corporate Rate';
    differentRoomTypes = true;
    rateOverride = true;
    returningGuest = true;
    selectedSalutation = 'Mr.';
    guestNameController.text = 'John Doe';
    mobileNumberController.text = '+1-123-456-7890';
    emailController.text = 'john.doe@example.com';
    voucherController.text = 'VOUCH123';
    // Update room-specific data
    selectedRoomTypes = ['Deluxe Room', 'Suite'];
    selectedRateTypes = ['Corporate Rate', 'Standard Rate'];
    selectedRooms = ['Room 201', 'Room 202'];
    adultCounts = [2, 1];
    childCounts = [1, 0];
    rates = [160.00, 210.00];
    // Simulate loading (replace with real async data fetch, e.g., API call for existing reservation)
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    });
    _calculateNights();
    _updateTotals();
  }

  void _initializeRoomLists() {
    selectedRoomTypes = List.filled(roomCount, null, growable: true);
    selectedRateTypes = List.filled(roomCount, null, growable: true);
    selectedRooms = List.filled(roomCount, null, growable: true);
    adultCounts = List.filled(roomCount, 1, growable: true);
    childCounts = List.filled(roomCount, 0, growable: true);
    rates = List.filled(roomCount, 0.00, growable: true);
  }

  @override
  void dispose() {
    _shimmerController.dispose();
    guestNameController.dispose();
    mobileNumberController.dispose();
    emailController.dispose();
    voucherController.dispose();
    super.dispose();
  }

  void _calculateNights() {
    nights = checkOutDate.difference(checkInDate).inDays;
    if (nights <= 0) nights = 1;
    _updateTotals();
    setState(() {});
  }

  void _updateTotals() {
    roomCharges = 0.0;
    tax = 0.0;
    for (int i = 0; i < roomCount; i++) {
      final double roomCharge = rates[i] * nights;
      roomCharges += roomCharge;
      tax += roomCharge * 0.1;
    }
    total = roomCharges + tax;
  }

  void _setDefaultRates() {
    for (int i = 0; i < roomCount; i++) {
      String? rt = differentRoomTypes ? selectedRoomTypes[i] : selectedRoomType;
      if (rt != null) {
        rates[i] = defaultRates[rt] ?? 0.0;
      }
    }
    _updateTotals();
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

  void _removeRoom(int index) {
    setState(() {
      selectedRoomTypes.removeAt(index);
      selectedRateTypes.removeAt(index);
      selectedRooms.removeAt(index);
      adultCounts.removeAt(index);
      childCounts.removeAt(index);
      rates.removeAt(index);
      roomCount = adultCounts.length;
      _updateTotals();
    });
  }

  bool _validateForm() {
    // Basic validation for required fields
    if (reservationType.isEmpty || roomCount < 1) {
      return false;
    }
    if (selectedBusinessSource == 'Online Travel Agent' && selectedOta == null) return false;
    if (selectedBusinessSource == 'Travel Agent' && (selectedTravelAgent == null || voucherController.text.isEmpty)) return false;
    if (selectedBusinessSource == 'Corporate' && selectedCompany == null) return false;
    for (int i = 0; i < roomCount; i++) {
      if (adultCounts[i] < 1) return false;
      if (differentRoomTypes) {
        if (selectedRoomTypes[i] == null || selectedRateTypes[i] == null) return false;
      }
    }
    if (!differentRoomTypes && (selectedRoomType == null || selectedRateType == null)) return false;
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
          title: 'Edit Reservation',
          onRefreshTap: () {},
        ),
        bottomNavigationBar: _isLoading ? null : _buildBottomBar(theme, fontScale, defaultPadding, cardRadius, isMobile),
        body: SingleChildScrollView(
          padding: horizontalPadding,
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: _isLoading
                ? _buildShimmerLayout(
                    theme: theme,
                    isMobile: isMobile,
                    defaultPadding: defaultPadding,
                    listItemSpacing: listItemSpacing,
                    cardRadius: cardRadius,
                  )
                : Column(
                    key: const ValueKey('loaded'),
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(height: defaultPadding),
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
                      // Business Source (always shown)
                      _buildDropdownField(
                        label: 'Business Source',
                        value: selectedBusinessSource,
                        hint: 'Select Business Source',
                        items: businessSources,
                        onChanged: (value) => setState(() {
                          selectedBusinessSource = value;
                          selectedOta = null;
                          selectedTravelAgent = null;
                          selectedCompany = null;
                          voucherController.clear();
                        }),
                        theme: theme,
                        fontScale: fontScale,
                        cardRadius: cardRadius,
                      ),
                      SizedBox(height: listItemSpacing),
                      // Conditional Extra Fields based on selected category
                      if (selectedBusinessSource == 'Online Travel Agent')
                        _buildDropdownField(
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
                      else if (selectedBusinessSource == 'Travel Agent')
                        Column(
                          key: const ValueKey('travel_agent'),
                          children: [
                            _buildDropdownField(
                              label: 'Agent *',
                              value: selectedTravelAgent,
                              hint: 'Select Travel Agent',
                              items: travelAgents,
                              onChanged: (value) => setState(() => selectedTravelAgent = value),
                              theme: theme,
                              fontScale: fontScale,
                              cardRadius: cardRadius,
                            ),
                            SizedBox(height: listItemSpacing),
                            _buildTextField(
                              label: 'Voucher No *',
                              controller: voucherController,
                              hint: 'Enter Voucher No',
                              theme: theme,
                              fontScale: fontScale,
                            ),
                          ],
                        )
                      else if (selectedBusinessSource == 'Corporate')
                        _buildDropdownField(
                          key: const ValueKey('corporate'),
                          label: 'Company *',
                          value: selectedCompany,
                          hint: 'Select Company',
                          items: companies,
                          onChanged: (value) => setState(() => selectedCompany = value),
                          theme: theme,
                          fontScale: fontScale,
                          cardRadius: cardRadius,
                        ),
                      if (selectedBusinessSource != null && selectedBusinessSource != 'Web') SizedBox(height: listItemSpacing),
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
                                  if (value > roomCount) {
                                    final int toAdd = value - roomCount;
                                    for (int j = 0; j < toAdd; j++) {
                                      selectedRoomTypes.add(null);
                                      selectedRateTypes.add(null);
                                      selectedRooms.add(null);
                                      adultCounts.add(1);
                                      childCounts.add(0);
                                      rates.add(0.00);
                                    }
                                  } else if (value < roomCount) {
                                    final int toRemove = roomCount - value;
                                    for (int j = 0; j < toRemove; j++) {
                                      selectedRoomTypes.removeLast();
                                      selectedRateTypes.removeLast();
                                      selectedRooms.removeLast();
                                      adultCounts.removeLast();
                                      childCounts.removeLast();
                                      rates.removeLast();
                                    }
                                  }
                                  roomCount = value;
                                  if (!rateOverride) {
                                    _setDefaultRates();
                                  }
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
                                    if (value > roomCount) {
                                      final int toAdd = value - roomCount;
                                      for (int j = 0; j < toAdd; j++) {
                                        selectedRoomTypes.add(null);
                                        selectedRateTypes.add(null);
                                        selectedRooms.add(null);
                                        adultCounts.add(1);
                                        childCounts.add(0);
                                        rates.add(0.00);
                                      }
                                    } else if (value < roomCount) {
                                      final int toRemove = roomCount - value;
                                      for (int j = 0; j < toRemove; j++) {
                                        selectedRoomTypes.removeLast();
                                        selectedRateTypes.removeLast();
                                        selectedRooms.removeLast();
                                        adultCounts.removeLast();
                                        childCounts.removeLast();
                                        rates.removeLast();
                                      }
                                    }
                                    roomCount = value;
                                    if (!rateOverride) {
                                      _setDefaultRates();
                                    }
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
                      SizedBox(height: listItemSpacing),
                      // Different Room Types switch
                      Tooltip(
                        message: 'Allow different room types for each room',
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Different Room Types',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontSize: 14 * fontScale,
                                color: AppColors.lightgrey,
                              ),
                            ),
                            Switch(
                              value: differentRoomTypes,
                              onChanged: (value) => setState(() {
                                differentRoomTypes = value;
                                if (!rateOverride) {
                                  _setDefaultRates();
                                }
                              }),
                              activeColor: AppColors.primary,
                              inactiveThumbColor: AppColors.lightgrey,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: listItemSpacing * 0.5),
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
                              if (!differentRoomTypes)
                                if (isMobile)
                                  Column(
                                    children: [
                                      _buildDropdownField(
                                        label: 'Room Type *',
                                        value: selectedRoomType,
                                        hint: 'Select Room Type',
                                        items: roomTypes,
                                        onChanged: (value) => setState(() {
                                          selectedRoomType = value;
                                          if (!rateOverride) {
                                            _setDefaultRates();
                                          }
                                        }),
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
                                          onChanged: (value) => setState(() {
                                            selectedRoomType = value;
                                            if (!rateOverride) {
                                              _setDefaultRates();
                                            }
                                          }),
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
                              if (!differentRoomTypes) SizedBox(height: listItemSpacing),
                              Tooltip(
                                message: 'Override the default rate',
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Rate Override',
                                      style: theme.textTheme.bodyMedium?.copyWith(
                                        fontSize: 14 * fontScale,
                                        color: AppColors.lightgrey,
                                      ),
                                    ),
                                    Switch(
                                      value: rateOverride,
                                      onChanged: (value) => setState(() {
                                        rateOverride = value;
                                        if (!value) {
                                          _setDefaultRates();
                                        }
                                      }),
                                      activeColor: AppColors.primary,
                                      inactiveThumbColor: AppColors.lightgrey,
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: listItemSpacing),
                              ...List.generate(
                                roomCount,
                                (index) => _buildRoomSection(
                                  index,
                                  theme: theme,
                                  isMobile: isMobile,
                                  defaultPadding: defaultPadding,
                                  listItemSpacing: listItemSpacing,
                                  fontScale: fontScale,
                                  cardRadius: cardRadius,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: listItemSpacing * 1.5),
                      // Guest Information Card
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
                    content: Text('Reservation updated!'),
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
              'Update',
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
    ValueKey<String>? key,
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
    required int index,
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
          initialValue: rates[index].toStringAsFixed(2),
          enabled: rateOverride,
          keyboardType: TextInputType.numberWithOptions(decimal: true),
          onChanged: (value) {
            rates[index] = double.tryParse(value) ?? 0.0;
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

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required ThemeData theme,
    required double fontScale,
    String? hint,
    TextInputType keyboardType = TextInputType.text,
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
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hint ?? 'Enter $label',
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
          style: TextStyle(
            fontSize: 14 * fontScale,
            color: AppColors.darkgrey,
          ),
        ),
      ],
    );
  }

  Widget _buildRoomSection(
    int index, {
    required ThemeData theme,
    required bool isMobile,
    required double defaultPadding,
    required double listItemSpacing,
    required double fontScale,
    required double cardRadius,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: listItemSpacing),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(cardRadius),
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: defaultPadding, vertical: defaultPadding / 2),
            decoration: BoxDecoration(
              color: Colors.blueGrey[700],
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(cardRadius),
                topRight: Radius.circular(cardRadius),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Room ${index + 1}',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 14 * fontScale,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: roomCount > 1 ? () => _removeRoom(index) : null,
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(defaultPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (differentRoomTypes)
                  if (isMobile)
                    Column(
                      children: [
                        _buildDropdownField(
                          label: 'Room Type *',
                          value: selectedRoomTypes[index],
                          hint: 'Select Room Type',
                          items: roomTypes,
                          onChanged: (value) => setState(() {
                            selectedRoomTypes[index] = value;
                            if (!rateOverride) {
                              rates[index] = defaultRates[value!] ?? 0.0;
                              _updateTotals();
                            }
                          }),
                          theme: theme,
                          fontScale: fontScale,
                          cardRadius: cardRadius,
                        ),
                        SizedBox(height: listItemSpacing),
                        _buildDropdownField(
                          label: 'Rate Type *',
                          value: selectedRateTypes[index],
                          hint: 'Select Rate Type',
                          items: rateTypes,
                          onChanged: (value) => setState(() => selectedRateTypes[index] = value),
                          theme: theme,
                          fontScale: fontScale,
                          cardRadius: cardRadius,
                        ),
                        SizedBox(height: listItemSpacing),
                      ],
                    )
                  else
                    Row(
                      children: [
                        Expanded(
                          child: _buildDropdownField(
                            label: 'Room Type *',
                            value: selectedRoomTypes[index],
                            hint: 'Select Room Type',
                            items: roomTypes,
                            onChanged: (value) => setState(() {
                              selectedRoomTypes[index] = value;
                              if (!rateOverride) {
                                rates[index] = defaultRates[value!] ?? 0.0;
                                _updateTotals();
                              }
                            }),
                            theme: theme,
                            fontScale: fontScale,
                            cardRadius: cardRadius,
                          ),
                        ),
                        SizedBox(width: defaultPadding),
                        Expanded(
                          child: _buildDropdownField(
                            label: 'Rate Type *',
                            value: selectedRateTypes[index],
                            hint: 'Select Rate Type',
                            items: rateTypes,
                            onChanged: (value) => setState(() => selectedRateTypes[index] = value),
                            theme: theme,
                            fontScale: fontScale,
                            cardRadius: cardRadius,
                          ),
                        ),
                      ],
                    ),
                _buildDropdownField(
                  label: 'Room',
                  value: selectedRooms[index],
                  hint: 'Select Room',
                  items: rooms,
                  onChanged: (value) => setState(() => selectedRooms[index] = value),
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
                        value: adultCounts[index],
                        onChanged: (value) => setState(() => adultCounts[index] = value),
                        theme: theme,
                        fontScale: fontScale,
                        cardRadius: cardRadius,
                        minValue: 1,
                      ),
                      SizedBox(height: listItemSpacing),
                      _buildStepperField(
                        label: 'Child *',
                        value: childCounts[index],
                        onChanged: (value) => setState(() => childCounts[index] = value),
                        theme: theme,
                        fontScale: fontScale,
                        cardRadius: cardRadius,
                      ),
                      SizedBox(height: listItemSpacing),
                      _buildRateField(
                        index: index,
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
                          value: adultCounts[index],
                          onChanged: (value) => setState(() => adultCounts[index] = value),
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
                          value: childCounts[index],
                          onChanged: (value) => setState(() => childCounts[index] = value),
                          theme: theme,
                          fontScale: fontScale,
                          cardRadius: cardRadius,
                        ),
                      ),
                      SizedBox(width: defaultPadding),
                      Expanded(
                        child: _buildRateField(
                          index: index,
                          theme: theme,
                          fontScale: fontScale,
                          cardRadius: cardRadius,
                        ),
                      ),
                    ],
                  ),
                SizedBox(height: listItemSpacing),
                Container(
                  padding: EdgeInsets.all(defaultPadding),
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(cardRadius / 1.5),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildRateSummaryItem('Room Charges', '\$${(rates[index] * nights).toStringAsFixed(2)}', theme, fontScale),
                      _buildRateSummaryItem('Tax', '\$${(rates[index] * nights * 0.1).toStringAsFixed(2)}', theme, fontScale),
                      _buildRateSummaryItem('Total Rate', '\$${(rates[index] * nights * 1.1).toStringAsFixed(2)}', theme, fontScale),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShimmerLayout({
    required ThemeData theme,
    required bool isMobile,
    required double defaultPadding,
    required double listItemSpacing,
    required double cardRadius,
  }) {
    return Column(
      key: const ValueKey('shimmer'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(height: defaultPadding),
        // Shimmer for Check-in/Check-out
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(child: _buildShimmerContainer(height: 100, width: double.infinity)),
            SizedBox(width: listItemSpacing),
            _buildShimmerContainer(height: 50, width: 60),
            SizedBox(width: listItemSpacing),
            Expanded(child: _buildShimmerContainer(height: 100, width: double.infinity)),
          ],
        ),
        SizedBox(height: listItemSpacing * 1.25),
        // Shimmer for Dropdowns (Business Category, etc.)
        _buildShimmerContainer(height: 60, width: double.infinity),
        SizedBox(height: listItemSpacing),
        if (isMobile)
          Column(
            children: [
              _buildShimmerContainer(height: 60, width: double.infinity),
              SizedBox(height: listItemSpacing),
              _buildShimmerContainer(height: 60, width: double.infinity),
            ],
          )
        else
          Row(
            children: [
              Expanded(child: _buildShimmerContainer(height: 60, width: double.infinity)),
              SizedBox(width: defaultPadding),
              Expanded(child: _buildShimmerContainer(height: 60, width: double.infinity)),
            ],
          ),
        SizedBox(height: listItemSpacing * 1.5),
        // Shimmer for Room Details Card
        _buildShimmerCard(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildShimmerContainer(height: 20, width: 150),
                  _buildShimmerContainer(height: 20, width: 100),
                ],
              ),
              SizedBox(height: listItemSpacing),
              if (isMobile)
                Column(
                  children: List.generate(5, (_) => Padding(
                    padding: EdgeInsets.only(bottom: listItemSpacing),
                    child: _buildShimmerContainer(height: 60, width: double.infinity),
                  )),
                )
              else
                Column(
                  children: [
                    Row(
                      children: List.generate(2, (_) => Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(right: defaultPadding),
                          child: _buildShimmerContainer(height: 60, width: double.infinity),
                        ),
                      )),
                    ),
                    SizedBox(height: listItemSpacing),
                    _buildShimmerContainer(height: 60, width: double.infinity),
                    SizedBox(height: listItemSpacing),
                    Row(
                      children: List.generate(3, (_) => Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(right: defaultPadding),
                          child: _buildShimmerContainer(height: 60, width: double.infinity),
                        ),
                      )),
                    ),
                  ],
                ),
              SizedBox(height: listItemSpacing * 1.5),
              _buildShimmerContainer(height: 80, width: double.infinity),
            ],
          ),
          defaultPadding: defaultPadding,
          cardRadius: cardRadius,
        ),
        SizedBox(height: listItemSpacing * 1.5),
        // Shimmer for Guest Information Card
        _buildShimmerCard(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildShimmerContainer(height: 20, width: 150),
                  _buildShimmerContainer(height: 20, width: 100),
                ],
              ),
              SizedBox(height: listItemSpacing * 1.5),
              if (isMobile)
                Column(
                  children: List.generate(4, (_) => Padding(
                    padding: EdgeInsets.only(bottom: listItemSpacing),
                    child: _buildShimmerContainer(height: 60, width: double.infinity),
                  )),
                )
              else
                Column(
                  children: [
                    Row(
                      children: [
                        Expanded(flex: 1, child: _buildShimmerContainer(height: 60, width: double.infinity)),
                        SizedBox(width: defaultPadding),
                        Expanded(flex: 2, child: _buildShimmerContainer(height: 60, width: double.infinity)),
                      ],
                    ),
                    SizedBox(height: listItemSpacing),
                    Row(
                      children: List.generate(2, (_) => Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(right: defaultPadding),
                          child: _buildShimmerContainer(height: 60, width: double.infinity),
                        ),
                      )),
                    ),
                  ],
                ),
            ],
          ),
          defaultPadding: defaultPadding,
          cardRadius: cardRadius,
        ),
        SizedBox(height: defaultPadding * 2),
      ],
    );
  }

  Widget _buildShimmerCard({
    required Widget child,
    required double defaultPadding,
    required double cardRadius,
  }) {
    return Card(
      color: AppColors.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(cardRadius)),
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.all(defaultPadding),
        child: child,
      ),
    );
  }

  Widget _buildShimmerContainer({
    required double height,
    double? width,
    double radius = 8.0,
  }) {
    return AnimatedBuilder(
      animation: _shimmerController,
      builder: (context, child) {
        return Container(
          height: height,
          width: width,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(radius),
          ),
          child: ShaderMask(
            shaderCallback: (bounds) {
              return LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  Colors.grey[300]!,
                  Colors.grey[100]!,
                  Colors.grey[300]!,
                ],
                stops: const [0.0, 0.5, 1.0],
                transform: _ShimmerGradientTransform(_shimmerController.value),
              ).createShader(bounds);
            },
            blendMode: BlendMode.srcATop,
            child: Container(
              color: Colors.grey[300],
            ),
          ),
        );
      },
    );
  }
}

// Custom transform for shimmering effect
class _ShimmerGradientTransform extends GradientTransform {
  final double percent;
  const _ShimmerGradientTransform(this.percent);
  @override
  Matrix4? transform(Rect bounds, {TextDirection? textDirection}) {
    return Matrix4.translationValues(bounds.width * (percent - 0.5) * 2, 0, 0);
  }
}