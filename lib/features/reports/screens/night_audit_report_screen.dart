import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:inta_mobile_pms/core/theme/app_colors.dart';
import 'package:inta_mobile_pms/features/reports/models/currency_item.dart';
import 'package:inta_mobile_pms/features/reports/models/hotel_item.dart';
import 'package:inta_mobile_pms/features/reports/viewmodels/night_audit_report_vm.dart';
import 'package:inta_mobile_pms/services/message_service.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

class NightAuditReport extends StatefulWidget {
  const NightAuditReport({super.key});

  @override
  State<NightAuditReport> createState() => _ReportWidgetState();
}

class _ReportWidgetState extends State<NightAuditReport>
    with SingleTickerProviderStateMixin {
  final _nightAuditReportVm = Get.find<NightAuditReportVm>();
  late List<HotelItem> _hotelList = [HotelItem(hotelId: -1, hotelName: 'None')];
  late List<CurrencyItem> _currencyList = [
    CurrencyItem(currencyId: -1, code: 'None', symbol: 'None'),
  ];
  late TabController _tabController;
  DateTime? _selectedDate;
  CurrencyItem? _selectedCurrency;
  HotelItem? _selectedHotel;
  final List<ScrollController> _horizontalControllers = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 10, vsync: this);
    for (int i = 0; i < 10; i++) {
      _horizontalControllers.add(ScrollController());
    }
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (mounted) {
        await _nightAuditReportVm.loadInitialData();

        setState(() {
          _selectedDate = _nightAuditReportVm.systemWorkingDate.value.subtract(
            const Duration(days: 1),
          );
          _currencyList = _nightAuditReportVm.currencyList.toList();
          _hotelList = _nightAuditReportVm.hotelList.toList();
        });
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    for (var controller in _horizontalControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _loadReportData() async {
    try {
      if (_selectedCurrency == null) {
        MessageService().error('Please select a currency');
        return;
      }

      if (_selectedHotel == null) {
        MessageService().error('Please select a hotel');
        return;
      }
      if (_selectedCurrency != null &&
          _selectedDate != null &&
          _selectedHotel != null) {
        await _nightAuditReportVm.loadNightAuditReport(
          _selectedDate!,
          _selectedHotel!.hotelId,
          _selectedCurrency!.currencyId,
        );
      } else {
        MessageService().error('Invalid data selected!');
      }
    } catch (e) {
      throw Exception('Error loading report: $e');
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  final roomChargeCols = [
    {'field': "room", 'header': "Room"},
    {'field': "folioID", 'header': "Folio No"},
    {'field': "guest", 'header': "Guest Name"},
    {'field': "businessCategory", 'header': "Business Category"},
    {'field': "businessSource", 'header': "Business Source"},
    {'field': "rentDate", 'header': "Reserve Date"},
    {'field': "rateType", 'header': "Rate Type"},
    {'field': "nrmlTariff", 'header': "Nrml. Tariff"},
    {'field': "ofrdTariff", 'header': "Ofrd. Tariff"},
    {'field': "discountAmount", 'header': "Discount Amount"},
    {'field': "totalTax", 'header': "Total Tax"},
    {'field': "totalRent", 'header': "Total Rent"},
    {'field': "varPercentage", 'header': "Var%"},
    {'field': "checkingBy", 'header': "Checking By"},
  ];

  final checkedOutColsJson = [
    {"field": "room", "header": "Room"},
    {"field": "guest", "header": "Guest Name"},
    {"field": "arrival", "header": "Arrival"},
    {"field": "departure", "header": "Departure"},
    {"field": "nights", "header": "Nights"},
    {"field": "roomCharge", "header": "Room Charges"},
    {"field": "extraCharges", "header": "Extra Charges"},
    {"field": "discount", "header": "Discount"},
    {"field": "taxAmount", "header": "Tax Amount"},
    {"field": "adjust", "header": "Adjustment"},
    {"field": "receivedAmount", "header": "Received Amount"},
    {"field": "balanceAmount", "header": "Balance Amount"},
  ];

  final dailySalesColsJson = [
    {"field": "saleType", "header": "Sale Type"},
    {"field": "roomCharges", "header": "Room Charges"},
    {"field": "extraCharges", "header": "Extra Charges"},
    {"field": "roomTax", "header": "Room Tax"},
    {"field": "extraTax", "header": "Extra Tax"},
    {"field": "roundOffAmount", "header": "Auto Adjustment"},
    {"field": "discount", "header": "Discount"},
    // {"field": "adjustment", "header": "Adjustment"}, // commented as in original
    {"field": "totalSales", "header": "Total Sales"},
  ];

  final receiptDetailsColsJson = [
    // {"field": "mode", "header": "Payment Method"}, // commented as in original
    {"field": "paymentDate", "header": "Payment Date"},
    {"field": "receipt", "header": "Receipt No"},
    {"field": "reference", "header": "Reference"},
    {"field": "amount", "header": "Amount"},
    {"field": "user", "header": "User"},
    {"field": "enteredOn", "header": "Entered On"},
    {"field": "remarks", "header": "Remarks"},
  ];

  final miscellaneousCols = [
    {"field": "rooms", "header": "Rooms"},
    {"field": "folioId", "header": "Folio No"},
    {"field": "guest", "header": "Guest Name"},
    {"field": "voucherNo", "header": "Voucher No"},
    {"field": "charge", "header": "Extra Charge"},
    {"field": "quantity", "header": "Quantity"},
    {"field": "amount", "header": "Amount"},
    {"field": "enteredOn", "header": "Entered On"},
    {"field": "remarks", "header": "Remarks"},
  ];

  final complimentaryCols = [
    {"field": "room", "header": "Room"},
    {"field": "folioID", "header": "Folio No"},
    {"field": "firstName", "header": "Guest Name"},
    {"field": "businessCategory", "header": "Business Category"},
    {"field": "businessSource", "header": "Business Source"},
    {"field": "rentDate", "header": "Reserve Date"},
    {"field": "rateType", "header": "Rate Type"},
    {"field": "nrmlTariff", "header": "Nrml. Tariff"},
    {"field": "ofrdTariff", "header": "Ofrd. Tariff"},
    {"field": "discountAmount", "header": "Discount Amount"},
    {"field": "totalTax", "header": "Total Tax"},
    {"field": "totalRent", "header": "Total Rent"},
    {"field": "varPercentage", "header": "Var%"},
    {"field": "checkingBy", "header": "Checking By"},
  ];

  final paxStatusCols = [
    {"field": "status", "header": "Status"},
    {"field": "rooms", "header": "Rooms"},
    {"field": "adults", "header": "Adults"},
    {"field": "children", "header": "Children"},
  ];

  final paxAnalysisCols = [
    {"field": "rateType", "header": "Rate Type"},
    {"field": "adults", "header": "Adults"},
    {"field": "children", "header": "Children"},
  ];
  final roomStatusCols = [
    {"field": "date", "header": "Date"},
    {"field": "totalRooms", "header": "Total Rooms"},
    {"field": "occupied", "header": "Occupied"},
    // { "field": "dueOut", "header": "Due Out" }, // commented out as in original
    {"field": "vacant", "header": "Vacant"},
    {"field": "departed", "header": "Departed"},
    // { "field": "reserve", "header": "Reserve" }, // commented out as in original
    {"field": "blocked", "header": "Blocked"},
  ];

  final receiptUserSummaryCols = {
    {"field": "user", "header": "User"},
    {"field": "amount", "header": "Amount"},
  };

  final receiptPaySummaryCols = {
    {"field": "mode", "header": "Payment Method"},
    {"field": "amount", "header": "amount"},
  };

  DataColumn _leftColAlign(String title) => DataColumn(
    label: Expanded(
      child: Align(alignment: Alignment.centerLeft, child: Text(title)),
    ),
  );

  DataColumn _rightColAlign(String title) => DataColumn(
    label: Expanded(
      child: Align(alignment: Alignment.centerRight, child: Text(title)),
    ),
  );

  DataCell _leftCell(dynamic value) => DataCell(
    Align(alignment: Alignment.centerLeft, child: Text(value.toString())),
  );

  DataCell _rightCell(dynamic value) => DataCell(
    Align(alignment: Alignment.centerRight, child: Text(value.toString())),
  );

  DataCell _leftBoldCell(dynamic value) => DataCell(
    Align(
      alignment: Alignment.centerLeft,
      child: Text(
        value.toString(),
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
    ),
  );

  DataCell _rightBoldCell(dynamic value) => DataCell(
    Align(
      alignment: Alignment.centerRight,
      child: Text(
        value.toString(),
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Night Audit Report')),
      body: Column(
        children: [
          Container(
            color: AppColors.primary,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Select Date',
                            style: TextStyle(
                              color: AppColors.onPrimary,
                              fontSize: 14,
                            ),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              foregroundColor: AppColors.onPrimary,
                              backgroundColor: AppColors.primary,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                            ),
                            onPressed: () => _selectDate(context),
                            child: Text(
                              _selectedDate == null
                                  ? 'Pick a date'
                                  : '${_selectedDate!.toLocal()}'.split(' ')[0],
                              style: TextStyle(fontSize: 14),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Currency',
                            style: TextStyle(
                              color: AppColors.onPrimary,
                              fontSize: 14,
                            ),
                          ),
                          DropdownButton<CurrencyItem>(
                            value: _selectedCurrency,
                            hint: Text(
                              "select",
                              style: TextStyle(
                                color: AppColors.onPrimary,
                                fontSize: 14,
                              ),
                            ),
                            dropdownColor: Colors.white,
                            underline: Container(),
                            iconEnabledColor: AppColors.onPrimary,
                            selectedItemBuilder: (BuildContext context) {
                              return _currencyList.map<Widget>((
                                CurrencyItem item,
                              ) {
                                return Text(
                                  item.code,
                                  style: TextStyle(
                                    color: AppColors.onPrimary,
                                    fontSize: 14, // match other texts
                                  ),
                                );
                              }).toList();
                            },
                            items: _currencyList
                                .map<DropdownMenuItem<CurrencyItem>>((
                                  CurrencyItem value,
                                ) {
                                  return DropdownMenuItem<CurrencyItem>(
                                    value: value,
                                    child: Text(
                                      value.code,
                                      style: TextStyle(
                                        color: AppColors.darkgrey,
                                        fontSize: 14,
                                      ),
                                    ),
                                  );
                                })
                                .toList(),
                            onChanged: (CurrencyItem? currency) {
                              setState(() {
                                _selectedCurrency = currency!;
                              });
                            },
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Hotel',
                            style: TextStyle(
                              color: AppColors.onPrimary,
                              fontSize: 14,
                            ),
                          ),
                          DropdownButton<HotelItem>(
                            value: _selectedHotel,
                            hint: Text(
                              "Select",
                              style: TextStyle(
                                color: AppColors.onPrimary,
                                fontSize: 14,
                              ),
                            ),
                            dropdownColor: Colors.white,
                            underline: Container(),
                            iconEnabledColor: AppColors.onPrimary,
                            selectedItemBuilder: (BuildContext context) {
                              return _hotelList.map<Widget>((HotelItem item) {
                                return Text(
                                  item.hotelName,
                                  style: TextStyle(
                                    color: AppColors.onPrimary,
                                    fontSize: 14,
                                  ),
                                );
                              }).toList();
                            },
                            items: _hotelList.map<DropdownMenuItem<HotelItem>>((
                              HotelItem value,
                            ) {
                              return DropdownMenuItem<HotelItem>(
                                value: value,
                                child: Text(
                                  value.hotelName,
                                  style: TextStyle(
                                    color: AppColors.darkgrey,
                                    fontSize: 14,
                                  ),
                                ),
                              );
                            }).toList(),
                            onChanged: (HotelItem? hotel) {
                              setState(() {
                                _selectedHotel = hotel!;
                              });
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          foregroundColor: AppColors.primary,
                          backgroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                        ),
                        onPressed: () {
                          _loadReportData();
                        },
                        child: const Text(
                          'Generate',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          Container(
            color: AppColors.primary,
            child: TabBar(
              isScrollable: true,
              labelColor: AppColors.onPrimary,
              unselectedLabelColor: AppColors.onPrimary.withOpacity(0.7),
              controller: _tabController,
              tabs: [
                Tab(text: 'Room Charges'),
                Tab(text: 'Complimentary'),
                Tab(text: 'Checked Out'),
                Tab(text: 'Daily Sales'),
                Tab(text: 'Receipt Detail'),
                Tab(text: 'Receipt Summary'),
                Tab(text: 'Misc. Charges'),
                Tab(text: 'Room Status'),
                Tab(text: 'Pax Status'),
                Tab(text: 'Pax Analysis'),
              ],
            ),
          ),
          Obx(() {
            if (_nightAuditReportVm.isLoading.value) {
              return Expanded(
                child: Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: ListView.builder(
                    itemCount: 10,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Container(height: 20, color: Colors.white),
                        subtitle: Container(height: 14, color: Colors.white),
                      );
                    },
                  ),
                ),
              );
            } else {
              return Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    SingleChildScrollView(
                      child: Scrollbar(
                        controller: _horizontalControllers[0],
                        thumbVisibility: true,
                        trackVisibility: true,
                        child: SingleChildScrollView(
                          controller: _horizontalControllers[0],
                          scrollDirection: Axis.horizontal,
                          child: DataTable(
                            columns: roomChargeCols.map((col) {
                              if ([
                                'nrmlTariff',
                                'ofrdTariff',
                                'discountAmount',
                                'totalTax',
                                'totalRent',
                                'varPercentage',
                              ].contains(col['field'])) {
                                return _rightColAlign(col['header']!);
                              } else {
                                return _leftColAlign(col['header']!);
                              }
                            }).toList(),
                            rows: [
                              ..._nightAuditReportVm.roomCharges.map((item) {
                                return DataRow(
                                  cells: roomChargeCols.map((col) {
                                    if ([
                                      'nrmlTariff',
                                      'ofrdTariff',
                                      'discountAmount',
                                      'totalTax',
                                      'totalRent',
                                      'varPercentage',
                                    ].contains(col['field'])) {
                                      final value = item[col['field']];
                                      final formatted = formatCurrency(value);
                                      return _rightCell(formatted.toString());
                                    } else {
                                      final value = item[col['field']];
                                      return _leftCell(value.toString());
                                    }
                                  }).toList(),
                                );
                              }).toList(),
                              if (_nightAuditReportVm.roomCharges.isNotEmpty)
                                DataRow(
                                  cells: [
                                    _leftBoldCell('Total'),
                                    DataCell(Text('')),
                                    DataCell(Text('')),
                                    DataCell(Text('')),
                                    DataCell(Text('')),
                                    DataCell(Text('')),
                                    DataCell(Text('')),
                                    _rightBoldCell(
                                      formatCurrency(
                                        _nightAuditReportVm
                                            .roomChargesTotals["nrmlTariff"],
                                      ).toString(),
                                    ),

                                    _rightBoldCell(
                                      formatCurrency(
                                        _nightAuditReportVm
                                            .roomChargesTotals["ofrdTariff"],
                                      ).toString(),
                                    ),
                                    _rightBoldCell(
                                      formatCurrency(
                                        _nightAuditReportVm
                                            .roomChargesTotals["discountAmount"],
                                      ).toString(),
                                    ),
                                    _rightBoldCell(
                                      formatCurrency(
                                        _nightAuditReportVm
                                            .roomChargesTotals["totalTax"],
                                      ).toString(),
                                    ),
                                    _rightBoldCell(
                                      formatCurrency(
                                        _nightAuditReportVm
                                            .roomChargesTotals["totalRent"],
                                      ).toString(),
                                    ),
                                    _rightBoldCell(
                                      formatCurrency(
                                        _nightAuditReportVm
                                            .roomChargesTotals["varPercentage"],
                                      ).toString(),
                                    ),
                                    DataCell(Text('')),
                                  ],
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SingleChildScrollView(
                      child: Scrollbar(
                        controller: _horizontalControllers[0],
                        thumbVisibility: true,
                        trackVisibility: true,
                        child: SingleChildScrollView(
                          controller: _horizontalControllers[0],
                          scrollDirection: Axis.horizontal,
                          child: DataTable(
                            columns: complimentaryCols.map((col) {
                              if ([
                                'varPercentage',
                                'totalRent',
                                'totalTax',
                                'discountAmount',
                                'ofrdTariff',
                                'nrmlTariff',
                              ].contains(col['field'])) {
                                return _rightColAlign(col['header']!);
                              } else {
                                return _leftColAlign(col['header']!);
                              }
                            }).toList(),
                            rows: [
                              ..._nightAuditReportVm.complimentaryRecodes.map((
                                item,
                              ) {
                                return DataRow(
                                  cells: complimentaryCols.map((col) {
                                    if ([
                                      'varPercentage',
                                      'totalRent',
                                      'totalTax',
                                      'discountAmount',
                                      'ofrdTariff',
                                      'nrmlTariff',
                                    ].contains(col['field'])) {
                                      final value = item[col['field']];
                                      final formatted = formatCurrency(value);
                                      return _rightCell(formatted.toString());
                                    } else {
                                      final value = item[col['field']];
                                      return _leftCell(value.toString());
                                    }
                                  }).toList(),
                                );
                              }).toList(),
                              if (_nightAuditReportVm
                                  .complimentaryRecodes
                                  .isNotEmpty)
                                DataRow(
                                  cells: [
                                    _leftBoldCell('Total'),
                                    DataCell(Text('')),
                                    DataCell(Text('')),
                                    DataCell(Text('')),
                                    DataCell(Text('')),
                                    DataCell(Text('')),
                                    DataCell(Text('')),
                                    _rightBoldCell(
                                      formatCurrency(
                                        _nightAuditReportVm
                                            .complementaryTotals["nrmlTariff"],
                                      ).toString(),
                                    ),

                                    _rightBoldCell(
                                      formatCurrency(
                                        _nightAuditReportVm
                                            .complementaryTotals["ofrdTariff"],
                                      ).toString(),
                                    ),
                                    _rightBoldCell(
                                      formatCurrency(
                                        _nightAuditReportVm
                                            .complementaryTotals["discountAmount"],
                                      ).toString(),
                                    ),
                                    _rightBoldCell(
                                      formatCurrency(
                                        _nightAuditReportVm
                                            .complementaryTotals["totalTax"],
                                      ).toString(),
                                    ),
                                    _rightBoldCell(
                                      formatCurrency(
                                        _nightAuditReportVm
                                            .complementaryTotals["totalRent"],
                                      ).toString(),
                                    ),
                                    _rightBoldCell(
                                      formatCurrency(
                                        _nightAuditReportVm
                                            .complementaryTotals["varPercentage"],
                                      ).toString(),
                                    ),
                                    DataCell(Text('')),
                                  ],
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SingleChildScrollView(
                      child: Scrollbar(
                        controller: _horizontalControllers[1],
                        thumbVisibility: true,
                        trackVisibility: true,
                        child: SingleChildScrollView(
                          controller: _horizontalControllers[1],
                          scrollDirection: Axis.horizontal,
                          child: DataTable(
                            columns: checkedOutColsJson.map((col) {
                              if ([
                                'room',
                                'guest',
                                'arrival',
                                'departure',
                              ].contains(col['field'])) {
                                final value = col['header'];
                                return _leftColAlign(value.toString());
                              } else {
                                final value = col['header'];
                                return _rightColAlign(value.toString());
                              }
                            }).toList(),
                            rows: [
                              ..._nightAuditReportVm.checkedOutRecodes.map((
                                item,
                              ) {
                                return DataRow(
                                  cells: checkedOutColsJson.map((col) {
                                    if ([
                                      'room',
                                      'guest',
                                      'arrival',
                                      'departure',
                                    ].contains(col['field'])) {
                                      final value = item[col['field']];
                                      return _leftCell(value.toString());
                                    } else if (col['field'] == 'nights') {
                                      final value = item[col['field']];
                                      return _rightCell(value);
                                    } else {
                                      final value = item[col['field']];
                                      final formatted = formatCurrency(value);
                                      return _rightCell(formatted.toString());
                                    }
                                  }).toList(),
                                );
                              }).toList(),
                              if (_nightAuditReportVm
                                  .checkedOutRecodes
                                  .isNotEmpty)
                                DataRow(
                                  cells: [
                                    _leftBoldCell('Total'),
                                    DataCell(Text('')),
                                    DataCell(Text('')),
                                    DataCell(Text('')),
                                    DataCell(Text('')),
                                    _rightBoldCell(
                                      formatCurrency(
                                        _nightAuditReportVm
                                            .checkedOutTotals["roomCharge"],
                                      ).toString(),
                                    ),
                                    _rightBoldCell(
                                      formatCurrency(
                                        _nightAuditReportVm
                                            .checkedOutTotals["extraCharges"],
                                      ).toString(),
                                    ),
                                    _rightBoldCell(
                                      formatCurrency(
                                        _nightAuditReportVm
                                            .checkedOutTotals["discount"],
                                      ).toString(),
                                    ),
                                    _rightBoldCell(
                                      formatCurrency(
                                        _nightAuditReportVm
                                            .checkedOutTotals["taxAmount"],
                                      ).toString(),
                                    ),
                                    _rightBoldCell(
                                      formatCurrency(
                                        _nightAuditReportVm
                                            .checkedOutTotals["adjust"],
                                      ).toString(),
                                    ),
                                    _rightBoldCell(
                                      formatCurrency(
                                        _nightAuditReportVm
                                            .checkedOutTotals["receivedAmount"],
                                      ).toString(),
                                    ),
                                    _rightBoldCell(
                                      formatCurrency(
                                        _nightAuditReportVm
                                            .checkedOutTotals["balanceAmount"],
                                      ).toString(),
                                    ),
                                  ],
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SingleChildScrollView(
                      child: Scrollbar(
                        controller: _horizontalControllers[2],
                        thumbVisibility: true,
                        trackVisibility: true,
                        child: SingleChildScrollView(
                          controller: _horizontalControllers[2],
                          scrollDirection: Axis.horizontal,
                          child: DataTable(
                            columns: dailySalesColsJson.map((col) {
                              if (['saleType'].contains(col['field'])) {
                                final value = col['header'];
                                return _leftColAlign(value.toString());
                              } else {
                                final value = col['header'];
                                return _rightColAlign(value.toString());
                              }
                            }).toList(),
                            rows: [
                              ..._nightAuditReportVm.dailySalesRecodes.map((
                                item,
                              ) {
                                return DataRow(
                                  cells: dailySalesColsJson.map((col) {
                                    if (['saleType'].contains(col['field'])) {
                                      final value = item[col['field']];
                                      return _leftCell(value.toString());
                                    } else {
                                      final value = item[col['field']];
                                      final formatted = formatCurrency(value);
                                      return _rightCell(formatted.toString());
                                    }
                                  }).toList(),
                                );
                              }).toList(),
                              if (_nightAuditReportVm
                                  .dailySalesRecodes
                                  .isNotEmpty)
                                DataRow(
                                  cells: [
                                    _leftBoldCell('Total'),
                                    _rightBoldCell(
                                      formatCurrency(
                                        _nightAuditReportVm
                                            .dailySalesTotals["roomCharges"],
                                      ).toString(),
                                    ),
                                    _rightBoldCell(
                                      formatCurrency(
                                        _nightAuditReportVm
                                            .dailySalesTotals["extraCharges"],
                                      ).toString(),
                                    ),
                                    _rightBoldCell(
                                      formatCurrency(
                                        _nightAuditReportVm
                                            .dailySalesTotals["roomTax"],
                                      ).toString(),
                                    ),
                                    _rightBoldCell(
                                      formatCurrency(
                                        _nightAuditReportVm
                                            .dailySalesTotals["extraTax"],
                                      ).toString(),
                                    ),
                                    _rightBoldCell(
                                      formatCurrency(
                                        _nightAuditReportVm
                                            .dailySalesTotals["discount"],
                                      ).toString(),
                                    ),
                                    _rightBoldCell(
                                      formatCurrency(
                                        _nightAuditReportVm
                                            .dailySalesTotals["roundOffAmount"],
                                      ).toString(),
                                    ),
                                    _rightBoldCell(
                                      formatCurrency(
                                        _nightAuditReportVm
                                            .dailySalesTotals["totalSales"],
                                      ).toString(),
                                    ),
                                  ],
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SingleChildScrollView(
                      child: Scrollbar(
                        controller: _horizontalControllers[3],
                        thumbVisibility: true,
                        trackVisibility: true,
                        child: SingleChildScrollView(
                          controller: _horizontalControllers[3],
                          scrollDirection: Axis.horizontal,
                          child: DataTable(
                            columns: receiptDetailsColsJson.map((col) {
                              if (['amount'].contains(col['field'])) {
                                final value = col['header'];
                                return _rightColAlign(value.toString());
                              } else {
                                final value = col['header'];
                                return _leftColAlign(value.toString());
                              }
                            }).toList(),
                            rows: [
                              for (var item
                                  in _nightAuditReportVm
                                      .arrangedReceptDetailsRecodes) ...[
                                DataRow(
                                  color: MaterialStateProperty.all(
                                    Colors.grey.shade300,
                                  ),
                                  cells: [
                                    DataCell(
                                      Text(
                                        item['mode'].toString(),
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    for (
                                      int i = 1;
                                      i < receiptDetailsColsJson.length;
                                      i++
                                    )
                                      const DataCell(Text('')),
                                  ],
                                ),
                                for (var rec in item['recodes'])
                                  DataRow(
                                    cells: receiptDetailsColsJson.map((col) {
                                      if (col['field'] == 'amount') {
                                        final value = rec[col['field']];
                                        final formatted = formatCurrency(value);
                                        return _rightCell(formatted.toString());
                                      } else {
                                        final value = rec[col['field']];
                                        return _leftCell(value.toString());
                                      }
                                    }).toList(),
                                  ),
                                if (_nightAuditReportVm
                                    .arrangedReceptDetailsRecodes
                                    .isNotEmpty)
                                  DataRow(
                                    cells: [
                                      _leftBoldCell('Total'),
                                      DataCell(Text(''.toString())),
                                      DataCell(Text(''.toString())),
                                      _rightBoldCell(
                                        formatCurrency(
                                          item["subTotalAmount"],
                                        ).toString(),
                                      ),
                                      DataCell(Text(''.toString())),
                                      DataCell(Text(''.toString())),
                                      DataCell(Text(''.toString())),
                                    ],
                                  ),
                              ],

                              DataRow(
                                cells: [
                                  _leftBoldCell('Grand Total'),
                                  DataCell(Text(''.toString())),
                                  DataCell(Text(''.toString())),
                                  _rightBoldCell(
                                    formatCurrency(
                                      _nightAuditReportVm
                                          .receiptDetailsTotals["amount"],
                                    ).toString(),
                                  ),
                                  DataCell(Text(''.toString())),
                                  DataCell(Text(''.toString())),
                                  DataCell(Text(''.toString())),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SingleChildScrollView(
                      child: Scrollbar(
                        controller: _horizontalControllers[3],
                        thumbVisibility: true,
                        trackVisibility: true,
                        child: SingleChildScrollView(
                          controller: _horizontalControllers[3],
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              DataTable(
                                columns: receiptUserSummaryCols.map((col) {
                                  if (['user'].contains(col['field'])) {
                                    final value = col['header'];
                                    return _leftColAlign(value.toString());
                                  } else {
                                    final value = col['header'];
                                    return _rightColAlign(value.toString());
                                  }
                                }).toList(),
                                rows: [
                                  ..._nightAuditReportVm
                                      .receiptSummaryUserWiseRecodes
                                      .map((item) {
                                        return DataRow(
                                          cells: receiptUserSummaryCols.map((
                                            col,
                                          ) {
                                            if ([
                                              'user',
                                            ].contains(col['field'])) {
                                              final value = item[col['field']];
                                              return _leftCell(
                                                value.toString(),
                                              );
                                            } else {
                                              final value = item[col['field']];
                                              final formatted = formatCurrency(
                                                value,
                                              );
                                              return _rightCell(
                                                formatted.toString(),
                                              );
                                            }
                                          }).toList(),
                                        );
                                      })
                                      .toList(),
                                  DataRow(
                                    cells: [
                                      _leftBoldCell('Total'),
                                      _rightBoldCell(
                                        formatCurrency(
                                          _nightAuditReportVm
                                              .receiptSummaryUserTotals["amount"],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              DataTable(
                                columns: receiptPaySummaryCols.map((col) {
                                  if (['mode'].contains(col['field'])) {
                                    final value = col['header'];
                                    return _leftColAlign(value.toString());
                                  } else {
                                    final value = col['header'];
                                    return _rightColAlign(value.toString());
                                  }
                                }).toList(),
                                rows: [
                                  ..._nightAuditReportVm
                                      .receiptSummaryPayModeWiseRecodes
                                      .map((item) {
                                        return DataRow(
                                          cells: receiptPaySummaryCols.map((
                                            col,
                                          ) {
                                            if ([
                                              'mode',
                                            ].contains(col['field'])) {
                                              final value = item[col['field']];
                                              return _leftCell(
                                                value.toString(),
                                              );
                                            } else {
                                              final value = item[col['field']];
                                              final formatted = formatCurrency(
                                                value,
                                              );
                                              return _rightCell(
                                                formatted.toString(),
                                              );
                                            }
                                          }).toList(),
                                        );
                                      })
                                      .toList(),
                                  if (_nightAuditReportVm
                                      .receiptSummaryPayModeWiseRecodes
                                      .isNotEmpty)
                                    DataRow(
                                      cells: [
                                        _leftBoldCell('Total'),
                                        _rightBoldCell(
                                          formatCurrency(
                                            _nightAuditReportVm
                                                .receiptSummaryPayTotals["amount"],
                                          ).toString(),
                                        ),
                                      ],
                                    ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SingleChildScrollView(
                      child: Scrollbar(
                        controller: _horizontalControllers[3],
                        thumbVisibility: true,
                        trackVisibility: true,
                        child: SingleChildScrollView(
                          controller: _horizontalControllers[3],
                          scrollDirection: Axis.horizontal,
                          child: DataTable(
                            columns: miscellaneousCols.map((col) {
                              if ([
                                'amount',
                                'quantity',
                              ].contains(col['field'])) {
                                final value = col['header'];
                                return _rightColAlign(value.toString());
                              } else {
                                final value = col['header'];
                                return _leftColAlign(value.toString());
                              }
                            }).toList(),
                            rows: [
                              ..._nightAuditReportVm.miscellaneousRecodes.map((
                                item,
                              ) {
                                return DataRow(
                                  cells: miscellaneousCols.map((col) {
                                    if (col['field'] == 'amount') {
                                      final value = item[col['field']];
                                      final formatted = formatCurrency(value);
                                      return _rightCell(formatted.toString());
                                    } else if (col['field'] == 'quantity') {
                                      final value = item[col['field']];
                                      return _rightCell(value.toString());
                                    } else {
                                      final value = item[col['field']];
                                      return _leftCell(value.toString());
                                    }
                                  }).toList(),
                                );
                              }).toList(),
                              if (_nightAuditReportVm
                                  .miscellaneousRecodes
                                  .isNotEmpty)
                                DataRow(
                                  cells: [
                                    _leftBoldCell('Total'),
                                    DataCell(Text(''.toString())),
                                    DataCell(Text(''.toString())),
                                    DataCell(Text(''.toString())),
                                    DataCell(Text(''.toString())),
                                    _rightBoldCell(
                                      _nightAuditReportVm.miscTotals["quantity"]
                                          .toString(),
                                    ),
                                    _rightBoldCell(
                                      formatCurrency(
                                        _nightAuditReportVm
                                            .miscTotals["amount"],
                                      ).toString(),
                                    ),
                                    DataCell(Text(''.toString())),
                                    DataCell(Text(''.toString())),
                                  ],
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SingleChildScrollView(
                      child: Scrollbar(
                        controller: _horizontalControllers[3],
                        thumbVisibility: true,
                        trackVisibility: true,
                        child: SingleChildScrollView(
                          controller: _horizontalControllers[3],
                          scrollDirection: Axis.horizontal,
                          child: DataTable(
                            columns: roomStatusCols.map((col) {
                              if (['date'].contains(col['field'])) {
                                final value = col['header'];
                                return _leftColAlign(value.toString());
                              } else {
                                final value = col['header'];
                                return _rightColAlign(value.toString());
                              }
                            }).toList(),
                            rows: [
                              ..._nightAuditReportVm.roomStatusRecodes.map((
                                item,
                              ) {
                                return DataRow(
                                  cells: roomStatusCols.map((col) {
                                    if (['date'].contains(col['field'])) {
                                      final value = item[col['field']];
                                      return _leftCell(value.toString());
                                    } else {
                                      final value = item[col['field']];
                                      return _rightCell(value.toString());
                                    }
                                  }).toList(),
                                );
                              }).toList(),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SingleChildScrollView(
                      child: Scrollbar(
                        controller: _horizontalControllers[3],
                        thumbVisibility: true,
                        trackVisibility: true,
                        child: SingleChildScrollView(
                          controller: _horizontalControllers[3],
                          scrollDirection: Axis.horizontal,
                          child: DataTable(
                            columns: paxStatusCols.map((col) {
                              if (['status'].contains(col['field'])) {
                                final value = col['header'];
                                return _leftColAlign(value.toString());
                              } else {
                                final value = col['header'];
                                return _rightColAlign(value.toString());
                              }
                            }).toList(),
                            rows: [
                              ..._nightAuditReportVm.paxStatusRecodes.map((
                                item,
                              ) {
                                return DataRow(
                                  cells: paxStatusCols.map((col) {
                                    if (['status'].contains(col['field'])) {
                                      final value = item[col['field']];
                                      return _leftCell(value.toString());
                                    } else {
                                      final value = item[col['field']];
                                      return _rightCell(value.toString());
                                    }
                                  }).toList(),
                                );
                              }),
                              if (_nightAuditReportVm
                                  .paxStatusRecodes
                                  .isNotEmpty)
                                DataRow(
                                  cells: [
                                    _leftBoldCell('Total'),
                                    DataCell(Text(''.toString())),
                                    _rightBoldCell(
                                      _nightAuditReportVm
                                          .paxStatusTotals["adult"]
                                          .toString(),
                                    ),
                                    _rightBoldCell(
                                      _nightAuditReportVm
                                          .paxStatusTotals["children"]
                                          .toString(),
                                    ),
                                  ],
                                ),
                            ].toList(),
                          ),
                        ),
                      ),
                    ),
                    SingleChildScrollView(
                      child: Scrollbar(
                        controller: _horizontalControllers[3],
                        thumbVisibility: true,
                        trackVisibility: true,
                        child: SingleChildScrollView(
                          controller: _horizontalControllers[3],
                          scrollDirection: Axis.horizontal,
                          child: DataTable(
                            columns: paxAnalysisCols.map((col) {
                              if (['rateType'].contains(col['field'])) {
                                final value = col['header'];
                                return _leftColAlign(value.toString());
                              } else {
                                final value = col['header'];
                                return _rightColAlign(value.toString());
                              }
                            }).toList(),
                            rows: [
                              ..._nightAuditReportVm.paxAnalysisRecodes.map((
                                item,
                              ) {
                                return DataRow(
                                  cells: paxAnalysisCols.map((col) {
                                    if (['rateType'].contains(col['field'])) {
                                      final value = item[col['field']];
                                      return _leftCell(value.toString());
                                    } else {
                                      final value = item[col['field']];
                                      return _rightCell(value.toString());
                                    }
                                  }).toList(),
                                );
                              }).toList(),
                              if (_nightAuditReportVm
                                  .paxAnalysisRecodes
                                  .isNotEmpty)
                                DataRow(
                                  cells: [
                                    _leftBoldCell('Total'),
                                    _rightBoldCell(
                                      _nightAuditReportVm
                                          .paxAnalysisTotals["adult"]
                                          .toString(),
                                    ),
                                    _rightBoldCell(
                                      _nightAuditReportVm
                                          .paxAnalysisTotals["children"]
                                          .toString(),
                                    ),
                                  ],
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
          }),
        ],
      ),
    );
  }

  String formatCurrency(num? value) {
    if (value == null) return '0.00';
    final formatter = NumberFormat('#,##0.00');
    return formatter.format(value);
  }
}
