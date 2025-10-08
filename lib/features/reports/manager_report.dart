import 'package:flutter/material.dart';
import 'package:inta_mobile_pms/core/config/responsive_config.dart';
import 'package:inta_mobile_pms/core/widgets/custom_appbar.dart';
import 'package:intl/intl.dart';

import 'package:inta_mobile_pms/core/theme/app_colors.dart';
import 'package:inta_mobile_pms/core/theme/app_text_theme.dart';


class ManagerReport extends StatefulWidget {
  const ManagerReport({super.key});

  @override
  State<ManagerReport> createState() => _ManagerReportState();
}

class _ManagerReportState extends State<ManagerReport> {
  int _selectedPeriod = 1;

  final NumberFormat _currencyFormat = NumberFormat('#,##0.00');

  // Financial sections with double values
  final Map<String, List<Map<String, dynamic>>> financialSections = {
    'Room Charges': [
      {'name': 'Cancellation Revenue', 'today': 0.0, 'pdt': 37600.0, 'ydt': 325840.26},
      {'name': 'Day Use Charges', 'today': 0.0, 'pdt': 0.0, 'ydt': 139000.0},
      {'name': 'Late CheckOut Charges', 'today': 0.0, 'pdt': 0.0, 'ydt': 92547.25},
      {'name': 'No Show Revenue', 'today': 0.0, 'pdt': 0.0, 'ydt': 349800.0},
      {'name': 'Room Charges', 'today': 30000.0, 'pdt': 265550.38, 'ydt': 2575755.93},
      {'name': 'Early Check In Charges', 'today': 0.0, 'pdt': 0.0, 'ydt': 17200.0},
      {'name': 'Group Total', 'today': 30000.0, 'pdt': 303150.38, 'ydt': 3500143.44, 'bold': true},
    ],
    'Extra Charges': [
      {'name': 'Airport Transfer', 'today': 0.0, 'pdt': 0.0, 'ydt': 34000.0},
      {'name': 'Connecting Room Request', 'today': 0.0, 'pdt': 3666.66, 'ydt': 7876.05},
      {'name': 'Mini-Bar Consumption', 'today': 0.0, 'pdt': 454.55, 'ydt': 5909.13},
      {'name': 'Deep Cleaning (after pet or sm', 'today': 0.0, 'pdt': 0.0, 'ydt': 3000.0},
      {'name': 'Courier / Postage Services', 'today': 0.0, 'pdt': 0.0, 'ydt': 500.0},
      {'name': 'Extra Slipper', 'today': 0.0, 'pdt': 1785.72, 'ydt': 80357.2},
      {'name': 'Group Total', 'today': 0.0, 'pdt': 5906.93, 'ydt': 131642.38, 'bold': true},
    ],
    'Adjustments': [
      {'name': 'Adjustment Amount', 'today': 0.0, 'pdt': 0.0, 'ydt': 1788.5},
      {'name': 'Group Total', 'today': 0.0, 'pdt': 0.0, 'ydt': 1788.5, 'bold': true},
    ],
    'Tax': [
      {'name': 'Service Charge', 'today': 1050.0, 'pdt': 14045.73, 'ydt': 220110.42},
      {'name': 'TDL 1%', 'today': 210.0, 'pdt': 2800.07, 'ydt': 39976.02},
      {'name': 'VAT', 'today': 525.0, 'pdt': 6910.86, 'ydt': 108094.33},
      {'name': 'SSCL', 'today': 300.0, 'pdt': 3726.51, 'ydt': 45687.77},
      {'name': 'Group Total', 'today': 2085.0, 'pdt': 27483.17, 'ydt': 413868.54, 'bold': true},
    ],
    'Discount': [
      {'name': 'Festive Offer(B)', 'today': 0.0, 'pdt': 0.0, 'ydt': -16860.16},
      {'name': 'Direct Booking Discount(E)', 'today': 0.0, 'pdt': 0.0, 'ydt': -2880.0},
      {'name': 'Loyalty Member Discount (B)', 'today': 0.0, 'pdt': 0.0, 'ydt': -1407.5},
      {'name': 'Anniversary Offer (R)', 'today': 0.0, 'pdt': 0.0, 'ydt': -65781.52},
      {'name': 'Referral Discount (B)', 'today': 0.0, 'pdt': 0.0, 'ydt': -14672.5},
      {'name': 'Room Discount (R)', 'today': 0.0, 'pdt': 0.0, 'ydt': -2527.94},
      {'name': 'Extra Discount (E)', 'today': 0.0, 'pdt': 0.0, 'ydt': -7510.0},
      {'name': 'Test 04', 'today': 0.0, 'pdt': 0.0, 'ydt': -20100.0},
      {'name': 'Group Total', 'today': 0.0, 'pdt': 0.0, 'ydt': -131739.62, 'bold': true},
    ],
    'Pay Outs': [
      {'name': 'Fresh Flowers', 'today': 0.0, 'pdt': 0.0, 'ydt': 25000.0},
      {'name': 'Group Total', 'today': 0.0, 'pdt': 0.0, 'ydt': 25000.0, 'bold': true},
    ],
    'Total Revenue': [
      {'name': 'Total Revenue without Tax', 'today': 30000.0, 'pdt': 309057.31, 'ydt': 3476834.70, 'bold': true},
      {'name': 'Total Revenue with Tax', 'today': 32085.0, 'pdt': 336540.48, 'ydt': 3890703.24, 'bold': true},
    ],
    'Payment': [
      {'name': 'CASH', 'today': 0.0, 'pdt': 0.0, 'ydt': 685752.69},
      {'name': 'CHEQUE', 'today': 0.0, 'pdt': 0.0, 'ydt': 926465.86},
      {'name': 'CREDIT CARD', 'today': 0.0, 'pdt': 0.0, 'ydt': 153148.0},
      {'name': 'ADVANCE', 'today': 0.0, 'pdt': 0.0, 'ydt': 226096.07},
      {'name': 'PayPal', 'today': 0.0, 'pdt': 0.0, 'ydt': 9850.0},
      {'name': 'Bank Transfer', 'today': 0.0, 'pdt': 0.0, 'ydt': 74787.0},
      {'name': 'Digital Payment', 'today': 0.0, 'pdt': 0.0, 'ydt': 54595.0},
      {'name': 'Google Pay', 'today': 0.0, 'pdt': 0.0, 'ydt': 98593.48},
      {'name': 'Total Payment', 'today': 0.0, 'pdt': 0.0, 'ydt': 2229288.10, 'bold': true},
    ],
    'City Ledger': [
      {'name': 'Opening Balance', 'today': 286885.58, 'pdt': 286885.58, 'ydt': 0.0},
      {'name': 'Payment Received', 'today': 0.0, 'pdt': 0.0, 'ydt': 7450.0},
      {'name': 'Charges Raised', 'today': 0.0, 'pdt': 0.0, 'ydt': 294335.58},
      {'name': 'Closing Balance', 'today': 286885.58, 'pdt': 286885.58, 'ydt': 286885.58, 'bold': true},
    ],
  };

