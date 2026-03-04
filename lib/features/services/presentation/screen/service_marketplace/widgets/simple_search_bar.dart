import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SimpleSearchBar extends StatelessWidget {
  final ValueChanged<String>? onChanged;

  const SimpleSearchBar({super.key, this.onChanged});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Approximating colors from the simplistic screenshot
    final outerBgColor = isDark ? const Color(0xFF22272B) : Colors.white;
    final innerBgColor = isDark ? const Color(0xFF2D333B) : Colors.grey[50]!;
    final borderColor = isDark ? const Color(0xFF3E444C) : Colors.grey[300]!;
    final textColor = isDark ? Colors.grey[400] : Colors.grey[600];

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: outerBgColor,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Container(
        height: 48.h,
        decoration: BoxDecoration(
          color: innerBgColor,
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(color: borderColor, width: 1),
        ),
        child: Row(
          children: [
            SizedBox(width: 16.w),
            Icon(Icons.search, color: textColor, size: 20.sp),
            SizedBox(width: 12.w),
            Expanded(
              child: TextField(
                onChanged: onChanged,
                style: TextStyle(
                  color: isDark ? Colors.white : Colors.black,
                  fontSize: 14.sp,
                ),
                decoration: InputDecoration(
                  hintText: 'Search ...',
                  hintStyle: TextStyle(color: textColor, fontSize: 14.sp),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                  isDense: true,
                ),
              ),
            ),
            SizedBox(width: 16.w),
          ],
        ),
      ),
    );
  }
}
