import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:brantro_business/controllers/re_useable/app_color.dart';
import 'package:brantro_business/controllers/re_useable/app_texts.dart';

class SidebarDrawerItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool isActive;
  final VoidCallback? onTap;

  const SidebarDrawerItem({
    super.key,
    required this.icon,
    required this.title,
    required this.isActive,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Container(
        decoration: BoxDecoration(
          color: isActive ? Colors.white.withOpacity(0.05) : Colors.transparent,
          border: isActive
              ? Border(
                  left: BorderSide(color: AppColors.secondaryColor, width: 4.w),
                )
              : Border(
                  left: BorderSide(color: Colors.transparent, width: 4.w),
                ),
        ),
        child: ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 20.w),
          leading: Icon(
            icon,
            color: isActive
                ? AppColors.secondaryColor
                : const Color(0xFF8B9EB0),
            size: 24.sp,
          ),
          title: Text(
            title,
            style:
                AppTexts.bodyLarge(
                  color: isActive ? AppColors.secondaryColor : Colors.white70,
                ).copyWith(
                  fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
                ),
          ),
          onTap: onTap,
        ),
      ),
    );
  }
}
