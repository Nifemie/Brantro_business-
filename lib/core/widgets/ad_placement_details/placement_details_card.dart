import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../../../../features/ad_slot/data/models/ad_placement_model.dart';
import 'ad_placement_details_shared.dart';

class PlacementDetailsCard extends StatelessWidget {
  final AdPlacementModel placement;
  final bool isDark;

  const PlacementDetailsCard({
    super.key,
    required this.placement,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final createdStr = DateFormat('M/d/yyyy').format(placement.createdAt);
    
    String updatedStr = '-';
    if (placement.rawJson['updatedAt'] != null) {
      try {
        updatedStr = DateFormat('M/d/yyyy').format(DateTime.parse(placement.rawJson['updatedAt']));
      } catch (e) {}
    }

    final amountFormatted = '₦${placement.amount.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}';

    return AdPlacementDetailsShared.buildBaseCard(
      isDark: isDark,
      title: 'Placement Details',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AdPlacementDetailsShared.buildInfoRow(Icons.calendar_month, 'Created: $createdStr', isDark),
          SizedBox(height: 16.h),
          AdPlacementDetailsShared.buildInfoRow(Icons.update, 'Updated: $updatedStr', isDark),
          SizedBox(height: 16.h),
          AdPlacementDetailsShared.buildInfoRow(Icons.attach_money, 'Amount: $amountFormatted', isDark),
        ],
      ),
    );
  }
}
