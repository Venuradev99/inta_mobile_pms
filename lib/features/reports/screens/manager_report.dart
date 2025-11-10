import 'package:flutter/material.dart';
import 'package:get/Get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:inta_mobile_pms/core/config/responsive_config.dart';
import 'package:inta_mobile_pms/core/widgets/custom_appbar.dart';
import 'package:inta_mobile_pms/features/reports/models/manager_report.dart';
import 'package:inta_mobile_pms/features/reports/models/manager_report_payload.dart';
import 'package:inta_mobile_pms/features/reports/viewmodels/manager_report_vm.dart';
import 'package:inta_mobile_pms/services/message_service.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

import 'package:inta_mobile_pms/core/theme/app_colors.dart';
import 'package:inta_mobile_pms/core/theme/app_text_theme.dart';

class ManagerReport extends StatefulWidget {
  const ManagerReport({super.key});

  @override
  State<ManagerReport> createState() => _ManagerReportState();
}

class _ManagerReportState extends State<ManagerReport> {
  final _managerReportVm = Get.find<ManagerReportVm>();

  int _selectedPeriod = 1;

  NumberFormat _currencyFormat = NumberFormat('#,##0.00');

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (mounted) {
        await _managerReportVm.loadInitialData();

        setState(() {
          selectedDate = _managerReportVm.systemWorkingDate.value;
        });
      }
    });
  }

  List<String> selectedHotels = [];
  DateTime? selectedDate;

  final List<String> currencyList = [];
  String? selectedCurrency;
  bool _showReport = false;

  dynamic _getValue(dynamic  item) {
    switch (_selectedPeriod) {
      case 0:
        return item.today;
      case 1:
        return item.ptd;
      case 2:
        return item.ytd;
      default:
        return 0.0;
    }
  }

  void _handleRefresh() {
    setState(() {});
  }

  void _handleFilter() {}

  void _handleInfo() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Manager Report Information'),
        content: const Text(
          'This report shows financial data and room statistics. Select a time period (Today, PDT, or YTD) to view corresponding data.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? now,
      firstDate: DateTime(2000),
      lastDate: DateTime(2050),
    );

    if (picked != null) {
      setState(() => selectedDate = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        title: 'Manager Report',
        onInfoTap: _handleInfo,
        onFilterTap: _handleFilter,
        onRefreshTap: _handleRefresh,
      ),
      body: ListView(
        padding: ResponsiveConfig.verticalPadding(
          context,
        ).add(ResponsiveConfig.horizontalPadding(context)),
        children: [
         Row(
  crossAxisAlignment: CrossAxisAlignment.end,
  children: [
    // DATE PICKER
    Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Date", style: AppTextTheme.lightTextTheme.titleMedium),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: _pickDate,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade400),
              ),
              child: Text(
                selectedDate != null
                    ? DateFormat('yyyy-MM-dd').format(selectedDate!)
                    : "Select",
                style: AppTextTheme.lightTextTheme.bodyMedium,
              ),
            ),
          ),
        ],
      ),
    ),

    // CURRENCY DROPDOWN
    Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Currency", style: AppTextTheme.lightTextTheme.titleMedium),
          const SizedBox(height: 8),
          Obx(() {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade400),
              ),
              child: DropdownButton<String>(
                isExpanded: true,
                underline: const SizedBox(),
                hint: const Text("Select"),
                value: selectedCurrency,
                items: _managerReportVm.currencyList
                    .map((e) => DropdownMenuItem(
                          value: e.code,
                          child: Text(e.code),
                        ))
                    .toList(),
                onChanged: (val) => setState(() => selectedCurrency = val),
              ),
            );
          }),
        ],
      ),
    ),

    const SizedBox(width: 24),

    // GENERATE BUTTON
    SizedBox(
      height: 48,
      child: ElevatedButton(
        onPressed: () async {
          if (selectedDate == null || selectedCurrency == null) {
            MessageService().error(
              "Please select a date and currency.",
            );
            return;
          }

          _managerReportVm.isReportLoading.value = true;

          await _managerReportVm.getManagerReport(
            selectedCurrency!,
            selectedDate!,
          );

          _managerReportVm.isReportLoading.value = false;

          setState(() {
            _currencyFormat = NumberFormat.currency(
              locale: 'en_US',
              symbol: _managerReportVm.getCurrencySymbol(selectedCurrency),
              decimalDigits: 2,
            );
            _showReport = true;
          });
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          padding: const EdgeInsets.symmetric(horizontal: 16),
        ),
        child: const Text(
          "Generate",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    ),
  ],
)
,

          const SizedBox(height: 40),

          Obx(() {
            if (_managerReportVm.isReportLoading.value) {
              return _buildReportShimmer(context);
            } else if (_showReport) {
              return Column(
                children: [
                  Padding(
                    padding: ResponsiveConfig.horizontalPadding(context),
                    child: Text(
                      'As on Date: ${selectedDate != null ? DateFormat('yyyy-MM-dd').format(selectedDate!) : ''}',
                      style: AppTextTheme.lightTextTheme.titleMedium?.copyWith(
                        color: AppColors.darkgrey,
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),
                  Padding(
                    padding: ResponsiveConfig.horizontalPadding(context),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildPeriodRadio(0, 'Today'),
                        _buildPeriodRadio(1, 'PDT'),
                        _buildPeriodRadio(2, 'YTD'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  ..._managerReportVm.financialSections.entries.map(
                    (entry) =>
                        _buildFinancialSection(context, entry.key, entry.value),
                  ),
                  _buildRoomSummarySection(context),
                ],
              );
            } else {
              return const SizedBox();
            }
          }),
        ],
      ),
    );
  }

  Widget _buildPeriodRadio(int value, String label) {
    return Row(
      children: [
        Radio<int>(
          value: value,
          groupValue: _selectedPeriod,
          onChanged: (val) => setState(() => _selectedPeriod = val!),
          activeColor: AppColors.primary,
        ),
        Text(label, style: AppTextTheme.lightTextTheme.bodyMedium),
      ],
    );
  }

  Widget _buildFinancialSection(
    BuildContext context,
    String title,
    List<dynamic> items,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          color: const Color(0xFFE3F2FD),
          child: Text(
            title,
            style: AppTextTheme.lightTextTheme.titleSmall?.copyWith(
              color: AppColors.primary,
            ),
          ),
        ),
        ...items.map((item) {
          final value = _getValue(item) as num;
          final isNegative = value < 0;
          return Column(
            children: [
              Padding(
                padding: ResponsiveConfig.horizontalPadding(
                  context,
                ).copyWith(top: 8, bottom: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        item.description,
                        style: AppTextTheme.lightTextTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                    Text(
                      _currencyFormat.format(value),
                      style: AppTextTheme.lightTextTheme.bodyMedium?.copyWith(
                        fontWeight:FontWeight.normal,
                        color: isNegative ? AppColors.red : AppColors.black,
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(color: Color(0xFFE0E0E0), height: 1),
            ],
          );
        }),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildRoomSummarySection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          color: const Color(0xFFE3F2FD),
          child: Text(
            'Room Summary',
            style: AppTextTheme.lightTextTheme.titleSmall?.copyWith(
              color: AppColors.primary,
            ),
          ),
        ),
        ..._managerReportVm.roomSummaryItems.map((item) {
          final value = _getValue(item);
          return Column(
            children: [
              Padding(
                padding: ResponsiveConfig.horizontalPadding(
                  context,
                ).copyWith(top: 8, bottom: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        item.description,
                        style: AppTextTheme.lightTextTheme.bodyMedium,
                      ),
                    ),
                    Text(
                      value.toString(),
                      style: AppTextTheme.lightTextTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              const Divider(color: Color(0xFFE0E0E0), height: 1),
            ],
          );
        }),
      ],
    );
  }

  Widget _buildReportShimmer(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: ResponsiveConfig.horizontalPadding(context),
            child: Container(
              width: 200,
              height: 20,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: ResponsiveConfig.horizontalPadding(context),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(
                3,
                (_) => Row(
                  children: [
                    Container(
                      width: 20,
                      height: 20,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 8),
                    Container(
                      width: 50,
                      height: 16,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          ...List.generate(
            4, // Assuming approximately 4 sections including room summary
            (_) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  height: 40,
                  color: Colors.white,
                ),
                ...List.generate(
                  6, // Assuming average 6 items per section
                  (_) => Column(
                    children: [
                      Padding(
                        padding: ResponsiveConfig.horizontalPadding(context)
                            .copyWith(top: 8, bottom: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Container(
                                height: 16,
                                color: Colors.white,
                              ),
                            ),
                            Container(
                              width: 100,
                              height: 16,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
                      const Divider(
                        color: Colors.transparent,
                        height: 1,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }
}