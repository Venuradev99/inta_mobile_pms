import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:inta_mobile_pms/core/theme/app_colors.dart';
import 'package:inta_mobile_pms/router/app_routes.dart';

class ReservationList extends StatefulWidget {
  const ReservationList({super.key});

  @override
  State<ReservationList> createState() => _ReservationListState();
}

class _ReservationListState extends State<ReservationList> with TickerProviderStateMixin {
  late TabController _tabController;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _selectedIndex = _tabController.index;
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.black),
          onPressed: () => context.go(AppRoutes.dashboard),
        ),
        title: Text(
          'Reservation List',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: AppColors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline, color: AppColors.black),
            onPressed: () => _showReservationStatusInfo(context),
          ),
          IconButton(
            icon: const Icon(Icons.filter_list, color: AppColors.black),
            onPressed: () {
              // Show filter options
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            color: AppColors.surface,
            child: TabBar(
              controller: _tabController,
              indicatorColor: AppColors.primary,
              indicatorWeight: 3,
              labelColor: AppColors.primary,
              unselectedLabelColor: Colors.grey[600],
              labelStyle: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
              unselectedLabelStyle: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w400,
              ),
              isScrollable: true,
              tabs: const [
                Tab(text: 'Today'),
                Tab(text: 'Tomorrow'),
                Tab(text: 'This Week'),
                Tab(text: 'All Upcoming'),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildReservationTab('today'),
                _buildReservationTab('tomorrow'),
                _buildReservationTab('week'),
                _buildReservationTab('upcoming'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReservationTab(String period) {
    final List<ReservationItem> reservations = _getReservationsForPeriod(period);

    if (reservations.isEmpty) {
      return _buildEmptyState(period);
    }

    return RefreshIndicator(
      onRefresh: () async {
        // Implement refresh logic
        await Future.delayed(const Duration(seconds: 1));
      },
      child: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: reservations.length,
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          return _buildReservationCard(reservations[index]);
        },
      ),
    );
  }

  Widget _buildEmptyState(String period) {
    String message = _getEmptyStateMessage(period);
    
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(40),
            ),
            child: Icon(
              Icons.event_busy,
              size: 40,
              color: Colors.grey[400],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'No Reservations',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Colors.grey[600],
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            message,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey[500],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  String _getEmptyStateMessage(String period) {
    switch (period) {
      case 'today':
        return 'No reservations scheduled for today';
      case 'tomorrow':
        return 'No reservations scheduled for tomorrow';
      case 'week':
        return 'No reservations scheduled for this week';
      case 'upcoming':
        return 'No upcoming reservations found';
      default:
        return 'No reservations available';
    }
  }

  Widget _buildReservationCard(ReservationItem reservation) {
    return GestureDetector(
      onTap: () => _showReservationActionsBottomSheet(context, reservation),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[200]!, width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with guest info and status
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: AppColors.primary.withOpacity(0.1),
                  child: Text(
                    reservation.guestName.substring(0, 1).toUpperCase(),
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        reservation.guestName,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        '${reservation.propertyName} • ${reservation.bookingId}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                _buildStatusChip(reservation.status),
              ],
            ),
            const SizedBox(height: 16),
            
            // Check-in and Check-out dates
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.05),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue.withOpacity(0.1)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: _buildDateInfo(
                      'Check-in',
                      reservation.checkInDate,
                      Icons.login,
                      Colors.green[600]!,
                    ),
                  ),
                  Container(
                    width: 1,
                    height: 30,
                    color: Colors.grey[300],
                  ),
                  Expanded(
                    child: _buildDateInfo(
                      'Check-out',
                      reservation.checkOutDate,
                      Icons.logout,
                      Colors.red[600]!,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            
            // Stay details
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.purple.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.night_shelter,
                        size: 16,
                        color: Colors.purple[700],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${reservation.nights} Night${reservation.nights > 1 ? 's' : ''}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.purple[700],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.people,
                        size: 16,
                        color: Colors.orange[700],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${reservation.guests} Guest${reservation.guests > 1 ? 's' : ''}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.orange[700],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                // Quick action button based on status
                _buildQuickActionButton(reservation),
              ],
            ),
            const SizedBox(height: 12),
            
            // Total amount
            Row(
              children: [
                Text(
                  'Total Amount: ',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
                Text(
                  '\$${reservation.totalAmount.toStringAsFixed(2)}',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Spacer(),
                if (reservation.balanceAmount > 0) ...[
                  Text(
                    'Balance: ',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                  Text(
                    '\$${reservation.balanceAmount.toStringAsFixed(2)}',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: Colors.red[600],
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateInfo(String label, String date, IconData icon, Color color) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 16, color: color),
            const SizedBox(width: 4),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          date,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildStatusChip(String status) {
    Color backgroundColor;
    Color textColor;
    IconData? icon;
    
    switch (status.toLowerCase()) {
      case 'confirmed':
        backgroundColor = Colors.green.withOpacity(0.1);
        textColor = Colors.green[700]!;
        icon = Icons.check_circle;
        break;
      case 'pending':
        backgroundColor = Colors.orange.withOpacity(0.1);
        textColor = Colors.orange[700]!;
        icon = Icons.schedule;
        break;
      case 'cancelled':
        backgroundColor = Colors.red.withOpacity(0.1);
        textColor = Colors.red[700]!;
        icon = Icons.cancel;
        break;
      case 'checked in':
        backgroundColor = Colors.blue.withOpacity(0.1);
        textColor = Colors.blue[700]!;
        icon = Icons.login;
        break;
      case 'completed':
        backgroundColor = Colors.purple.withOpacity(0.1);
        textColor = Colors.purple[700]!;
        icon = Icons.check_circle_outline;
        break;
      default:
        backgroundColor = Colors.grey.withOpacity(0.1);
        textColor = Colors.grey[700]!;
        icon = Icons.info;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 14, color: textColor),
            const SizedBox(width: 4),
          ],
          Text(
            status,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: textColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionButton(ReservationItem reservation) {
    String buttonText;
    Color buttonColor;
    IconData buttonIcon;
    
    switch (reservation.status.toLowerCase()) {
      case 'confirmed':
        buttonText = 'Check In';
        buttonColor = Colors.blue;
        buttonIcon = Icons.login;
        break;
      case 'checked in':
        buttonText = 'Check Out';
        buttonColor = Colors.green;
        buttonIcon = Icons.logout;
        break;
      case 'pending':
        buttonText = 'Confirm';
        buttonColor = Colors.orange;
        buttonIcon = Icons.check;
        break;
      default:
        buttonText = 'View';
        buttonColor = Colors.grey;
        buttonIcon = Icons.visibility;
    }

    return SizedBox(
      height: 32,
      child: ElevatedButton.icon(
        onPressed: () {
          // Handle quick action based on status
        },
        icon: Icon(buttonIcon, size: 16),
        label: Text(buttonText),
        style: ElevatedButton.styleFrom(
          backgroundColor: buttonColor,
          foregroundColor: AppColors.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12),
        ),
      ),
    );
  }

  void _showReservationStatusInfo(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: AppColors.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 400),
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: AppColors.primary,
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Reservation Status',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.black,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: Icon(
                        Icons.close,
                        color: Colors.grey[600],
                        size: 20,
                      ),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildStatusItem(
                  context,
                  'Confirmed',
                  'Reservations that are confirmed and ready for check-in',
                  Colors.green[700]!,
                  Icons.check_circle,
                ),
                const SizedBox(height: 12),
                _buildStatusItem(
                  context,
                  'Pending',
                  'Reservations awaiting confirmation or payment',
                  Colors.orange[700]!,
                  Icons.schedule,
                ),
                const SizedBox(height: 12),
                _buildStatusItem(
                  context,
                  'Checked In',
                  'Guests who have already checked in',
                  Colors.blue[700]!,
                  Icons.login,
                ),
                const SizedBox(height: 12),
                _buildStatusItem(
                  context,
                  'Completed',
                  'Reservations that have been completed',
                  Colors.purple[700]!,
                  Icons.check_circle_outline,
                ),
                const SizedBox(height: 12),
                _buildStatusItem(
                  context,
                  'Cancelled',
                  'Reservations that have been cancelled',
                  Colors.red[700]!,
                  Icons.cancel,
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: AppColors.onPrimary,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'Got it',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.onPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatusItem(
    BuildContext context,
    String status,
    String description,
    Color color,
    IconData icon,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(
            icon,
            size: 16,
            color: color,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  status,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: color,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey[600],
                  height: 1.3,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showReservationActionsBottomSheet(BuildContext context, ReservationItem reservation) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      enableDrag: true,
      isDismissible: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.3,
        maxChildSize: 0.95,
        builder: (context, scrollController) => Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: Column(
            children: [
              // Handle/grip indicator
              Container(
                margin: const EdgeInsets.symmetric(vertical: 8),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Actions for ${reservation.guestName}',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${reservation.propertyName} • ${reservation.bookingId}',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildActionItem(Icons.visibility, 'View Reservation Details'),
                        _buildActionItem(Icons.login, 'Check In Guest'),
                        _buildActionItem(Icons.edit, 'Modify Reservation'),
                        _buildActionItem(Icons.person_add, 'Add Guest Details'),
                        _buildActionItem(Icons.payment, 'Process Payment'),
                        _buildActionItem(Icons.receipt_long, 'Generate Invoice'),
                        _buildActionItem(Icons.email, 'Send Confirmation Email'),
                        _buildActionItem(Icons.calendar_today, 'Extend Stay'),
                        _buildActionItem(Icons.room_service, 'Add Room Service'),
                        _buildActionItem(Icons.cancel, 'Cancel Reservation'),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionItem(IconData icon, String label) {
    return ListTile(
      leading: Icon(icon, color: Colors.grey[600]),
      title: Text(
        label,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
      onTap: () {
        Navigator.pop(context);
        // Handle action
      },
    );
  }

  List<ReservationItem> _getReservationsForPeriod(String period) {
    // Mock data - replace with actual data fetching logic
    switch (period) {
      case 'today':
        return [
          ReservationItem(
            guestName: 'John Smith',
            propertyName: 'Ocean View Suite',
            checkInDate: 'Sep 17, 2025',
            checkOutDate: 'Sep 20, 2025',
            nights: 3,
            guests: 2,
            bookingId: 'RSV001',
            status: 'Confirmed',
            totalAmount: 450.00,
            balanceAmount: 0.00,
          ),
          ReservationItem(
            guestName: 'Emma Wilson',
            propertyName: 'Garden Villa',
            checkInDate: 'Sep 17, 2025',
            checkOutDate: 'Sep 19, 2025',
            nights: 2,
            guests: 3,
            bookingId: 'RSV006',
            status: 'Pending',
            totalAmount: 320.00,
            balanceAmount: 150.00,
          ),
        ];
      case 'tomorrow':
        return [
          ReservationItem(
            guestName: 'Sarah Johnson',
            propertyName: 'Mountain Cabin',
            checkInDate: 'Sep 18, 2025',
            checkOutDate: 'Sep 23, 2025',
            nights: 5,
            guests: 4,
            bookingId: 'RSV002',
            status: 'Confirmed',
            totalAmount: 750.00,
            balanceAmount: 0.00,
          ),
        ];
      case 'week':
        return [
          ReservationItem(
            guestName: 'Michael Brown',
            propertyName: 'City Apartment',
            checkInDate: 'Sep 20, 2025',
            checkOutDate: 'Sep 22, 2025',
            nights: 2,
            guests: 1,
            bookingId: 'RSV003',
            status: 'Checked In',
            totalAmount: 200.00,
            balanceAmount: 0.00,
          ),
          ReservationItem(
            guestName: 'Lisa Anderson',
            propertyName: 'Beach House',
            checkInDate: 'Sep 21, 2025',
            checkOutDate: 'Sep 24, 2025',
            nights: 3,
            guests: 2,
            bookingId: 'RSV007',
            status: 'Confirmed',
            totalAmount: 540.00,
            balanceAmount: 100.00,
          ),
        ];
      case 'upcoming':
        return [
          ReservationItem(
            guestName: 'David Thompson',
            propertyName: 'Luxury Suite',
            checkInDate: 'Sep 25, 2025',
            checkOutDate: 'Sep 30, 2025',
            nights: 5,
            guests: 2,
            bookingId: 'RSV008',
            status: 'Confirmed',
            totalAmount: 800.00,
            balanceAmount: 0.00,
          ),
          ReservationItem(
            guestName: 'Jennifer Davis',
            propertyName: 'Penthouse',
            checkInDate: 'Oct 1, 2025',
            checkOutDate: 'Oct 5, 2025',
            nights: 4,
            guests: 6,
            bookingId: 'RSV009',
            status: 'Pending',
            totalAmount: 1200.00,
            balanceAmount: 600.00,
          ),
        ];
      default:
        return [];
    }
  }
}

class ReservationItem {
  final String guestName;
  final String propertyName;
  final String checkInDate;
  final String checkOutDate;
  final int nights;
  final int guests;
  final String bookingId;
  final String status;
  final double totalAmount;
  final double balanceAmount;

  ReservationItem({
    required this.guestName,
    required this.propertyName,
    required this.checkInDate,
    required this.checkOutDate,
    required this.nights,
    required this.guests,
    required this.bookingId,
    required this.status,
    required this.totalAmount,
    required this.balanceAmount,
  });
}