import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:brantro_business/controllers/re_useable/app_color.dart';

class DrawerGroupList extends StatelessWidget {
  final bool isDark;
  final List<dynamic> groups;

  const DrawerGroupList({
    super.key,
    required this.isDark,
    this.groups = const [],
  });

  @override
  Widget build(BuildContext context) {
    if (groups.isEmpty) {
      return Expanded(
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 32.h),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.groups_outlined,
                  size: 40.sp,
                  color: isDark ? Colors.white38 : Colors.grey.shade400,
                ),
                SizedBox(height: 12.h),
                Text(
                  'No groups yet',
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white70 : Colors.black87,
                  ),
                ),
                SizedBox(height: 6.h),
                Text(
                  'Community groups and project teams will appear here.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: isDark ? Colors.white38 : Colors.grey.shade500,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Expanded(
      child: ListView.builder(
        padding: EdgeInsets.zero,
        itemCount: groups.length,
        itemBuilder: (context, index) {
          final group = groups[index];
          return _GroupItem(
            initial: (group['title'] ?? 'G').toString().substring(0, 1).toUpperCase(),
            title: group['title'] ?? '',
            isDark: isDark,
          );
        },
      ),
    );
  }
}

class _ActionItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool isDark;
  final bool isOrange;

  const _ActionItem({
    required this.icon,
    required this.title,
    required this.isDark,
    this.isOrange = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
      child: Row(
        children: [
          Container(
            width: 48.w,
            height: 48.w,
            decoration: BoxDecoration(
              color: isOrange ? const Color(0xFFFF8A65) : (isDark ? const Color(0xFF3A3F4B) : AppColors.grey300),
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: 20.sp,
            ),
          ),
          SizedBox(width: 16.w),
          Text(
            title,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
              color: isDark ? Colors.white70 : AppColors.grey800,
            ),
          ),
        ],
      ),
    );
  }
}

class _GroupItem extends StatelessWidget {
  final String initial;
  final String title;
  final bool isDark;

  const _GroupItem({
    required this.initial,
    required this.title,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
      child: Row(
        children: [
          Container(
            width: 48.w,
            height: 48.w,
            decoration: BoxDecoration(
              color: const Color(0xFF5D4037), // Brownish container for 'G'
              borderRadius: BorderRadius.circular(16.r),
            ),
            alignment: Alignment.center,
            child: Text(
              initial,
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: const Color(0xFFFF8A65), // Orange text inside
              ),
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.w500,
                color: isDark ? Colors.white70 : AppColors.grey800,
                height: 1.3,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
