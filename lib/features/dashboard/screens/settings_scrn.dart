import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:go_router/go_router.dart';
import 'package:inta_mobile_pms/core/theme/app_colors.dart';
import 'package:inta_mobile_pms/core/theme/app_text_theme.dart';
import 'package:inta_mobile_pms/router/app_routes.dart';



class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  // Notification settings state
  bool _newBookingNotifications = true;
  bool _bookingCancellationNotifications = true;
  bool _bookingModificationNotifications = false;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).brightness == Brightness.dark 
        ? AppTextTheme.darkTextTheme 
        : AppTextTheme.lightTextTheme;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Settings',
          style: textTheme.titleMedium?.copyWith(
            color: AppColors.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: AppColors.surface,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: AppColors.onSurface,
          ),
          onPressed: () => context.go(AppRoutes.dashboard),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Notification Settings Section
            _buildNotificationSettingsSection(textTheme),
            
            const SizedBox(height: 24),
            
            // Placeholder for future sections
            // _buildPlaceholderSection('Account Settings', textTheme),
            // _buildPlaceholderSection('Privacy & Security', textTheme),
            // _buildPlaceholderSection('Help & Support', textTheme),
            
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationSettingsSection(TextTheme textTheme) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.lightgrey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Header
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Icon(
                  Icons.notifications_outlined,
                  color: AppColors.primary,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Text(
                  'Notification Settings',
                  style: textTheme.titleMedium?.copyWith(
                    color: AppColors.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          
          // Divider
          Divider(
            height: 1,
            color: AppColors.lightgrey.withOpacity(0.2),
            indent: 20,
            endIndent: 20,
          ),
          
          // Settings Items
          _buildNotificationToggle(
            title: 'New Booking',
            subtitle: 'Get notified when you receive new bookings',
            icon: Icons.event_available,
            value: _newBookingNotifications,
            onChanged: (value) {
              setState(() {
                _newBookingNotifications = value;
              });
              _showSnackBar('New booking notifications ${value ? 'enabled' : 'disabled'}');
            },
            textTheme: textTheme,
          ),
          
          _buildDivider(),
          
          _buildNotificationToggle(
            title: 'Booking Cancellation',
            subtitle: 'Get notified when bookings are cancelled',
            icon: Icons.event_busy,
            value: _bookingCancellationNotifications,
            onChanged: (value) {
              setState(() {
                _bookingCancellationNotifications = value;
              });
              _showSnackBar('Cancellation notifications ${value ? 'enabled' : 'disabled'}');
            },
            textTheme: textTheme,
          ),
          
          _buildDivider(),
          
          _buildNotificationToggle(
            title: 'Booking Modification',
            subtitle: 'Get notified when bookings are modified',
            icon: Icons.edit_calendar,
            value: _bookingModificationNotifications,
            onChanged: (value) {
              setState(() {
                _bookingModificationNotifications = value;
              });
              _showSnackBar('Modification notifications ${value ? 'enabled' : 'disabled'}');
            },
            textTheme: textTheme,
          ),
          
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildNotificationToggle({
    required String title,
    required String subtitle,
    required IconData icon,
    required bool value,
    required ValueChanged<bool> onChanged,
    required TextTheme textTheme,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => onChanged(!value),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Row(
            children: [
              // Icon
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  icon,
                  color: AppColors.primary,
                  size: 20,
                ),
              ),
              
              const SizedBox(width: 16),
              
              // Text Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: textTheme.titleSmall?.copyWith(
                        color: AppColors.onSurface,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: textTheme.bodySmall?.copyWith(
                        color: AppColors.lightgrey,
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(width: 12),
              
              // Toggle Switch
              Switch.adaptive(
                value: value,
                onChanged: onChanged,
                activeColor: AppColors.primary,
                inactiveThumbColor: AppColors.lightgrey,
                inactiveTrackColor: AppColors.lightgrey.withOpacity(0.3),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 1,
      color: AppColors.lightgrey.withOpacity(0.1),
      indent: 76,
      endIndent: 20,
    );
  }

  Widget _buildPlaceholderSection(String title, TextTheme textTheme) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.lightgrey.withOpacity(0.08),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Icon(
              Icons.settings_outlined,
              color: AppColors.lightgrey,
              size: 24,
            ),
            const SizedBox(width: 12),
            Text(
              title,
              style: textTheme.titleSmall?.copyWith(
                color: AppColors.lightgrey,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Spacer(),
            Text(
              'Coming Soon',
              style: textTheme.bodySmall?.copyWith(
                color: AppColors.primary.withOpacity(0.7),
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(color: AppColors.onPrimary),
        ),
        backgroundColor: AppColors.primary,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}