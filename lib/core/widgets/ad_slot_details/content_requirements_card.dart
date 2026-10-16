import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'ad_slot_shared_widgets.dart';

class ContentRequirementsCard extends StatelessWidget {
  final Map<String, dynamic> adSlot;
  final bool isDark;

  const ContentRequirementsCard({
    super.key,
    required this.adSlot,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final reqs = (adSlot['contentRequirements'] as List?)?.map((e) => e.toString()).toList() ?? 
                 ['Brand name and overview', 'Caption text or key message', 'Brand handles to tag'];

    return AdSlotSharedWidgets.buildSectionCard(
      isDark: isDark,
      title: 'Content Requirements',
      indicatorColor: const Color(0xFFEF4444), // Red
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: reqs.map((req) {
          return Padding(
            padding: EdgeInsets.only(bottom: 8.h),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 6.h, right: 8.w),
                  child: Container(
                    width: 4.r,
                    height: 4.r,
                    decoration: BoxDecoration(
                      color: isDark ? Colors.white70 : Colors.grey[800],
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    req,
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: isDark ? Colors.white : Colors.grey[800],
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
