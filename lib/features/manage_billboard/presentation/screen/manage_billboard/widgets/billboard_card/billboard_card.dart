import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'billboard_card_actions.dart';
import 'billboard_card_details.dart';
import 'billboard_card_image.dart';

class BillboardCard extends StatelessWidget {
  final String imageAsset;
  final String title;
  final String location;
  final String status;
  final String rating;
  final String likes;

  const BillboardCard({
    super.key,
    required this.imageAsset,
    required this.title,
    required this.location,
    required this.status,
    this.rating = '0.0',
    this.likes = '0',
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final cardBgColor = isDark ? const Color(0xFF22272B) : Colors.white;

    return Container(
      margin: EdgeInsets.only(bottom: 24.h),
      decoration: BoxDecoration(
        color: cardBgColor,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          if (!isDark)
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Banner Image + BILLBOARD badge
          BillboardCardImage(imageAsset: imageAsset, isDark: isDark),

          // Text content + buttons
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BillboardCardDetails(
                  title: title,
                  location: location,
                  status: status,
                  rating: rating,
                  likes: likes,
                  isDark: isDark,
                ),
                SizedBox(height: 20.h),
                BillboardCardActions(isDark: isDark, title: title),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
