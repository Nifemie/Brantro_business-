import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BillboardCardDetails extends StatelessWidget {
  final String title;
  final String location;
  final String status;
  final String rating;
  final String likes;
  final bool isDark;

  const BillboardCardDetails({
    super.key,
    required this.title,
    required this.location,
    required this.status,
    required this.rating,
    required this.likes,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final titleColor = isDark ? Colors.grey[300] : Colors.black87;
    final locationColor = isDark ? Colors.grey[500] : Colors.grey[600];

    // Status badge color based on value
    Color statusColor;
    if (status.toLowerCase() == 'active') {
      statusColor = const Color(0xFF2ECC71); // Green
    } else if (status.toLowerCase() == 'inactive') {
      statusColor = const Color(0xFFE55858); // Red
    } else {
      statusColor = const Color(0xFFFF7A45); // Orange for pending etc
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title row with Active badge
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  color: titleColor,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  height: 1.3,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SizedBox(width: 12.w),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 5.h),
              decoration: BoxDecoration(
                color: statusColor,
                borderRadius: BorderRadius.circular(6.r),
              ),
              child: Text(
                status,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 8.h),

        // Location text, smaller and lighter
        Text(
          location,
          style: TextStyle(color: locationColor, fontSize: 13.sp, height: 1.5),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(height: 12.h),

        // Rating and Likes Row
        Row(
          children: [
            // Stars
            Row(
              children: List.generate(
                5,
                (index) => Icon(
                  Icons.star_border_rounded,
                  color: isDark ? Colors.grey[600] : Colors.grey[400],
                  size: 16.sp,
                ),
              ),
            ),
            SizedBox(width: 6.w),
            Text(
              rating,
              style: TextStyle(
                color: locationColor,
                fontSize: 13.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(width: 16.w),
            Icon(
              Icons.favorite,
              color: const Color(0xFFFF6B6B), // Soft Red
              size: 14.sp,
            ),
            SizedBox(width: 4.w),
            Text(
              likes,
              style: TextStyle(
                color: locationColor,
                fontSize: 13.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
