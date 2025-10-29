import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:go_router/go_router.dart';
import 'package:inta_mobile_pms/core/config/responsive_config.dart';
import 'package:inta_mobile_pms/core/theme/app_colors.dart';
import 'package:inta_mobile_pms/features/reservations/viewmodels/void_reservation_vm.dart';

class VoidReservation extends StatefulWidget {
  final Map<String, dynamic> reservationData;

  const VoidReservation({Key? key, required this.reservationData})
    : super(key: key);

  @override
  State<VoidReservation> createState() => _VoidReservationState();
}

class _VoidReservationState extends State<VoidReservation> {
  final _voidReservationVm = Get.find<VoidReservationVm>();
  String? selectedReason;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final padding = ResponsiveConfig.defaultPadding(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: AppColors.black),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Void Reservation',
          style: textTheme.titleMedium?.copyWith(
            color: AppColors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(padding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInfoCard(context),
                  SizedBox(height: padding),
                  _buildReasonSection(context),
                ],
              ),
            ),
          ),
          _buildBottomButtons(context),
        ],
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final cardRadius = ResponsiveConfig.cardRadius(context);

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(cardRadius),
      ),
      child: Column(
        children: [
          _buildInfoRow(
            'Guest Name',
            widget.reservationData['guestName'] ?? '',
            textTheme,
          ),
          _buildDivider(),
          _buildInfoRow(
            'Res #',
            widget.reservationData['resNumber'] ?? '',
            textTheme,
          ),
          _buildDivider(),
          _buildInfoRow(
            'Folio',
            widget.reservationData['folio'] ?? '',
            textTheme,
          ),
          _buildDivider(),
          _buildInfoRow(
            'Arrival Date',
            widget.reservationData['arrivalDate'] ?? '',
            textTheme,
          ),
          _buildDivider(),
          _buildInfoRow(
            'Departure Date',
            widget.reservationData['departureDate'] ?? '',
            textTheme,
          ),
          _buildDivider(),
          _buildInfoRow(
            'Room Type',
            widget.reservationData['roomType'] ?? '',
            textTheme,
          ),
          _buildDivider(),
          _buildInfoRow(
            'Room',
            widget.reservationData['room'] ?? '',
            textTheme,
          ),
          _buildDivider(),
          _buildInfoRow(
            'Total',
            '\$ ${widget.reservationData['total'] ?? '0.00'}',
            textTheme,
          ),
          _buildDivider(),
          _buildInfoRow(
            'Deposit',
            '\$ ${widget.reservationData['deposit'] ?? '0.00'}',
            textTheme,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, TextTheme textTheme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: textTheme.bodyMedium?.copyWith(
              color: AppColors.darkgrey,
              fontWeight: FontWeight.w400,
            ),
          ),
          Flexible(
            child: Text(
              value,
              style: textTheme.bodyMedium?.copyWith(
                color: AppColors.black,
                fontWeight: FontWeight.w400,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return const Divider(height: 1, thickness: 1, color: Color(0xFFE0E0E0));
  }

  Widget _buildReasonSection(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final cardRadius = ResponsiveConfig.cardRadius(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          decoration: BoxDecoration(
            color: const Color(0xFFE8EAF6),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(cardRadius),
              topRight: Radius.circular(cardRadius),
            ),
          ),
          child: Text(
            'Reason',
            style: textTheme.bodyMedium?.copyWith(
              color: AppColors.darkgrey,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(cardRadius),
              bottomRight: Radius.circular(cardRadius),
            ),
          ),
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: widget.reservationData["reasons"].length,
            separatorBuilder: (context, index) => _buildDivider(),
            itemBuilder: (context, index) {
              final selected = widget.reservationData["reasons"][index];
              final reason = selected["name"];
              return InkWell(
                onTap: () {
                  setState(() {
                    selectedReason = reason;
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 14.0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        reason,
                        style: textTheme.bodyMedium?.copyWith(
                          color: AppColors.lightgrey,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: selectedReason == reason
                                ? AppColors.primary
                                : AppColors.lightgrey,
                            width: 2,
                          ),
                          color: selectedReason == reason
                              ? AppColors.primary
                              : Colors.transparent,
                        ),
                        child: selectedReason == reason
                            ? const Icon(
                                Icons.circle,
                                size: 10,
                                color: AppColors.surface,
                              )
                            : null,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildBottomButtons(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: Color(0xFFE0E0E0), width: 1)),
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () => context.pop(),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14.0),
                side: const BorderSide(color: AppColors.lightgrey),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: Text(
                'Cancel',
                style: textTheme.bodyMedium?.copyWith(
                  color: AppColors.darkgrey,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton(
              onPressed: selectedReason != null
                  ? () async {
                      final data = {
                        "bookingRoomId":
                            widget.reservationData["bookingRoomId"],
                        "reason": selectedReason,
                      };
                      await _voidReservationVm.voidReservation(data);
                      if (!mounted) return;
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                disabledBackgroundColor: Colors.blue.withOpacity(0.5),
                padding: const EdgeInsets.symmetric(vertical: 14.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                elevation: 0,
              ),
              child: Text(
                'Save',
                style: textTheme.bodyMedium?.copyWith(
                  color: AppColors.surface,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
