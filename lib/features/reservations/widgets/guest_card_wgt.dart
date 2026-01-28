// lib/widgets/common/guest_card.dart
import 'package:flutter/material.dart';
import 'package:inta_mobile_pms/core/theme/app_colors.dart';
import 'package:shimmer/shimmer.dart';

class GuestCard extends StatelessWidget {
  final String guestName;
  final String resId;
  final String startDate;
  final String endDate;
  final String nightsLabel;
  final int nights;
  final int adults;
  final int children;
  final double totalAmount;
  final double balanceAmount;
  final String? roomNumber;
  final String? reservationType;
  final Color? colorCode;
  final String? baseCurrencySymbol;
  final Widget? actionButton;
  final GestureTapCallback? onTap;
  final String? roomType;
  final String? room;
  final String? statusName;
  final String? businessCategoryName;
  final bool? isGroupOwner;

  const GuestCard({
    super.key,
    required this.guestName,
    required this.resId,
    required this.startDate,
    required this.endDate,
    required this.nightsLabel,
    required this.nights,
    required this.adults,
    required this.children,
    required this.totalAmount,
    required this.balanceAmount,
    this.roomNumber,
    this.room,
    this.reservationType,
    this.colorCode,
    this.actionButton,
    this.onTap,
    this.roomType,
    this.baseCurrencySymbol,
    this.statusName,
    this.businessCategoryName,
    this.isGroupOwner,
  });

  String formatCurrency(double? value) {
    final symbol = baseCurrencySymbol ?? '';
    if (value == null) return '$symbol 0.00';

    final formatted = value
        .toStringAsFixed(2)
        .replaceAllMapped(
          RegExp(r'(\d)(?=(\d{3})+\.)'),
          (Match m) => '${m[1]},',
        );

    return '$symbol $formatted';
  }

  String formatDateShort(String dateStr) {
    if (dateStr.isEmpty) return '';

    DateTime? date;
    try {
      date = DateTime.parse(dateStr);
    } catch (e) {
      return '';
    }

    final monthNames = [
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "May",
      "Jun",
      "Jul",
      "Aug",
      "Sep",
      "Oct",
      "Nov",
      "Dec",
    ];

    final month = monthNames[date.month - 1];
    final day = date.day;

    return "$month $day";
  }

  String getMonth(String dateStr) {
    if (dateStr.isEmpty) return '';
    final d = DateTime.tryParse(dateStr);
    if (d == null) return '';
    const months = [
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "May",
      "Jun",
      "Jul",
      "Aug",
      "Sep",
      "Oct",
      "Nov",
      "Dec",
    ];
    return months[d.month - 1];
  }

  String getDay(String dateStr) {
    if (dateStr.isEmpty) return '';
    final d = DateTime.tryParse(dateStr);
    if (d == null) return '';
    return d.day.toString();
  }

