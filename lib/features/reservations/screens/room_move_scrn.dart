// lib/features/reservations/pages/room_move_page.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:inta_mobile_pms/core/config/responsive_config.dart';
import 'package:inta_mobile_pms/core/theme/app_colors.dart';
import 'package:inta_mobile_pms/core/theme/app_text_theme.dart';
import 'package:inta_mobile_pms/features/reservations/models/guest_item.dart';
import 'package:inta_mobile_pms/router/app_routes.dart';

class RoomMovePage extends StatefulWidget {
  final GuestItem? guestItem;

  const RoomMovePage({
    super.key,
    this.guestItem,
  });

  @override
  State<RoomMovePage> createState() => _RoomMovePageState();
}

class _RoomMovePageState extends State<RoomMovePage> {
  // Sample data - replace with actual data models
  final List<String> _roomTypes = [
    'Single Room',
    'Double Room',
    'Double Room new',
    'Suite',
    'Deluxe Room',
    'Executive Suite',
    'Presidential Suite'
  ];
  
  final Map<String, List<String>> _roomsByType = {
    'Single Room': ['101', '102', '103', '201', '202'],
    'Double Room': ['104', '105', '106', '203', '204'],
    'Double Room new': ['Test', '107', '108', '205', '206'],
    'Suite': ['301', '302', '401', '402'],
    'Deluxe Room': ['303', '304', '403', '404'],
    'Executive Suite': ['501', '502'],
    'Presidential Suite': ['601', '602'],
  };
  
  String? _selectedRoomType;
  String? _selectedRoom;
  List<String> _availableRooms = [];

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  void _initializeData() {
    // Initialize with existing guest data if available
    if (widget.guestItem != null) {
      _selectedRoomType = widget.guestItem!.roomType;
      _selectedRoom = 'Test'; // Default from your design
    } else {
      // Default values
      _selectedRoomType = 'Double Room new';
      _selectedRoom = 'Test';
    }
    
    // Update available rooms based on selected room type
    _updateAvailableRooms();
  }

  void _updateAvailableRooms() {
    if (_selectedRoomType != null) {
      setState(() {
        _availableRooms = _roomsByType[_selectedRoomType!] ?? [];
        // Reset room selection if current room is not available in new type
        if (!_availableRooms.contains(_selectedRoom)) {
          _selectedRoom = _availableRooms.isNotEmpty ? _availableRooms.first : null;
        }
      });
    }
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
        onPressed: () => context.go(AppRoutes.arrivalList),
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
      padding: ResponsiveConfig.horizontalPadding(context).add(
        ResponsiveConfig.verticalPadding(context),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildGuestInfoSection(context),
          SizedBox(height: ResponsiveConfig.listItemSpacing(context)),
          _buildRoomSelectionSection(context),
        ],
      ),
    );
  }

  Widget _buildGuestInfoSection(BuildContext context) {
    return _buildSection(
      context,
      child: Column(
        children: [
          _buildInfoRow(
            'Guest Name',
            widget.guestItem?.guestName ?? 'Ms. Pabasara Dissanayake',
          ),
          _buildDivider(),
          _buildInfoRow(
            'Res #',
            widget.guestItem?.resId ?? 'BH2832',
          ),
        ],
      ),
    );
  }

  Widget _buildRoomSelectionSection(BuildContext context) {
    return Column(
      children: [
        _buildDropdownSection(
          context,
          'Room Type',
          _selectedRoomType,
          _roomTypes,
          (value) {
            setState(() {
              _selectedRoomType = value;
              _updateAvailableRooms();
            });
          },
        ),
        SizedBox(height: ResponsiveConfig.listItemSpacing(context)),
        _buildDropdownSection(
          context,
          'Room',
          _selectedRoom,
          _availableRooms,
          (value) {
            setState(() {
              _selectedRoom = value;
            });
          },
          enabled: _availableRooms.isNotEmpty,
        ),
      ],
    );
  }

  Widget _buildSection(BuildContext context, {required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(ResponsiveConfig.cardRadius(context)),
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
    List<String> items,
    ValueChanged<String?> onChanged, {
    bool enabled = true,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(ResponsiveConfig.cardRadius(context)),
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
                    value ?? (items.isNotEmpty ? items.first : 'No options available'),
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
                    color: enabled ? AppColors.lightgrey : AppColors.lightgrey.withOpacity(0.5),
                    size: ResponsiveConfig.iconSize(context),
                  ),
                  itemBuilder: (BuildContext context) {
                    return items.map((String item) {
                      return PopupMenuItem<String>(
                        value: item,
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Text(
                            item,
                            style: AppTextTheme.lightTextTheme.bodyMedium?.copyWith(
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
    final bool canSave = _selectedRoomType != null && 
                        _selectedRoom != null && 
                        _availableRooms.isNotEmpty;

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
                backgroundColor: canSave ? AppColors.primary : Colors.grey.shade300,
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

    // Show confirmation dialog
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: AppColors.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(ResponsiveConfig.cardRadius(context)),
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
                'Room Type: $_selectedRoomType',
                style: AppTextTheme.lightTextTheme.bodyMedium?.copyWith(
                  color: AppColors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                'Room: $_selectedRoom',
                style: AppTextTheme.lightTextTheme.bodyMedium?.copyWith(
                  color: AppColors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text(
                'Cancel',
                style: AppTextTheme.lightTextTheme.bodyMedium?.copyWith(
                  color: AppColors.lightgrey,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                _confirmRoomMove();
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

  void _confirmRoomMove() {
    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Room moved successfully to $_selectedRoomType - $_selectedRoom',
        ),
        backgroundColor: AppColors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );

    // Navigate back
    context.pop();
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}