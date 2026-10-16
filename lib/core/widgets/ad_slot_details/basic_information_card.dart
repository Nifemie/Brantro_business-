import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'ad_slot_shared_widgets.dart';

class BasicInformationCard extends StatelessWidget {
  final Map<String, dynamic> adSlot;
  final bool isDark;

  const BasicInformationCard({
    super.key,
    required this.adSlot,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final platformsList = (adSlot['platforms'] as List?)?.map((e) => e.toString()).toList() ?? [];
    final platforms = platformsList.isNotEmpty ? platformsList.join(', ') : 'Instagram, TikTok, X (Twitter)';
    
    final contentTypesList = (adSlot['contentTypes'] as List?)?.map((e) => e.toString()).toList() ?? [];
    final contentTypes = contentTypesList.isNotEmpty ? contentTypesList.join(', ') : 'Post, Reel, Short Video, Livestream, Product Review';
    
    final partnerType = adSlot['partnerType'] ?? 'Influencer';
    final timeWindow = adSlot['timeWindow'] ?? 'Anytime';
    final adFormat = adSlot['adFormat'] ?? 'Video';

    return AdSlotSharedWidgets.buildSectionCard(
      isDark: isDark,
      title: 'Basic Information',
      indicatorColor: const Color(0xFFFF7A45),
      child: Wrap(
        spacing: 24.w,
        runSpacing: 24.h,
        children: [
          AdSlotSharedWidgets.buildInfoItem(Icons.desktop_windows_outlined, 'Platforms', platforms, isDark, width: 250.w),
          AdSlotSharedWidgets.buildInfoItem(Icons.receipt_long_outlined, 'Content Types', contentTypes, isDark, width: 250.w),
          AdSlotSharedWidgets.buildInfoItem(
            Icons.person_outline, 
            'Partner Type', 
            '', 
            isDark, 
            customValueWidget: Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
              decoration: BoxDecoration(
                color: const Color(0xFFFF7A45),
                borderRadius: BorderRadius.circular(4.r),
              ),
              child: Text(
                partnerType,
                style: TextStyle(color: Colors.white, fontSize: 10.sp, fontWeight: FontWeight.bold),
              ),
            ),
            width: 250.w,
          ),
          AdSlotSharedWidgets.buildInfoItem(Icons.access_time, 'Time Window', timeWindow, isDark, width: 250.w),
          AdSlotSharedWidgets.buildInfoItem(Icons.local_offer_outlined, 'Ad Format', adFormat, isDark, width: 250.w),
        ],
      ),
    );
  }
}
