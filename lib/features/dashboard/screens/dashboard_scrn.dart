// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:inta_mobile_pms/core/theme/app_colors.dart';
import 'package:inta_mobile_pms/core/config/responsive_config.dart';
import 'package:inta_mobile_pms/core/widgets/pms_app_bar.dart';
import 'package:inta_mobile_pms/router/app_routes.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final config = ResponsiveConfig();
    final isMobile = ResponsiveConfig.isMobile(context);
    final padding = ResponsiveConfig.defaultPadding(context);
    final cardRadius = ResponsiveConfig.cardRadius(context);
    final iconSize = ResponsiveConfig.iconSize(context);
    final fontScale = ResponsiveConfig.fontScale(context);

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: PmsAppBar(
        title: '',
        alwaysVisibleSearch: true,
        actions: [
          IconButton(
            icon: Icon(Icons.edit_calendar, color: AppColors.black, size: iconSize),
            onPressed: () {
              context.go(AppRoutes.quickReservation);
            },
          ),
          IconButton(
            icon: Icon(Icons.calendar_view_month, color: AppColors.black, size: iconSize),
            onPressed: () {
              context.go(AppRoutes.stayView);
            },
          ),
          IconButton(
            icon: Icon(Icons.notifications, color: AppColors.black, size: iconSize),
            onPressed: () {
              context.go(AppRoutes.notifications);
            },
          ),
        ],
      ),
      drawer: _buildDrawer(context, textTheme, config),
      body: ListView(
        padding: EdgeInsets.all(padding),
        children: [
          _buildOccupancyCards(context, textTheme, config, isMobile, cardRadius, iconSize, fontScale),
          SizedBox(height: ResponsiveConfig.scaleHeight(context, 24)),
          _buildPropertyStatistics(context, textTheme, config, cardRadius, iconSize, fontScale),
          SizedBox(height: ResponsiveConfig.scaleHeight(context, 24)),
          _buildInventoryStatistics(context, textTheme, config, cardRadius, iconSize, fontScale),
          SizedBox(height: ResponsiveConfig.scaleHeight(context, 24)),
          _buildOccupancyStatistics(context, textTheme, config, cardRadius, iconSize, fontScale),
        ],
      ),
    );
  }

  Widget _buildDrawer(BuildContext context, TextTheme textTheme, ResponsiveConfig config) {
    final iconSize = ResponsiveConfig.iconSize(context);
    final avatarRadius = ResponsiveConfig.drawerAvatarRadius(context);
    final fontScale = ResponsiveConfig.fontScale(context);

    return Drawer(
      backgroundColor: AppColors.surface,
      elevation: 8,
      child: Column(
        children: [
          // Drawer Header
          Container(
            height: ResponsiveConfig.scaleHeight(context, 150),
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.primary,
                  AppColors.primary.withOpacity(0.85),
                ],
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10),
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.35),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: ResponsiveConfig.defaultPadding(context), vertical: ResponsiveConfig.scaleHeight(context, 16)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        // Avatar with subtle border
                        CircleAvatar(
                          radius: avatarRadius,
                          backgroundColor: AppColors.onPrimary.withOpacity(0.15),
                          child: Icon(
                            Icons.person,
                            color: AppColors.onPrimary,
                            size: iconSize,
                          ),
                        ),
                        SizedBox(width: ResponsiveConfig.scaleWidth(context, 14)),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Welcome Back',
                                style: textTheme.bodySmall?.copyWith(
                                  color: AppColors.onPrimary.withOpacity(0.85),
                                  fontWeight: FontWeight.w500,
                                  fontSize: (textTheme.bodySmall?.fontSize ?? 12) * fontScale,
                                ),
                              ),
                              SizedBox(height: ResponsiveConfig.scaleHeight(context, 6)),
                              Text(
                                'Admin User',
                                style: textTheme.titleLarge?.copyWith(
                                  color: AppColors.onPrimary,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.5,
                                  fontSize: (textTheme.titleLarge?.fontSize ?? 22) * fontScale,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.settings_outlined,
                            color: AppColors.onPrimary.withOpacity(0.9),
                            size: iconSize,
                          ),
                          onPressed: () {
                            () => context.go(AppRoutes.settings);
                          },
                        ),
                      ],
                    ),
                    const Spacer(),
                    Text(
                      'Inta PMS',
                      style: textTheme.bodyMedium?.copyWith(
                        color: AppColors.onPrimary.withOpacity(0.95),
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.3,
                        fontSize: (textTheme.bodyMedium?.fontSize ?? 14) * fontScale,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                // Main Navigation Section
                _buildSectionHeader(context, textTheme, config, 'Main Navigation'),
                _buildMenuTile(
                  context,
                  textTheme,
                  Icons.home,
                  'Dashboard',
                  () => context.go(AppRoutes.dashboard),
                  config,
                  isActive: true, // Assuming dashboard is active
                ),
                _buildMenuTile(
                  context,
                  textTheme,
                  Icons.grid_view,
                  'Stay View',
                  () => context.go(AppRoutes.stayView),
                  config,
                ),
                _buildMenuTile(
                  context,
                  textTheme,
                  Icons.calendar_today,
                  'Quick Reservation',
                  () => context.go(AppRoutes.quickReservation),
                  config,
                ),
                _buildMenuTile(
                  context,
                  textTheme,
                  Icons.calendar_month,
                  'Reservation List',
                  () => context.go(AppRoutes.reservationList),
                  config,
                ),
                _buildMenuTile(
                  context,
                  textTheme,
                  Icons.airplanemode_on,
                  'Arrival List',
                  () => context.go(AppRoutes.arrivalList),
                  config,
                ),
                _buildMenuTile(
                  context,
                  textTheme,
                  Icons.hotel,
                  'In-house List',
                  () => context.go(AppRoutes.inhouseList),
                  config,
                ),
                _buildMenuTile(
                  context,
                  textTheme,
                  Icons.emoji_transportation_rounded,
                  'Departure List',
                  () => context.go(AppRoutes.departureList),
                  config,
                ),
                _buildMenuTile(
                  context,
                  textTheme,
                  Icons.attach_money,
                  'Rates & Inventory',
                  () => context.go(AppRoutes.ratesInventory),
                  config,
                ),
                _buildMenuTile(
                  context,
                  textTheme,
                  Icons.bar_chart,
                  'Manager Report',
                  () => context.go(AppRoutes.managerReport),
                  config,
                ),
                Divider(height: 1, color: AppColors.onSurface, indent: ResponsiveConfig.defaultPadding(context), endIndent: ResponsiveConfig.defaultPadding(context)),

                // Maintenance Section
                _buildSectionHeader(context, textTheme, config, 'Maintenance'),
                _buildMenuTile(
                  context,
                  textTheme,
                  Icons.tire_repair_sharp,
                  'Maintenance Block',
                  () => context.go(AppRoutes.maintenanceBlock),
                  config,
                ),
                _buildMenuTile(
                  context,
                  textTheme,
                  Icons.checklist,
                  'Work Order List',
                  () => context.go(AppRoutes.workOrderList),
                  config,
                ),
                _buildMenuTile(
                  context,
                  textTheme,
                  Icons.house,
                  'House Status',
                  () => context.go(AppRoutes.houseStatus),
                  config,
                ),
                Divider(height: 1, color: AppColors.onSurface, indent: ResponsiveConfig.defaultPadding(context), endIndent: ResponsiveConfig.defaultPadding(context)),

                // Settings Section
                _buildSectionHeader(context, textTheme, config, 'Settings'),
                _buildMenuTile(
                  context,
                  textTheme,
                  Icons.lock,
                  'Net Lock',
                  () => context.go(AppRoutes.netLock),
                  config,
                ),
                _buildMenuTile(
                  context,
                  textTheme,
                  Icons.notifications,
                  'Notification',
                  () => context.go(AppRoutes.notifications),
                  config,
                ),
                _buildMenuTile(
                  context,
                  textTheme,
                  Icons.settings,
                  'Settings',
                  () => context.go(AppRoutes.settings),
                  config,
                ),
              ],
            ),
          ),
          // Bottom Actions (e.g., Logout)
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(ResponsiveConfig.defaultPadding(context)),
            decoration: BoxDecoration(
              color: AppColors.surface.withOpacity(0.5),
              border: Border(top: BorderSide(color: AppColors.onSurface.withOpacity(0.1))),
            ),
            child: ListTile(
              leading: Icon(Icons.logout, color: AppColors.error, size: iconSize),
              title: Text(
                'Logout',
                style: textTheme.bodyMedium?.copyWith(
                  color: AppColors.error,
                  fontWeight: FontWeight.w500,
                  fontSize: (textTheme.bodyMedium?.fontSize ?? 14) * fontScale,
                ),
              ),
              trailing: Icon(Icons.arrow_forward_ios, size: iconSize * 0.8, color: AppColors.error),
              onTap: () => context.go(AppRoutes.login),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              tileColor: Colors.transparent,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, TextTheme textTheme, ResponsiveConfig config, String title) {
    final fontScale = ResponsiveConfig.fontScale(context);
    return Padding(
      padding: EdgeInsets.fromLTRB(
        ResponsiveConfig.defaultPadding(context),
        ResponsiveConfig.scaleHeight(context, 20),
        ResponsiveConfig.defaultPadding(context),
        ResponsiveConfig.scaleHeight(context, 8),
      ),
      child: Text(
        title,
        style: textTheme.titleSmall?.copyWith(
          color: AppColors.primary,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
          fontSize: (textTheme.titleSmall?.fontSize ?? 16) * fontScale,
        ),
      ),
    );
  }

  Widget _buildMenuTile(
    BuildContext context,
    TextTheme textTheme,
    IconData icon,
    String title,
    VoidCallback? onTap,
    ResponsiveConfig config, {
    bool isActive = false,
  }) {
    final iconSize = ResponsiveConfig.iconSize(context);
    final fontScale = ResponsiveConfig.fontScale(context);
    final cardRadius = ResponsiveConfig.cardRadius(context);

    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: ResponsiveConfig.defaultPadding(context), vertical: ResponsiveConfig.scaleHeight(context, 2)),
      leading: Container(
        padding: EdgeInsets.all(ResponsiveConfig.scaleWidth(context, 8)),
        decoration: BoxDecoration(
          color: isActive ? AppColors.primary.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(cardRadius * 0.5),
        ),
        child: Icon(
          icon,
          color: isActive ? AppColors.primary : AppColors.primary.withOpacity(0.6),
          size: iconSize * 0.8,
        ),
      ),
      title: Text(
        title,
        style: textTheme.bodyMedium?.copyWith(
          color: isActive ? AppColors.black : AppColors.onSurface.withOpacity(0.7),
          fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
          fontSize: (textTheme.bodyMedium?.fontSize ?? 14) * fontScale,
        ),
      ),
      trailing: isActive
          ? Container(
              width: ResponsiveConfig.scaleWidth(context, 4),
              height: ResponsiveConfig.scaleHeight(context, 20),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(ResponsiveConfig.scaleWidth(context, 2)),
              ),
            )
          : null,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(cardRadius),
        side: isActive
            ? BorderSide(color: AppColors.primary.withOpacity(0.2))
            : BorderSide.none,
      ),
      tileColor: isActive ? AppColors.primary.withOpacity(0.05) : Colors.transparent,
      onTap: onTap,
      hoverColor: AppColors.primary.withOpacity(0.05),
    );
  }

  Widget _buildOccupancyCards(
    BuildContext context,
    TextTheme textTheme,
    ResponsiveConfig config,
    bool isMobile,
    double cardRadius,
    double iconSize,
    double fontScale,
  ) {
    return Column(
      children: [
        if (isMobile)
          Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: _buildOccupancyCard(
                      context,
                      'Arrival',
                      '4',
                      'Pending (1)\nArrived (3)',
                      AppColors.primary.withOpacity(0.1),
                      AppColors.surface,
                      textTheme,
                      config,
                      cardRadius,
                      iconSize,
                      fontScale,
                      () => context.go(AppRoutes.arrivalList),
                    ),
                  ),
                  SizedBox(width: ResponsiveConfig.scaleWidth(context, 16)),
                  Expanded(
                    child: _buildOccupancyCard(
                      context,
                      'Departure',
                      '2',
                      'Pending (0)\nChecked out (2)',
                      AppColors.secondary.withOpacity(0.1),
                      AppColors.surface,
                      textTheme,
                      config,
                      cardRadius,
                      iconSize,
                      fontScale,
                      () => context.go(AppRoutes.departureList),
                    ),
                  ),
                ],
              ),
              SizedBox(height: ResponsiveConfig.scaleHeight(context, 12)),
            ],
          )
        else
          // On tablet/desktop, stack vertically for better readability
          Column(
            children: [
              _buildOccupancyCard(
                context,
                'Arrival',
                '0',
                'Pending (0)\nArrived (0)',
                AppColors.primary.withOpacity(0.1),
                AppColors.surface,
                textTheme,
                config,
                cardRadius,
                iconSize,
                fontScale,
                () => context.go(AppRoutes.arrivalList),
              ),
              SizedBox(height: ResponsiveConfig.scaleHeight(context, 16)),
              _buildOccupancyCard(
                context,
                'Departure',
                '2',
                'Pending (0)\nChecked out (0)',
                AppColors.secondary.withOpacity(0.1),
                AppColors.surface,
                textTheme,
                config,
                cardRadius,
                iconSize,
                fontScale,
                () => context.go(AppRoutes.departureList),
              ),
            ],
          ),
        SizedBox(height: ResponsiveConfig.scaleHeight(context, 8)),
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () => context.go(AppRoutes.inhouseList),
                child: _buildInHouseCard(context, textTheme, config, cardRadius, iconSize, fontScale),
              ),
            ),
            SizedBox(width: ResponsiveConfig.scaleWidth(context, 16)),
            Expanded(
              child: GestureDetector(
                onTap: () => context.go(AppRoutes.reservationList),
                child: _buildBookingCard(context, textTheme, config, cardRadius, iconSize, fontScale),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildOccupancyCard(
    BuildContext context,
    String title,
    String count,
    String details,
    Color bgColor,
    Color accentColor,
    TextTheme textTheme,
    ResponsiveConfig config,
    double cardRadius,
    double iconSize,
    double fontScale,
    VoidCallback? onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(ResponsiveConfig.defaultPadding(context)),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [bgColor, bgColor.withOpacity(0.6)],
          ),
          borderRadius: BorderRadius.circular(cardRadius),
          border: Border.all(color: accentColor.withOpacity(0.3)),
          boxShadow: [
            BoxShadow(
              color: accentColor.withOpacity(0.15),
              spreadRadius: 0,
              blurRadius: ResponsiveConfig.scaleWidth(context, 20),
              offset: const Offset(0, 8),
            ),
            BoxShadow(
              color: AppColors.surface.withOpacity(0.5),
              spreadRadius: -2,
              blurRadius: ResponsiveConfig.scaleWidth(context, 10),
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: textTheme.titleSmall?.copyWith(
                    color: AppColors.black.withOpacity(0.8),
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.3,
                    fontSize: (textTheme.titleSmall?.fontSize ?? 16) * fontScale,
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(ResponsiveConfig.scaleWidth(context, 6)),
                  decoration: BoxDecoration(
                    color: accentColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(ResponsiveConfig.scaleWidth(context, 10)),
                  ),
                  child: Icon(
                    title == 'Arrival' ? Icons.flight_land : Icons.flight_takeoff,
                    color: accentColor,
                    size: iconSize * 0.9,
                  ),
                ),
              ],
            ),
            SizedBox(height: ResponsiveConfig.scaleHeight(context, 14)),
            Text(
              count,
              style: textTheme.headlineLarge?.copyWith(
                color: accentColor,
                fontWeight: FontWeight.bold,
                height: 0.9,
                fontSize: (textTheme.headlineLarge?.fontSize ?? 32) * fontScale * 0.8, 
              ),
            ),
            SizedBox(height: ResponsiveConfig.scaleHeight(context, 10)),
            Container(
              padding: EdgeInsets.symmetric(horizontal: ResponsiveConfig.scaleWidth(context, 10), vertical: ResponsiveConfig.scaleHeight(context, 6)),
              decoration: BoxDecoration(
                color: AppColors.surface.withOpacity(0.7),
                borderRadius: BorderRadius.circular(ResponsiveConfig.scaleWidth(context, 8)),
                border: Border.all(color: accentColor.withOpacity(0.1)),
              ),
              child: Text(
                details,
                style: textTheme.bodySmall?.copyWith(
                  color: AppColors.black.withOpacity(0.7),
                  height: 1.3,
                  fontWeight: FontWeight.w500,
                  fontSize: (textTheme.bodySmall?.fontSize ?? 12) * fontScale,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPropertyStatistics(
    BuildContext context,
    TextTheme textTheme,
    ResponsiveConfig config,
    double cardRadius,
    double iconSize,
    double fontScale,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: ResponsiveConfig.horizontalPadding(context).copyWith(bottom: ResponsiveConfig.scaleHeight(context, 4)),
          child: Text(
            'Property Statistics',
            style: textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.black,
              letterSpacing: 0.2,
              fontSize: (textTheme.headlineSmall?.fontSize ?? 20) * fontScale,
            ),
          ),
        ),
        SizedBox(height: ResponsiveConfig.scaleHeight(context, 20)),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: ResponsiveConfig.gridCrossAxisCount(context, mobileCount: 2, tabletCount: 3),
          mainAxisSpacing: ResponsiveConfig.listItemSpacing(context),
          crossAxisSpacing: ResponsiveConfig.listItemSpacing(context),
          childAspectRatio: ResponsiveConfig.gridChildAspectRatio(context),
          children: [
            _buildStatCard(
              context,
              textTheme,
              config,
              cardRadius,
              iconSize,
              fontScale,
              'Total Revenue',
              '\$13,469.02',
              'Y\'day: \$2,233.91',
              '+502.93%',
              true,
              AppColors.primary,
              Icons.trending_up,
            ),
            _buildStatCard(
              context,
              textTheme,
              config,
              cardRadius,
              iconSize,
              fontScale,
              'Avg. Daily Rate',
              '\$8,979.35',
              'Y\'day: \$1,116.96',
              '+703.91%',
              true,
              AppColors.primary,
              Icons.show_chart,
            ),
            _buildStatCard(
              context,
              textTheme,
              config,
              cardRadius,
              iconSize,
              fontScale,
              'Booking Lead Time',
              '-1092 Days',
              'Y\'day: -1089 Days',
              '-0.28%',
              false,
              AppColors.primary,
              Icons.trending_down,
            ),
            _buildStatCard(
              context,
              textTheme,
              config,
              cardRadius,
              iconSize,
              fontScale,
              'Avg. Length of Stay',
              '2 Nights',
              'Y\'day: 3 Nights',
              '-33.33%',
              false,
              AppColors.primary,
              Icons.trending_down,
            ),
            _buildStatCard(
              context,
              textTheme,
              config,
              cardRadius,
              iconSize,
              fontScale,
              'Total Payment',
              '\$13,685.00',
              'Y\'day: \$6,930.00',
              '+97.47%',
              true,
              AppColors.primary,
              Icons.trending_up,
            ),
            _buildStatCard(
              context,
              textTheme,
              config,
              cardRadius,
              iconSize,
              fontScale,
              'RevPar',
              '\$123.57',
              'Y\'day: \$20.31',
              '+508.42%',
              true,
              AppColors.primary,
              Icons.trending_up,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    TextTheme textTheme,
    ResponsiveConfig config,
    double cardRadius,
    double iconSize,
    double fontScale,
    String title,
    String value,
    String yesterday,
    String percentage,
    bool isPositive,
    Color accentColor,
    IconData icon,
  ) {
    return Container(
      padding: EdgeInsets.all(ResponsiveConfig.defaultPadding(context)),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(cardRadius),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withOpacity(0.08),
            spreadRadius: 0,
            blurRadius: ResponsiveConfig.scaleWidth(context, 20),
            offset: const Offset(0, 8),
          ),
          BoxShadow(
            color: AppColors.surface.withOpacity(0.7),
            spreadRadius: -2,
            blurRadius: ResponsiveConfig.scaleWidth(context, 10),
            offset: const Offset(0, -4),
          ),
        ],
        border: Border.all(
          color: accentColor.withOpacity(0.1),
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  title,
                  style: textTheme.bodyMedium?.copyWith(
                    color: AppColors.black.withOpacity(0.7),
                    fontWeight: FontWeight.w600,
                    height: 1.2,
                    fontSize: (textTheme.bodyMedium?.fontSize ?? 14) * fontScale,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.all(ResponsiveConfig.scaleWidth(context, 6)),
                decoration: BoxDecoration(
                  color: accentColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(ResponsiveConfig.scaleWidth(context, 8)),
                ),
                child: Icon(
                  icon,
                  color: accentColor,
                  size: iconSize * 0.8,
                ),
              ),
            ],
          ),
          SizedBox(height: ResponsiveConfig.scaleHeight(context, 12)),
          Text(
            yesterday,
            style: textTheme.bodySmall?.copyWith(
              color: AppColors.black.withOpacity(0.5),
              fontSize: (textTheme.bodySmall?.fontSize ?? 11) * fontScale,
            ),
          ),
          SizedBox(height: ResponsiveConfig.scaleHeight(context, 8)),
          Text(
            value,
            style: textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: accentColor,
              height: 1.1,
              fontSize: (textTheme.titleMedium?.fontSize ?? 18) * fontScale,
            ),
          ),
          SizedBox(height: ResponsiveConfig.scaleHeight(context, 12)),
          Container(
            padding: EdgeInsets.symmetric(horizontal: ResponsiveConfig.scaleWidth(context, 8), vertical: ResponsiveConfig.scaleHeight(context, 4)),
            decoration: BoxDecoration(
              color: (isPositive ? Colors.green : Colors.red).withOpacity(0.1),
              borderRadius: BorderRadius.circular(ResponsiveConfig.scaleWidth(context, 12)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isPositive ? Icons.trending_up : Icons.trending_down,
                  size: iconSize * 0.7,
                  color: isPositive ? Colors.green.shade600 : Colors.red.shade600,
                ),
                SizedBox(width: ResponsiveConfig.scaleWidth(context, 4)),
                Text(
                  percentage,
                  style: textTheme.bodySmall?.copyWith(
                    color: isPositive ? Colors.green.shade600 : Colors.red.shade600,
                    fontWeight: FontWeight.w600,
                    fontSize: (textTheme.bodySmall?.fontSize ?? 12) * fontScale,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInHouseCard(BuildContext context, TextTheme textTheme, ResponsiveConfig config, double cardRadius, double iconSize, double fontScale) {
    return Container(
      padding: EdgeInsets.all(ResponsiveConfig.defaultPadding(context)),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(cardRadius),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withOpacity(0.08),
            spreadRadius: 0,
            blurRadius: ResponsiveConfig.scaleWidth(context, 20),
            offset: const Offset(0, 8),
          ),
          BoxShadow(
            color: AppColors.surface.withOpacity(0.7),
            spreadRadius: -2,
            blurRadius: ResponsiveConfig.scaleWidth(context, 10),
            offset: const Offset(0, -4),
          ),
        ],
        border: Border.all(
          color: AppColors.primary.withOpacity(0.1),
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'In-House (2)',
                style: textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.black,
                  fontSize: (textTheme.titleSmall?.fontSize ?? 16) * fontScale,
                ),
              ),
              Container(
                padding: EdgeInsets.all(ResponsiveConfig.scaleWidth(context, 6)),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(ResponsiveConfig.scaleWidth(context, 10)),
                ),
                child: Icon(
                  Icons.home,
                  color: AppColors.primary,
                  size: iconSize * 0.9,
                ),
              ),
            ],
          ),
          SizedBox(height: ResponsiveConfig.scaleHeight(context, 16)),
          _buildGuestRow(context, textTheme, config, 'Adult', '4', 'Y\'day: (4)', fontScale),
          SizedBox(height: ResponsiveConfig.scaleHeight(context, 2)),
          _buildGuestRow(context, textTheme, config, 'Child', '0', 'Y\'day: (0)', fontScale),
        ],
      ),
    );
  }

  Widget _buildGuestRow(BuildContext context, TextTheme textTheme, ResponsiveConfig config, String label, String value, String yday, double fontScale) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: ResponsiveConfig.scaleHeight(context, 6)),
      child: Row(
        children: [
          Text(
            label,
            style: textTheme.bodySmall?.copyWith(
              color: AppColors.black.withOpacity(0.7),
              fontWeight: FontWeight.w500,
              fontSize: (textTheme.bodySmall?.fontSize ?? 12) * fontScale,
            ),
          ),
          const Spacer(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: ResponsiveConfig.scaleWidth(context, 8), vertical: ResponsiveConfig.scaleHeight(context, 2)),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(ResponsiveConfig.scaleWidth(context, 10)),
                ),
                child: Text(
                  value,
                  style: textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                    fontSize: (textTheme.bodySmall?.fontSize ?? 12) * fontScale,
                  ),
                ),
              ),
              SizedBox(height: ResponsiveConfig.scaleHeight(context, 2)),
              Text(
                yday,
                style: textTheme.bodySmall?.copyWith(
                  color: AppColors.black.withOpacity(0.5),
                  fontSize: (textTheme.bodySmall?.fontSize ?? 10) * fontScale,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBookingCard(BuildContext context, TextTheme textTheme, ResponsiveConfig config, double cardRadius, double iconSize, double fontScale) {
    return Container(
      padding: EdgeInsets.all(ResponsiveConfig.defaultPadding(context)),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(cardRadius),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withOpacity(0.08),
            spreadRadius: 0,
            blurRadius: ResponsiveConfig.scaleWidth(context, 20),
            offset: const Offset(0, 8),
          ),
          BoxShadow(
            color: AppColors.surface.withOpacity(0.7),
            spreadRadius: -2,
            blurRadius: ResponsiveConfig.scaleWidth(context, 10),
            offset: const Offset(0, -4),
          ),
        ],
        border: Border.all(
          color: AppColors.primary.withOpacity(0.1),
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Booking (6)',
                style: textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.black,
                  fontSize: (textTheme.titleSmall?.fontSize ?? 16) * fontScale,
                ),
              ),
              Container(
                padding: EdgeInsets.all(ResponsiveConfig.scaleWidth(context, 6)),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(ResponsiveConfig.scaleWidth(context, 10)),
                ),
                child: Icon(
                  Icons.book,
                  color: AppColors.primary,
                  size: iconSize * 0.9,
                ),
              ),
            ],
          ),
          SizedBox(height: ResponsiveConfig.scaleHeight(context, 16)),
          _buildBookingRow(context, textTheme, config, 'Void', '0', fontScale),
          SizedBox(height: ResponsiveConfig.scaleHeight(context, 2)),
          _buildBookingRow(context, textTheme, config, 'Cancel', '4', fontScale),
          SizedBox(height: ResponsiveConfig.scaleHeight(context, 2)),
          _buildBookingRow(context, textTheme, config, 'No Show', '2', fontScale),
        ],
      ),
    );
  }

  Widget _buildBookingRow(BuildContext context, TextTheme textTheme, ResponsiveConfig config, String label, String value, double fontScale) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: ResponsiveConfig.scaleHeight(context, 6)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: textTheme.bodySmall?.copyWith(
              color: AppColors.black.withOpacity(0.7),
              fontWeight: FontWeight.w500,
              fontSize: (textTheme.bodySmall?.fontSize ?? 12) * fontScale,
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: ResponsiveConfig.scaleWidth(context, 8), vertical: ResponsiveConfig.scaleHeight(context, 2)),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(ResponsiveConfig.scaleWidth(context, 10)),
            ),
            child: Text(
              value,
              style: textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
                fontSize: (textTheme.bodySmall?.fontSize ?? 12) * fontScale,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInventoryStatistics(
    BuildContext context,
    TextTheme textTheme,
    ResponsiveConfig config,
    double cardRadius,
    double iconSize,
    double fontScale,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: ResponsiveConfig.horizontalPadding(context).copyWith(bottom: ResponsiveConfig.scaleHeight(context, 4)),
          child: Text(
            'Inventory Statistics',
            style: textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.black,
              letterSpacing: 0.2,
              fontSize: (textTheme.headlineSmall?.fontSize ?? 20) * fontScale,
            ),
          ),
        ),
        SizedBox(height: ResponsiveConfig.scaleHeight(context, 20)),
        Container(
          padding: EdgeInsets.all(ResponsiveConfig.scaleWidth(context, 24)),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(cardRadius),
            boxShadow: [
              BoxShadow(
                color: AppColors.black.withOpacity(0.08),
                spreadRadius: 0,
                blurRadius: ResponsiveConfig.scaleWidth(context, 20),
                offset: const Offset(0, 8),
              ),
              BoxShadow(
                color: AppColors.surface.withOpacity(0.7),
                spreadRadius: -2,
                blurRadius: ResponsiveConfig.scaleWidth(context, 10),
                offset: const Offset(0, -4),
              ),
            ],
            border: Border.all(
              color: AppColors.primary.withOpacity(0.1),
              width: 1.5,
            ),
          ),
          child: Column(
            children: [
              _buildInventoryRow(
                context,
                textTheme,
                config,
                iconSize,
                fontScale,
                'Available Rooms',
                0.8,
                '107.5',
                AppColors.primary,
                Icons.hotel,
              ),
              SizedBox(height: ResponsiveConfig.scaleHeight(context, 20)),
              _buildInventoryRow(
                context,
                textTheme,
                config,
                iconSize,
                fontScale,
                'Sold Rooms',
                0.15,
                '45',
                Colors.green.shade600,
                Icons.check_circle,
              ),
              SizedBox(height: ResponsiveConfig.scaleHeight(context, 20)),
              _buildInventoryRow(
                context,
                textTheme,
                config,
                iconSize,
                fontScale,
                'Blocked Rooms',
                0.03,
                '12',
                Colors.orange.shade600,
                Icons.block,
              ),
              SizedBox(height: ResponsiveConfig.scaleHeight(context, 20)),
              _buildInventoryRow(
                context,
                textTheme,
                config,
                iconSize,
                fontScale,
                'Complimentary Rooms',
                0.02,
                '8',
                Colors.purple.shade600,
                Icons.card_giftcard,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInventoryRow(
    BuildContext context,
    TextTheme textTheme,
    ResponsiveConfig config,
    double iconSize,
    double fontScale,
    String label,
    double progressFactor,
    String value,
    Color progressColor,
    IconData icon,
  ) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(ResponsiveConfig.scaleWidth(context, 8)),
          decoration: BoxDecoration(
            color: progressColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(ResponsiveConfig.scaleWidth(context, 12)),
          ),
          child: Icon(
            icon,
            color: progressColor,
            size: iconSize,
          ),
        ),
        SizedBox(width: ResponsiveConfig.scaleWidth(context, 16)),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    label,
                    style: textTheme.bodyMedium?.copyWith(
                      color: AppColors.black.withOpacity(0.8),
                      fontWeight: FontWeight.w600,
                      fontSize: (textTheme.bodyMedium?.fontSize ?? 14) * fontScale,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: ResponsiveConfig.scaleWidth(context, 12), vertical: ResponsiveConfig.scaleHeight(context, 4)),
                    decoration: BoxDecoration(
                      color: progressColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(ResponsiveConfig.scaleWidth(context, 12)),
                    ),
                    child: Text(
                      value,
                      style: textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: progressColor,
                        fontSize: (textTheme.titleSmall?.fontSize ?? 16) * fontScale,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: ResponsiveConfig.scaleHeight(context, 12)),
              Container(
                width: double.infinity,
                height: ResponsiveConfig.scaleHeight(context, 8),
                decoration: BoxDecoration(
                  color: AppColors.black.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(ResponsiveConfig.scaleWidth(context, 4)),
                ),
                child: FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: progressFactor,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [progressColor, progressColor.withOpacity(0.7)],
                      ),
                      borderRadius: BorderRadius.circular(ResponsiveConfig.scaleWidth(context, 4)),
                      boxShadow: [
                        BoxShadow(
                          color: progressColor.withOpacity(0.3),
                          blurRadius: ResponsiveConfig.scaleWidth(context, 4),
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildOccupancyStatistics(
    BuildContext context,
    TextTheme textTheme,
    ResponsiveConfig config,
    double cardRadius,
    double iconSize,
    double fontScale,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: ResponsiveConfig.horizontalPadding(context).copyWith(bottom: ResponsiveConfig.scaleHeight(context, 4)),
          child: Text(
            'Occupancy Statistics',
            style: textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.black,
              letterSpacing: 0.2,
              fontSize: (textTheme.headlineSmall?.fontSize ?? 20) * fontScale,
            ),
          ),
        ),
        SizedBox(height: ResponsiveConfig.scaleHeight(context, 20)),
        Container(
          padding: EdgeInsets.all(ResponsiveConfig.defaultPadding(context)),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(cardRadius),
            boxShadow: [
              BoxShadow(
                color: AppColors.black.withOpacity(0.08),
                spreadRadius: 0,
                blurRadius: ResponsiveConfig.scaleWidth(context, 20),
                offset: const Offset(0, 8),
              ),
              BoxShadow(
                color: AppColors.surface.withOpacity(0.7),
                spreadRadius: -2,
                blurRadius: ResponsiveConfig.scaleWidth(context, 10),
                offset: const Offset(0, -4),
              ),
            ],
            border: Border.all(
              color: AppColors.secondary.withOpacity(0.1),
              width: 1.5,
            ),
          ),
          child: Column(
            children: [
              _buildOccupancyRow(
                context,
                textTheme,
                config,
                iconSize,
                fontScale,
                'Today',
                0.2,
                '22.5%',
                AppColors.primary,
                Icons.today,
              ),
              SizedBox(height: ResponsiveConfig.scaleHeight(context, 20)),
              _buildOccupancyRow(
                context,
                textTheme,
                config,
                iconSize,
                fontScale,
                'Yesterday',
                0.15,
                '16.5%',
                Colors.green.shade600,
                Icons.date_range,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildOccupancyRow(
    BuildContext context,
    TextTheme textTheme,
    ResponsiveConfig config,
    double iconSize,
    double fontScale,
    String label,
    double progressFactor,
    String value,
    Color progressColor,
    IconData icon,
  ) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(ResponsiveConfig.scaleWidth(context, 8)),
          decoration: BoxDecoration(
            color: progressColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(ResponsiveConfig.scaleWidth(context, 12)),
          ),
          child: Icon(
            icon,
            color: progressColor,
            size: iconSize,
          ),
        ),
        SizedBox(width: ResponsiveConfig.scaleWidth(context, 16)),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    label,
                    style: textTheme.bodyMedium?.copyWith(
                      color: AppColors.black.withOpacity(0.8),
                      fontWeight: FontWeight.w600,
                      fontSize: (textTheme.bodyMedium?.fontSize ?? 14) * fontScale,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: ResponsiveConfig.scaleWidth(context, 12), vertical: ResponsiveConfig.scaleHeight(context, 4)),
                    decoration: BoxDecoration(
                      color: progressColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(ResponsiveConfig.scaleWidth(context, 12)),
                    ),
                    child: Text(
                      value,
                      style: textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: progressColor,
                        fontSize: (textTheme.titleSmall?.fontSize ?? 16) * fontScale,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: ResponsiveConfig.scaleHeight(context, 12)),
              Container(
                width: double.infinity,
                height: ResponsiveConfig.scaleHeight(context, 8),
                decoration: BoxDecoration(
                  color: AppColors.black.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(ResponsiveConfig.scaleWidth(context, 4)),
                ),
                child: FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: progressFactor,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [progressColor, progressColor.withOpacity(0.7)],
                      ),
                      borderRadius: BorderRadius.circular(ResponsiveConfig.scaleWidth(context, 4)),
                      boxShadow: [
                        BoxShadow(
                          color: progressColor.withOpacity(0.3),
                          blurRadius: ResponsiveConfig.scaleWidth(context, 4),
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}