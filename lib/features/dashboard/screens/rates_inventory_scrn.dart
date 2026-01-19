import 'package:flutter/material.dart';
import 'package:inta_mobile_pms/core/config/responsive_config.dart';
import 'package:inta_mobile_pms/core/widgets/custom_appbar.dart';
import 'package:intl/intl.dart';
import 'package:inta_mobile_pms/core/theme/app_colors.dart';
import 'package:inta_mobile_pms/core/theme/app_text_theme.dart';

class RatesInventory extends StatefulWidget {
  const RatesInventory({super.key});

  @override
  State<RatesInventory> createState() => _RatesInventoryState();
}

class _RatesInventoryState extends State<RatesInventory> with TickerProviderStateMixin {
  DateTime _selectedDate = DateTime(2025, 9, 24);
  String _selectedSource = 'OTA Common Pool';
  String _selectedRatePlan = 'Cabana Full Board';
  bool _ratesInclusiveTax = true;
  bool _hasChanges = false;

  late AnimationController _saveButtonController;
  late Animation<double> _saveButtonAnimation;

  final List<String> _sources = [
    'OTA Common Pool',
    'Direct Booking',
    'Corporate',
    'Travel Agent',
  ];

  final Map<String, List<String>> _ratePlans = {
    'Cabana': [
      'Cabana Full Board',
      'Cabana Half Board',
      'Cabana Adventure Full Board',
      'Cabana Family Package',
    ],
    'Deluxe Room': [
      'Deluxe Room Bed and Breakfast',
      'Deluxe Room Half Board',
    ],
  };

  late List<Map<String, dynamic>> _inventoryData;

