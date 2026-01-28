import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:inta_mobile_pms/core/config/responsive_config.dart';
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
  DateTime? _selectedDate;
  CurrencyItem? _selectedCurrency;
  HotelItem? _selectedHotel;
  List<HotelItem> _selectedHotels = [];
  List<int> _selectedViewIndices = [];
  final ScrollController _horizontalController = ScrollController();
  bool _isMultipleHotel = false;
  bool _reportGenerated = false;

  @override
  void initState() {
    super.initState();
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
    _horizontalController.dispose();
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
        setState(() {
          _reportGenerated = true;
        });
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
    label: Align(
      alignment: Alignment.centerLeft,
      child: Text(title, style: TextTheme.of(context).titleMedium),
    ),
  );

  DataColumn _rightColAlign(String title) => DataColumn(
    label: Align(
      alignment: Alignment.centerRight,
      child: Text(title, style: TextTheme.of(context).titleMedium),
    ),
    numeric: true,
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
                              ),
                              dialogHeight: 400,
                              itemsTextStyle: const TextStyle(fontSize: 14),
                              selectedItemsTextStyle: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                              onConfirm: (values) {
                                setState(() {
                                  _selectedHotels = values;
                                  if (_selectedHotels.length > 1) {
                                    _isMultipleHotel = true;
                                  }
                                });
                              },
                              chipDisplay: MultiSelectChipDisplay.none(),
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
                                  return Align(
                                    alignment: Alignment
                                        .centerLeft, // or center if you want
                                    child: Text(
                                      item.code,
                                      style: TextStyle(
                                        color: AppColors.onPrimary,
                                        fontSize: 14,
                                      ),
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
                              IgnorePointer(
                                ignoring: true,
                                child: Checkbox(
                                  value: _isMultipleHotel,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      _isMultipleHotel = value ?? false;
                                    });
                                  },
                                  activeColor: Colors.white,
                                  checkColor: AppColors.primary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      // Obx(() {
                      //   if (!_managerReportVm.isShowHotelDropdown.value ||
                      //       _isMultipleHotel) {
                      //     return const Spacer();
                      //   } else {
                      //     return Expanded(
                      //       child: MultiSelectDialogField<int>(
                      //         items: _managerReportVm.receivedHotels
                      //             .map(
                      //               (hotel) => MultiSelectItem<int>(
                      //                 hotel["index"],
                      //                 hotel["hotelName"],
                      //               ),
                      //             )
                      //             .toList(),
                      //         title: const Text("Select Hotels"),
                      //         searchable: true,
                      //         initialValue: _selectedViewIndices,
                      //         buttonIcon: Icon(
                      //           Icons.arrow_drop_down,
                      //           color: AppColors.onPrimary,
                      //         ),
                      //         buttonText: Text(
                      //           _selectedViewIndices.isEmpty
                      //               ? "Select"
                      //               : "View Hotels",
                      //           style: TextStyle(
                      //             color: AppColors.onPrimary,
                      //             fontSize: 14,
                      //           ),
                      //           overflow: TextOverflow.ellipsis,
                      //         ),
                      //         decoration: BoxDecoration(
                      //           borderRadius: BorderRadius.circular(6),
                      //         ),
                      //         dialogHeight: 400,
                      //         itemsTextStyle: const TextStyle(fontSize: 14),
                      //         selectedItemsTextStyle: const TextStyle(
                      //           fontWeight: FontWeight.w600,
                      //         ),
                      //         onConfirm: (values) {
                      //           setState(() {
                      //             _selectedViewIndices = values;
                      //           });
                      //         },
                      //         chipDisplay: MultiSelectChipDisplay.none(),
                      //       ),
                      //     );
                      //   }
                      // }),
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
          Obx(() {
            // if (!_reportGenerated) {
            //   return Center(
            //     child: Text( 'No data available'),
            //   );
            // }
            if (_managerReportVm.isReportLoading.value) {
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
                child: SingleChildScrollView(
                  child: Scrollbar(
                    controller: _horizontalController,
                    thumbVisibility: true,
                    trackVisibility: true,
                    child: SingleChildScrollView(
                      controller: _horizontalController,
                      scrollDirection: Axis.horizontal,
                      child: _buildCombinedTable(),
                    ),
                  ),
                ),
              );
            }
          }),
        ],
      ),
    );
  }

  Widget _buildCombinedTable() {
    List<Map<String, dynamic>> sections = [
      {
        'title': 'Room Charges',
        'data': _managerReportVm.roomChargeData,
        'totals': _managerReportVm.roomChargeDataTotals,
      },
      {
        'title': 'Extra Charge',
        'data': _managerReportVm.extraChargeData,
        'totals': _managerReportVm.extraChargeDataTotals,
      },
      {
        'title': 'Adjustment',
        'data': _managerReportVm.adjustmentData,
        'totals': _managerReportVm.adjustmentDataTotals,
      },
      {
        'title': 'Tax',
        'data': _managerReportVm.taxData,
        'totals': _managerReportVm.taxDataTotals,
      },
      {
        'title': 'Discount',
        'data': _managerReportVm.discountData,
        'totals': _managerReportVm.discountDataTotals,
      },
      {
        'title': 'Pay Outs',
        'data': _managerReportVm.payoutData,
        'totals': _managerReportVm.payoutDataTotals,
      },
      {
        'title': 'POS Revenue',
        'data': _managerReportVm.posRevenueData,
        'totals': _managerReportVm.posRevenueDataTotals,
      },
      {
        'title': 'Payment',
        'data': _managerReportVm.paymentData,
        'totals': _managerReportVm.paymentDataTotals,
      },
      {
        'title': 'POS Revenue Payment',
        'data': _managerReportVm.posRevenuePaymentData,
        'totals': _managerReportVm.posRevenuePaymentDataTotals,
      },
      {'title': 'City Ledger', 'data': _managerReportVm.cityLedgerData},
      {'title': 'Room Summary', 'data': _managerReportVm.roomSummaryData},
      {'title': 'Statistics', 'data': _managerReportVm.statisticRecordsData},
    ];

    List<DataRow> allRows = [];

    for (var section in sections) {
      var data = section['data'] as RxList<dynamic>;
      if (data.isNotEmpty) {
        allRows.add(
          DataRow(
            color: MaterialStateProperty.all(Colors.blue[50]),
            cells: [
              _leftBoldCell(section['title']),
              DataCell(Text('')),
              DataCell(Text('')),
              DataCell(Text('')),
            ],
          ),
        );

        allRows.addAll(
          data.map<DataRow>((item) {
            return DataRow(
              cells: cols.map((col) {
                var field = col['field'];
                var value = item[field];
                if (field == "description") {
                  return _leftCell(value ?? '');
                } else {
                  var formatted = formatCurrency(value);
                  return _rightCell(formatted);
                }
              }).toList(),
            );
          }).toList(),
        );
        var totals = section['totals'] as Map<String, dynamic>?;
        if (totals != null) {
          allRows.add(
            DataRow(
              // color: MaterialStateProperty.all(Colors.green[50]),
              cells: [
                _leftBoldCell('Total'),
                _rightBoldCell(formatCurrency(totals["today"])),
                _rightBoldCell(formatCurrency(totals["ptd"])),
                _rightBoldCell(formatCurrency(totals["ytd"])),
              ],
            ),
          );
        }
      }
    }

    if (allRows.isEmpty) {
      return Center(child: Text(_reportGenerated ? 'No data available' : ''));
    } else {
      return DataTable(
        headingRowColor: MaterialStateProperty.all(Colors.grey[200]),
        columns: cols.map((col) {
          var header = col['header']!;
          if (col['field'] == "description") {
            return _leftColAlign(header);
          } else {
            return _rightColAlign(header);
          }
        }).toList(),
        rows: allRows,
      );
    }
  }

  String formatCurrency(num? value) {
    if (value == null) return '0.00';
    final formatter = NumberFormat('#,##0.00');
    return formatter.format(value);
  }
}
