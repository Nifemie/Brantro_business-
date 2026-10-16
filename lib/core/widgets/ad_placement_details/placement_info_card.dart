import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../features/ad_slot/data/models/ad_placement_model.dart';
import 'ad_placement_details_shared.dart';

class PlacementInfoCard extends StatelessWidget {
  final AdPlacementModel placement;
  final bool isDark;

  const PlacementInfoCard({
    super.key,
    required this.placement,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final amountFormatted = '₦${placement.amount.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}';
    final scheduledDateRaw = placement.rawJson['scheduledDate']?.toString() ?? '';
    final hasScheduledDate = scheduledDateRaw.isNotEmpty && scheduledDateRaw != '-';
    
    return AdPlacementDetailsShared.buildBaseCard(
      isDark: isDark,
      title: 'Placement Info',
      titleIcon: Icons.info_outline,
      titleColor: const Color(0xFFFF7A45),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (hasScheduledDate) ...[
                      AdPlacementDetailsShared.buildIconLabelRow(Icons.calendar_today, 'Scheduled Date', scheduledDateRaw, isDark, iconColor: Colors.orange),
                      SizedBox(height: 24.h),
                    ],
                    _buildStatusRow(isDark),
                    SizedBox(height: 24.h),
                    AdPlacementDetailsShared.buildIconLabelRow(Icons.description_outlined, 'Description', placement.description, isDark, iconColor: Colors.purple),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AdPlacementDetailsShared.buildIconLabelRow(Icons.attach_money, 'Amount', amountFormatted, isDark, 
                      iconColor: Colors.green, 
                      valueColor: const Color(0xFFFF7A45), 
                      isBold: true
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusRow(bool isDark) {
    Color badgeColor;
    String badgeText = placement.status;

    switch (placement.status.trim().toLowerCase()) {
      case 'requested':
      case 'pending':
        badgeColor = const Color(0xFFFF7A45);
        break;
      case 'accepted':
      case 'approved':
        badgeColor = Colors.green;
        break;
      case 'cancelled':
        badgeColor = Colors.red;
        break;
      default:
        badgeColor = Colors.blue;
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(8.r),
          decoration: BoxDecoration(
            color: isDark ? Colors.grey[800] : Colors.grey[100],
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Icon(Icons.info_outline, size: 16.sp, color: Colors.blueGrey),
        ),
        SizedBox(width: 12.w),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Status',
              style: TextStyle(
                fontSize: 12.sp,
                color: isDark ? Colors.white54 : Colors.grey[600],
              ),
            ),
            SizedBox(height: 4.h),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: badgeColor,
                borderRadius: BorderRadius.circular(4.r),
              ),
              child: Text(
                badgeText,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
