import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:brantro_business/controllers/re_useable/app_color.dart';
import 'package:brantro_business/controllers/re_useable/app_texts.dart';

class SidebarExpandableDrawerItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool isActive;
  final List<Widget> children;
  final ValueChanged<bool>? onExpansionChanged;

  const SidebarExpandableDrawerItem({
    super.key,
    required this.icon,
    required this.title,
    required this.isActive,
    required this.children,
    this.onExpansionChanged,
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
        child: Theme(
          data: ThemeData(dividerColor: Colors.transparent),
          child: ExpansionTile(
            onExpansionChanged: onExpansionChanged,
            tilePadding: EdgeInsets.symmetric(horizontal: 20.w),
            iconColor: isActive
                ? AppColors.secondaryColor
                : const Color(0xFF8B9EB0),
            collapsedIconColor: const Color(0xFF8B9EB0),
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
            children: children
                .map(
                  (child) => Padding(
                    padding: EdgeInsets.only(left: 48.w),
                    child: child,
                  ),
                )
                .toList(),
          ),
        ),
      ),
    );
  }
}

class SidebarSubItem extends StatelessWidget {
  final String title;
  final bool isActive;
  final VoidCallback? onTap;

  const SidebarSubItem({
    super.key,
    required this.title,
    required this.isActive,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 16.w),
      title: Text(
        title,
        style: AppTexts.bodyMedium(
          color: isActive ? AppColors.secondaryColor : Colors.white60,
        ).copyWith(fontWeight: isActive ? FontWeight.bold : FontWeight.normal),
      ),
      onTap: onTap,
    );
  }
}
