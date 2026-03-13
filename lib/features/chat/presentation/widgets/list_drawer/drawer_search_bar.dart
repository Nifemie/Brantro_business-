import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:brantro_business/controllers/re_useable/app_color.dart';

class DrawerSearchBar extends StatelessWidget {
  final Color textColor;
  final bool isDark;

  const DrawerSearchBar({
    super.key,
    required this.textColor,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
      child: Container(
        height: 44.h,
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF2A2E3D) : Colors.white,
          borderRadius: BorderRadius.circular(24.r),
          border: isDark ? null : Border.all(color: AppColors.grey200, width: 1),
        ),
        child: TextField(
          style: TextStyle(color: textColor, fontSize: 14.sp),
          decoration: InputDecoration(
            hintText: 'Search ...',
            hintStyle: TextStyle(
              color: isDark ? Colors.white38 : AppColors.grey500,
              fontSize: 14.sp,
            ),
            border: InputBorder.none,
            isDense: true,
            contentPadding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
            suffixIcon: Icon(
              Icons.search,
              color: isDark ? Colors.white38 : AppColors.grey500,
              size: 20.sp,
            ),
          ),
        ),
      ),
    );
  }
}