  @override
  Widget build(BuildContext context) {
    //   final theme = Theme.of(context);
    //   final statusColor = colorCode ?? Colors.grey;
    //   final icon = roomType != null ? Icons.apartment : Icons.apartment;

    return GestureDetector(
      onTap: onTap,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isNarrow = constraints.maxWidth < 360;
          final theme = Theme.of(context);

          return Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: EdgeInsets.all(isNarrow ? 10 : 14),
              child: IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      width: 70,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: AppColors.purple.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [
                              Text(
                                getMonth(startDate),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.purple.withOpacity(0.8),
                                  fontSize: 14,
                                ),
                              ),
                              Text(
                                getDay(startDate),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.purple.withOpacity(0.8),
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              SizedBox(height: 4),
                              Divider(
                                thickness: 1,
                                color: AppColors.purple.withOpacity(0.8),
                              ),
                              SizedBox(height: 4),
                            ],
                          ),
                          Column(
                            children: [
                              Text(
                                getMonth(endDate),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.purple.withOpacity(0.8),
                                  fontSize: 14,
                                ),
                              ),
                              Text(
                                getDay(endDate),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.purple.withOpacity(0.8),
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Row(
                                  children: [
                                    Text(
                                      guestName,
                                      style: theme.textTheme.titleMedium
                                          ?.copyWith(
                                            fontWeight: FontWeight.w700,
                                            color: AppColors.darkgrey,
                                          ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(width: 8),
                                    if (isGroupOwner ?? false)
                                      Icon(
                                        Icons.workspace_premium_rounded,
                                        size: 20,
                                        color: AppColors.darkgrey,
                                      ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.qr_code,
                                size: 16,
                                color: AppColors.darkgrey,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'Res: $resId',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: AppColors.darkgrey,
                                ),
                              ),
                            ],
                          ),

                          Row(
                            children: [
                              Icon(
                                Icons.hotel,
                                size: 16,
                                color: AppColors.darkgrey,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '${room ?? 'N/A'}',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: AppColors.darkgrey,
                                ),
                              ),
                            ],
                          ),

                          Row(
                            children: [
                              Icon(
                                Icons.business_rounded,
                                size: 16,
                                color: AppColors.darkgrey,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '$businessCategoryName',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.people,
                                size: 16,
                                color: AppColors.darkgrey,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'Pax $adults / $children',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: AppColors.darkgrey,
                                ),
                              ),
                              const Spacer(),
                              Icon(
                                Icons.brightness_3,
                                size: 16,
                                color: AppColors.darkgrey,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '$nights $nightsLabel',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                'Total: ${formatCurrency(totalAmount)}',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  fontWeight: FontWeight.w500,
                                  fontSize:
                                      theme.textTheme.bodySmall?.fontSize !=
                                          null
                                      ? theme.textTheme.bodySmall!.fontSize! *
                                            0.85
                                      : 10,
                                ),
                              ),
                              const Spacer(),
                              Text(
                                'Balance: ${formatCurrency(balanceAmount)}',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: Colors.red,
                                  fontWeight: FontWeight.w500,
                                  fontSize:
                                      theme.textTheme.bodySmall?.fontSize !=
                                          null
                                      ? theme.textTheme.bodySmall!.fontSize! *
                                            0.85
                                      : 10,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );

    // return GestureDetector(
    //   onTap: onTap,
    //   child: LayoutBuilder(
    //     builder: (context, constraints) {
    //       final isNarrow =
    //           constraints.maxWidth <
    //           360;

    //       return Container(
    //         padding: EdgeInsets.all(isNarrow ? 12 : 16),
    //         decoration: BoxDecoration(
    //           color: AppColors.surface,
    //           borderRadius: BorderRadius.circular(12),
    //           border: Border.all(color: Colors.grey[200]!, width: 1),
    //         ),
    //         child: Column(
    //           crossAxisAlignment: CrossAxisAlignment.start,
    //           children: [
    //             Row(
    //               crossAxisAlignment: CrossAxisAlignment.start,
    //               children: [
    //                 Container(
    //                   padding: const EdgeInsets.all(8),
    //                   decoration: BoxDecoration(
    //                     color: Colors.purple.withOpacity(0.1),
    //                     borderRadius: BorderRadius.circular(8),
    //                   ),
    //                   child: Icon(
    //                     icon,
    //                     color: Colors.purple,
    //                     size: isNarrow ? 20 : 24,
    //                   ),
    //                 ),
    //                 SizedBox(width: isNarrow ? 8 : 12),
    //                 Expanded(
    //                   child: Column(
    //                     crossAxisAlignment: CrossAxisAlignment.start,
    //                     children: [
    //                       Text(
    //                         guestName,
    //                         style: theme.textTheme.titleMedium?.copyWith(
    //                           fontWeight: FontWeight.w600,
    //                           fontSize: isNarrow ? 14 : null,
    //                         ),
    //                         overflow: TextOverflow.ellipsis,
    //                         maxLines: 1,
    //                       ),
    //                       Text(
    //                         'Res: $resId | ${room ?? 'N/A'}',
    //                         style: theme.textTheme.bodySmall?.copyWith(
    //                           color: Colors.grey[600],
    //                         ),
    //                         overflow: TextOverflow.ellipsis,
    //                         maxLines: 1,
    //                       ),
    //                     ],
    //                   ),
    //                 ),
    //               ],
    //             ),
    //             SizedBox(height: isNarrow ? 8 : 12),
    //             Row(
    //               children: [
    //                 Expanded(
    //                   child: Text(
    //                     '${formatDateShort(startDate)} - ${formatDateShort(endDate)}',
    //                     style: theme.textTheme.bodyMedium?.copyWith(
    //                       fontWeight: FontWeight.w500,
    //                       fontSize: isNarrow ? 12 : null,
    //                     ),
    //                     overflow: TextOverflow.ellipsis,
    //                   ),
    //                 ),
    //                 SizedBox(width: isNarrow ? 4 : 8),
    //                 Container(
    //                   padding: EdgeInsets.symmetric(
    //                     horizontal: isNarrow ? 2 : 4,
    //                     vertical: isNarrow ? 1 : 2,
    //                   ),
    //                   decoration: BoxDecoration(
    //                     color: Colors.blue.withOpacity(0.1),
    //                     borderRadius: BorderRadius.circular(4),
    //                   ),
    //                   child: Row(
    //                     mainAxisSize: MainAxisSize.min,
    //                     children: [
    //                       Icon(
    //                         Icons.night_shelter,
    //                         size: isNarrow ? 14 : 16,
    //                         color: Colors.blue,
    //                       ),
    //                       SizedBox(width: isNarrow ? 2 : 4),
    //                       Text(
    //                         '$nights $nightsLabel',
    //                         style: theme.textTheme.bodySmall?.copyWith(
    //                           color: Colors.blue[700],
    //                           fontWeight: FontWeight.w500,
    //                           fontSize: isNarrow ? 10 : null,
    //                         ),
    //                       ),
    //                     ],
    //                   ),
    //                 ),
    //               ],
    //             ),
    //             SizedBox(height: isNarrow ? 4 : 8),
    //             Row(
    //               crossAxisAlignment: CrossAxisAlignment.center,
    //               children: [
    //                 Expanded(
    //                   child: Wrap(
    //                     spacing: isNarrow ? 4 : 8,
    //                     runSpacing: 4,
    //                     alignment: WrapAlignment.start,
    //                     children: [
    //                       Container(
    //                         padding: EdgeInsets.all(isNarrow ? 2 : 4),
    //                         decoration: BoxDecoration(
    //                           color: Colors.green.withOpacity(0.1),
    //                           borderRadius: BorderRadius.circular(4),
    //                         ),
    //                         child: Icon(
    //                           Icons.people,
    //                           color: Colors.green,
    //                           size: isNarrow ? 14 : 16,
    //                         ),
    //                       ),
    //                       Text(
    //                         'Pax $adults / $children',
    //                         style: theme.textTheme.bodySmall?.copyWith(
    //                           color: Colors.grey[600],
    //                           fontSize: isNarrow ? 10 : null,
    //                         ),
    //                       ),
    //                       Container(
    //                         padding: EdgeInsets.symmetric(
    //                           horizontal: isNarrow ? 8 : 12,
    //                           vertical: isNarrow ? 4 : 6,
    //                         ),
    //                         decoration: BoxDecoration(
    //                           color: statusColor.withOpacity(0.2),
    //                           borderRadius: BorderRadius.circular(12),
    //                         ),
    //                         child: Text(
    //                           statusName ?? 'N/A',
    //                           style: theme.textTheme.bodySmall?.copyWith(
    //                             color: statusColor,
    //                             fontWeight: FontWeight.bold,
    //                             fontSize: isNarrow ? 10 : null,
    //                           ),
    //                         ),
    //                       ),
    //                     ],
    //                   ),
    //                 ),
    //                 if (roomNumber != null)
    //                   Container(
    //                     padding: EdgeInsets.symmetric(
    //                       horizontal: isNarrow ? 4 : 8,
    //                       vertical: isNarrow ? 2 : 4,
    //                     ),
    //                     decoration: BoxDecoration(
    //                       color: Colors.orange.withOpacity(0.1),
    //                       borderRadius: BorderRadius.circular(20),
    //                     ),
    //                     child: Text(
    //                       roomNumber!,
    //                       style: theme.textTheme.bodySmall?.copyWith(
    //                         color: Colors.orange[700],
    //                         fontWeight: FontWeight.w500,
    //                         fontSize: isNarrow ? 10 : null,
    //                       ),
    //                     ),
    //                   )
    //                 else if (actionButton != null)
    //                   actionButton!,
    //               ],
    //             ),
    //             SizedBox(height: isNarrow ? 4 : 8),
    //             Row(
    //               children: [
    //                 Text(
    //                   'Total: ${formatCurrency(totalAmount)}',
    //                   style: theme.textTheme.bodyMedium?.copyWith(
    //                     fontWeight: FontWeight.w500,
    //                     fontSize: isNarrow ? 12 : null,
    //                   ),
    //                 ),
    //                 const Spacer(),
    //                 Text(
    //                   'Balance: ${formatCurrency(balanceAmount)}',
    //                   style: theme.textTheme.bodyMedium?.copyWith(
    //                     color: Colors.red,
    //                     fontWeight: FontWeight.w500,
    //                     fontSize: isNarrow ? 12 : null,
    //                   ),
    //                 ),
    //               ],
    //             ),
    //           ],
    //         ),
    //       );
    //     },
    //   ),
    // );
  }

  String getReservationType() {
    return reservationType ?? 'N/A';
  }
}

class GuestCardShimmer extends StatelessWidget {
  const GuestCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isNarrow = constraints.maxWidth < 360;

        return Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
            padding: EdgeInsets.all(isNarrow ? 12 : 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[200]!, width: 1),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: isNarrow ? 32 : 40,
                      height: isNarrow ? 32 : 40,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    SizedBox(width: isNarrow ? 8 : 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 120,
                            height: isNarrow ? 12 : 14,
                            color: Colors.grey[300],
                          ),
                          const SizedBox(height: 6),
                          Container(
                            width: 160,
                            height: isNarrow ? 10 : 12,
                            color: Colors.grey[300],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: isNarrow ? 8 : 12),
                Row(
                  children: [
                    Container(
                      width: 100,
                      height: isNarrow ? 10 : 12,
                      color: Colors.grey[300],
                    ),
                    SizedBox(width: isNarrow ? 8 : 12),
                    Container(
                      width: 60,
                      height: isNarrow ? 16 : 20,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: isNarrow ? 4 : 8),
                Row(
                  children: [
                    Container(
                      width: 80,
                      height: isNarrow ? 10 : 12,
                      color: Colors.grey[300],
                    ),
                    SizedBox(width: isNarrow ? 8 : 12),
                    Container(
                      width: 100,
                      height: isNarrow ? 10 : 12,
                      color: Colors.grey[300],
                    ),
                    const Spacer(),
                    Container(
                      width: 40,
                      height: isNarrow ? 16 : 20,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: isNarrow ? 4 : 8),
                Row(
                  children: [
                    Container(
                      width: 100,
                      height: isNarrow ? 12 : 14,
                      color: Colors.grey[300],
                    ),
                    const Spacer(),
                    Container(
                      width: 80,
                      height: isNarrow ? 12 : 14,
                      color: Colors.grey[300],
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
}
