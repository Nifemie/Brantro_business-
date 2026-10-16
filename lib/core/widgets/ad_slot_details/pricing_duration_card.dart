import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'ad_slot_shared_widgets.dart';

class PricingDurationCard extends StatelessWidget {
  final Map<String, dynamic> adSlot;
  final bool isDark;

  const PricingDurationCard({
    super.key,
    required this.adSlot,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final priceRaw = double.tryParse(adSlot['price']?.toString() ?? '0') ?? 350000.0;
    final priceStr = '₦${priceRaw.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}';
    
    final duration = adSlot['duration'] ?? '24hrs';
    final maxRevisions = adSlot['maxRevisions']?.toString() ?? '3';
    final status = adSlot['status'] ?? 'Active';

    return AdSlotSharedWidgets.buildSectionCard(
      isDark: isDark,
      title: 'Pricing & Duration',
      indicatorColor: const Color(0xFF22C55E),
      child: Wrap(
        spacing: 24.w,
        runSpacing: 24.h,
        children: [
          AdSlotSharedWidgets.buildInfoItem(
            Icons.attach_money, 
            'Price', 
            priceStr, 
            isDark, 
            valueColor: const Color(0xFF22C55E), 
            isBold: true,
            width: 250.w,
          ),
          AdSlotSharedWidgets.buildInfoItem(Icons.access_time, 'Duration', duration, isDark, width: 250.w),
          AdSlotSharedWidgets.buildInfoItem(Icons.sync, 'Max Revisions', maxRevisions, isDark, width: 250.w),
          AdSlotSharedWidgets.buildInfoItem(
            Icons.check_circle_outline, 
            'Status', 
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
