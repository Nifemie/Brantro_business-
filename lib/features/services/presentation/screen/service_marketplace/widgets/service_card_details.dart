import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:brantro_business/controllers/re_useable/app_color.dart';

class ServiceCardDetails extends StatelessWidget {
  final String title;
  final String price;
  final String priceUnit;
  final List<String> tags;
  final VoidCallback onViewDetails;

  const ServiceCardDetails({
    super.key,
    required this.title,
    required this.price,
    required this.priceUnit,
    required this.tags,
    required this.onViewDetails,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : AppColors.textPrimary;
    final secondaryTextColor = isDark ? Colors.grey[400] : Colors.grey[600];

    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Text(
            title,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
              color: textColor,
              letterSpacing: 0.2,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),

          SizedBox(height: 12.h),

          // Rating & Likes Row
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
                '0.0',
                style: TextStyle(
                  fontSize: 13.sp,
                  color: secondaryTextColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(width: 16.w),
              // Heart
              Icon(
                Icons.favorite,
                color: const Color(0xFFFF6B6B), // Soft Red
                size: 14.sp,
              ),
              SizedBox(width: 6.w),
              Text(
                '0',
                style: TextStyle(
                  fontSize: 13.sp,
                  color: secondaryTextColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),

          SizedBox(height: 16.h),

          // Price Row
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                price,
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w700,
                  color: textColor,
                ),
              ),
              SizedBox(width: 4.w),
              Text(
                priceUnit,
                style: TextStyle(
                  fontSize: 16.sp,
                  color: secondaryTextColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),

          SizedBox(height: 12.h),

          // Hashtags
          Wrap(
            spacing: 12.w,
            runSpacing: 4.h,
            children: tags
                .map(
                  (tag) => Text(
                    tag,
                    style: TextStyle(
                      color: secondaryTextColor,
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                )
                .toList(),
          ),

          SizedBox(height: 20.h),

          // Actions Row
          Row(
            children: [
              // More options button (...)
              Container(
                width: 44.w,
                height: 44.h,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: const Color(0xFFC05E2B).withOpacity(0.5),
                    width: 1,
                  ),
                ),
                child: PopupMenuButton<String>(
                  icon: const Icon(
                    Icons.more_horiz,
                    color: Color(0xFFC05E2B), // Orange icon
                  ),
                  offset: Offset(0, 48.h),
                  color: isDark ? const Color(0xFF22272B) : Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    side: BorderSide(
                      color: isDark
                          ? const Color(0xFF3E444C)
                          : Colors.grey[300]!,
                      width: 1,
                    ),
                  ),
                  itemBuilder: (context) => [
                    _buildPopupMenuItem(
                      value: 'Update',
                      icon: Icons.edit_square,
                      text: 'Update',
                      isDark: isDark,
                    ),
                    _buildPopupMenuItem(
                      value: 'View',
                      icon: Icons.visibility_outlined,
                      text: 'View',
                      isDark: isDark,
                    ),
                    _buildPopupMenuItem(
                      value: 'Delete',
                      icon: Icons.delete_outline,
                      text: 'Delete',
                      isDark: isDark,
                      isDestructive: true,
                    ),
                  ],
                  onSelected: (value) {
                    // Handle option selection
                    debugPrint('Selected: $value');
                  },
                ),
              ),

              SizedBox(width: 16.w),

              // View Orders Button
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: onViewDetails,
                  icon: Icon(
                    Icons.shopping_bag_outlined,
                    color: Colors.white,
                    size: 20.sp,
                  ),
                  label: Text(
                    'View Orders',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF003D82), // Dark Blue
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    elevation: 0,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  PopupMenuItem<String> _buildPopupMenuItem({
    required String value,
    required IconData icon,
    required String text,
    required bool isDark,
    bool isDestructive = false,
  }) {
    final textColor = isDestructive
        ? const Color(0xFFE55858) // Red color for delete
        : (isDark ? Colors.grey[300] : Colors.grey[700]);
    final iconColor = isDestructive
        ? const Color(0xFFE55858)
        : (isDark ? Colors.grey[400] : Colors.grey[600]);

    return PopupMenuItem<String>(
      value: value,
      child: Container(
        width: 140.w,
        child: Row(
          children: [
            Icon(icon, color: iconColor, size: 20.sp),
            SizedBox(width: 12.w),
            Text(
              text,
              style: TextStyle(
                color: textColor,
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
