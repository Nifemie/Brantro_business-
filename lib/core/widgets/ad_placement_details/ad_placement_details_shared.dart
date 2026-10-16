import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AdPlacementDetailsShared {
  static Widget buildBaseCard({
    required bool isDark,
    required String title,
    IconData? titleIcon,
    Color? titleColor,
    Widget? trailing,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[900] : Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black.withOpacity(0.3) : Colors.grey.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(20.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    if (titleIcon != null) ...[
                      Icon(titleIcon, size: 18.sp, color: titleColor ?? (isDark ? Colors.white : Colors.grey[800])),
                      SizedBox(width: 8.w),
                    ],
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.grey[900],
                      ),
                    ),
                  ],
                ),
                if (trailing != null) trailing,
              ],
            ),
          ),
          Divider(height: 1, color: isDark ? Colors.grey[800] : Colors.grey[200]),
          Padding(
            padding: EdgeInsets.all(20.w),
            child: child,
          ),
        ],
      ),
    );
  }

  static Widget buildIconLabelRow(IconData icon, String label, String value, bool isDark, {Color? iconColor, Color? valueColor, bool isBold = false}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(8.r),
          decoration: BoxDecoration(
            color: isDark ? Colors.grey[800] : Colors.grey[100],
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Icon(icon, size: 16.sp, color: iconColor ?? Colors.blueGrey),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12.sp,
                  color: isDark ? Colors.white54 : Colors.grey[600],
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                value,
                style: TextStyle(
                  fontSize: isBold ? 16.sp : 14.sp,
                  fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                  color: valueColor ?? (isDark ? Colors.white : Colors.grey[900]),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  static Widget buildInfoRow(IconData icon, String text, bool isDark) {
    return Row(
      children: [
        Icon(icon, size: 16.sp, color: isDark ? Colors.white54 : Colors.grey[500]),
        SizedBox(width: 12.w),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 13.sp,
              color: isDark ? Colors.white70 : Colors.grey[800],
            ),
          ),
        ),
      ],
    );
  }
}
