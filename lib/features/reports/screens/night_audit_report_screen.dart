import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:inta_mobile_pms/core/theme/app_colors.dart';
import 'package:inta_mobile_pms/features/reports/models/currency_item.dart';
import 'package:inta_mobile_pms/features/reports/models/hotel_item.dart';
import 'package:inta_mobile_pms/features/reports/viewmodels/night_audit_report_vm.dart';
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
    _tabController = TabController(length: 9, vsync: this);
    for (int i = 0; i < 9; i++) {
      _horizontalControllers.add(ScrollController());
    }
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (mounted) {
        await _nightAuditReportVm.loadInitialData();

        setState(() {
          _selectedDate = _nightAuditReportVm.systemWorkingDate.value;
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

  _loadReportData() async {
    if (_selectedCurrency == null) {
      Get.snackbar(
        'Error',
        'Please select a currency',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      return;
    }

    if (_selectedHotel == null) {
      Get.snackbar(
        'Error',
        'Please select a hotel',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      return;
    }

    if (_selectedDate == null) {
      Get.snackbar(
        'Error',
        'Please select a date',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      return;
    }

    await _nightAuditReportVm.loadNightAuditReport(
      _selectedDate!,
      _selectedHotel!.hotelId,
      _selectedCurrency!.currencyId,
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() async {
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
    {'field': "status", 'header': "Status"},
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Report Dashboard')),
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
                      // Date picker
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

                      // Currency dropdown
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

                      // Hotel dropdown
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
                            value:  _selectedHotel,
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

                  // Generate button row
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
              labelColor: AppColors.onPrimary,
              unselectedLabelColor: AppColors.onPrimary.withOpacity(0.7),
              controller: _tabController,
              tabs: const [
                Tab(text: 'Room Charges'),
                Tab(text: 'Complimentary'),
                Tab(text: 'Checked Out'),
                Tab(text: 'Daily Sales'),
                Tab(text: 'Receipt Detail'),
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
                            columns: roomChargeCols
                                .map(
                                  (col) =>
                                      DataColumn(label: Text(col['header']!)),
                                )
                                .toList(),
                            rows: _nightAuditReportVm.roomCharges.map((item) {
                              return DataRow(
                                cells: roomChargeCols.map((col) {
                                  final value = item[col['field']] ?? '';
                                  return DataCell(Text(value.toString()));
                                }).toList(),
                              );
                            }).toList(),
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
                            columns: complimentaryCols
                                .map(
                                  (col) =>
                                      DataColumn(label: Text(col['header']!)),
                                )
                                .toList(),
                            rows: _nightAuditReportVm.complimentaryRecodes.map((
                              item,
                            ) {
                              return DataRow(
                                cells: complimentaryCols.map((col) {
                                  final value = item[col['field']] ?? '';
                                  return DataCell(Text(value.toString()));
                                }).toList(),
                              );
                            }).toList(),
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
                            columns: checkedOutColsJson
                                .map(
                                  (col) =>
                                      DataColumn(label: Text(col['header']!)),
                                )
                                .toList(),
                            rows: _nightAuditReportVm.checkedOutRecodes.map((
                              item,
                            ) {
                              return DataRow(
                                cells: checkedOutColsJson.map((col) {
                                  final value = item[col['field']] ?? '';
                                  return DataCell(Text(value.toString()));
                                }).toList(),
                              );
                            }).toList(),
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
                            columns: dailySalesColsJson
                                .map(
                                  (col) =>
                                      DataColumn(label: Text(col['header']!)),
                                )
                                .toList(),
                            rows: _nightAuditReportVm.dailySalesRecodes.map((
                              item,
                            ) {
                              return DataRow(
                                cells: dailySalesColsJson.map((col) {
                                  final value = item[col['field']] ?? '';
                                  return DataCell(Text(value.toString()));
                                }).toList(),
                              );
                            }).toList(),
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
                            columns: receiptDetailsColsJson
                                .map(
                                  (col) =>
                                      DataColumn(label: Text(col['header']!)),
                                )
                                .toList(),
                            rows: _nightAuditReportVm.receiptDetailsRecodes.map(
                              (item) {
                                return DataRow(
                                  cells: receiptDetailsColsJson.map((col) {
                                    final value = item[col['field']] ?? '';
                                    return DataCell(Text(value.toString()));
                                  }).toList(),
                                );
                              },
                            ).toList(),
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
}
