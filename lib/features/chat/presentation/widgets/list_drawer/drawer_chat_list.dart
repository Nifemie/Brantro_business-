import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:brantro_business/controllers/re_useable/app_color.dart';

class DrawerChatList extends StatelessWidget {
  final bool isDark;
  final List<dynamic> chats;

  const DrawerChatList({
    super.key,
    required this.isDark,
    this.chats = const [],
  });

  @override
  Widget build(BuildContext context) {
    if (chats.isEmpty) {
      return Expanded(
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 32.h),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.mark_chat_unread_outlined,
                  size: 40.sp,
                  color: isDark ? Colors.white38 : Colors.grey.shade400,
                ),
                SizedBox(height: 12.h),
                Text(
                  'No conversations yet',
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white70 : Colors.black87,
                  ),
                ),
                SizedBox(height: 6.h),
                Text(
                  'When you connect with buyers or clients, your chats will appear here.',
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
        itemCount: chats.length,
        itemBuilder: (context, index) {
          final chat = chats[index];
          return _ChatListItem(
            name: chat['name'] ?? '',
            message: chat['message'] ?? '',
            time: chat['time'] ?? '',
            avatarIndex: index % 8,
            isDark: isDark,
            isSelected: index == 0,
          );
        },
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
