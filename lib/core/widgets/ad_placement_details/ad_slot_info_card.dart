import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../features/ad_slot/data/models/ad_placement_model.dart';
import '../../screens/ad_slot_details_screen.dart';
import 'ad_placement_details_shared.dart';

class AdSlotInfoCard extends StatelessWidget {
  final AdPlacementModel placement;
  final bool isDark;

  const AdSlotInfoCard({
    super.key,
    required this.placement,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final adSlot = placement.rawJson['adSlot'] ?? {};
    final platforms = placement.platforms.isNotEmpty ? placement.platforms.join(', ') : 'None';
    final contentTypes = placement.contentTypes.isNotEmpty ? placement.contentTypes.join(', ') : 'None';
    final price = double.tryParse(adSlot['price']?.toString() ?? '0') ?? 0.0;
    final priceStr = '₦${price.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}';
    final duration = adSlot['duration'] ?? '-';
    final audience = adSlot['audienceSize'] ?? '-';
    final coverage = adSlot['coverageAreas'] ?? '-';

    return AdPlacementDetailsShared.buildBaseCard(
      isDark: isDark,
      title: 'Ad Slot Information',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AdPlacementDetailsShared.buildInfoRow(Icons.computer, 'Platforms: $platforms', isDark),
          SizedBox(height: 16.h),
          AdPlacementDetailsShared.buildInfoRow(Icons.menu_book, 'Content Types: $contentTypes', isDark),
          SizedBox(height: 16.h),
          AdPlacementDetailsShared.buildInfoRow(Icons.attach_money, 'Price: $priceStr', isDark),
          SizedBox(height: 16.h),
          AdPlacementDetailsShared.buildInfoRow(Icons.access_time, 'Duration: $duration', isDark),
          SizedBox(height: 16.h),
          AdPlacementDetailsShared.buildInfoRow(Icons.people_outline, 'Audience: $audience', isDark),
          SizedBox(height: 16.h),
          AdPlacementDetailsShared.buildInfoRow(Icons.map_outlined, 'Coverage: $coverage', isDark),
          SizedBox(height: 24.h),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AdSlotDetailsScreen(adSlot: adSlot),
                  ),
                );
              },
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Color(0xFFFF7A45)),
                padding: EdgeInsets.symmetric(vertical: 12.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
              child: Text(
                'View Ad Slot',
                style: TextStyle(
                  color: const Color(0xFFFF7A45),
                  fontSize: 14.sp,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
