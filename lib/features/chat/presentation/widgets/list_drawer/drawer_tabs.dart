import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:brantro_business/controllers/re_useable/app_color.dart';

class DrawerTabs extends StatelessWidget {
  final bool isDark;
  final int activeIndex;
  final ValueChanged<int> onTabChanged;

  const DrawerTabs({
    super.key, 
    required this.isDark,
    required this.activeIndex,
    required this.onTabChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _TabItem(
            title: 'Chat', 
            isSelected: activeIndex == 0, 
            isDark: isDark,
            onTap: () => onTabChanged(0),
          ),
          _TabItem(
            title: 'Group', 
            isSelected: activeIndex == 1, 
            isDark: isDark,
            onTap: () => onTabChanged(1),
          ),
          _TabItem(
            title: 'Contact', 
            isSelected: activeIndex == 2, 
            isDark: isDark,
            onTap: () => onTabChanged(2),
          ),
        ],
      ),
    );
  }
}

class _TabItem extends StatelessWidget {
  final String title;
  final bool isSelected;
  final bool isDark;
  final VoidCallback onTap;

  const _TabItem({
    required this.title,
    required this.isSelected,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final unselectedColorDark = const Color(0xFFFF8A65); // Orange in dark mode
    final unselectedColorLight = AppColors.grey500; // Grey in light mode
    final unselectedColor = isDark ? unselectedColorDark : unselectedColorLight;

    final selectedColorDark = Colors.white;
    final selectedColorLight = const Color(0xFF2A2E3D); // Dark slate in light mode
    final selectedColor = isDark ? selectedColorDark : selectedColorLight;

    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 8.h),
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  color: isSelected ? selectedColor : unselectedColor,
                ),
              ),
            ),
            if (isSelected)
              Container(
                height: 3.h,
                width: double.infinity,
                color: selectedColor,
              )
            else
              Container(
                height: 3.h,
                width: double.infinity,
                color: Colors.transparent,
              )
          ],
        ),
      ),
    );
  }
}
