import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:brantro_business/controllers/re_useable/app_color.dart';

class DrawerContactList extends StatelessWidget {
  final bool isDark;

  const DrawerContactList({super.key, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          _ActionItem(
            icon: Icons.person_add, // "New Contact" uses person_add icon
            title: 'New Contact',
            isDark: isDark,
          ),
          _ContactItem(
            name: 'Anna M. Hines',
            status: 'Hey there! I am using Chat.',
            avatarIndex: 0,
            isDark: isDark,
          ),
          _ContactItem(
            name: 'Judith H. Fritsche',
            status: '** no status **',
            avatarIndex: 1,
            isDark: isDark,
          ),
          _ContactItem(
            name: 'Peter T. Smith',
            status: '|| Karma ||',
            avatarIndex: 2,
            isDark: isDark,
          ),
        ],
      ),
    );
  }
}

class _ActionItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool isDark;

  const _ActionItem({
    required this.icon,
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
              color: const Color(0xFFFF8A65), // Orange background
              borderRadius: BorderRadius.circular(24.r),
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

class _ContactItem extends StatelessWidget {
  final String name;
  final String status;
  final int avatarIndex;
  final bool isDark;

  const _ContactItem({
    required this.name,
    required this.status,
    required this.avatarIndex,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 24.r,
            backgroundColor: AppColors.grey300,
            backgroundImage: AssetImage(
              'assets/icons/avatars/avatars/avatar-${(avatarIndex % 7) + 1}.jpg',
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white : AppColors.grey900,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 6.h),
                Text(
                  status,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: isDark ? Colors.white54 : AppColors.grey500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
