import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AdSlotSharedWidgets {
  static Widget buildSectionCard({
    required bool isDark,
    required String title,
    required Color indicatorColor,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[850] : Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: isDark ? Colors.grey[800]! : Colors.grey[200]!),
      ),
      child: Padding(
        padding: EdgeInsets.all(20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 8.r,
                  height: 8.r,
                  decoration: BoxDecoration(
                    color: indicatorColor,
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(width: 8.w),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.bold,
                    color: indicatorColor,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.h),
            child,
          ],
        ),
      ),
    );
  }

  static Widget buildInfoItem(
    IconData icon,
    String label,
    String value,
    bool isDark, {
    Color? valueColor,
    bool isBold = false,
    Widget? customValueWidget,
    double? width,
  }) {
    return SizedBox(
      width: width,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(8.r),
            decoration: BoxDecoration(
              color: isDark ? Colors.grey[800] : const Color(0xFFF3F4F6),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 16.sp, color: isDark ? Colors.white54 : Colors.grey[600]),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: isDark ? Colors.white54 : Colors.grey[500],
                  ),
                ),
                SizedBox(height: 4.h),
                if (customValueWidget != null)
                  customValueWidget
                else
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
                      color: valueColor ?? (isDark ? Colors.white : Colors.grey[900]),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
