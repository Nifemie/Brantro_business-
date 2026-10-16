import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AdSlotEditorToolbar extends StatelessWidget {
  const AdSlotEditorToolbar({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[800] : Colors.grey[200],
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12.r),
          topRight: Radius.circular(12.r),
        ),
      ),
      child: Row(
        children: [
          Text(
            'Normal', 
            style: TextStyle(
              fontSize: 12.sp, 
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white70 : Colors.black87,
            ),
          ),
          SizedBox(width: 4.w),
          Icon(Icons.arrow_drop_down, size: 16.sp, color: isDark ? Colors.white70 : Colors.black87),
          SizedBox(width: 8.w),
          Container(width: 1.w, height: 16.h, color: Colors.grey),
          SizedBox(width: 8.w),
          Icon(Icons.format_list_bulleted, size: 16.sp, color: isDark ? Colors.white70 : Colors.black87),
          SizedBox(width: 12.w),
          Icon(Icons.format_list_numbered, size: 16.sp, color: isDark ? Colors.white70 : Colors.black87),
        ],
      ),
    );
  }
}