  @override
  void initState() {
    super.initState();
    _loadInventoryData();
    _saveButtonController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _saveButtonAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _saveButtonController, curve: Curves.elasticOut),
    );
  }

  @override
  void dispose() {
    _saveButtonController.dispose();
    super.dispose();
  }

  void _loadInventoryData() {
    _inventoryData = List.generate(14, (index) {
      DateTime date = _selectedDate.add(Duration(days: index));
      return {
        'date': date,
        'inv': 4,
        'rate': 15980,
        'minNights': 1,
        'stopSell': false,
        'changed': false,
      };
    });
    setState(() => _hasChanges = false);
  }

  void _markAsChanged() {
    if (!_hasChanges) {
      setState(() => _hasChanges = true);
      _saveButtonController.forward();
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
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
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _loadInventoryData();
      });
    }
  }

  void _showBottomSelector({
    required String title,
    required List<String> options,
    required String selectedValue,
    required Function(String) onSelected,
    Map<String, List<String>>? groupedOptions,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Drag handle
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(top: 12),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                child: Row(
                  children: [
                    Text(
                      title,
                      style:  TextTheme.of(context).headlineSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.onSurface,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close, color: AppColors.darkgrey),
                    ),
                  ],
                ),
              ),
              Flexible(
                child: ListView(
                  shrinkWrap: true,
                  children: groupedOptions?.entries.map((entry) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                          child: Text(
                            entry.key,
                            style:  TextTheme.of(context).titleMedium?.copyWith(
                              fontWeight: FontWeight.w500,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                        ...entry.value.map((option) => _buildSelectorTile(
                              option,
                              selectedValue,
                              (value) {
                                onSelected(value);
                                Navigator.pop(context);
                              },
                            )),
                      ],
                    );
                  }).toList() ??
                  options.map((option) => _buildSelectorTile(
                        option,
                        selectedValue,
                        (value) {
                          onSelected(value);
                          Navigator.pop(context);
                        },
                      )).toList(),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSelectorTile(String option, String selectedValue, Function(String) onTap) {
    final isSelected = option == selectedValue;
    return InkWell(
      onTap: () => onTap(option),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: isSelected ? Border.all(color: AppColors.primary, width: 1.5) : null,
        ),
        child: Row(
          children: [
            Text(
              option,
              style:  TextTheme.of(context).bodyLarge?.copyWith(
                color: isSelected ? AppColors.primary : AppColors.onSurface,
                fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
              ),
            ),
            const Spacer(),
            if (isSelected)
              Icon(Icons.check_circle, color: AppColors.primary, size: 20),
          ],
        ),
      ),
    );
  }

  void _editCell(int index, String key, String label) {
    final controller = TextEditingController(
      text: '${_inventoryData[index][key]}',
    );
    
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Edit $label',
                  style:  TextTheme.of(context).headlineSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: controller,
                  keyboardType: TextInputType.number,
                  autofocus: true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: AppColors.primary, width: 2),
                    ),
                    hintText: 'Enter $label',
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text('Cancel'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          final value = int.tryParse(controller.text);
                          if (value != null) {
                            setState(() {
                              _inventoryData[index][key] = value;
                              _inventoryData[index]['changed'] = true;
                            });
                            _markAsChanged();
                          }
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text('Update', style: TextStyle(color: AppColors.surface)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _saveChanges() {
    setState(() {
      for (var data in _inventoryData) {
        data['changed'] = false;
      }
      _hasChanges = false;
    });
    _saveButtonController.reverse();
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Changes saved successfully!'),
        backgroundColor: AppColors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${DateFormat('EEE').format(date)}\n${DateFormat('dd MMM').format(date)}';
  }

  Widget _buildSelectorCard({
    required String label,
    required String value,
    required VoidCallback onTap,
    IconData? icon,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        height: 72,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: Row(
          children: [
            if (icon != null) ...[
              Icon(icon, color: AppColors.primary, size: 20),
              const SizedBox(width: 12),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextTheme.of(context).bodySmall?.copyWith(
                      color: AppColors.darkgrey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style:  TextTheme.of(context).bodyLarge?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: AppColors.darkgrey),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme =  TextTheme.of(context);
    final padding = ResponsiveConfig.defaultPadding(context);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: CustomAppBar(
        title: 'Rates & Inventory',
        onRefreshTap: () {
          setState(_loadInventoryData);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Data refreshed!'),
              backgroundColor: AppColors.blue,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              margin: const EdgeInsets.all(16),
            ),
          );
        },
      ),
      body: Column(
        children: [
          // Filters Section
          Container(
            color: AppColors.surface,
            padding: EdgeInsets.all(padding),
            child: Column(
              children: [
                _buildSelectorCard(
                  label: 'Date',
                  value: DateFormat('dd MMM yyyy').format(_selectedDate),
                  icon: Icons.calendar_today,
                  onTap: () => _selectDate(context),
                ),
                const SizedBox(height: 12),
                _buildSelectorCard(
                  label: 'Source',
                  value: _selectedSource,
                  icon: Icons.source,
                  onTap: () => _showBottomSelector(
                    title: 'Select Source',
                    options: _sources,
                    selectedValue: _selectedSource,
                    onSelected: (value) => setState(() => _selectedSource = value),
                  ),
                ),
                const SizedBox(height: 12),
                _buildSelectorCard(
                  label: 'Rate Plan',
                  value: _selectedRatePlan,
                  icon: Icons.hotel,
                  onTap: () => _showBottomSelector(
                    title: 'Select Rate Plan',
                    options: [],
                    selectedValue: _selectedRatePlan,
                    groupedOptions: _ratePlans,
                    onSelected: (value) => setState(() => _selectedRatePlan = value),
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey[200]!),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.account_balance_wallet, color: AppColors.primary, size: 20),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Rates Inclusive Tax',
                          style:  TextTheme.of(context).bodyLarge?.copyWith(fontWeight: FontWeight.w500),
                        ),
                      ),
                      Switch(
                        value: _ratesInclusiveTax,
                        onChanged: (value) => setState(() => _ratesInclusiveTax = value),
                        activeColor: AppColors.green,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // Data Table Section
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(top: 8),
              decoration: const BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Column(
                children: [
                  // Table Header
                  Container(
                    padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
                    child: Row(
                      children: [
                        Expanded(flex: 3, child: Text('Date', style: textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600))),
                        Expanded(child: Center(child: Text('Inv', style: textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600)))),
                        Expanded(child: Center(child: Text('Rate', style: textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600)))),
                        Expanded(child: Center(child: Text('Min\nNights', style: textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600), textAlign: TextAlign.center))),
                        Expanded(child: Center(child: Text('Stop\nSell', style: textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600), textAlign: TextAlign.center))),
                      ],
                    ),
                  ),
                  
                  // Inventory List
                  Expanded(
                    child: ListView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: _inventoryData.length,
                      itemBuilder: (context, index) {
                        final data = _inventoryData[index];
                        final isChanged = data['changed'] as bool;

                        return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
                          decoration: BoxDecoration(
                            color: isChanged ? AppColors.yellow.withOpacity(0.15) : Colors.transparent,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: Text(
                                    _formatDate(data['date'] as DateTime),
                                    style: textTheme.bodyMedium?.copyWith(
                                      height: 1.2,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () => _editCell(index, 'inv', 'Inventory'),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(vertical: 8),
                                      child: Center(
                                        child: Text(
                                          '${data['inv']}',
                                          style: textTheme.bodyMedium?.copyWith(
                                            fontWeight: FontWeight.w500,
                                            color: AppColors.primary,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () => _editCell(index, 'rate', 'Rate'),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(vertical: 8),
                                      child: Center(
                                        child: Text(
                                          '${data['rate']}',
                                          style: textTheme.bodyMedium?.copyWith(
                                            fontWeight: FontWeight.w500,
                                            color: AppColors.primary,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () => _editCell(index, 'minNights', 'Min Nights'),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(vertical: 8),
                                      child: Center(
                                        child: Text(
                                          '${data['minNights']}',
                                          style: textTheme.bodyMedium?.copyWith(
                                            fontWeight: FontWeight.w500,
                                            color: AppColors.primary,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Center(
                                    child: Checkbox(
                                      value: data['stopSell'] as bool,
                                      onChanged: (value) {
                                        setState(() {
                                          _inventoryData[index]['stopSell'] = value;
                                          _inventoryData[index]['changed'] = true;
                                        });
                                        _markAsChanged();
                                      },
                                      activeColor: AppColors.red,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      
      // Floating Action Button for Save
      floatingActionButton: _hasChanges
          ? AnimatedBuilder(
              animation: _saveButtonAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: _saveButtonAnimation.value,
                  child: FloatingActionButton.extended(
                    onPressed: _saveChanges,
                    backgroundColor: AppColors.green,
                    icon: const Icon(Icons.save, color: AppColors.surface),
                    label: const Text(
                      'Save Changes',
                      style: TextStyle(color: AppColors.surface, fontWeight: FontWeight.w600),
                    ),
                  ),
                );
              },
            )
          : null,
      
      // Bottom info panel
      bottomSheet: Container(
        color: Colors.grey[100],
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Icon(Icons.info_outline, size: 16, color: AppColors.darkgrey),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Tap any cell to edit values. Changes are highlighted in yellow.',
                    style: textTheme.bodySmall?.copyWith(
                      color: AppColors.darkgrey,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}