import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'ad_slot_shared_widgets.dart';

class AudienceCoverageCard extends StatelessWidget {
  final Map<String, dynamic> adSlot;
  final bool isDark;

  const AudienceCoverageCard({
    super.key,
    required this.adSlot,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final audienceSize = adSlot['audienceSize'] ?? '100k - 500k';
    final coverageArea = adSlot['coverageAreas'] ?? 'Coverage Area';
    final status = adSlot['status'] ?? 'Active';

    return AdSlotSharedWidgets.buildSectionCard(
      isDark: isDark,
      title: 'Audience & Coverage',
      indicatorColor: const Color(0xFF06B6D4), // Cyan
      child: Wrap(
        spacing: 24.w,
        runSpacing: 24.h,
        children: [
          AdSlotSharedWidgets.buildInfoItem(Icons.people_outline, 'Audience Size', audienceSize, isDark, isBold: true, width: 250.w),
          AdSlotSharedWidgets.buildInfoItem(Icons.location_on_outlined, 'Coverage Area', coverageArea, isDark, width: 250.w),
          AdSlotSharedWidgets.buildInfoItem(
            Icons.verified_outlined, 
            'Active Status', 
            '', 
            isDark, 
            customValueWidget: Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
              decoration: BoxDecoration(
                color: const Color(0xFF22C55E),
                borderRadius: BorderRadius.circular(4.r),
              ),
              child: Text(
                status,
                style: TextStyle(color: Colors.white, fontSize: 10.sp, fontWeight: FontWeight.bold),
              ),
            ),
            width: 250.w,
          ),
        ],
      ),
    );
  }
}
