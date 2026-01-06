import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:inta_mobile_pms/core/theme/app_colors.dart';
import 'package:inta_mobile_pms/features/reports/models/currency_item.dart';
import 'package:inta_mobile_pms/features/reports/models/hotel_item.dart';
import 'package:inta_mobile_pms/features/reports/viewmodels/manager_report_vm.dart';
import 'package:inta_mobile_pms/services/message_service.dart';
import 'package:intl/intl.dart';
import 'package:multi_select_flutter/chip_display/multi_select_chip_display.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:shimmer/shimmer.dart';

class ManagerReport extends StatefulWidget {
  const ManagerReport({super.key});

  @override
  State<ManagerReport> createState() => _ReportWidgetState();
}

class _ReportWidgetState extends State<ManagerReport>
    with SingleTickerProviderStateMixin {
  final _managerReportVm = Get.find<ManagerReportVm>();
  late List<CurrencyItem> _currencyList = [
    CurrencyItem(currencyId: -1, code: 'None', symbol: 'None'),
  ];
  late List<HotelItem> _hotelList = [HotelItem(hotelId: -1, hotelName: 'All')];
  late TabController _tabController;
  DateTime? _selectedDate;
  CurrencyItem? _selectedCurrency;
  HotelItem? _selectedHotel;
  List<HotelItem> _selectedHotels = [];
  List<int> _selectedViewIndices = [];
  final List<ScrollController> _horizontalControllers = [];
  bool _isMultipleHotel = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 12, vsync: this);
    for (int i = 0; i < 12; i++) {
      _horizontalControllers.add(ScrollController());
    }
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (mounted) {
        _managerReportVm.resetData();
        await _managerReportVm.loadInitialData();

        setState(() {
          _selectedDate = _managerReportVm.systemWorkingDate.value.subtract(
            const Duration(days: 1),
          );
          _currencyList = _managerReportVm.currencyList.toList();
          _hotelList = _managerReportVm.hotelList.toList();
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

      if (_selectedHotels.isEmpty) {
        MessageService().error('Please select a hotel');
        return;
      }
      if (_selectedCurrency != null &&
          _selectedDate != null &&
          _selectedHotels.isNotEmpty) {
        await _managerReportVm.getManagerReport(
          _selectedCurrency!,
          _selectedDate!,
          _selectedHotels,
          _isMultipleHotel,
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

  final cols = [
    {"field": "description", "header": "Particulars"},
    {"field": "today", "header": "Today"},
    {"field": "ptd", "header": "PDT"},
    {"field": "ytd", "header": "YDT"},
  ];

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Manager Report')),
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Hotel',
                              style: TextStyle(
                                color: AppColors.onPrimary,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 4),
                            MultiSelectDialogField<HotelItem>(
                              items: _managerReportVm.hotelList
                                  .map(
                                    (hotel) => MultiSelectItem<HotelItem>(
                                      hotel,
                                      hotel.hotelName,
                                    ),
                                  )
                                  .toList(),
                              title: const Text("Select Hotels"),
                              searchable: true,
                              initialValue: _selectedHotels,
                              buttonIcon: Icon(
                                Icons.arrow_drop_down,
                                color: AppColors.onPrimary,
                              ),
                              buttonText: Text(
                                _selectedHotels.isEmpty
                                    ? "Select"
                                    : "View Hotels",
                                style: TextStyle(
                                  color: AppColors.onPrimary,
                                  fontSize: 14,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(color: Colors.white),
                              ),
                              dialogHeight: 400,
                              itemsTextStyle: const TextStyle(fontSize: 14),
                              selectedItemsTextStyle: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                              onConfirm: (values) {
                                setState(() {
                                  _selectedHotels = values;
                                });
                              },
                              chipDisplay: MultiSelectChipDisplay.none(),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      if (_selectedHotels.length > 1)
                        Flexible(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Is Multiple Hotel',
                                style: TextStyle(
                                  color: AppColors.onPrimary,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Checkbox(
                                value: _isMultipleHotel,
                                onChanged: (bool? value) {
                                  setState(() {
                                    _isMultipleHotel = value ?? false;
                                  });
                                },
                                activeColor: Colors.white,
                                checkColor: AppColors.primary,
                              ),
                            ],
                          ),
                        ),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Column(
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
                                    : '${_selectedDate!.toLocal()}'.split(
                                        ' ',
                                      )[0],
                                style: TextStyle(fontSize: 14),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Column(
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
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Obx(() {
                        if (!_managerReportVm.isShowHotelDropdown.value ||
                            _isMultipleHotel) {
                          return const Spacer();
                        } else {
                          return Expanded(
                            child: MultiSelectDialogField<int>(
                              items: _managerReportVm.receivedHotels
                                  .map(
                                    (hotel) => MultiSelectItem<int>(
                                      hotel["index"],
                                      hotel["hotelName"],
                                    ),
                                  )
                                  .toList(),
                              title: const Text("Select Hotels"),
                              searchable: true,
                              initialValue: _selectedViewIndices,
                              buttonIcon: Icon(
                                Icons.arrow_drop_down,
                                color: AppColors.onPrimary,
                              ),
                              buttonText: Text(
                                _selectedViewIndices.isEmpty
                                    ? "Select"
                                    : "View Hotels",
                                style: TextStyle(
                                  color: AppColors.onPrimary,
                                  fontSize: 14,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(color: Colors.white),
                              ),
                              dialogHeight: 400,
                              itemsTextStyle: const TextStyle(fontSize: 14),
                              selectedItemsTextStyle: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                              onConfirm: (values) {
                                setState(() {
                                  _selectedViewIndices = values;
                                });
                                // TODO: Bind to VM, e.g., _managerReportVm.loadTablesAccordingToHotels(values);
                              },
                              chipDisplay: MultiSelectChipDisplay.none(),
                            ),
                          );
                        }
                      }),
                      const SizedBox(width: 12),
                      Obx(
                        () => ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            foregroundColor: AppColors.primary,
                            backgroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                          ),
                          onPressed: _managerReportVm.isLoading.value
                              ? null
                              : () {
                                  _loadReportData();
                                },
                          child: _managerReportVm.isLoading.value
                              ? CircularProgressIndicator(
                                  color: AppColors.primary,
                                )
                              : const Text(
                                  'Generate',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
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
                Tab(text: 'Extra Charge'),
                Tab(text: 'Adjustment'),
                Tab(text: 'Tax'),
                Tab(text: 'Discount'),
                Tab(text: 'Pay Outs'),
                Tab(text: 'POS Revenue'),
                Tab(text: 'Payment'),
                Tab(text: 'POS Revenue Payment'),
                Tab(text: 'City Ledger'),
                Tab(text: 'Room Summary'),
                Tab(text: 'Statistics'),
              ],
            ),
          ),
          Obx(() {
            if (_managerReportVm.isLoading.value) {
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
            } else if (_managerReportVm.roomChargeData.isEmpty) {
              return const Expanded(
                child: Center(child: Text('Please generate the report')),
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
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: DataTable(
                              columns: cols.map((col) {
                                if (['description'].contains(col['field'])) {
                                  return _leftColAlign(col['header']!);
                                } else {
                                  return _rightColAlign(col['header']!);
                                }
                              }).toList(),
                              rows: [
                                ..._managerReportVm.roomChargeData.map((item) {
                                  return DataRow(
                                    cells: cols.map((col) {
                                      if ([
                                        'description',
                                      ].contains(col['field'])) {
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
                                DataRow(
                                  cells: [
                                    DataCell(Text('Total')),

                                    _rightCell(
                                      formatCurrency(
                                        _managerReportVm
                                            .roomChargeDataTotals["today"],
                                      ).toString(),
                                    ),

                                    _rightCell(
                                      formatCurrency(
                                        _managerReportVm
                                            .roomChargeDataTotals["ptd"],
                                      ).toString(),
                                    ),
                                    _rightCell(
                                      formatCurrency(
                                        _managerReportVm
                                            .roomChargeDataTotals["ytd"],
                                      ).toString(),
                                    ),
                                  ],
                                ),
                              ],
                            ),
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
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: DataTable(
                              columns: cols.map((col) {
                                if (['description'].contains(col['field'])) {
                                  return _leftColAlign(col['header']!);
                                } else {
                                  return _rightColAlign(col['header']!);
                                }
                              }).toList(),
                              rows: [
                                ..._managerReportVm.extraChargeData.map((item) {
                                  return DataRow(
                                    cells: cols.map((col) {
                                      if ([
                                        'description',
                                      ].contains(col['field'])) {
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
                                DataRow(
                                  cells: [
                                    DataCell(Text('Total')),

                                    _rightCell(
                                      formatCurrency(
                                        _managerReportVm
                                            .extraChargeDataTotals["today"],
                                      ).toString(),
                                    ),

                                    _rightCell(
                                      formatCurrency(
                                        _managerReportVm
                                            .extraChargeDataTotals["ptd"],
                                      ).toString(),
                                    ),
                                    _rightCell(
                                      formatCurrency(
                                        _managerReportVm
                                            .extraChargeDataTotals["ytd"],
                                      ).toString(),
                                    ),
                                  ],
                                ),
                              ],
                            ),
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
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: DataTable(
                              columns: cols.map((col) {
                                if (['description'].contains(col['field'])) {
                                  return _leftColAlign(col['header']!);
                                } else {
                                  return _rightColAlign(col['header']!);
                                }
                              }).toList(),
                              rows: [
                                ..._managerReportVm.adjustmentData.map((item) {
                                  return DataRow(
                                    cells: cols.map((col) {
                                      if ([
                                        'description',
                                      ].contains(col['field'])) {
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
                                DataRow(
                                  cells: [
                                    DataCell(Text('Total')),

                                    _rightCell(
                                      formatCurrency(
                                        _managerReportVm
                                            .adjustmentDataTotals["today"],
                                      ).toString(),
                                    ),

                                    _rightCell(
                                      formatCurrency(
                                        _managerReportVm
                                            .adjustmentDataTotals["ptd"],
                                      ).toString(),
                                    ),
                                    _rightCell(
                                      formatCurrency(
                                        _managerReportVm
                                            .adjustmentDataTotals["ytd"],
                                      ).toString(),
                                    ),
                                  ],
                                ),
                              ],
                            ),
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
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: DataTable(
                              columns: cols.map((col) {
                                if (['description'].contains(col['field'])) {
                                  return _leftColAlign(col['header']!);
                                } else {
                                  return _rightColAlign(col['header']!);
                                }
                              }).toList(),
                              rows: [
                                ..._managerReportVm.taxData.map((item) {
                                  return DataRow(
                                    cells: cols.map((col) {
                                      if ([
                                        'description',
                                      ].contains(col['field'])) {
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
                                DataRow(
                                  cells: [
                                    DataCell(Text('Total')),

                                    _rightCell(
                                      formatCurrency(
                                        _managerReportVm.taxDataTotals["today"],
                                      ).toString(),
                                    ),

                                    _rightCell(
                                      formatCurrency(
                                        _managerReportVm.taxDataTotals["ptd"],
                                      ).toString(),
                                    ),
                                    _rightCell(
                                      formatCurrency(
                                        _managerReportVm.taxDataTotals["ytd"],
                                      ).toString(),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    SingleChildScrollView(
                      child: Scrollbar(
                        controller: _horizontalControllers[4],
                        thumbVisibility: true,
                        trackVisibility: true,
                        child: SingleChildScrollView(
                          controller: _horizontalControllers[4],
                          scrollDirection: Axis.horizontal,
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: DataTable(
                              columns: cols.map((col) {
                                if (['description'].contains(col['field'])) {
                                  return _leftColAlign(col['header']!);
                                } else {
                                  return _rightColAlign(col['header']!);
                                }
                              }).toList(),
                              rows: [
                                ..._managerReportVm.discountData.map((item) {
                                  return DataRow(
                                    cells: cols.map((col) {
                                      if ([
                                        'description',
                                      ].contains(col['field'])) {
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
                                DataRow(
                                  cells: [
                                    DataCell(Text('Total')),

                                    _rightCell(
                                      formatCurrency(
                                        _managerReportVm
                                            .discountDataTotals["today"],
                                      ).toString(),
                                    ),

                                    _rightCell(
                                      formatCurrency(
                                        _managerReportVm
                                            .discountDataTotals["ptd"],
                                      ).toString(),
                                    ),
                                    _rightCell(
                                      formatCurrency(
                                        _managerReportVm
                                            .discountDataTotals["ytd"],
                                      ).toString(),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    SingleChildScrollView(
                      child: Scrollbar(
                        controller: _horizontalControllers[5],
                        thumbVisibility: true,
                        trackVisibility: true,
                        child: SingleChildScrollView(
                          controller: _horizontalControllers[5],
                          scrollDirection: Axis.horizontal,
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: DataTable(
                              columns: cols.map((col) {
                                if (['description'].contains(col['field'])) {
                                  return _leftColAlign(col['header']!);
                                } else {
                                  return _rightColAlign(col['header']!);
                                }
                              }).toList(),
                              rows: [
                                ..._managerReportVm.payoutData.map((item) {
                                  return DataRow(
                                    cells: cols.map((col) {
                                      if ([
                                        'description',
                                      ].contains(col['field'])) {
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
                                DataRow(
                                  cells: [
                                    DataCell(Text('Total')),

                                    _rightCell(
                                      formatCurrency(
                                        _managerReportVm
                                            .payoutDataTotals["today"],
                                      ).toString(),
                                    ),

                                    _rightCell(
                                      formatCurrency(
                                        _managerReportVm
                                            .payoutDataTotals["ptd"],
                                      ).toString(),
                                    ),
                                    _rightCell(
                                      formatCurrency(
                                        _managerReportVm
                                            .payoutDataTotals["ytd"],
                                      ).toString(),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    SingleChildScrollView(
                      child: Scrollbar(
                        controller: _horizontalControllers[6],
                        thumbVisibility: true,
                        trackVisibility: true,
                        child: SingleChildScrollView(
                          controller: _horizontalControllers[6],
                          scrollDirection: Axis.horizontal,
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: DataTable(
                              columns: cols.map((col) {
                                if (['description'].contains(col['field'])) {
                                  return _leftColAlign(col['header']!);
                                } else {
                                  return _rightColAlign(col['header']!);
                                }
                              }).toList(),
                              rows: [
                                ..._managerReportVm.posRevenueData.map((item) {
                                  return DataRow(
                                    cells: cols.map((col) {
                                      if ([
                                        'description',
                                      ].contains(col['field'])) {
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
                                DataRow(
                                  cells: [
                                    DataCell(Text('Total')),

                                    _rightCell(
                                      formatCurrency(
                                        _managerReportVm
                                            .posRevenueDataTotals["today"],
                                      ).toString(),
                                    ),

                                    _rightCell(
                                      formatCurrency(
                                        _managerReportVm
                                            .posRevenueDataTotals["ptd"],
                                      ).toString(),
                                    ),
                                    _rightCell(
                                      formatCurrency(
                                        _managerReportVm
                                            .posRevenueDataTotals["ytd"],
                                      ).toString(),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    SingleChildScrollView(
                      child: Scrollbar(
                        controller: _horizontalControllers[7],
                        thumbVisibility: true,
                        trackVisibility: true,
                        child: SingleChildScrollView(
                          controller: _horizontalControllers[7],
                          scrollDirection: Axis.horizontal,
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: DataTable(
                              columns: cols.map((col) {
                                if (['description'].contains(col['field'])) {
                                  return _leftColAlign(col['header']!);
                                } else {
                                  return _rightColAlign(col['header']!);
                                }
                              }).toList(),
                              rows: [
                                ..._managerReportVm.paymentData.map((item) {
                                  return DataRow(
                                    cells: cols.map((col) {
                                      if ([
                                        'description',
                                      ].contains(col['field'])) {
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
                                DataRow(
                                  cells: [
                                    DataCell(Text('Total')),

                                    _rightCell(
                                      formatCurrency(
                                        _managerReportVm
                                            .paymentDataTotals["today"],
                                      ).toString(),
                                    ),

                                    _rightCell(
                                      formatCurrency(
                                        _managerReportVm
                                            .paymentDataTotals["ptd"],
                                      ).toString(),
                                    ),
                                    _rightCell(
                                      formatCurrency(
                                        _managerReportVm
                                            .paymentDataTotals["ytd"],
                                      ).toString(),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    SingleChildScrollView(
                      child: Scrollbar(
                        controller: _horizontalControllers[8],
                        thumbVisibility: true,
                        trackVisibility: true,
                        child: SingleChildScrollView(
                          controller: _horizontalControllers[8],
                          scrollDirection: Axis.horizontal,
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: DataTable(
                              columns: cols.map((col) {
                                if (['description'].contains(col['field'])) {
                                  return _leftColAlign(col['header']!);
                                } else {
                                  return _rightColAlign(col['header']!);
                                }
                              }).toList(),
                              rows: [
                                ..._managerReportVm.posRevenuePaymentData.map((
                                  item,
                                ) {
                                  return DataRow(
                                    cells: cols.map((col) {
                                      if ([
                                        'description',
                                      ].contains(col['field'])) {
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
                                DataRow(
                                  cells: [
                                    DataCell(Text('Total')),

                                    _rightCell(
                                      formatCurrency(
                                        _managerReportVm
                                            .posRevenuePaymentDataTotals["today"],
                                      ).toString(),
                                    ),

                                    _rightCell(
                                      formatCurrency(
                                        _managerReportVm
                                            .posRevenuePaymentDataTotals["ptd"],
                                      ).toString(),
                                    ),
                                    _rightCell(
                                      formatCurrency(
                                        _managerReportVm
                                            .posRevenuePaymentDataTotals["ytd"],
                                      ).toString(),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    SingleChildScrollView(
                      child: Scrollbar(
                        controller: _horizontalControllers[9],
                        thumbVisibility: true,
                        trackVisibility: true,
                        child: SingleChildScrollView(
                          controller: _horizontalControllers[9],
                          scrollDirection: Axis.horizontal,
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: DataTable(
                              columns: cols.map((col) {
                                if (['description'].contains(col['field'])) {
                                  return _leftColAlign(col['header']!);
                                } else {
                                  return _rightColAlign(col['header']!);
                                }
                              }).toList(),
                              rows: [
                                ..._managerReportVm.cityLedgerData.map((item) {
                                  return DataRow(
                                    cells: cols.map((col) {
                                      if ([
                                        'description',
                                      ].contains(col['field'])) {
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
                                DataRow(
                                  cells: [
                                    DataCell(Text('Total')),

                                    _rightCell(
                                      formatCurrency(
                                        _managerReportVm
                                            .cityLedgerDataTotals["today"],
                                      ).toString(),
                                    ),

                                    _rightCell(
                                      formatCurrency(
                                        _managerReportVm
                                            .cityLedgerDataTotals["ptd"],
                                      ).toString(),
                                    ),
                                    _rightCell(
                                      formatCurrency(
                                        _managerReportVm
                                            .cityLedgerDataTotals["ytd"],
                                      ).toString(),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    SingleChildScrollView(
                      child: Scrollbar(
                        controller: _horizontalControllers[10],
                        thumbVisibility: true,
                        trackVisibility: true,
                        child: SingleChildScrollView(
                          controller: _horizontalControllers[10],
                          scrollDirection: Axis.horizontal,
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: DataTable(
                              columns: cols.map((col) {
                                if (['description'].contains(col['field'])) {
                                  return _leftColAlign(col['header']!);
                                } else {
                                  return _rightColAlign(col['header']!);
                                }
                              }).toList(),
                              rows: [
                                ..._managerReportVm.roomSummaryData.map((item) {
                                  return DataRow(
                                    cells: cols.map((col) {
                                      if ([
                                        'description',
                                      ].contains(col['field'])) {
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
                                DataRow(
                                  cells: [
                                    DataCell(Text('Total')),

                                    _rightCell(
                                      formatCurrency(
                                        _managerReportVm
                                            .roomSummaryDataTotals["today"],
                                      ).toString(),
                                    ),

                                    _rightCell(
                                      formatCurrency(
                                        _managerReportVm
                                            .roomSummaryDataTotals["ptd"],
                                      ).toString(),
                                    ),
                                    _rightCell(
                                      formatCurrency(
                                        _managerReportVm
                                            .roomSummaryDataTotals["ytd"],
                                      ).toString(),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    SingleChildScrollView(
                      child: Scrollbar(
                        controller: _horizontalControllers[10],
                        thumbVisibility: true,
                        trackVisibility: true,
                        child: SingleChildScrollView(
                          controller: _horizontalControllers[10],
                          scrollDirection: Axis.horizontal,
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: DataTable(
                              columns: cols.map((col) {
                                if (['description'].contains(col['field'])) {
                                  return _leftColAlign(col['header']!);
                                } else {
                                  return _rightColAlign(col['header']!);
                                }
                              }).toList(),
                              rows: [
                                ..._managerReportVm.statisticRecordsData.map((
                                  item,
                                ) {
                                  return DataRow(
                                    cells: cols.map((col) {
                                      if ([
                                        'description',
                                      ].contains(col['field'])) {
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
                              ],
                            ),
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
