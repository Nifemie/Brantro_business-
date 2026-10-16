import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../features/ad_slot/data/models/ad_placement_model.dart';
import 'ad_placement_details_shared.dart';

class AdvertiserInfoCard extends StatelessWidget {
  final AdPlacementModel placement;
  final bool isDark;

  const AdvertiserInfoCard({
    super.key,
    required this.placement,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final advertiser = placement.rawJson['advertiser'] ?? {};
    final phone = advertiser['phoneNumber'] ?? 'No phone';
    final country = advertiser['country'] ?? '';
    final state = advertiser['state'] ?? '';
    final location = (country.isNotEmpty && state.isNotEmpty) ? '$country, $state' : 'No location provided';
    final isVerified = advertiser['isVerified'] == true ? 'Yes' : 'No';

    return AdPlacementDetailsShared.buildBaseCard(
      isDark: isDark,
      title: 'Advertiser Information',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20.r,
                backgroundColor: isDark ? Colors.grey[700] : Colors.grey[200],
                child: Icon(Icons.person, color: isDark ? Colors.white54 : Colors.grey[500]),
              ),
              SizedBox(width: 12.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    placement.advertiserName,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.grey[900],
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                    child: Text(
                      'ACTIVE',
                      style: TextStyle(
                        color: Colors.green,
                        fontSize: 10.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 24.h),
          AdPlacementDetailsShared.buildInfoRow(Icons.email_outlined, placement.advertiserEmail, isDark),
          SizedBox(height: 16.h),
          AdPlacementDetailsShared.buildInfoRow(Icons.phone_outlined, phone, isDark),
          SizedBox(height: 16.h),
          AdPlacementDetailsShared.buildInfoRow(Icons.location_on_outlined, location, isDark),
          SizedBox(height: 16.h),
          AdPlacementDetailsShared.buildInfoRow(Icons.verified_outlined, 'Verified: $isVerified', isDark),
        ],
      ),
    );
  }
}
