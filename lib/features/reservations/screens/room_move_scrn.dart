// lib/features/reservations/pages/room_move_page.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:go_router/go_router.dart';
import 'package:inta_mobile_pms/core/config/responsive_config.dart';
import 'package:inta_mobile_pms/core/theme/app_colors.dart';
import 'package:inta_mobile_pms/core/theme/app_text_theme.dart';
import 'package:inta_mobile_pms/features/reservations/models/guest_item.dart';
import 'package:inta_mobile_pms/features/reservations/models/room_move_save_data.dart';
import 'package:inta_mobile_pms/features/reservations/viewmodels/room_move_vm.dart';

class RoomMovePage extends StatefulWidget {
  final GuestItem? guestItem;

  const RoomMovePage({super.key, this.guestItem});

  @override
  State<RoomMovePage> createState() => _RoomMovePageState();
}

class _RoomMovePageState extends State<RoomMovePage> {
  final _roomMoveVm = Get.find<RoomMoveVm>();

  bool isManualRate = false;
  bool isEnabledTaxInclusive = false;
  final TextEditingController _rateController = TextEditingController();

  final String currencyCode = 'LKR';

  String? _selectedRoomType;
  String? _selectedRoom;
  bool isOverrideRate = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (mounted) {
        int? folioId = int.tryParse(widget.guestItem?.folioId ?? '');
        await _roomMoveVm.loadInitialData(folioId!);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(context),
      body: _buildBody(context),
      bottomNavigationBar: _buildBottomActions(context),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.surface,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.close, color: AppColors.black),
        onPressed: () => context.pop(),
      ),
      title: Text(
        'Room Move',
        style: AppTextTheme.lightTextTheme.titleMedium?.copyWith(
          color: AppColors.black,
          fontWeight: FontWeight.w600,
        ),
      ),
      centerTitle: false,
    );
  }

  Widget _buildBody(BuildContext context) {
    return SingleChildScrollView(
      padding: ResponsiveConfig.horizontalPadding(
        context,
      ).add(ResponsiveConfig.verticalPadding(context)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildGuestInfoSection(context),
          SizedBox(height: ResponsiveConfig.listItemSpacing(context)),
          _buildRoomSelectionSection(context),
          SizedBox(height: ResponsiveConfig.listItemSpacing(context)),
          _buildOverrideRateSection(context),
          SizedBox(height: ResponsiveConfig.listItemSpacing(context)),
          if (isOverrideRate == true) _buildRateSection(context),
        ],
      ),
    );
  }

  Widget _buildGuestInfoSection(BuildContext context) {
    return _buildSection(
      context,
      child: Column(
        children: [
          _buildInfoRow('Guest Name', widget.guestItem?.guestName ?? ''),
          _buildDivider(),
          _buildInfoRow('Res #', widget.guestItem?.resId ?? ''),
        ],
      ),
    );
  }

  Widget _buildOverrideRateSection(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(
          ResponsiveConfig.cardRadius(context),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          ResponsiveConfig.defaultPadding(context),
          ResponsiveConfig.defaultPadding(context),
          ResponsiveConfig.defaultPadding(context),
          8,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Is Override Rate',
              style: AppTextTheme.lightTextTheme.bodySmall?.copyWith(
                color: AppColors.darkgrey,
                fontWeight: FontWeight.w500,
              ),
            ),
            Switch(
              value: isOverrideRate,
              onChanged: (v) => setState(() => isOverrideRate = v),
              activeColor: AppColors.surface,
              activeTrackColor: AppColors.blue,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRateSection(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(ResponsiveConfig.defaultPadding(context)),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(
          ResponsiveConfig.cardRadius(context),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          /// --- Left Side: Switches + Labels ---
          Row(
            children: [
              // Main "Rate" switch
              Switch(
                value: isManualRate,
                onChanged: (v) => setState(() => isManualRate = v),
                activeColor: AppColors.surface,
                activeTrackColor: AppColors.blue,
              ),
              const SizedBox(width: 6),
              Text(
                'Rate',
                style: AppTextTheme.lightTextTheme.bodySmall?.copyWith(
                  color: AppColors.darkgrey,
                  fontWeight: FontWeight.w500,
                ),
              ),

              // Tax Inclusive toggle (only visible if Rate enabled)
              if (isManualRate) ...[
                const SizedBox(width: 20),
                Switch(
                  value: isEnabledTaxInclusive,
                  onChanged: (v) => setState(() => isEnabledTaxInclusive = v),
                  activeColor: AppColors.surface,
                  activeTrackColor: AppColors.blue,
                ),
                const SizedBox(width: 6),
                Text(
                  'Tax Inclusive',
                  style: AppTextTheme.lightTextTheme.bodySmall?.copyWith(
                    color: AppColors.darkgrey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ],
          ),

          /// --- Right Side: Rate input + Currency label ---
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 100,
                child: TextField(
                  controller: _rateController,
                  enabled: isManualRate,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                      RegExp(r'^\d*\.?\d{0,2}'),
                    ),
                  ],
                  decoration: InputDecoration(
                    hintText: '0.00',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 8,
                    ),
                  ),
                  onChanged: (_) {},
                ),
              ),
              const SizedBox(width: 8),
              Text(
                currencyCode,
                style: AppTextTheme.lightTextTheme.bodySmall?.copyWith(
                  color: AppColors.darkgrey,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  double? _getRateValue() {
    final text = _rateController.text.trim();
    if (text.isEmpty) return null;
    return double.tryParse(text);
  }

  Widget _buildRoomSelectionSection(BuildContext context) {
    final RoomMoveVm roomMoveVm = Get.find<RoomMoveVm>();

    return Column(
      children: [
        // Room Type Dropdown
        Obx(() {
          return _buildDropdownSection(
            context,
            'Room Type',
            _selectedRoomType,
            roomMoveVm.roomTypes,
            (value) {
              setState(() {
                _selectedRoomType = value;
              });
              roomMoveVm.availableRooms.clear();
              roomMoveVm.loadAvailableRooms(value!);
            },
          );
        }),
        SizedBox(height: ResponsiveConfig.listItemSpacing(context)),

        // Available Rooms Dropdown
        Obx(() {
          return _buildDropdownSection(
            context,
            'Room',
            _selectedRoom,
            roomMoveVm.availableRooms,
            (value) {
              setState(() {
                _selectedRoom = value;
              });
            },
            enabled: roomMoveVm.availableRooms.isNotEmpty,
          );
        }),
      ],
    );
  }

  Widget _buildSection(BuildContext context, {required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(
          ResponsiveConfig.cardRadius(context),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildDropdownSection(
    BuildContext context,
    String label,
    String? value,
    List<Map<String, dynamic>> items,
    ValueChanged<String?> onChanged, {
    bool enabled = true,
  }) {
    final selectedName = items.firstWhere(
      (item) => item["id"].toString() == value,
      orElse: () => {"name": "Select option"},
    )["name"];

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(
          ResponsiveConfig.cardRadius(context),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Label
          Padding(
            padding: EdgeInsets.fromLTRB(
              ResponsiveConfig.defaultPadding(context),
              ResponsiveConfig.defaultPadding(context),
              ResponsiveConfig.defaultPadding(context),
              8,
            ),
            child: Text(
              label,
              style: AppTextTheme.lightTextTheme.bodySmall?.copyWith(
                color: AppColors.darkgrey,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          // Dropdown
          Padding(
            padding: EdgeInsets.fromLTRB(
              ResponsiveConfig.defaultPadding(context),
              0,
              ResponsiveConfig.defaultPadding(context),
              ResponsiveConfig.defaultPadding(context),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    selectedName ?? 'Selected Type',
                    style: AppTextTheme.lightTextTheme.bodyMedium?.copyWith(
                      color: enabled ? AppColors.black : AppColors.lightgrey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                PopupMenuButton<String>(
                  enabled: enabled && items.isNotEmpty,
                  initialValue: value,
                  onSelected: onChanged,
                  icon: Icon(
                    Icons.keyboard_arrow_down,
                    color: enabled
                        ? AppColors.lightgrey
                        : AppColors.lightgrey.withOpacity(0.5),
                    size: ResponsiveConfig.iconSize(context),
                  ),
                  itemBuilder: (BuildContext context) {
                    return items.map((Map<String, dynamic> item) {
                      return PopupMenuItem<String>(
                        value: item["id"].toString(),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Text(
                            item["name"],
                            style: AppTextTheme.lightTextTheme.bodyMedium
                                ?.copyWith(
                                  color: AppColors.black,
                                  fontWeight: FontWeight.w400,
                                ),
                          ),
                        ),
                      );
                    }).toList();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.all(ResponsiveConfig.defaultPadding(context)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppTextTheme.lightTextTheme.bodyMedium?.copyWith(
              color: AppColors.darkgrey,
              fontWeight: FontWeight.w500,
            ),
          ),
          Flexible(
            child: Text(
              value,
              style: AppTextTheme.lightTextTheme.bodyMedium?.copyWith(
                color: AppColors.black,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.end,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 1,
      color: Colors.grey.shade200,
      indent: ResponsiveConfig.defaultPadding(context),
      endIndent: ResponsiveConfig.defaultPadding(context),
    );
  }

  Widget _buildBottomActions(BuildContext context) {
    final bool canSave = _selectedRoomType != null && _selectedRoom != null;

    return Container(
      padding: EdgeInsets.all(ResponsiveConfig.defaultPadding(context)),
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () => context.pop(),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppColors.lightgrey),
                padding: EdgeInsets.symmetric(
                  vertical: ResponsiveConfig.defaultPadding(context),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'Cancel',
                style: AppTextTheme.lightTextTheme.bodyMedium?.copyWith(
                  color: AppColors.lightgrey,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: ElevatedButton(
              onPressed: canSave ? _handleSave : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: canSave
                    ? AppColors.primary
                    : Colors.grey.shade300,
                padding: EdgeInsets.symmetric(
                  vertical: ResponsiveConfig.defaultPadding(context),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 0,
              ),
              child: Text(
                'Save',
                style: AppTextTheme.lightTextTheme.bodyMedium?.copyWith(
                  color: canSave ? AppColors.onPrimary : Colors.grey.shade600,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _handleSave() {
    if (_selectedRoomType == null || _selectedRoom == null) {
      _showErrorSnackBar('Please select both room type and room');
      return;
    }

    final selectedRoomType = _roomMoveVm.getType(
      int.tryParse(_selectedRoomType.toString()) ?? 0,
    );
    final selectedRoom = _roomMoveVm.getRoom(
      int.tryParse(_selectedRoom.toString()) ?? 0,
    );

    // Show confirmation dialog
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: AppColors.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              ResponsiveConfig.cardRadius(context),
            ),
          ),
          title: Text(
            'Confirm Room Move',
            style: AppTextTheme.lightTextTheme.titleMedium?.copyWith(
              color: AppColors.black,
              fontWeight: FontWeight.w600,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Are you sure you want to move the guest to:',
                style: AppTextTheme.lightTextTheme.bodyMedium?.copyWith(
                  color: AppColors.darkgrey,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Room Type: $selectedRoomType',
                style: AppTextTheme.lightTextTheme.bodyMedium?.copyWith(
                  color: AppColors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                'Room: ${selectedRoom!}',
                style: AppTextTheme.lightTextTheme.bodyMedium?.copyWith(
                  color: AppColors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => context.pop(),
              child: Text(
                'Cancel',
                style: AppTextTheme.lightTextTheme.bodyMedium?.copyWith(
                  color: AppColors.lightgrey,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                try {
                  context.pop();
                  final roomMoveVm = Get.find<RoomMoveVm>();
                  final folioDetails = roomMoveVm.folioDetails.value;

                  final saveData = RoomMoveSaveData(
                    bookingRoomId:
                        int.tryParse(widget.guestItem?.bookingRoomId ?? '') ??
                        0,
                    currencyId: folioDetails?.visibleCurrencyId ?? 0,
                    isManualRate: isManualRate,
                    isOverrideRate: isOverrideRate,
                    isTaxInclusive: isEnabledTaxInclusive,
                    manualRate: _getRateValue() ?? 0.0,
                    roomId: int.tryParse(_selectedRoom.toString()) ?? 0,
                    roomTypeId: int.tryParse(_selectedRoomType.toString()) ?? 0,
                  );

                  final response = await roomMoveVm.saveRoomMove(saveData);
                  if (!mounted) return;
                } catch (e) {
                  throw Exception('Error while room move: $e');
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'Confirm',
                style: AppTextTheme.lightTextTheme.bodyMedium?.copyWith(
                  color: AppColors.onPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}
