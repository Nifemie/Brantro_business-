import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:brantro_business/controllers/re_useable/app_color.dart';
import 'package:brantro_business/core/utils/avatar_helper.dart';
import 'package:brantro_business/core/service/session_service.dart';
import 'package:go_router/go_router.dart';

class ChatAppBar extends ConsumerWidget implements PreferredSizeWidget {
  const ChatAppBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return AppBar(
      backgroundColor: theme.appBarTheme.backgroundColor,
      elevation: 0,
      centerTitle: false,
      leadingWidth: 84.w,
      leading: Padding(
        padding: EdgeInsets.only(left: 4.w),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              onPressed: () {
                context.pop();
              },
              icon: Icon(
                Icons.arrow_back,
                color: isDark ? Colors.white70 : AppColors.grey700,
                size: 24.sp,
              ),
              padding: EdgeInsets.zero,
              constraints: BoxConstraints(minWidth: 32.w),
            ),
            GestureDetector(
              onTap: () => Scaffold.of(context).openDrawer(),
              child: Container(
                width: 36.w,
                height: 36.w,
                margin: EdgeInsets.only(left: 4.w),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF2A2E3D) : AppColors.grey200,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Icon(
                  Icons.menu,
                  color: isDark ? Colors.white70 : AppColors.grey700,
                  size: 20.sp,
                ),
              ),
            ),
          ],
        ),
      ),
      titleSpacing: 0,
      title: FutureBuilder<Map<String, dynamic>?>(
        future: SessionService.getUser().then(
          (value) => value != null ? Map<String, dynamic>.from(value) : null,
        ),
        builder: (context, snapshot) {
          final user = snapshot.data;
          final userId =
              user?['id']?.toString() ?? user?['userId']?.toString() ?? 'user';
          final avatarUrl = AvatarHelper.getAvatar(
            avatarUrl: user?['avatarUrl'] ?? '',
            userId: userId,
          );

          return CircleAvatar(
            radius: 18.r,
            backgroundColor: Colors.transparent,
            backgroundImage: AvatarHelper.isDefaultAvatar(avatarUrl)
                ? AssetImage(avatarUrl) as ImageProvider
                : NetworkImage(avatarUrl),
          );
        },
      ),
      actions: [
        IconButton(
          onPressed: () {
            // Video call action
          },
          icon: Icon(
            Icons.videocam_outlined,
            color: isDark ? AppColors.grey400 : AppColors.grey600,
            size: 24.sp,
          ),
          padding: EdgeInsets.zero,
          constraints: BoxConstraints(minWidth: 40.w),
        ),
        IconButton(
          onPressed: () {
            // Voice call action
          },
          icon: Icon(
            Icons.phone_outlined,
            color: isDark ? AppColors.grey400 : AppColors.grey600,
            size: 24.sp,
          ),
          padding: EdgeInsets.zero,
          constraints: BoxConstraints(minWidth: 40.w),
        ),
        Padding(
          padding: EdgeInsets.only(right: 8.w),
          child: IconButton(
            onPressed: () {
              Scaffold.of(context).openEndDrawer();
            },
            icon: Icon(
              Icons.person_outline,
              color: isDark ? AppColors.grey400 : AppColors.grey600,
              size: 24.sp,
            ),
            padding: EdgeInsets.zero,
            constraints: BoxConstraints(minWidth: 40.w),
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