  // Room Summary with String values
  final List<Map<String, dynamic>> roomSummaryItems = [
    {'name': 'Total Room', 'today': '4', 'pdt': '30', 'ydt': '461'},
    {'name': 'Block Room', 'today': '0', 'pdt': '8', 'ydt': '63'},
    {'name': 'No Of Guest', 'today': '4/0', 'pdt': '38/0', 'ydt': '775/16'},
    {'name': 'Total Available Rooms Nights', 'today': '4', 'pdt': '22', 'ydt': '398'},
    {'name': 'Sold Room', 'today': '0', 'pdt': '0', 'ydt': '14'},
    {'name': 'No Show Rooms', 'today': '0', 'pdt': '0', 'ydt': '29'},
    {'name': 'Average Guest Per Room', 'today': '0/0', 'pdt': '0/0', 'ydt': '55/0'},
    {'name': 'No of Reservations (Confirm)', 'today': '3', 'pdt': '23', 'ydt': '351'},
    {'name': 'No of Reservations (Unconfirm)', 'today': '1', 'pdt': '7', 'ydt': '110'},
  ];

  dynamic _getValue(Map<String, dynamic> item) {
    switch (_selectedPeriod) {
      case 0:
        return item['today'];
      case 1:
        return item['pdt'];
      case 2:
        return item['ydt'];
      default:
        return 0.0;
    }
  }

  void _handleRefresh() {
    // Implement refresh logic here
    setState(() {
      // Trigger data reload
    });
  }

  void _handleFilter() {
    // Implement filter logic here
    // You can show a bottom sheet or dialog for filter options
  }

  void _handleInfo() {
    // Show information dialog about the report
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Manager Report Information'),
        content: const Text('This report shows financial data and room statistics. Select a time period (Today, PDT, or YTD) to view corresponding data.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
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
        padding: ResponsiveConfig.verticalPadding(context),
        children: [
          Padding(
            padding: ResponsiveConfig.horizontalPadding(context),
            child: Text(
              'As on Date: 2025-10-07',
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
          ...financialSections.entries.map(
            (entry) => _buildFinancialSection(context, entry.key, entry.value),
          ),
          _buildRoomSummarySection(context),
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
    List<Map<String, dynamic>> items,
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
          final value = _getValue(item);
          final isNegative = value < 0;
          return Column(
            children: [
              Padding(
                padding: ResponsiveConfig.horizontalPadding(context).copyWith(
                  top: 8,
                  bottom: 8,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        item['name'],
                        style: AppTextTheme.lightTextTheme.bodyMedium?.copyWith(
                          fontWeight: item['bold'] == true
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                    ),
                    Text(
                      _currencyFormat.format(value),
                      style: AppTextTheme.lightTextTheme.bodyMedium?.copyWith(
                        fontWeight: item['bold'] == true
                            ? FontWeight.bold
                            : FontWeight.normal,
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
        ...roomSummaryItems.map((item) {
          final value = _getValue(item);
          return Column(
            children: [
              Padding(
                padding: ResponsiveConfig.horizontalPadding(context).copyWith(
                  top: 8,
                  bottom: 8,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        item['name'],
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
}