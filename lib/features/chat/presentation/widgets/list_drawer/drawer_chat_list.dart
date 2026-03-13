import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:brantro_business/controllers/re_useable/app_color.dart';

class DrawerChatList extends StatelessWidget {
  final bool isDark;

  const DrawerChatList({super.key, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          _ChatListItem(
            name: 'Anna M. Hines',
            message: 'How are you today?',
            time: '2 hours ago',
            avatarIndex: 0,
            isDark: isDark,
            isSelected: true,
          ),
          _ChatListItem(
            name: 'Judith H. Fritsche',
            message: "Hey! a reminder for tommorow's meeting...",
            time: '2 hours ago',
            avatarIndex: 1,
            isDark: isDark,
            isSelected: false,
          ),
          _ChatListItem(
            name: 'Peter T. Smith',
            message: "Hello! I just got your assignment, everything's alright. exce",
            time: '3 hours ago',
            avatarIndex: 2,
            isDark: isDark,
            isSelected: false,
          ),
          _ChatListItem(
            name: 'Michael Collins',
            message: "Can we reschedule our sync for later this afternoon?",
            time: '5 hours ago',
            avatarIndex: 3,
            isDark: isDark,
            isSelected: false,
          ),
          _ChatListItem(
            name: 'Sarah Jenkins',
            message: "The new design files are uploaded to the shared folder.",
            time: 'Yesterday',
            avatarIndex: 4,
            isDark: isDark,
            isSelected: false,
          ),
          _ChatListItem(
            name: 'David O. Wellington',
            message: "Great work on the presentation! The client really liked it.",
            time: 'Yesterday',
            avatarIndex: 5,
            isDark: isDark,
            isSelected: false,
          ),
          _ChatListItem(
            name: 'Emily Chen',
            message: "Are we still on for lunch?",
            time: 'Tuesday',
            avatarIndex: 6,
            isDark: isDark,
            isSelected: false,
          ),
          _ChatListItem(
            name: 'Marcus Thorne',
            message: "Please review the pull request when you get a chance. Thanks!",
            time: 'Monday',
            avatarIndex: 7,
            isDark: isDark,
            isSelected: false,
          ),
        ],
      ),
    );
  }
}

class _ChatListItem extends StatelessWidget {
  final String name;
  final String message;
  final String time;
  final int avatarIndex;
  final bool isDark;
  final bool isSelected;

  const _ChatListItem({
    required this.name,
    required this.message,
    required this.time,
    required this.avatarIndex,
    required this.isDark,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor = isSelected
        ? (isDark ? const Color(0xFF2B323B) : Colors.white)
        : Colors.transparent;

    final shadow = isSelected && !isDark
        ? [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))]
        : null;

    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: shadow,
      ),
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 22.r,
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      child: Text(
                        name,
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w500,
                          color: isDark ? Colors.white : AppColors.grey900,
                        ),
                        maxLines: 2,
                        softWrap: true,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      time,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: isDark ? Colors.white54 : AppColors.grey500,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Text(
                        message,
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: isDark ? Colors.white70 : AppColors.grey600,
                          height: 1.4,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Icon(
                      Icons.done_all,
                      size: 16.sp,
                      color: const Color(0xFF4CAF50),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
