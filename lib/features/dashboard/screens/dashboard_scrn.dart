// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:get/Get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:go_router/go_router.dart';
import 'package:inta_mobile_pms/core/theme/app_colors.dart';
import 'package:inta_mobile_pms/core/config/responsive_config.dart';
import 'package:inta_mobile_pms/core/widgets/pms_app_bar.dart';
import 'package:inta_mobile_pms/features/dashboard/viewmodels/dashboard_vm.dart';
import 'package:inta_mobile_pms/features/dashboard/widgets/hotel_list_dialog_wgt.dart';
import 'package:inta_mobile_pms/router/app_routes.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final _dashboardVm = Get.find<DashboardVm>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (mounted) {
        await _dashboardVm.loadBookingStaticData();
        await _dashboardVm.getInitialData();
      }
    });
  }

  void openBrowser(String url) async {
    final uri = Uri.parse(url);
    try {
      if (!await launchUrl(uri, mode: LaunchMode.platformDefault)) {
        throw Exception('Count not launch!');
      }
    } catch (e) {
      throw Exception('Error launching URL: $e');
    }
  }

  String formatCurrency(double? value) {
    if (value == null) return '${_dashboardVm.baseCurrency} 0.00';

    final formatted = value
        .toStringAsFixed(2)
        .replaceAllMapped(
          RegExp(r'(\d)(?=(\d{3})+\.)'),
          (Match m) => '${m[1]},',
        );

    return '${_dashboardVm.baseCurrency} ${formatted}';
  }

  _onChangeProperty() async {
    await _dashboardVm.getAllHotels();
    showDialog(
      context: context,
      builder: (_) => HotelListDialog(
        onHotelSelected: (hotel) async {
          await _dashboardVm.changeProperty(hotel);
        },
      ),
    );
  }

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
        alwaysVisibleSearch: false,
        onSearchChanged: (query) {},
        actions: [
          IconButton(
            icon: Icon(
              Icons.edit_calendar,
              color: AppColors.black,
              size: iconSize,
            ),
            onPressed: () {
              context.push(AppRoutes.quickReservation);
            },
          ),
          IconButton(
            icon: Icon(
              Icons.calendar_view_month,
              color: AppColors.black,
              size: iconSize,
            ),
            onPressed: () {
              context.push(AppRoutes.stayView);
            },
          ),
          // IconButton(
          //   icon: Icon(Icons.print, color: AppColors.black, size: iconSize),
          //   onPressed: () {
          //     // openBrowser('http://192.168.1.176:2234');
          //   },
          // ),
          // IconButton(
          //   icon: Icon(
          //     Icons.notifications,
          //     color: AppColors.black,
          //     size: iconSize,
          //   ),
          //   onPressed: () {
          //     context.push(AppRoutes.notifications);
          //   },
          // ),
          IconButton(
            icon: const Icon(Icons.swap_vert, color: AppColors.black),
            onPressed: () => _onChangeProperty(),
          ),
        ],
      ),
      drawer: _buildDrawer(context, textTheme, config),
      body: RefreshIndicator(
        onRefresh: () async {
          _dashboardVm.refreshDashboard();
        },
        child: Obx(() {
          if (_dashboardVm.isLoading.value) {
            return ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.all(padding),
              children: [
                _buildShimmerOccupancyCards(
                  context,
                  textTheme,
                  config,
                  isMobile,
                  cardRadius,
                  iconSize,
                  fontScale,
                ),
                SizedBox(height: ResponsiveConfig.scaleHeight(context, 24)),
                _buildShimmerPropertyStatistics(
                  context,
                  textTheme,
                  config,
                  cardRadius,
                  iconSize,
                  fontScale,
                ),
                SizedBox(height: ResponsiveConfig.scaleHeight(context, 24)),
                _buildShimmerInventoryStatistics(
                  context,
                  textTheme,
                  config,
                  cardRadius,
                  iconSize,
                  fontScale,
                ),
                SizedBox(height: ResponsiveConfig.scaleHeight(context, 24)),
                _buildShimmerOccupancyStatistics(
                  context,
                  textTheme,
                  config,
                  cardRadius,
                  iconSize,
                  fontScale,
                ),
              ],
            );
          } else {
            return ListView(
              padding: EdgeInsets.all(padding),
              children: [
                _buildOccupancyCards(
                  context,
                  textTheme,
                  config,
                  isMobile,
                  cardRadius,
                  iconSize,
                  fontScale,
                ),
                SizedBox(height: ResponsiveConfig.scaleHeight(context, 24)),
                _buildPropertyStatistics(
                  context,
                  textTheme,
                  config,
                  cardRadius,
                  iconSize,
                  fontScale,
                ),
                SizedBox(height: ResponsiveConfig.scaleHeight(context, 24)),
                _buildInventoryStatistics(
                  context,
                  textTheme,
                  config,
                  cardRadius,
                  iconSize,
                  fontScale,
                ),
                SizedBox(height: ResponsiveConfig.scaleHeight(context, 24)),
                _buildOccupancyStatistics(
                  context,
                  textTheme,
                  config,
                  cardRadius,
                  iconSize,
                  fontScale,
                ),
              ],
            );
          }
        }),
      ),
    );
  }

  Widget _buildShimmerOccupancyCards(
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
                    child: _buildShimmerCard(
                      context,
                      height: ResponsiveConfig.scaleHeight(context, 150),
                      cardRadius: cardRadius,
                    ),
                  ),
                  SizedBox(width: ResponsiveConfig.scaleWidth(context, 16)),
                  Expanded(
                    child: _buildShimmerCard(
                      context,
                      height: ResponsiveConfig.scaleHeight(context, 150),
                      cardRadius: cardRadius,
                    ),
                  ),
                ],
              ),
              SizedBox(height: ResponsiveConfig.scaleHeight(context, 12)),
            ],
          )
        else
          Column(
            children: [
              _buildShimmerCard(
                context,
                height: ResponsiveConfig.scaleHeight(context, 150),
                cardRadius: cardRadius,
              ),
              SizedBox(height: ResponsiveConfig.scaleHeight(context, 16)),
              _buildShimmerCard(
                context,
                height: ResponsiveConfig.scaleHeight(context, 150),
                cardRadius: cardRadius,
              ),
            ],
          ),
        SizedBox(height: ResponsiveConfig.scaleHeight(context, 8)),
        Row(
          children: [
            Expanded(
              child: _buildShimmerCard(
                context,
                height: ResponsiveConfig.scaleHeight(context, 150),
                cardRadius: cardRadius,
              ),
            ),
            SizedBox(width: ResponsiveConfig.scaleWidth(context, 16)),
            Expanded(
              child: _buildShimmerCard(
                context,
                height: ResponsiveConfig.scaleHeight(context, 150),
                cardRadius: cardRadius,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildShimmerPropertyStatistics(
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
          padding: ResponsiveConfig.horizontalPadding(
            context,
          ).copyWith(bottom: ResponsiveConfig.scaleHeight(context, 4)),
          child: Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              width: ResponsiveConfig.scaleWidth(context, 200),
              height: ResponsiveConfig.responsiveFont(
                context,
                textTheme.headlineSmall?.fontSize ?? 20,
              ),
              color: Colors.white,
            ),
          ),
        ),
        SizedBox(height: ResponsiveConfig.scaleHeight(context, 20)),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: ResponsiveConfig.gridCrossAxisCount(
            context,
            mobileCount: 2,
            tabletCount: 3,
          ),
          mainAxisSpacing: ResponsiveConfig.listItemSpacing(context),
          crossAxisSpacing: ResponsiveConfig.listItemSpacing(context),
          childAspectRatio: ResponsiveConfig.gridChildAspectRatio(context),
          children: List.generate(
            6,
            (index) => _buildShimmerCard(
              context,
              height: ResponsiveConfig.scaleHeight(context, 150),
              cardRadius: cardRadius,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildShimmerInventoryStatistics(
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
          padding: ResponsiveConfig.horizontalPadding(
            context,
          ).copyWith(bottom: ResponsiveConfig.scaleHeight(context, 4)),
          child: Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              width: ResponsiveConfig.scaleWidth(context, 200),
              height: ResponsiveConfig.responsiveFont(
                context,
                textTheme.headlineSmall?.fontSize ?? 20,
              ),
              color: Colors.white,
            ),
          ),
        ),
        SizedBox(height: ResponsiveConfig.scaleHeight(context, 20)),
        _buildShimmerCard(
          context,
          height: ResponsiveConfig.scaleHeight(context, 300),
          cardRadius: cardRadius,
          child: Column(
            children: List.generate(
              4,
              (index) => Padding(
                padding: EdgeInsets.only(
                  bottom: ResponsiveConfig.scaleHeight(context, 20),
                ),
                child: Row(
                  children: [
                    Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: Container(
                        width: iconSize,
                        height: iconSize,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
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
                              Shimmer.fromColors(
                                baseColor: Colors.grey[300]!,
                                highlightColor: Colors.grey[100]!,
                                child: Container(
                                  width: ResponsiveConfig.scaleWidth(
                                    context,
                                    100,
                                  ),
                                  height: ResponsiveConfig.responsiveFont(
                                    context,
                                    16,
                                  ),
                                  color: Colors.white,
                                ),
                              ),
                              Shimmer.fromColors(
                                baseColor: Colors.grey[300]!,
                                highlightColor: Colors.grey[100]!,
                                child: Container(
                                  width: ResponsiveConfig.scaleWidth(
                                    context,
                                    50,
                                  ),
                                  height: ResponsiveConfig.responsiveFont(
                                    context,
                                    16,
                                  ),
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: ResponsiveConfig.scaleHeight(context, 12),
                          ),
                          Shimmer.fromColors(
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.grey[100]!,
                            child: Container(
                              width: double.infinity,
                              height: ResponsiveConfig.responsiveFont(
                                context,
                                8,
                              ),
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildShimmerOccupancyStatistics(
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
          padding: ResponsiveConfig.horizontalPadding(
            context,
          ).copyWith(bottom: ResponsiveConfig.scaleHeight(context, 4)),
          child: Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              width: ResponsiveConfig.scaleWidth(context, 200),
              height: ResponsiveConfig.responsiveFont(
                context,
                textTheme.headlineSmall?.fontSize ?? 20,
              ),
              color: Colors.white,
            ),
          ),
        ),
        SizedBox(height: ResponsiveConfig.scaleHeight(context, 20)),
        _buildShimmerCard(
          context,
          height: ResponsiveConfig.scaleHeight(context, 150),
          cardRadius: cardRadius,
          child: Column(
            children: List.generate(
              2,
              (index) => Padding(
                padding: EdgeInsets.only(
                  bottom: ResponsiveConfig.scaleHeight(context, 20),
                ),
                child: Row(
                  children: [
                    Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: Container(
                        width: iconSize,
                        height: iconSize,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
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
                              Shimmer.fromColors(
                                baseColor: Colors.grey[300]!,
                                highlightColor: Colors.grey[100]!,
                                child: Container(
                                  width: ResponsiveConfig.scaleWidth(
                                    context,
                                    100,
                                  ),
                                  height: ResponsiveConfig.responsiveFont(
                                    context,
                                    16,
                                  ),
                                  color: Colors.white,
                                ),
                              ),
                              Shimmer.fromColors(
                                baseColor: Colors.grey[300]!,
                                highlightColor: Colors.grey[100]!,
                                child: Container(
                                  width: ResponsiveConfig.scaleWidth(
                                    context,
                                    50,
                                  ),
                                  height: ResponsiveConfig.responsiveFont(
                                    context,
                                    16,
                                  ),
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: ResponsiveConfig.scaleHeight(context, 12),
                          ),
                          Shimmer.fromColors(
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.grey[100]!,
                            child: Container(
                              width: double.infinity,
                              height: ResponsiveConfig.responsiveFont(
                                context,
                                8,
                              ),
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildShimmerCard(
    BuildContext context, {
    required double height,
    required double cardRadius,
    Widget? child,
  }) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(cardRadius),
        ),
        child: child,
      ),
    );
  }

  Widget _buildDrawer(
    BuildContext context,
    TextTheme textTheme,
    ResponsiveConfig config,
  ) {
    final iconSize = ResponsiveConfig.iconSize(context);
    final avatarRadius = ResponsiveConfig.drawerAvatarRadius(context);
    final fontScale = ResponsiveConfig.fontScale(context);

    return Drawer(
      backgroundColor: AppColors.surface,
      elevation: 8,
      child: Column(
        children: [
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
              borderRadius: const BorderRadius.only(
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
                padding: EdgeInsets.symmetric(
                  horizontal: ResponsiveConfig.defaultPadding(context),
                  vertical: ResponsiveConfig.scaleHeight(context, 16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: avatarRadius,
                          backgroundColor: AppColors.onPrimary.withOpacity(
                            0.15,
                          ),
                          child: Icon(
                            Icons.person,
                            color: AppColors.onPrimary,
                            size: iconSize,
                          ),
                        ),
                        SizedBox(
                          width: ResponsiveConfig.scaleWidth(context, 14),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Obx(() {
                                return Text(
                                  _dashboardVm.userName.value,
                                  style: textTheme.titleLarge?.copyWith(
                                    color: AppColors.onPrimary,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 0.5,
                                    fontSize: ResponsiveConfig.responsiveFont(
                                      context,
                                      textTheme.titleLarge?.fontSize ?? 22,
                                    ),
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                );
                              }),
                              const SizedBox(height: 4),
                              Obx(() {
                                return Text(
                                  _dashboardVm.hotelName.value,
                                  style: textTheme.bodyMedium?.copyWith(
                                    color: AppColors.onPrimary.withOpacity(
                                      0.95,
                                    ),
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: 0.3,
                                    fontSize: ResponsiveConfig.responsiveFont(
                                      context,
                                      textTheme.bodyMedium?.fontSize ?? 14,
                                    ),
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                );
                              }),
                            ],
                          ),
                        ),
                      ],
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
                _buildSectionHeader(
                  context,
                  textTheme,
                  config,
                  'Main Navigation',
                ),
                _buildMenuTile(
                  context,
                  textTheme,
                  Icons.home,
                  'Dashboard',
                  () => context.push(AppRoutes.dashboard),
                  config,
                  isActive: true,
                ),
                _buildMenuTile(
                  context,
                  textTheme,
                  Icons.grid_view,
                  'Stay View',
                  () => context.push(AppRoutes.stayView),
                  config,
                ),
                _buildMenuTile(
                  context,
                  textTheme,
                  Icons.calendar_today,
                  'Quick Reservation',
                  () => context.push(AppRoutes.quickReservation),
                  config,
                ),
                _buildMenuTile(
                  context,
                  textTheme,
                  Icons.calendar_month,
                  'Reservation List',
                  () => context.push(AppRoutes.reservationList),
                  config,
                ),
                _buildMenuTile(
                  context,
                  textTheme,
                  Icons.airplanemode_on,
                  'Arrival List',
                  () => context.push(AppRoutes.arrivalList),
                  config,
                ),
                _buildMenuTile(
                  context,
                  textTheme,
                  Icons.emoji_transportation_rounded,
                  'Departure List',
                  () => context.push(AppRoutes.departureList),
                  config,
                ),
                // _buildMenuTile(
                //   context,
                //   textTheme,
                //   Icons.attach_money,
                //   'Rates & Inventory',
                //   () => context.push(AppRoutes.ratesInventory),
                //   config,
                // ),
                ExpansionTile(
                  leading: Container(
                    padding: EdgeInsets.all(
                      ResponsiveConfig.scaleWidth(context, 8),
                    ),
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(
                        ResponsiveConfig.cardRadius(context) * 0.5,
                      ),
                    ),
                    child: Icon(
                      Icons.assessment,
                      size: iconSize * 0.8,
                      color: AppColors.primary.withOpacity(0.6),
                    ),
                  ),
                  title: Text(
                    'Reports',
                    style: textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: ResponsiveConfig.responsiveFont(
                        context,
                        textTheme.bodyMedium?.fontSize ?? 14,
                      ),
                      color: AppColors.onSurface.withOpacity(0.7),
                    ),
                  ),
                  tilePadding: EdgeInsets.symmetric(
                    horizontal: ResponsiveConfig.defaultPadding(context),
                    vertical: ResponsiveConfig.scaleHeight(context, 2),
                  ),
                  childrenPadding: EdgeInsets.zero,
                  backgroundColor: AppColors.primary.withOpacity(0.05),
                  collapsedBackgroundColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      ResponsiveConfig.cardRadius(context),
                    ),
                    side: BorderSide(color: AppColors.primary.withOpacity(0.2)),
                  ),
                  initiallyExpanded: false,
                  children: [
                    _buildSubMenuTile(
                      context,
                      textTheme,
                      Icons.nights_stay,
                      'Night Audit Report',
                      () => context.push(AppRoutes.nightAuditReport),
                      config,
                      // isActive: GoRouterState.of(context).location.contains(AppRoutes.nightAuditReport),
                    ),
                    _buildSubMenuTile(
                      context,
                      textTheme,
                      Icons.bar_chart,
                      'Manager Report',
                      () => context.push(AppRoutes.managerReport),
                      config,
                      // isActive: GoRouterState.of(context).location.contains(AppRoutes.managerReport),
                    ),
                  ],
                ),
                Divider(
                  height: 1,
                  color: AppColors.onSurface,
                  indent: ResponsiveConfig.defaultPadding(context),
                  endIndent: ResponsiveConfig.defaultPadding(context),
                ),
                // Maintenance Section
                _buildSectionHeader(context, textTheme, config, 'Housekeeping'),
                _buildMenuTile(
                  context,
                  textTheme,
                  Icons.tire_repair_sharp,
                  'Maintenance Block',
                  () => context.push(AppRoutes.maintenanceBlock),
                  config,
                ),
                _buildMenuTile(
                  context,
                  textTheme,
                  Icons.checklist,
                  'Work Order List',
                  () => context.push(AppRoutes.workOrderList),
                  config,
                ),
                _buildMenuTile(
                  context,
                  textTheme,
                  Icons.house,
                  'House Status',
                  () => context.push(AppRoutes.houseStatus),
                  config,
                ),
                Divider(
                  height: 1,
                  color: AppColors.onSurface,
                  indent: ResponsiveConfig.defaultPadding(context),
                  endIndent: ResponsiveConfig.defaultPadding(context),
                ),
                // Settings Section
                _buildSectionHeader(context, textTheme, config, 'Settings'),
                _buildMenuTile(
                  context,
                  textTheme,
                  Icons.lock,
                  'Net Lock',
                  () => context.push(AppRoutes.netLock),
                  config,
                ),
                // _buildMenuTile(
                //   context,
                //   textTheme,
                //   Icons.notifications,
                //   'Notification',
                //   () => context.push(AppRoutes.notifications),
                //   config,
                // ),
                _buildMenuTile(
                  context,
                  textTheme,
                  Icons.settings,
                  'Settings',
                  () => context.push(AppRoutes.settings),
                  config,
                ),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(ResponsiveConfig.defaultPadding(context)),
            decoration: BoxDecoration(
              color: AppColors.surface.withOpacity(0.5),
              border: Border(
                top: BorderSide(color: AppColors.onSurface.withOpacity(0.1)),
              ),
            ),
            child: Obx(
              () => Text(
                'Working Date: ${_dashboardVm.currentWorkingDate.value}',
                style: textTheme.bodySmall?.copyWith(
                  color: AppColors.primary.withOpacity(0.6),
                  fontSize: ResponsiveConfig.responsiveFont(
                    context,
                    textTheme.bodySmall?.fontSize ?? 12,
                  ),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(ResponsiveConfig.defaultPadding(context)),
            decoration: BoxDecoration(
              color: AppColors.surface.withOpacity(0.5),
              border: Border(
                top: BorderSide(color: AppColors.onSurface.withOpacity(0.1)),
              ),
            ),
            child: ListTile(
              leading: Icon(
                Icons.logout,
                color: AppColors.error,
                size: iconSize,
              ),
              title: Text(
                'Logout',
                style: textTheme.bodyMedium?.copyWith(
                  color: AppColors.error,
                  fontWeight: FontWeight.w500,
                  fontSize: ResponsiveConfig.responsiveFont(
                    context,
                    textTheme.bodyMedium?.fontSize ?? 14,
                  ),
                ),
              ),
              trailing: Icon(
                Icons.arrow_forward_ios,
                size: iconSize * 0.8,
                color: AppColors.error,
              ),
              onTap: () => _dashboardVm.handleLogout(),
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

  Widget _buildSectionHeader(
    BuildContext context,
    TextTheme textTheme,
    ResponsiveConfig config,
    String title,
  ) {
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
          fontSize: ResponsiveConfig.responsiveFont(
            context,
            textTheme.titleSmall?.fontSize ?? 16,
          ),
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
      contentPadding: EdgeInsets.symmetric(
        horizontal: ResponsiveConfig.defaultPadding(context),
        vertical: ResponsiveConfig.scaleHeight(context, 2),
      ),
      leading: Container(
        padding: EdgeInsets.all(ResponsiveConfig.scaleWidth(context, 8)),
        decoration: BoxDecoration(
          color: isActive
              ? AppColors.primary.withOpacity(0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(cardRadius * 0.5),
        ),
        child: Icon(
          icon,
          color: isActive
              ? AppColors.primary
              : AppColors.primary.withOpacity(0.6),
          size: iconSize * 0.8,
        ),
      ),
      title: Text(
        title,
        style: textTheme.bodyMedium?.copyWith(
          color: isActive
              ? AppColors.black
              : AppColors.onSurface.withOpacity(0.7),
          fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
          fontSize: ResponsiveConfig.responsiveFont(
            context,
            textTheme.bodyMedium?.fontSize ?? 14,
          ),
        ),
      ),
      trailing: isActive
          ? Container(
              width: ResponsiveConfig.scaleWidth(context, 4),
              height: ResponsiveConfig.scaleHeight(context, 20),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(
                  ResponsiveConfig.scaleWidth(context, 2),
                ),
              ),
            )
          : null,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(cardRadius),
        side: isActive
            ? BorderSide(color: AppColors.primary.withOpacity(0.2))
            : BorderSide.none,
      ),
      tileColor: isActive
          ? AppColors.primary.withOpacity(0.05)
          : Colors.transparent,
      onTap: onTap,
      hoverColor: AppColors.primary.withOpacity(0.05),
    );
  }

  Widget _buildSubMenuTile(
    BuildContext context,
    TextTheme textTheme,
    IconData icon,
    String title,
    VoidCallback onTap,
    ResponsiveConfig config, {
    bool isActive = false,
    int? badgeCount,
  }) {
    final iconSize = ResponsiveConfig.iconSize(context);
    final fontScale = ResponsiveConfig.fontScale(context);
    final cardRadius = ResponsiveConfig.cardRadius(context);
    final defaultPadding = ResponsiveConfig.defaultPadding(context);

    return ListTile(
      contentPadding: EdgeInsets.symmetric(
        horizontal: defaultPadding + 32, // indented like submenu
        vertical: ResponsiveConfig.scaleHeight(context, 2),
      ),
      leading: Container(
        padding: EdgeInsets.all(ResponsiveConfig.scaleWidth(context, 8)),
        decoration: BoxDecoration(
          color: isActive
              ? AppColors.primary.withOpacity(0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(cardRadius * 0.5),
        ),
        child: Icon(
          icon,
          color: isActive
              ? AppColors.primary
              : AppColors.primary.withOpacity(0.6),
          size: iconSize * 0.8,
        ),
      ),
      title: Text(
        title,
        style: textTheme.bodyMedium?.copyWith(
          color: isActive
              ? AppColors.black
              : AppColors.onSurface.withOpacity(0.7),
          fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
          fontSize: ResponsiveConfig.responsiveFont(
            context,
            textTheme.bodyMedium?.fontSize ?? 14,
          ),
        ),
      ),
      trailing: badgeCount != null
          ? _buildBadge(badgeCount, isActive)
          : (isActive
                ? Container(
                    width: ResponsiveConfig.scaleWidth(context, 4),
                    height: ResponsiveConfig.scaleHeight(context, 20),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(
                        ResponsiveConfig.scaleWidth(context, 2),
                      ),
                    ),
                  )
                : null),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(cardRadius),
        side: isActive
            ? BorderSide(color: AppColors.primary.withOpacity(0.2))
            : BorderSide.none,
      ),
      tileColor: isActive
          ? AppColors.primary.withOpacity(0.05)
          : Colors.transparent,
      onTap: onTap,
      hoverColor: AppColors.primary.withOpacity(0.05),
    );
  }

  Widget _buildBadge(int count, bool isActive) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: isActive ? AppColors.onPrimary : AppColors.error,
        borderRadius: BorderRadius.circular(10),
      ),
      constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
      child: Text(
        count > 99 ? '99+' : '$count',
        style: TextStyle(
          color: Colors.white,
          fontSize: ResponsiveConfig.responsiveFont(context, 10),
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.center,
      ),
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
    return Obx(() {
      final departureData = _dashboardVm.departureData.value;
      final arrivalData = _dashboardVm.arrivalData.value;
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
                        '${arrivalData?.total}',
                        'Pending (${arrivalData?.param2})\nArrived (${arrivalData?.param1})',
                        AppColors.primary.withOpacity(0.1),
                        AppColors.surface,
                        textTheme,
                        config,
                        cardRadius,
                        iconSize,
                        fontScale,
                        () => context.push(AppRoutes.arrivalList),
                      ),
                    ),
                    SizedBox(width: ResponsiveConfig.scaleWidth(context, 16)),
                    Expanded(
                      child: _buildOccupancyCard(
                        context,
                        'Departure',
                        '${departureData?.total}',
                        'Pending (${departureData?.param2})\nChecked out (${departureData?.param1})',
                        AppColors.secondary.withOpacity(0.1),
                        AppColors.surface,
                        textTheme,
                        config,
                        cardRadius,
                        iconSize,
                        fontScale,
                        () => context.push(AppRoutes.departureList),
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
                  '${arrivalData?.total}',
                  'Pending (${arrivalData?.param2})\nArrived (${arrivalData?.param1})',
                  AppColors.primary.withOpacity(0.1),
                  AppColors.surface,
                  textTheme,
                  config,
                  cardRadius,
                  iconSize,
                  fontScale,
                  () => context.push(AppRoutes.arrivalList),
                ),
                SizedBox(height: ResponsiveConfig.scaleHeight(context, 16)),
                _buildOccupancyCard(
                  context,
                  'Departure',
                  '${departureData?.total}',
                  'Pending (${departureData?.param2})\nChecked out (${departureData?.param1})',
                  AppColors.secondary.withOpacity(0.1),
                  AppColors.surface,
                  textTheme,
                  config,
                  cardRadius,
                  iconSize,
                  fontScale,
                  () => context.push(AppRoutes.departureList),
                ),
              ],
            ),
          SizedBox(height: ResponsiveConfig.scaleHeight(context, 8)),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  // onTap: () => context.push(AppRoutes.inhouseList),
                  child: _buildInHouseCard(
                    context,
                    textTheme,
                    config,
                    cardRadius,
                    iconSize,
                    fontScale,
                  ),
                ),
              ),
              SizedBox(width: ResponsiveConfig.scaleWidth(context, 16)),
              Expanded(
                child: GestureDetector(
                  onTap: () => context.push(AppRoutes.reservationList),
                  child: _buildBookingCard(
                    context,
                    textTheme,
                    config,
                    cardRadius,
                    iconSize,
                    fontScale,
                  ),
                ),
              ),
            ],
          ),
        ],
      );
    });
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
                    fontSize: ResponsiveConfig.responsiveFont(
                      context,
                      textTheme.titleSmall?.fontSize ?? 16,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(
                    ResponsiveConfig.scaleWidth(context, 6),
                  ),
                  decoration: BoxDecoration(
                    color: accentColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(
                      ResponsiveConfig.scaleWidth(context, 10),
                    ),
                  ),
                  child: Icon(
                    title == 'Arrival'
                        ? Icons.flight_land
                        : Icons.flight_takeoff,
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
                fontSize: ResponsiveConfig.responsiveFont(
                  context,
                  (textTheme.headlineLarge?.fontSize ?? 32) * 0.8,
                ),
              ),
            ),
            SizedBox(height: ResponsiveConfig.scaleHeight(context, 10)),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: ResponsiveConfig.scaleWidth(context, 10),
                vertical: ResponsiveConfig.scaleHeight(context, 6),
              ),
              decoration: BoxDecoration(
                color: AppColors.surface.withOpacity(0.7),
                borderRadius: BorderRadius.circular(
                  ResponsiveConfig.scaleWidth(context, 8),
                ),
                border: Border.all(color: accentColor.withOpacity(0.1)),
              ),
              child: Text(
                details,
                style: textTheme.bodySmall?.copyWith(
                  color: AppColors.black.withOpacity(0.7),
                  height: 1.3,
                  fontWeight: FontWeight.w500,
                  fontSize: ResponsiveConfig.responsiveFont(
                    context,
                    textTheme.bodySmall?.fontSize ?? 12,
                  ),
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
    return Obx(() {
      final totalRevenueData = _dashboardVm.totalRevenueData.value;
      final averageDailyRateData = _dashboardVm.averageDailyRateData.value;
      final bookingLeadTimeData = _dashboardVm.bookingLeadTimeData.value;
      final averageLengthOfStayData =
          _dashboardVm.averageLengthOfStayData.value;
      final totalPaymentData = _dashboardVm.totalPaymentData.value;
      final revParData = _dashboardVm.revParData.value;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: ResponsiveConfig.horizontalPadding(
              context,
            ).copyWith(bottom: ResponsiveConfig.scaleHeight(context, 4)),
            child: Text(
              'Property Statistics',
              style: textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.black,
                letterSpacing: 0.2,
              ),
            ),
          ),
          SizedBox(height: ResponsiveConfig.scaleHeight(context, 20)),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: ResponsiveConfig.gridCrossAxisCount(
              context,
              mobileCount: 2,
              tabletCount: 3,
            ),
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
                'Total Room Revenue',
                formatCurrency(totalRevenueData?.today),
                'Y\'day: ${formatCurrency(totalRevenueData?.yesterday)}',
                '${totalRevenueData?.percentage} %',
                (totalRevenueData?.percentage ?? 0) > 0,
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
                formatCurrency(averageDailyRateData?.today),
                'Y\'day: ${formatCurrency(averageDailyRateData?.yesterday)}',
                '${averageDailyRateData?.percentage} %',
                (averageDailyRateData?.percentage ?? 0) > 0,
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
                'Total Res. Payment',
                formatCurrency(totalPaymentData?.today),
                'Y\'day: ${formatCurrency(totalPaymentData?.yesterday)}',
                '${totalPaymentData?.percentage} %',
                (totalPaymentData?.percentage ?? 0) > 0,
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
                formatCurrency(revParData?.today),
                'Y\'day: ${formatCurrency(revParData?.yesterday)}',
                '${revParData?.percentage} %',
                (revParData?.percentage ?? 0) > 0,
                AppColors.primary,
                Icons.trending_up,
              ),
            ],
          ),
        ],
      );
    });
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
        border: Border.all(color: accentColor.withOpacity(0.1), width: 1.5),
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
                    fontSize: ResponsiveConfig.responsiveFont(
                      context,
                      textTheme.bodyMedium?.fontSize ?? 14,
                    ),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.all(
                  ResponsiveConfig.scaleWidth(context, 6),
                ),
                decoration: BoxDecoration(
                  color: accentColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(
                    ResponsiveConfig.scaleWidth(context, 8),
                  ),
                ),
                child: Icon(icon, color: accentColor, size: iconSize * 0.8),
              ),
            ],
          ),
          SizedBox(height: ResponsiveConfig.scaleHeight(context, 12)),
          Text(
            yesterday,
            style: textTheme.bodySmall?.copyWith(
              color: AppColors.black.withOpacity(0.5),
              fontSize: ResponsiveConfig.responsiveFont(
                context,
                textTheme.bodySmall?.fontSize ?? 11,
              ),
            ),
          ),
          SizedBox(height: ResponsiveConfig.scaleHeight(context, 8)),
          Text(
            value,
            style: textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: accentColor,
              height: 1.1,
            ),
          ),
          SizedBox(height: ResponsiveConfig.scaleHeight(context, 12)),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: ResponsiveConfig.scaleWidth(context, 8),
              vertical: ResponsiveConfig.scaleHeight(context, 4),
            ),
            decoration: BoxDecoration(
              color: (isPositive ? Colors.green : Colors.red).withOpacity(0.1),
              borderRadius: BorderRadius.circular(
                ResponsiveConfig.scaleWidth(context, 12),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isPositive ? Icons.trending_up : Icons.trending_down,
                  size: iconSize * 0.7,
                  color: isPositive
                      ? Colors.green.shade600
                      : Colors.red.shade600,
                ),
                SizedBox(width: ResponsiveConfig.scaleWidth(context, 4)),
                Text(
                  percentage,
                  style: textTheme.bodySmall?.copyWith(
                    color: isPositive
                        ? Colors.green.shade600
                        : Colors.red.shade600,
                    fontWeight: FontWeight.w600,
                    fontSize: ResponsiveConfig.responsiveFont(
                      context,
                      textTheme.bodySmall?.fontSize ?? 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInHouseCard(
    BuildContext context,
    TextTheme textTheme,
    ResponsiveConfig config,
    double cardRadius,
    double iconSize,
    double fontScale,
  ) {
    return Obx(() {
      final inHouseData = _dashboardVm.inHouseData.value;
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
                  'In-House (${inHouseData?.total})',
                  style: textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.black,
                    fontSize: ResponsiveConfig.responsiveFont(
                      context,
                      textTheme.titleSmall?.fontSize ?? 16,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(
                    ResponsiveConfig.scaleWidth(context, 6),
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(
                      ResponsiveConfig.scaleWidth(context, 10),
                    ),
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
            _buildGuestRow(
              context,
              textTheme,
              config,
              'Adult',
              '${inHouseData?.param1}',
              '',
              fontScale,
            ),
            SizedBox(height: ResponsiveConfig.scaleHeight(context, 2)),
            _buildGuestRow(
              context,
              textTheme,
              config,
              'Child',
              '${inHouseData?.param2}',
              '',
              fontScale,
            ),
          ],
        ),
      );
    });
  }

  Widget _buildGuestRow(
    BuildContext context,
    TextTheme textTheme,
    ResponsiveConfig config,
    String label,
    String value,
    String yday,
    double fontScale,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: ResponsiveConfig.scaleHeight(context, 6),
      ),
      child: Row(
        children: [
          Text(
            label,
            style: textTheme.bodySmall?.copyWith(
              color: AppColors.black.withOpacity(0.7),
              fontWeight: FontWeight.w500,
              fontSize: ResponsiveConfig.responsiveFont(
                context,
                textTheme.bodySmall?.fontSize ?? 12,
              ),
            ),
          ),
          const Spacer(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: ResponsiveConfig.scaleWidth(context, 8),
                  vertical: ResponsiveConfig.scaleHeight(context, 2),
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(
                    ResponsiveConfig.scaleWidth(context, 10),
                  ),
                ),
                child: Text(
                  value,
                  style: textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                    fontSize: ResponsiveConfig.responsiveFont(
                      context,
                      textTheme.bodySmall?.fontSize ?? 12,
                    ),
                  ),
                ),
              ),
              SizedBox(height: ResponsiveConfig.scaleHeight(context, 2)),
              Text(
                yday,
                style: textTheme.bodySmall?.copyWith(
                  color: AppColors.black.withOpacity(0.5),
                  fontSize: ResponsiveConfig.responsiveFont(
                    context,
                    textTheme.bodySmall?.fontSize ?? 10,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBookingCard(
    BuildContext context,
    TextTheme textTheme,
    ResponsiveConfig config,
    double cardRadius,
    double iconSize,
    double fontScale,
  ) {
    return Obx(() {
      final bookingData = _dashboardVm.bookingData.value;
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
                  'Booking (${bookingData?.total})',
                  style: textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.black,
                    fontSize: ResponsiveConfig.responsiveFont(
                      context,
                      textTheme.titleSmall?.fontSize ?? 16,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(
                    ResponsiveConfig.scaleWidth(context, 6),
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(
                      ResponsiveConfig.scaleWidth(context, 10),
                    ),
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
            _buildBookingRow(
              context,
              textTheme,
              config,
              'Void',
              '${bookingData?.param1}',
              fontScale,
            ),
            SizedBox(height: ResponsiveConfig.scaleHeight(context, 2)),
            _buildBookingRow(
              context,
              textTheme,
              config,
              'Cancel',
              '${bookingData?.param3}',
              fontScale,
            ),
            SizedBox(height: ResponsiveConfig.scaleHeight(context, 2)),
            _buildBookingRow(
              context,
              textTheme,
              config,
              'No Show',
              '${bookingData?.param2}',
              fontScale,
            ),
          ],
        ),
      );
    });
  }

  Widget _buildBookingRow(
    BuildContext context,
    TextTheme textTheme,
    ResponsiveConfig config,
    String label,
    String value,
    double fontScale,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: ResponsiveConfig.scaleHeight(context, 6),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: textTheme.bodySmall?.copyWith(
              color: AppColors.black.withOpacity(0.7),
              fontWeight: FontWeight.w500,
              fontSize: ResponsiveConfig.responsiveFont(
                context,
                textTheme.bodySmall?.fontSize ?? 12,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: ResponsiveConfig.scaleWidth(context, 8),
              vertical: ResponsiveConfig.scaleHeight(context, 2),
            ),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(
                ResponsiveConfig.scaleWidth(context, 10),
              ),
            ),
            child: Text(
              value,
              style: textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
                fontSize: ResponsiveConfig.responsiveFont(
                  context,
                  textTheme.bodySmall?.fontSize ?? 12,
                ),
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
    return Obx(() {
      final totalRoomSold = _dashboardVm.totalRoomSold.value;
      final totalAvailableRooms = _dashboardVm.totalAvailableRooms.value;
      final complementaryRooms = _dashboardVm.complementaryRooms.value;
      final outOfOrderRooms = _dashboardVm.outOfOrderRooms.value;
      final totalRoomSoldRate = _dashboardVm.totalRoomSoldRate.value;
      final totalAvailableRoomsRate =
          _dashboardVm.totalAvailableRoomsRate.value;
      final outOfOrderRoomsRate = _dashboardVm.outOfOrderRoomsRate.value;
      final complementaryRoomsRate = _dashboardVm.complementaryRoomsRate.value;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: ResponsiveConfig.horizontalPadding(
              context,
            ).copyWith(bottom: ResponsiveConfig.scaleHeight(context, 4)),
            child: Text(
              'Inventory Statistics',
              style: textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.black,
                letterSpacing: 0.2,
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
                  totalAvailableRoomsRate < 0 ? 0 : totalAvailableRoomsRate,
                  '${totalAvailableRooms % 1 == 0 ? totalAvailableRooms.toInt() : totalAvailableRooms}',
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
                  totalRoomSoldRate,
                  '${totalRoomSold % 1 == 0 ? totalRoomSold.toInt() : totalRoomSold}',
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
                  outOfOrderRoomsRate,
                  '${outOfOrderRooms % 1 == 0 ? outOfOrderRooms.toInt() : outOfOrderRooms}',
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
                  complementaryRoomsRate,
                  '${complementaryRooms % 1 == 0 ? complementaryRooms.toInt() : complementaryRooms}',
                  Colors.purple.shade600,
                  Icons.card_giftcard,
                ),
              ],
            ),
          ),
        ],
      );
    });
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
            borderRadius: BorderRadius.circular(
              ResponsiveConfig.scaleWidth(context, 12),
            ),
          ),
          child: Icon(icon, color: progressColor, size: iconSize),
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
                      fontSize: ResponsiveConfig.responsiveFont(
                        context,
                        textTheme.bodyMedium?.fontSize ?? 14,
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: ResponsiveConfig.scaleWidth(context, 12),
                      vertical: ResponsiveConfig.scaleHeight(context, 4),
                    ),
                    decoration: BoxDecoration(
                      color: progressColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(
                        ResponsiveConfig.scaleWidth(context, 12),
                      ),
                    ),
                    child: Text(
                      value,
                      style: textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: progressColor,
                        fontSize: ResponsiveConfig.responsiveFont(
                          context,
                          textTheme.titleSmall?.fontSize ?? 16,
                        ),
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
                  borderRadius: BorderRadius.circular(
                    ResponsiveConfig.scaleWidth(context, 4),
                  ),
                ),
                child: FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: progressFactor,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [progressColor, progressColor.withOpacity(0.7)],
                      ),
                      borderRadius: BorderRadius.circular(
                        ResponsiveConfig.scaleWidth(context, 4),
                      ),
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
    return Obx(() {
      final occupancyData = _dashboardVm.occupancyData.value;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: ResponsiveConfig.horizontalPadding(
              context,
            ).copyWith(bottom: ResponsiveConfig.scaleHeight(context, 4)),
            child: Text(
              'Occupancy Statistics',
              style: textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.black,
                letterSpacing: 0.2,
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
                  (occupancyData?.today ?? 0) / 100,
                  '${occupancyData?.today}%',
                  AppColors.primary,
                  Icons.today,
                ),
              ],
            ),
          ),
        ],
      );
    });
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
            borderRadius: BorderRadius.circular(
              ResponsiveConfig.scaleWidth(context, 12),
            ),
          ),
          child: Icon(icon, color: progressColor, size: iconSize),
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
                      fontSize: ResponsiveConfig.responsiveFont(
                        context,
                        textTheme.bodyMedium?.fontSize ?? 14,
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: ResponsiveConfig.scaleWidth(context, 12),
                      vertical: ResponsiveConfig.scaleHeight(context, 4),
                    ),
                    decoration: BoxDecoration(
                      color: progressColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(
                        ResponsiveConfig.scaleWidth(context, 12),
                      ),
                    ),
                    child: Text(
                      value,
                      style: textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: progressColor,
                        fontSize: ResponsiveConfig.responsiveFont(
                          context,
                          textTheme.titleSmall?.fontSize ?? 16,
                        ),
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
                  borderRadius: BorderRadius.circular(
                    ResponsiveConfig.scaleWidth(context, 4),
                  ),
                ),
                child: FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: progressFactor,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [progressColor, progressColor.withOpacity(0.7)],
                      ),
                      borderRadius: BorderRadius.circular(
                        ResponsiveConfig.scaleWidth(context, 4),
                      ),
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
