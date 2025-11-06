import 'package:flutter/material.dart';
import 'package:get/Get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:inta_mobile_pms/core/widgets/custom_appbar.dart';
import 'package:inta_mobile_pms/features/reports/viewmodels/manager_report_vm.dart';
import 'package:intl/intl.dart';
import 'package:inta_mobile_pms/core/config/responsive_config.dart';
import 'package:inta_mobile_pms/core/theme/app_colors.dart';
import 'package:inta_mobile_pms/core/theme/app_text_theme.dart';
import 'package:url_launcher/url_launcher.dart';

class ManagerReport extends StatefulWidget {
  const ManagerReport({super.key});

  @override
  State<ManagerReport> createState() => _ManagerReportState();
}

class _ManagerReportState extends State<ManagerReport> {
  final _managerReportVm = Get.find<ManagerReportVm>();

  // ✅ Hotel list
  final List<String> hotelList = ['Hotel A', 'Hotel B', 'Hotel C', 'Hotel D'];

  List<String> selectedHotels = [];

  // ✅ Date selection
  DateTime? selectedDate;

  // ✅ Currency dropdown
  final List<String> currencyList = ['LKR', 'USD', 'EUR', 'GBP'];
  String? selectedCurrency;

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
      appBar: CustomAppBar(title: 'Manager Report'),
      body: ListView(
        padding: ResponsiveConfig.verticalPadding(
          context,
        ).add(ResponsiveConfig.horizontalPadding(context)),
        children: [
          const SizedBox(height: 16),

          // ✅ HOTEL CHECKBOX SECTION
          Text("Select Hotels", style: AppTextTheme.lightTextTheme.titleMedium),
          const SizedBox(height: 8),

          Column(
            children: hotelList.map((hotel) {
              final isSelected = selectedHotels.contains(hotel);
              return CheckboxListTile(
                title: Text(hotel),
                value: isSelected,
                activeColor: AppColors.primary,
                onChanged: (checked) {
                  setState(() {
                    if (checked == true) {
                      selectedHotels.add(hotel);
                    } else {
                      selectedHotels.remove(hotel);
                    }
                  });
                },
                controlAffinity: ListTileControlAffinity.leading,
              );
            }).toList(),
          ),

          const SizedBox(height: 24),

          // ✅ DATE SELECTION
          Text("Select Date", style: AppTextTheme.lightTextTheme.titleMedium),
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
                    : "Tap to select date",
                style: AppTextTheme.lightTextTheme.bodyMedium,
              ),
            ),
          ),

          const SizedBox(height: 24),

          // ✅ CURRENCY DROPDOWN
          Text(
            "Select Currency",
            style: AppTextTheme.lightTextTheme.titleMedium,
          ),
          const SizedBox(height: 8),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade400),
            ),
            child: DropdownButton<String>(
              isExpanded: true,
              underline: const SizedBox(),
              hint: const Text("Select Currency"),
              value: selectedCurrency,
              items: currencyList
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (val) => setState(() => selectedCurrency = val),
            ),
          ),

          const SizedBox(height: 32),

          // ✅ GENERATE REPORT BUTTON
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
               _managerReportVm.openBrowser('http://192.168.1.176:2234/#/reports-v2/report-view-template-v2?reportName=Manager%20Report&reportId=213&params=date,currency,multipleHotel');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: const Text(
                "Generate Report",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          const SizedBox(height: 40),
        ],
      ),
    );
  }
}
